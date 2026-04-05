package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.model.sensemodels.SightModel;
   import com.gfp.core.utils.SpriteType;
   
   public class MapProcess_1092202 extends BaseMapProcess
   {
      
      private var _npc10133:SightModel;
      
      private var _npc10134:SightModel;
      
      private var _npc10135:SightModel;
      
      public function MapProcess_1092202()
      {
         super();
      }
      
      override protected function init() : void
      {
         FightManager.isAutoWinnerEnd = false;
      }
      
      private function addFightLister() : void
      {
         UserManager.addEventListener(UserEvent.DIE,this.onUserDied);
      }
      
      private function onUserDied(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data;
         if(_loc2_.spriteType == SpriteType.OGRE)
         {
            if(_loc2_.info.roleType == 13072)
            {
               _loc2_.hide();
               this.hideSighModel();
            }
         }
      }
      
      private function hideSighModel() : void
      {
         SightManager.hideModelById(10133);
         SightManager.hideModelById(10134);
         SightManager.hideModelById(10135);
         MainManager.actorModel.visible = false;
         SummonManager.setActorSummonVisible(false);
         MainManager.closeOperate();
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
   }
}

