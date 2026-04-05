package com.gfp.app.toolBar
{
   import com.gfp.core.CommandID;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.LineType;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class MapInfoShow
   {
      
      private static var _instance:MapInfoShow;
      
      private var _mapTxt:TextField;
      
      private var _tradeSwitchUI:Sprite;
      
      private var _roomTitleUI:Sprite;
      
      private var _tradeTxt:TextField;
      
      private var _tradeBtn:SimpleButton;
      
      private var _tradeNumer:int;
      
      private var _roomID:uint;
      
      public function MapInfoShow()
      {
         super();
         this._mapTxt = UIManager.getGlobalUi("UI_SWF_BottomBar")["mapNameTxt"];
         this._mapTxt.autoSize = TextFieldAutoSize.CENTER;
         this._tradeSwitchUI = UIManager.getSprite("ToolBar_TradeEnter");
         this._tradeTxt = this._tradeSwitchUI["txt"];
         this._tradeBtn = this._tradeSwitchUI["btn"];
         this._tradeTxt.restrict = "0-9";
      }
      
      public static function get instance() : MapInfoShow
      {
         if(_instance == null)
         {
            _instance = new MapInfoShow();
         }
         return _instance;
      }
      
      public static function destroy() : void
      {
         if(_instance)
         {
            _instance.destroy();
            _instance = null;
         }
      }
      
      public function destroy() : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         MapManager.removeEventListener(MapEvent.USER_ENTER_TRADE_MAP,this.onEnterTradeMap);
         MapManager.removeEventListener(MapEvent.USER_LEAVE_TRADE_MAP,this.onLeaveTradeMap);
         StageResizeController.instance.unregister(this.onStageResize);
         this._mapTxt = null;
         this._tradeSwitchUI = null;
      }
      
      public function show() : void
      {
         if(MapManager.currentMap)
         {
            this.setText(MapManager.currentMap.info.id,MapManager.currentMap.info.name);
         }
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         MapManager.addEventListener(MapEvent.USER_ENTER_TRADE_MAP,this.onEnterTradeMap);
         MapManager.addEventListener(MapEvent.USER_LEAVE_TRADE_MAP,this.onLeaveTradeMap);
         StageResizeController.instance.register(this.onStageResize);
      }
      
      private function onStageResize() : void
      {
         this._tradeSwitchUI.x = LayerManager.stageWidth - 195 >> 1;
         this._tradeSwitchUI.y = 0;
      }
      
      public function showInSummonRoom() : void
      {
         if(this._roomTitleUI == null)
         {
            this._roomTitleUI = UIManager.getSprite("ToolBar_RoomTitleUI");
            this._roomTitleUI.mouseEnabled = false;
            this._roomTitleUI.mouseChildren = false;
         }
         LayerManager.toolsLevel.addChild(this._roomTitleUI);
         DisplayUtil.align(this._roomTitleUI,null,AlignType.TOP_CENTER);
      }
      
      public function hideOutSummonRoom() : void
      {
         DisplayUtil.removeForParent(this._roomTitleUI);
         this._roomTitleUI = null;
      }
      
      public function setRoomText(param1:String, param2:uint) : void
      {
         TextField(this._roomTitleUI["nameTxt"]).htmlText = param1;
         this._roomTitleUI["levelTxt"].text = "第" + param2.toString() + "层";
      }
      
      public function hideRoomMC() : void
      {
         if(this._roomTitleUI)
         {
            MovieClip(this._roomTitleUI["waitMC"]).visible = false;
         }
      }
      
      public function setQuickEnterVisible(param1:Boolean = true) : void
      {
         this._tradeSwitchUI.visible = param1;
         this._mapTxt.text = this._roomID + AppLanguageDefine.SPECIAL_CHARACTER[6] + MapManager.currentMap.info.name;
      }
      
      public function activityShowOrHide(param1:Boolean) : void
      {
      }
      
      private function setText(param1:uint, param2:String) : void
      {
         if(ClientConfig.isRelease())
         {
            this._mapTxt.text = param2;
         }
         else
         {
            this._mapTxt.text = param1.toString() + " " + param2;
         }
      }
      
      private function onMapSwitchComplete(param1:MapEvent) : void
      {
         this.setText(param1.mapModel.info.id,param1.mapModel.info.name);
      }
      
      private function onEnterTradeMap(param1:MapEvent) : void
      {
         this.setTradeMapName(param1.mapModel.info.id);
         this.initQuickTradeRoomEnter();
      }
      
      private function initQuickTradeRoomEnter() : void
      {
         this._tradeTxt.addEventListener(MouseEvent.CLICK,this.onTradeTextClick);
         this._tradeBtn.addEventListener(MouseEvent.CLICK,this.onGotoTradeRoom);
         this.onStageResize();
         LayerManager.toolsLevel.addChild(this._tradeSwitchUI);
      }
      
      private function onGotoTradeRoom(param1:Event) : void
      {
         SocketConnection.addCmdListener(CommandID.STORE_ASSIGN_ENTER,this.onRequeset);
         var _loc2_:ByteArray = new ByteArray();
         this._tradeNumer = int(this._tradeTxt.text);
         var _loc3_:Boolean = false;
         switch(MainManager.loginInfo.lineType)
         {
            case LineType.LINE_TYPE_CT:
               if(this._tradeNumer > 7 * 420)
               {
                  _loc3_ = true;
               }
               break;
            default:
               if(this._tradeNumer > 3 * 420)
               {
                  _loc3_ = true;
               }
         }
         if(_loc3_)
         {
            AlertManager.showSimpleAlarm("小侠士，你输入的房间已超出范围，请重新输入！");
            this._tradeTxt.text = this._roomID.toString();
            return;
         }
         if(this._tradeNumer != 0 && this._tradeNumer != this._roomID)
         {
            _loc2_.writeUnsignedInt(this._tradeNumer);
            SocketConnection.send(CommandID.STORE_ASSIGN_ENTER,_loc2_);
         }
      }
      
      private function onTradeTextClick(param1:Event) : void
      {
         this._tradeNumer = 0;
         this._tradeTxt.text = "";
      }
      
      private function onRequeset(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.STORE_ASSIGN_ENTER,this.onRequeset);
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         CityMap.instance.gotoTradeMap(29,2,_loc3_);
         this._tradeNumer = 0;
         this._tradeTxt.text = AppLanguageDefine.MAPINFO_CHARACTER_COLLECTION[0];
      }
      
      private function onLeaveTradeMap(param1:Event) : void
      {
         DisplayUtil.removeForParent(this._tradeSwitchUI);
      }
      
      private function setTradeMapName(param1:int) : void
      {
         this._roomID = param1;
         if(this._tradeSwitchUI)
         {
            this._tradeSwitchUI["nametxt"].text = param1 + AppLanguageDefine.SPECIAL_CHARACTER[6] + MapManager.currentMap.info.name;
         }
      }
   }
}

