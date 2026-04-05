package com.gfp.app.manager
{
   import com.gfp.core.CommandID;
   import com.gfp.core.buff.BuffInfo;
   import com.gfp.core.buff.IBuff;
   import com.gfp.core.buff.movie.IconBuff;
   import com.gfp.core.config.xml.SkillXMLInfo;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.ScenceItemAddEvent;
   import com.gfp.core.info.SightInfo;
   import com.gfp.core.info.fight.BuffConfigInfo;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.model.sensemodels.FlowerModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class ExpAutoUpManager
   {
      
      public static var canExpUp:Boolean;
      
      private static var _instance:ExpAutoUpManager;
      
      public static const BUFF_ID:uint = 93;
      
      public var evtDispatch:EventDispatcher = new EventDispatcher();
      
      private var _flower:FlowerModel;
      
      public function ExpAutoUpManager()
      {
         super();
         SocketConnection.addCmdListener(CommandID.FLOWER_POSITION,this.onPutFlower);
         SocketConnection.addCmdListener(CommandID.PICK_FLOWER,this.onPickFlower);
         this.evtDispatch.addEventListener(ScenceItemAddEvent.FLOWER_APPEARED,this.onFlowerAppeared);
         SocketConnection.addCmdListener(CommandID.FLOWER_DISTANCE,this.onCheckDistance);
         MapManager.addEventListener(MapEvent.MAP_DESTROY,this.onMapDestroy);
      }
      
      public static function get instance() : ExpAutoUpManager
      {
         if(_instance == null)
         {
            _instance = new ExpAutoUpManager();
         }
         return _instance;
      }
      
      private function onPutFlower(param1:SocketEvent) : void
      {
         var _loc6_:Array = null;
         var _loc7_:UserModel = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:Point = new Point();
         _loc4_.x = _loc2_.readUnsignedInt();
         _loc4_.y = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         if(_loc5_ == 0 && _loc3_ == MapManager.currentMap.info.id)
         {
            this.removeFlower();
            this.removebuffIcon(BUFF_ID,MainManager.actorID);
            _loc6_ = UserManager.getModels();
            for each(_loc7_ in _loc6_)
            {
               this.removebuffIcon(BUFF_ID,_loc7_.info.userID);
            }
            canExpUp = false;
         }
         if(_loc5_ == 1 && _loc3_ == MapManager.currentMap.info.id)
         {
            this.putFlower(_loc4_);
         }
      }
      
      private function onFlowerAppeared(param1:ScenceItemAddEvent) : void
      {
         var _loc2_:Point = param1.position;
         this.putFlower(_loc2_);
      }
      
      private function putFlower(param1:Point) : void
      {
         var _loc2_:SightInfo = new SightInfo();
         _loc2_.tip = "经验回还花";
         _loc2_.name = "经验回还花";
         _loc2_.meterialSrc = "10412";
         _loc2_.meterialType = 2;
         _loc2_.defaultPos = param1;
         if(this._flower == null)
         {
            this._flower = new FlowerModel(null,_loc2_);
            this._flower.initView();
            MapManager.currentMap.contentLevel.addChild(this._flower);
            SightManager.add(this._flower);
         }
      }
      
      private function removeFlower() : void
      {
         if(this._flower)
         {
            SightManager.remove(this._flower);
            this._flower.destroy();
            this._flower = null;
         }
      }
      
      private function onPickFlower(param1:SocketEvent) : void
      {
         this.addBuffIcon(BUFF_ID,MainManager.actorModel.info.userID);
         canExpUp = true;
      }
      
      private function onCheckDistance(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         var _loc4_:uint = _loc2_.readUnsignedInt();
         if(_loc4_ > 200)
         {
            this.removebuffIcon(BUFF_ID,_loc3_);
            if(_loc3_ == MainManager.actorID)
            {
               canExpUp = false;
               TextAlert.show("小侠士，您距离经验回还花太远，不能享受经验光环。");
            }
         }
         else
         {
            this.addBuffIcon(BUFF_ID,_loc3_);
         }
      }
      
      private function onMapDestroy(param1:MapEvent) : void
      {
         this._flower = null;
      }
      
      private function addBuffIcon(param1:uint, param2:uint) : void
      {
         var _loc3_:BuffConfigInfo = SkillXMLInfo.getBuffConfigInfo(param1);
         var _loc4_:BuffInfo = new BuffInfo();
         _loc4_.id = param1;
         _loc4_.keyID = param1;
         _loc4_.view = _loc3_.buffViewID;
         _loc4_.layer = _loc3_.buffLayer;
         _loc4_.align = _loc3_.buffAlign;
         _loc4_.name = _loc3_.buffName;
         var _loc5_:IBuff = new IconBuff(_loc4_,false);
         UserManager.execBuff(param2,_loc5_,true);
      }
      
      private function removebuffIcon(param1:uint, param2:uint) : void
      {
         UserManager.endBuff(param2,param1);
      }
      
      public function init() : void
      {
      }
   }
}

