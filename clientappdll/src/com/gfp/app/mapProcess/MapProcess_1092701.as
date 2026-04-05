package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightGo;
   import com.gfp.core.config.xml.RoleXMLInfo;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.TextFormatUtil;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class MapProcess_1092701 extends BaseMapProcess
   {
      
      private var _dieCount:uint;
      
      private var _monsterName:String;
      
      private var _monsterId:int = 11311;
      
      private var _timer:Timer;
      
      public function MapProcess_1092701()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._monsterName = RoleXMLInfo.getName(this._monsterId);
         this._timer = new Timer(10000,12);
         this._timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this._timer.start();
         FightGo.instance.enabledShow = false;
         this.addItemListener();
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         var _loc3_:int = 0;
         var _loc2_:String = "";
         if(this._timer.currentCount == 6)
         {
            _loc3_ = 60;
         }
         else if(this._timer.currentCount == 11)
         {
            _loc3_ = 10;
         }
         if(_loc3_ > 0)
         {
            _loc2_ = TextFormatUtil.substitute(AppLanguageDefine.MAPPROCESS_MSG_ARR[1],_loc3_);
            TextAlert.show(_loc2_);
         }
      }
      
      private function addItemListener() : void
      {
         UserManager.addEventListener(UserEvent.DIE,this.onUserDied);
      }
      
      private function onUserDied(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         if(_loc2_.info.roleType == this._monsterId)
         {
            ++this._dieCount;
            this.execAlert();
         }
      }
      
      private function removeItemListener() : void
      {
         UserManager.removeEventListener(UserEvent.DIE,this.onUserDied);
      }
      
      private function execAlert() : void
      {
         var _loc2_:String = null;
         var _loc1_:int = 100 - this._dieCount;
         if(_loc1_ > 0)
         {
            _loc2_ = TextFormatUtil.substitute(AppLanguageDefine.MAPPROCESS_MSG_ARR[0],this._dieCount,this._monsterName);
            TextAlert.show(TextFormatUtil.getRedText(_loc2_));
         }
      }
      
      override public function destroy() : void
      {
         this.removeItemListener();
         this._timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
         this._timer.stop();
         this._timer = null;
         FightGo.instance.enabledShow = true;
      }
   }
}

