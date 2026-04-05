package com.gfp.app.mapProcess
{
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   
   public class MapProcess_1040201 extends BaseMapProcess
   {
      
      private var _score:int;
      
      protected var monsterIDs:Array = [11778,11779,11780,11781,11782,11783,11784,11785,11786,11787,11797];
      
      public function MapProcess_1040201()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.addMapListener();
      }
      
      private function addMapListener() : void
      {
         UserManager.addEventListener(UserEvent.DIE,this.onUserDied);
      }
      
      private function removeMapListener() : void
      {
         UserManager.removeEventListener(UserEvent.DIE,this.onUserDied);
      }
      
      private function onUserDied(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         if(this.monsterIDs.indexOf(_loc2_.info.roleType) != -1)
         {
            ++this._score;
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.removeMapListener();
         AlertManager.showSimpleAlarm("本次击杀" + this._score + "个怪物",function():void
         {
            ModuleManager.turnAppModule("ChariotPanel");
         });
      }
   }
}

