package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   
   public class MapProcess_1093501 extends BaseMapProcess
   {
      
      private const HERO_ID:uint = 13666;
      
      public function MapProcess_1093501()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.addMapListener();
      }
      
      private function addMapListener() : void
      {
         FightManager.instance.addEventListener(FightEvent.WINNER,this.onWinner);
         UserManager.addEventListener(UserEvent.BORN,this.onUserBorn);
      }
      
      private function removeMapListener() : void
      {
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onWinner);
         UserManager.removeEventListener(UserEvent.BORN,this.onUserBorn);
      }
      
      private function onWinner(param1:FightEvent) : void
      {
         var _loc2_:Array = MainManager.actorInfo.defeatHeros;
         if(_loc2_.indexOf(this.HERO_ID) == -1)
         {
            MainManager.actorInfo.defeatHeros.push(this.HERO_ID);
         }
      }
      
      private function onUserBorn(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         var _loc3_:UserInfo = _loc2_.info;
         var _loc4_:* = _loc2_.info.clothes;
         if(_loc2_.info.roleType == 13091)
         {
         }
      }
      
      override public function destroy() : void
      {
         this.removeMapListener();
         super.destroy();
      }
   }
}

