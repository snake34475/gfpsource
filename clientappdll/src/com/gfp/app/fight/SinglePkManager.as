package com.gfp.app.fight
{
   import com.gfp.app.user.UserInfoController;
   import com.gfp.core.CommandID;
   import com.gfp.core.controller.SocketSendController;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.FightMode;
   import com.gfp.core.utils.PvpTypeConstantUtil;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   public class SinglePkManager
   {
      
      private static var _instance:SinglePkManager;
      
      private const INVITE_BATTERY:uint = 180;
      
      private var _fightType:uint;
      
      private var _roomID:uint;
      
      private var _timeCount:uint;
      
      private var _timeID:uint;
      
      private var _isApplyPvP:Boolean = false;
      
      public function SinglePkManager()
      {
         super();
      }
      
      public static function get instance() : SinglePkManager
      {
         if(_instance == null)
         {
            _instance = new SinglePkManager();
         }
         return _instance;
      }
      
      public function get isApplyPvP() : Boolean
      {
         return this._isApplyPvP;
      }
      
      public function set isApplyPvP(param1:Boolean) : void
      {
         this._isApplyPvP = param1;
      }
      
      public function get fightType() : uint
      {
         return this._fightType;
      }
      
      public function set fightType(param1:uint) : void
      {
         this._fightType = param1;
      }
      
      public function get roomID() : uint
      {
         return this._roomID;
      }
      
      public function set roomID(param1:uint) : void
      {
         this._roomID = param1;
      }
      
      public function clear() : void
      {
         this._fightType = 0;
         this._roomID = 0;
         this._isApplyPvP = false;
         this.clearInviteBattery();
         FightManager.fightMode = FightMode.DEFAULT;
         UserInfoController.hasBeenInvitePK(false);
      }
      
      public function destroy() : void
      {
         this.clear();
         _instance = null;
      }
      
      public function openInviteBattery() : void
      {
         this.clearInviteBattery();
         this._timeID = setInterval(this.updateTimer,1000);
      }
      
      private function updateTimer() : void
      {
         ++this._timeCount;
         if(this._timeCount > this.INVITE_BATTERY)
         {
            this.clearInviteBattery();
            FightWaitPanel.hideWaitPanel();
            UserInfoController.hasBeenInvitePK(false);
            SocketConnection.send(CommandID.FIGHT_CANCEL);
            TextAlert.show(AppLanguageDefine.FIGHT_CHARACTER_COLLECTION[5]);
         }
      }
      
      public function clearInviteBattery() : void
      {
         if(this._timeID != 0)
         {
            clearInterval(this._timeID);
            this._timeCount = 0;
         }
      }
      
      public function joinPvPArea(param1:uint) : void
      {
         SocketSendController.sendPvpInviteCMD(false,0,PvpTypeConstantUtil.PVP_TYPE_POINT,param1);
      }
      
      public function initPvPState() : void
      {
         FightWaitPanel.showWaitPanel(false,PvpEntry.pvpID);
         TextAlert.show(AppLanguageDefine.FIGHT_CHARACTER_COLLECTION[6]);
      }
   }
}

