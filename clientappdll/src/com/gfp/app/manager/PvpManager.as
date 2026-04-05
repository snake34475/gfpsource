package com.gfp.app.manager
{
   import com.gfp.app.feature.AutoFightInPvpMap;
   import com.gfp.app.fight.FightWaitPanel;
   import com.gfp.app.fight.SinglePkManager;
   import com.gfp.core.CommandID;
   import com.gfp.core.controller.SocketSendController;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.ActivityExchangeAwardInfo;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.MapModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.PvpTypeConstantUtil;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.ui.Mouse;
   import org.taomee.utils.DisplayUtil;
   
   public class PvpManager
   {
      
      private static var _fightMap:Array;
      
      private static var _peaceMap:Array;
      
      private static var _friendMap:Array;
      
      private static var _totalMap:Array;
      
      private static var _selectedSide:int;
      
      private static var _arrow:Sprite;
      
      private static var _pkUserInfo:UserInfo;
      
      private static var _isNeedToDisplayPvp:Boolean = false;
      
      private static var autoFightMap:AutoFightInPvpMap = new AutoFightInPvpMap(PvpTypeConstantUtil.PVP_SIDE_YABIAO);
      
      public function PvpManager()
      {
         super();
      }
      
      public static function get isNeedToDisplayPvp() : Boolean
      {
         return _isNeedToDisplayPvp;
      }
      
      public static function set isNeedToDisplayPvp(param1:Boolean) : void
      {
         if(_isNeedToDisplayPvp != param1)
         {
            _isNeedToDisplayPvp = param1;
            if(param1)
            {
               showFightMouse();
               autoFightMap.start();
            }
            else
            {
               hideFightMouse();
               autoFightMap.stop();
            }
         }
      }
      
      private static function showFightMouse() : void
      {
         if(MainManager.actorInfo.side == 0)
         {
            return;
         }
         if(_arrow == null)
         {
            _arrow = new UI_MouseArrow();
            _arrow.mouseChildren = false;
            _arrow.mouseEnabled = false;
         }
         Mouse.hide();
         _arrow.x = LayerManager.stage.mouseX;
         _arrow.y = LayerManager.stage.mouseY;
         LayerManager.stage.addChild(_arrow);
         LayerManager.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
         UserManager.addEventListener(UserEvent.CLICK,onUserClick);
      }
      
      private static function onMouseMove(param1:MouseEvent) : void
      {
         if(_arrow)
         {
            _arrow.x = LayerManager.stage.mouseX;
            _arrow.y = LayerManager.stage.mouseY;
            if(LayerManager.stage.getChildIndex(_arrow) != LayerManager.stage.numChildren - 1)
            {
               LayerManager.stage.setChildIndex(_arrow,LayerManager.stage.numChildren - 1);
            }
         }
      }
      
      private static function hideFightMouse() : void
      {
         UserManager.removeEventListener(UserEvent.CLICK,onUserClick);
         LayerManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
         if(_arrow)
         {
            DisplayUtil.removeForParent(_arrow);
            _arrow.stopDrag();
            _arrow = null;
         }
         Mouse.show();
      }
      
      private static function onUserClick(param1:UserEvent) : void
      {
         var _loc2_:* = param1.data;
         if(_loc2_ is UserInfo)
         {
            _pkUserInfo = _loc2_ as UserInfo;
            if(MainManager.actorID == _pkUserInfo.userID)
            {
               return;
            }
            if(MainManager.actorInfo.side == _pkUserInfo.side)
            {
               return;
            }
            if(_pkUserInfo.lv < 65)
            {
               AlertManager.showSimpleAlarm("只能和65级以上的敌对玩家进行强制pvp哦。");
               return;
            }
            if(MainManager.actorInfo.lv < 65)
            {
               AlertManager.showSimpleAlarm("这个抢夺女神的歹人在战车里面异常凶险，小侠士还是修炼到65级再来挑战吧！");
               return;
            }
            UserManager.addUserListener(UserEvent.PVP_CHANGE,_pkUserInfo.userID,initPvPState);
            SocketSendController.sendPvpInviteCMD(false,PvpTypeConstantUtil.PVP_SIDE_YABIAO,PvpTypeConstantUtil.PVP_TYPE_INVITE,0);
         }
      }
      
      private static function initPvPState(param1:UserEvent) : void
      {
         if(_pkUserInfo == null)
         {
            return;
         }
         UserManager.removeUserListener(UserEvent.PVP_CHANGE,_pkUserInfo.userID,initPvPState);
         var _loc2_:uint = uint(int(param1.data));
         if(_loc2_ != 0)
         {
            SinglePkManager.instance.openInviteBattery();
            FightWaitPanel.showWaitPanel();
            SocketConnection.send(CommandID.TEAM_INVITE_FRIEND,PvpTypeConstantUtil.PVP_SIDE_YABIAO,_pkUserInfo.userID,_loc2_,0,0);
         }
      }
      
      public static function init() : void
      {
      }
      
      public static function setup(param1:int) : void
      {
         if(param1 == 1)
         {
            _fightMap = [1060];
            _peaceMap = [1061];
            _friendMap = [1059];
         }
         else if(param1 == 2)
         {
            _fightMap = [1059];
            _peaceMap = [1061];
            _friendMap = [1060];
         }
         else
         {
            _fightMap = [];
            _peaceMap = [1059,1060,1061];
            _friendMap = [];
         }
         _totalMap = _fightMap.concat(_peaceMap).concat(_friendMap);
         checkPvpStatus(MapManager.currentMap);
      }
      
      public static function joinSide(param1:Boolean) : void
      {
         var _loc2_:String = null;
         if(MainManager.actorInfo.side != 0)
         {
            AlertManager.showSimpleAlarm("小侠士，您已经加入阵营了，无法再次加入。");
            return;
         }
         if(param1)
         {
            _selectedSide = 1;
            _loc2_ = "小侠士，是否确认加入<font color=\'#FF0000\'>艾尔大陆阵营</font>，一旦加入，无法修改。";
         }
         else
         {
            _selectedSide = 2;
            _loc2_ = "小侠士，是否确认加入<font color=\'#FF0000\'>魔界大陆阵营</font>，一旦加入，无法修改。";
         }
         AlertManager.showSimpleAlert(_loc2_,onApplyFunction);
      }
      
      private static function onApplyFunction() : void
      {
         ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,onJoinBack);
         ActivityExchangeCommander.exchange(3985,_selectedSide);
      }
      
      private static function onJoinBack(param1:ExchangeEvent) : void
      {
         var _loc2_:ActivityExchangeAwardInfo = param1.info;
         if(_loc2_.id == 3985)
         {
            ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,onJoinBack);
            AlertManager.showSimpleAlarm("恭喜小侠士加入阵营成功。");
            MainManager.actorInfo.side = _selectedSide;
            UserManager.dispatchEvent(new UserEvent(UserEvent.JOIN_PVP_SUCCESS));
            ModuleManager.closeAllModule();
            ModuleManager.turnAppModule("PvpSideMainPanel");
            init();
            setup(_selectedSide);
         }
      }
      
      public static function destory() : void
      {
         removeEvent();
         _pkUserInfo = null;
      }
      
      private static function addEvent() : void
      {
         MapManager.addEventListener(MapEvent.MAP_SWITCH_OPEN,onMapChangeComplete);
      }
      
      private static function removeEvent() : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_OPEN,onMapChangeComplete);
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,onJoinBack);
         UserManager.removeEventListener(UserEvent.CLICK,onUserClick);
         if(_pkUserInfo)
         {
            UserManager.removeUserListener(UserEvent.PVP_CHANGE,_pkUserInfo.userID,initPvPState);
         }
      }
      
      private static function onMapChangeComplete(param1:MapEvent) : void
      {
         checkPvpStatus(param1.mapModel);
      }
      
      private static function checkPvpStatus(param1:MapModel) : void
      {
         if(!param1)
         {
            return;
         }
         if(_totalMap.indexOf(param1.info.id) == -1)
         {
            isNeedToDisplayPvp = false;
         }
         else
         {
            isNeedToDisplayPvp = true;
         }
      }
      
      public static function openMainPanel() : void
      {
         if(MainManager.actorInfo.side == 0)
         {
            AlertManager.showSimpleAlert("小侠士，必须先选择阵营才能进行阵营活动哦，是否打开阵营面板？",function():void
            {
               ModuleManager.turnAppModule("JoinPvpSidePanel");
            });
         }
         else
         {
            ModuleManager.turnAppModule("PvpSideMainPanel");
         }
      }
      
      public static function openYaBiaoPanel() : void
      {
         if(MainManager.actorInfo.side == 0)
         {
            AlertManager.showSimpleAlert("小侠士，必须先选择阵营才能进行阵营活动哦，是否打开阵营面板？",function():void
            {
               ModuleManager.turnAppModule("JoinPvpSidePanel");
            });
         }
         else
         {
            if(MainManager.actorInfo.side == 1 && MapManager.currentMap.info.id != 7)
            {
               AlertManager.showSimpleAlert("小侠士您是艾尔大陆阵营的，必须到功夫城广场才能接取阵营押镖任务哦，是否确认前往？",function():void
               {
                  CityMap.instance.tranToNpc(10410);
               });
               return;
            }
            if(MainManager.actorInfo.side == 2 && MapManager.currentMap.info.id != 101)
            {
               AlertManager.showSimpleAlert("小侠士您是魔界大陆阵营的，必须到大荒城才能接取阵营押镖任务哦，是否确认前往？",function():void
               {
                  CityMap.instance.tranToNpc(10538);
               });
               return;
            }
            ModuleManager.turnAppModule("PvpSendObjectPanel");
         }
      }
   }
}

