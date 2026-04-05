package com.gfp.app.mapProcess
{
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.ui.alert.TextAlert;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   public class MapProcess_1094201 extends BaseMapProcess
   {
      
      private var _timeID:uint;
      
      private var _round:uint = 1;
      
      public function MapProcess_1094201()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.addItemListener();
         this.addTick();
      }
      
      private function addItemListener() : void
      {
         UserManager.addEventListener(UserEvent.BORN,this.onUserBorn);
         UserManager.addEventListener(UserEvent.DIE,this.onUserDie);
      }
      
      private function removeListener() : void
      {
         UserManager.removeEventListener(UserEvent.BORN,this.onUserBorn);
         UserManager.removeEventListener(UserEvent.DIE,this.onUserDie);
      }
      
      private function onUserBorn(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         if(_loc2_.info.roleType == 13097)
         {
            this.clearTick();
         }
      }
      
      private function onUserDie(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         if(_loc2_.info.roleType == 11356)
         {
            this.clearBlock();
            this.clearTick();
         }
      }
      
      private function addTick() : void
      {
         this._timeID = setInterval(this.onTickTime,20000);
         this.excAlert();
      }
      
      private function onTickTime() : void
      {
         ++this._round;
         this.excAlert();
      }
      
      private function excAlert() : void
      {
         TextAlert.show("第" + this._round + "波怪物即将出现");
      }
      
      private function clearTick() : void
      {
         if(this._timeID != 0)
         {
            clearInterval(this._timeID);
            this._timeID = 0;
         }
      }
      
      private function clearBlock() : void
      {
         MapManager.currentMap.updatePathData(200,150,200,310,true);
      }
      
      override public function destroy() : void
      {
         this.removeListener();
         this.clearTick();
         super.destroy();
      }
   }
}

