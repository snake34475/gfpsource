package com.gfp.app.mapProcess
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.cartoon.event.AnimatEvent;
   import com.gfp.core.events.SkillEvent;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   
   public class MapProcess_1115202 extends BaseMapProcess
   {
      
      public function MapProcess_1115202()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         UserManager.addEventListener(SkillEvent.SKILL_ACTION,this.onSkill);
      }
      
      private function onSkill(param1:SkillEvent) : void
      {
         var _loc2_:UserModel = null;
         if(param1.skillID == 4120601)
         {
            AnimatPlay.addAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimatEndHandle);
            AnimatPlay.startAnimat("fight_1083_hands",-1,false,0,0,false,false,false,0);
            _loc2_ = UserManager.getModelByRoleType(14252);
            _loc2_ && (_loc2_.visible = false);
            _loc2_ = UserManager.getModelByRoleType(14253);
            _loc2_ && (_loc2_.visible = false);
         }
      }
      
      private function onAnimatEndHandle(param1:AnimatEvent) : void
      {
         AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimatEndHandle);
         var _loc2_:UserModel = UserManager.getModelByRoleType(14252);
         _loc2_ && (_loc2_.visible = true);
         _loc2_ = UserManager.getModelByRoleType(14253);
         _loc2_ && (_loc2_.visible = true);
      }
      
      override public function destroy() : void
      {
         UserManager.removeEventListener(SkillEvent.SKILL_ACTION,this.onSkill);
         super.destroy();
      }
   }
}

