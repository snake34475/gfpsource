package com.gfp.app.task.storyAnimation
{
   import com.gfp.core.manager.TasksManager;
   
   public class StoryAnimationTask_2028_1 extends BaseStoryAnimation
   {
      
      public function StoryAnimationTask_2028_1()
      {
         super();
      }
      
      override protected function loadAnimat() : void
      {
         loadAndPlayAnimat("StoryAnimationTask_2028_1","animat");
      }
      
      override public function onFinish() : void
      {
         super.onFinish();
         TasksManager.taskProComplete(2028,0);
      }
   }
}

