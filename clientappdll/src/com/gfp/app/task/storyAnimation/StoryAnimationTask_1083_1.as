package com.gfp.app.task.storyAnimation
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.cartoon.event.AnimatEvent;
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.model.MapModel;
   import com.gfp.core.model.sensemodels.SightModel;
   import flash.display.MovieClip;
   
   public class StoryAnimationTask_1083_1 implements IStoryAnimation
   {
      
      private var _drankMC:MovieClip;
      
      private var _grandpaNPC:SightModel;
      
      private var _mapModel:MapModel;
      
      public function StoryAnimationTask_1083_1()
      {
         super();
      }
      
      public function setParams(param1:String) : void
      {
         this.start();
      }
      
      public function start() : void
      {
         AnimatPlay.addAnimatListener(AnimatEvent.ANIMAT_END,this.onFinishHandler);
         AnimatPlay.startAnimat("StoryAnimationTask_1083_",1,true,1,0,false,false);
         this.onStart();
      }
      
      public function onStart() : void
      {
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_START,"");
      }
      
      public function onFinishHandler(param1:AnimatEvent) : void
      {
         this.onFinish();
         AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onFinishHandler);
      }
      
      public function onFinish() : void
      {
         TasksManager.taskComplete(1835,1);
         NpcDialogController.showForNpc(10432);
      }
   }
}

