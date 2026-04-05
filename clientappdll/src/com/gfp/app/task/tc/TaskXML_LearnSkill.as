package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.events.SkillLearnEvent;
   import com.gfp.core.manager.SkillManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.utils.Logger;
   
   public class TaskXML_LearnSkill extends TaskXML_Base
   {
      
      public function TaskXML_LearnSkill()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:String = Logger.createLogMsgByArr(_params,param1,param2);
         Logger.info(this,_loc5_);
      }
      
      override protected function addListener() : void
      {
         SkillManager.addEventListener(SkillLearnEvent.LEARN_SKILL,this.onSkillLearn);
      }
      
      private function onSkillLearn(param1:SkillLearnEvent) : void
      {
         TasksManager.taskProComplete(_taskID,_proID);
         this.uninit();
      }
      
      override public function uninit() : void
      {
         SkillManager.removeEventListener(SkillLearnEvent.LEARN_SKILL,this.onSkillLearn);
      }
      
      override public function get isComplete() : Boolean
      {
         return TasksManager.getTaskProStatus(_taskID,_proID) == TasksManager.STEP_COMPLETE;
      }
   }
}

