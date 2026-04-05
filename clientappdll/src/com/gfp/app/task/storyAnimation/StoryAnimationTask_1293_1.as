package com.gfp.app.task.storyAnimation
{
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.TasksManager;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class StoryAnimationTask_1293_1 extends BaseStoryAnimation
   {
      
      private var _doneBtn:SimpleButton;
      
      private var _param:Boolean;
      
      public function StoryAnimationTask_1293_1()
      {
         super();
      }
      
      override public function onStart() : void
      {
         if(this._param)
         {
            TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_START,"");
         }
         super.onStart();
      }
      
      override protected function loadAnimat() : void
      {
         loadAndPlayAnimat("task1293_1","mainMC");
      }
      
      override protected function onEnterFrame(param1:Event) : void
      {
      }
      
      override public function setParams(param1:String) : void
      {
         if(param1 == "true")
         {
            this._param = true;
         }
         else
         {
            this._param = false;
         }
      }
      
      override public function onFinish() : void
      {
         super.onFinish();
         if(this._param)
         {
            NpcDialogController.showForNpc(10005);
         }
      }
      
      override protected function onLoadComplete(param1:UILoadEvent) : void
      {
         super.onLoadComplete(param1);
         this._doneBtn = _mainMC["doneBtn"];
         this._doneBtn.addEventListener(MouseEvent.CLICK,onClose);
         _mainMC.stop();
      }
      
      override protected function destroy() : void
      {
         super.destroy();
         this._doneBtn.removeEventListener(MouseEvent.CLICK,onClose);
         this._doneBtn = null;
      }
   }
}

