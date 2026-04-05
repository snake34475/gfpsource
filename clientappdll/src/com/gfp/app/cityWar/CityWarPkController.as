package com.gfp.app.cityWar
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.fight.FightWaitPanel;
   import com.gfp.app.fight.SinglePkManager;
   import com.gfp.app.manager.CityWarManager;
   import com.gfp.app.time.CutDownTimePanel;
   import com.gfp.core.CommandID;
   import com.gfp.core.action.data.HitEffInfo;
   import com.gfp.core.action.normal.DieAction;
   import com.gfp.core.config.xml.ActionXMLInfo;
   import com.gfp.core.config.xml.MapXMLInfo;
   import com.gfp.core.controller.MouseController;
   import com.gfp.core.controller.SocketSendController;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.FriendInviteInfo;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.PvpIDConstantUtil;
   import com.gfp.core.utils.PvpTypeConstantUtil;
   import com.gfp.core.utils.StringConstants;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class CityWarPkController
   {
      
      private static var _instance:CityWarPkController;
      
      public static const REVIVE_SECOND:uint = 20;
      
      public static var tollgateDis:Boolean = false;
      
      private var _enemyUserID:uint;
      
      private var _cutDownHolder:Sprite;
      
      private var _reviveTimeID:uint;
      
      private var _reviveCount:uint;
      
      public function CityWarPkController()
      {
         super();
      }
      
      public static function get instance() : CityWarPkController
      {
         if(_instance == null)
         {
            _instance = new CityWarPkController();
         }
         return _instance;
      }
      
      public static function destroy() : void
      {
         if(_instance)
         {
            _instance.destroy();
         }
         _instance = null;
      }
      
      public function setup() : void
      {
         this.addEvent();
         this._cutDownHolder = new Sprite();
         this._cutDownHolder.scaleX = this._cutDownHolder.scaleY = 3;
      }
      
      private function addEvent() : void
      {
         SocketConnection.addCmdListener(CommandID.CITY_WAR_PK,this.onSinglePK);
         SocketConnection.addCmdListener(CommandID.USER_IN_FIGHT,this.onUserInFight);
         SocketConnection.addCmdListener(CommandID.CITY_WAR_RESULT,this.onWarResult);
         SocketConnection.addCmdListener(CommandID.CITY_WAR_REVIVE,this.onUserRevive);
         FightManager.instance.addEventListener(FightEvent.REASON,this.onFightLose);
      }
      
      private function removeEvent() : void
      {
         SocketConnection.removeCmdListener(CommandID.CITY_WAR_PK,this.onSinglePK);
         SocketConnection.removeCmdListener(CommandID.USER_IN_FIGHT,this.onUserInFight);
         SocketConnection.removeCmdListener(CommandID.CITY_WAR_RESULT,this.onWarResult);
         SocketConnection.removeCmdListener(CommandID.CITY_WAR_REVIVE,this.onUserRevive);
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         FightManager.instance.removeEventListener(FightEvent.REASON,this.onFightLose);
      }
      
      public function backHome() : void
      {
         var _loc2_:uint = 0;
         if(CityWarManager.instance.teamID == 1)
         {
            _loc2_ = CityWarManager.RED_BASE_MAP;
         }
         else
         {
            _loc2_ = CityWarManager.BLUE_BASE_MAP;
         }
         var _loc1_:Point = MapXMLInfo.getDefaultPos(_loc2_);
         FightManager.outToMapID = _loc2_;
         FightManager.outToMapPos = _loc1_;
         CityWarManager.instance.newMapID = _loc2_;
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
      }
      
      private function onMapSwitchComplete(param1:MapEvent) : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         MainManager.actorModel.execAction(new DieAction(ActionXMLInfo.getInfo(40004),new HitEffInfo(),MainManager.actorModel.pos));
         LayerManager.openMouseEvent();
         LayerManager.topLevel.addChild(this._cutDownHolder);
         DisplayUtil.align(this._cutDownHolder,null,AlignType.MIDDLE_CENTER);
         this._reviveTimeID = setInterval(this.updateTime,1000);
      }
      
      private function updateTime() : void
      {
         var _loc3_:Sprite = null;
         this.clearCutDownHolder();
         ++this._reviveCount;
         var _loc1_:String = Math.max(0,20 - this._reviveCount).toString();
         var _loc2_:uint = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = UIManager.getSprite("Number_Get_" + _loc1_.charAt(_loc2_));
            _loc3_.x = _loc2_ * 15;
            this._cutDownHolder.addChild(_loc3_);
            _loc2_++;
         }
      }
      
      private function clearCutDown() : void
      {
         DisplayUtil.removeForParent(this._cutDownHolder);
         clearInterval(this._reviveTimeID);
         this._reviveCount = 0;
         this.clearCutDownHolder();
      }
      
      private function clearCutDownHolder() : void
      {
         while(this._cutDownHolder.numChildren)
         {
            this._cutDownHolder.removeChildAt(0);
         }
      }
      
      private function onSinglePK(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         this._enemyUserID = _loc2_.readUnsignedInt();
         UserManager.addUserListener(UserEvent.PVP_CHANGE,this._enemyUserID,this.initPvPState);
         SocketSendController.sendPvpInviteCMD(false,PvpIDConstantUtil.CITY_WAR_PVP_ID,PvpTypeConstantUtil.PVP_TYPE_INVITE,0);
      }
      
      private function initPvPState(param1:UserEvent) : void
      {
         var _loc2_:uint = uint(param1.type.split(StringConstants.SIGN)[2]);
         UserManager.removeUserListener(UserEvent.PVP_CHANGE,_loc2_,this.initPvPState);
         var _loc3_:uint = uint(int(param1.data));
         if(_loc3_ != 0 && _loc2_ != 0)
         {
            SinglePkManager.instance.openInviteBattery();
            FightWaitPanel.showWaitPanel();
            MainManager.closeOperate();
            MainManager.actorModel.actionManager.clear();
            MainManager.actorModel.execStandAction(false);
            SocketConnection.send(CommandID.TEAM_INVITE_FRIEND,FriendInviteInfo.CITY_WAR_PVP,_loc2_,_loc3_,0,0);
         }
      }
      
      private function onUserInFight(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         var _loc6_:uint = _loc2_.readUnsignedInt();
         var _loc7_:uint = _loc2_.readUnsignedInt();
         if(_loc4_ != 0)
         {
            TowerController.instance.updateAtkUser(_loc4_,_loc3_,_loc5_,_loc6_);
         }
         if(_loc3_ == MainManager.actorID)
         {
            MainManager.actorModel.execStandAction();
            return;
         }
         var _loc8_:UserModel = UserManager.getModel(_loc3_);
         if(_loc8_)
         {
            if(_loc6_ == 1)
            {
               _loc8_.execStandAction(false);
               _loc8_.changeOverHeadSprite(2);
            }
            if(MapManager.mapInfo.mapType == MapType.PVP && _loc6_ == 2)
            {
               UserManager.remove(_loc3_);
               _loc8_.destroy();
               _loc8_ = null;
            }
            else if(_loc6_ == 2 && _loc7_ == 1)
            {
               _loc8_.changeOverHeadSprite(1);
            }
         }
      }
      
      public function onWarResult(param1:SocketEvent) : void
      {
         var _loc5_:uint = 0;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         CutDownTimePanel.destroy();
         if(_loc4_ > 0)
         {
            TextAlert.show("城战将在" + _loc4_ + "秒后结束，敬请小侠士等待领取奖励。");
            tollgateDis = true;
            if(Boolean(MapManager.mapInfo) && MapManager.mapInfo.mapType != MapType.STAND)
            {
               FightManager.quit();
            }
            return;
         }
         MainManager.closeOperate();
         ModuleManager.closeAllModule();
         if(_loc3_ == 1)
         {
            _loc5_ = uint(MainManager.actorInfo.overHeadState);
         }
         else
         {
            _loc5_ = 3 - MainManager.actorInfo.overHeadState;
         }
         ModuleManager.turnAppModule("CityWarDataPanel","",_loc5_);
         ModuleManager.turnAppModule("CityWarAwardPanel","",_loc3_);
      }
      
      public function onUserRevive(param1:SocketEvent) : void
      {
         var _loc4_:UserModel = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         if(_loc3_ == MainManager.actorID)
         {
            MainManager.actorModel.actionManager.clear();
            MainManager.actorModel.execStandAction(false);
            MainManager.openOperate();
            MouseController.instance.clear();
         }
         else if(UserManager.contains(_loc3_))
         {
            _loc4_ = UserManager.getModel(_loc3_);
            _loc4_.actionManager.clear();
            _loc4_.execStandAction(false);
         }
         this.clearCutDown();
      }
      
      private function onFightLose(param1:FightEvent) : void
      {
         FightManager.quit();
      }
      
      public function get enemyUserID() : uint
      {
         return this._enemyUserID;
      }
      
      public function destroy() : void
      {
         tollgateDis = false;
         this.removeEvent();
         this.clearCutDown();
         this._cutDownHolder = null;
      }
   }
}

