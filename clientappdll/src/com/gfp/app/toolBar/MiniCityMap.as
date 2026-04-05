package com.gfp.app.toolBar
{
   import com.gfp.app.manager.EscortManager;
   import com.gfp.app.miniMap.MiniMapNpcIcon;
   import com.gfp.app.miniMap.MiniMapTeleporterIcon;
   import com.gfp.app.miniMap.MiniMapTollgateIcon;
   import com.gfp.core.action.mouse.MouseProcess;
   import com.gfp.core.config.xml.MapXMLInfo;
   import com.gfp.core.config.xml.NpcXMLInfo;
   import com.gfp.core.config.xml.TollgateXMLInfo;
   import com.gfp.core.events.DataEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.MoveEvent;
   import com.gfp.core.info.NpcInstanceInfo;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.map.MapConfigUtil;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   import com.gfp.core.model.MapModel;
   import com.gfp.core.model.sensemodels.SightModel;
   import com.gfp.core.model.sensemodels.StageTeleportModel;
   import com.gfp.core.model.sensemodels.TeleporterModel;
   import com.gfp.core.ui.controller.BasePanel;
   import com.gfp.module.app.miniCityMap.UI_miniCityMapCurr;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class MiniCityMap extends Sprite
   {
      
      private static var _instance:MiniCityMap;
      
      private var imgMiniMap:Bitmap;
      
      private var miniMapContiner:Sprite;
      
      private var window:BasePanel;
      
      private var _currentMapId:int;
      
      private var _miniScaleX:Number;
      
      private var _miniScaleY:Number;
      
      private var _mySelfSp:Sprite;
      
      private var _pathContiner:Sprite;
      
      private var _trunPoint:Point = new Point();
      
      private var _npcIconCache:Array = new Array();
      
      private var _tollgateIconCache:Array = new Array();
      
      private var _transportIconCache:Array = new Array();
      
      private var _escortID:uint;
      
      public function MiniCityMap()
      {
         super();
         this.window = new BasePanel(600,400);
         this.window.title = "地图";
         this.window.addEventListener(BasePanel.UI_CLOSE_EVENT,this.onWindowClose);
         this.miniMapContiner = new Sprite();
         this.miniMapContiner.y = 51;
         this.miniMapContiner.x = 20;
         this.miniMapContiner.name = "miniMapContiner";
         this._mySelfSp = new UI_miniCityMapCurr();
         this._mySelfSp.buttonMode = true;
         this._pathContiner = new Sprite();
         ToolTipManager.add(this._mySelfSp,"当前位置");
         this.window.addChild(this.miniMapContiner);
         this.miniMapContiner.addEventListener(MouseEvent.CLICK,this.onClick);
         addChild(this.window);
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapswitchComplete);
         EscortManager.instance.addEventListener(EscortManager.ESCORT_OVER,this.onEscortOver);
         EscortManager.instance.addEventListener(EscortManager.ESCORT_START,this.onEscortStart);
      }
      
      public static function get instance() : MiniCityMap
      {
         if(_instance == null)
         {
            _instance = new MiniCityMap();
         }
         return _instance;
      }
      
      private function onMapswitchComplete(param1:MapEvent) : void
      {
         if(MapManager.mapInfo.mapType != MapType.STAND)
         {
            this.hide();
         }
         else
         {
            this.drawMapOnce();
         }
      }
      
      private function onEscortStart(param1:DataEvent) : void
      {
         this.drawMapOnce();
      }
      
      private function onEscortOver(param1:Event) : void
      {
         if(MapManager.mapInfo)
         {
            this.drawMapOnce();
         }
      }
      
      private function onWindowClose(param1:Event) : void
      {
         this.hide();
      }
      
      public function show() : void
      {
         if(this.parent != null)
         {
            this.hide();
         }
         else
         {
            this.drawMap();
            this.addToStage();
         }
      }
      
      private function addToStage() : void
      {
         LayerManager.toolsLevel.addChild(this);
         DisplayUtil.align(this,null,AlignType.MIDDLE_CENTER);
         MainManager.actorModel.addEventListener(MoveEvent.MOVE,this.onMove);
         MainManager.actorModel.addEventListener(MoveEvent.MOVE_START,this.onMoveStart);
         MainManager.actorModel.addEventListener(MoveEvent.MOVE_END,this.onMoveEnd);
      }
      
      private function onMoveEnd(param1:MoveEvent) : void
      {
         this._pathContiner.graphics.clear();
      }
      
      private function onMoveStart(param1:MoveEvent) : void
      {
         var _loc2_:Array = param1.path;
         this.drawPath(_loc2_);
      }
      
      private function onMove(param1:MoveEvent) : void
      {
         this._mySelfSp.x = MainManager.actorModel.pos.x * this._miniScaleX;
         this._mySelfSp.y = MainManager.actorModel.pos.y * this._miniScaleY;
      }
      
      public function hide() : void
      {
         DisplayUtil.removeForParent(this);
      }
      
      private function drawMap() : void
      {
         if(this._currentMapId != MapManager.mapInfo.id)
         {
            this.drawMapOnce();
         }
      }
      
      private function drawMapOnce() : void
      {
         this.clearMiniMap();
         this._currentMapId = MapManager.mapInfo.id;
         if(MapManager.mapInfo.mapType == MapType.TRADE)
         {
            this.window.title = "交易行" + this._currentMapId + "号";
         }
         else
         {
            this.window.title = MapXMLInfo.getName(this._currentMapId);
         }
         var _loc1_:MapModel = MapManager.currentMap;
         this.imgMiniMap = _loc1_.imgMiniMap;
         this._miniScaleX = _loc1_.miniMapScaleX;
         this._miniScaleY = _loc1_.miniMapScaleY;
         DisplayUtil.removeAllChild(this.miniMapContiner);
         this.miniMapContiner.addChild(this.imgMiniMap);
         this.miniMapContiner.addChild(this._pathContiner);
         this.window.height = this.imgMiniMap.height + 65;
         this.window.width = this.imgMiniMap.width + 48;
         this.drawNPC();
         this.drawTollgate();
         this.drawTransport();
         this._mySelfSp.x = MainManager.actorModel.pos.x * this._miniScaleX;
         this._mySelfSp.y = MainManager.actorModel.pos.y * this._miniScaleY;
         this.miniMapContiner.addChild(this._mySelfSp);
      }
      
      private function clearMiniMap() : void
      {
         if(this.imgMiniMap != null && Boolean(this.imgMiniMap.parent))
         {
            this.imgMiniMap.parent.removeChild(this.imgMiniMap);
            this.imgMiniMap = null;
         }
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(param1.target.name == "miniMapContiner")
         {
            this._trunPoint.x = param1.localX;
            this._trunPoint.y = param1.localY;
         }
         else
         {
            this._trunPoint.x = param1.target.x;
            this._trunPoint.y = param1.target.y;
         }
         MouseProcess.execRun(MainManager.actorModel,new Point(this._trunPoint.x / this._miniScaleX,this._trunPoint.y / this._miniScaleY));
      }
      
      private function drawNPC() : void
      {
         var _loc3_:SightModel = null;
         var _loc4_:int = 0;
         var _loc5_:NpcInstanceInfo = null;
         var _loc6_:MiniMapNpcIcon = null;
         var _loc1_:Array = SightManager.getSightModelList();
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = _loc1_[_loc2_] as SightModel;
            if(_loc3_.sightType == MapConfigUtil.NPCSIGHT && Boolean(_loc3_.visible) && _loc3_.parent != null)
            {
               _loc4_ = int(_loc3_.info.id);
               _loc5_ = NpcXMLInfo.getNpcInstanceById(_loc4_);
               _loc6_ = new MiniMapNpcIcon(_loc5_);
               _loc6_.x = _loc5_.pos.x * this._miniScaleX;
               _loc6_.y = _loc5_.pos.y * this._miniScaleY;
               this.miniMapContiner.addChild(_loc6_);
            }
            _loc2_++;
         }
      }
      
      private function drawTollgate() : void
      {
         var _loc3_:int = 0;
         var _loc4_:Point = null;
         var _loc5_:MiniMapTollgateIcon = null;
         if(MapManager.mapInfo.mapType == MapType.TRADE)
         {
            return;
         }
         var _loc1_:Array = TollgateXMLInfo.getTollgatesInMap(this._currentMapId);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = int(_loc1_[_loc2_]);
            _loc4_ = TollgateXMLInfo.getTollagtePointByTollgateID(_loc3_);
            if(_loc4_.length > 0)
            {
               _loc5_ = new MiniMapTollgateIcon(_loc3_);
               _loc5_.x = _loc4_.x * this._miniScaleX;
               _loc5_.y = _loc4_.y * this._miniScaleY;
               this.miniMapContiner.addChild(_loc5_);
            }
            _loc2_++;
         }
      }
      
      private function drawTransport() : void
      {
         var _loc3_:TeleporterModel = null;
         var _loc4_:MiniMapTeleporterIcon = null;
         var _loc5_:StageTeleportModel = null;
         var _loc6_:MiniMapTeleporterIcon = null;
         var _loc1_:Array = SightManager.getSightModelList();
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            if(_loc1_[_loc2_] is TeleporterModel)
            {
               _loc3_ = _loc1_[_loc2_] as TeleporterModel;
               _loc4_ = new MiniMapTeleporterIcon(_loc3_.mapTo);
               _loc4_.x = _loc3_.pos.x * this._miniScaleX;
               _loc4_.y = _loc3_.pos.y * this._miniScaleY;
               this.miniMapContiner.addChild(_loc4_);
            }
            else if(_loc1_[_loc2_] is StageTeleportModel)
            {
               _loc5_ = _loc1_[_loc2_] as StageTeleportModel;
               _loc6_ = new MiniMapTeleporterIcon(_loc5_.stageTo);
               _loc6_.x = _loc5_.pos.x * this._miniScaleX;
               _loc6_.y = _loc5_.pos.y * this._miniScaleY;
               this.miniMapContiner.addChild(_loc6_);
            }
            _loc2_++;
         }
      }
      
      private function drawPath(param1:Array) : void
      {
         var _loc2_:Point = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Point = null;
         this._pathContiner.graphics.clear();
         if(param1.length > 0)
         {
            this._pathContiner.graphics.lineStyle(2,11206553,0.8);
            _loc2_ = param1[0];
            _loc3_ = _loc2_.x * this._miniScaleX;
            _loc4_ = _loc2_.y * this._miniScaleY;
            for each(_loc7_ in param1)
            {
               _loc5_ = _loc7_.x * this._miniScaleX;
               _loc6_ = _loc7_.y * this._miniScaleY;
               this._pathContiner.graphics.beginFill(16711680,0.8);
               this._pathContiner.graphics.moveTo(_loc3_,_loc4_);
               this._pathContiner.graphics.lineTo(_loc5_,_loc6_);
               this._pathContiner.graphics.endFill();
               _loc3_ = _loc5_;
               _loc4_ = _loc6_;
            }
            this._pathContiner.graphics.beginFill(16776960,0.8);
            this._pathContiner.graphics.drawCircle(_loc5_,_loc6_,3);
            this._pathContiner.graphics.endFill();
         }
      }
   }
}

