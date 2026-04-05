package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.app.task.storyAnimation.IStoryAnimation;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.utils.Logger;
   import com.gfp.core.utils.StringConstants;
   import org.taomee.utils.Utils;
   
   public class TaskXML_StoryAnimation extends TaskXML_Base
   {
      
      public static const STORY_ANIMATION_PATH:String = "com.gfp.app.task.storyAnimation.";
      
      private var _storyAnimation:IStoryAnimation;
      
      public function TaskXML_StoryAnimation()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:String = Logger.createLogMsgByArr("TaskXML_AutoComplete setup:",_params,param1,param2);
         Logger.info(this,_loc5_);
         var _loc6_:Array = _params.split(StringConstants.TASK_PARAM_SIGN);
         var _loc7_:Class = Utils.getClass(STORY_ANIMATION_PATH + _loc6_[0]);
         this._storyAnimation = new _loc7_() as IStoryAnimation;
         this._storyAnimation.setParams(_loc6_[1]);
      }
      
      override public function init(param1:Boolean) : void
      {
         super.init(param1);
         this._storyAnimation.start();
      }
      
      override protected function addListener() : void
      {
         TasksManager.addActionListener(TaskActionEvent.TASK_ANIMATION_START,"",this.onAnimationStart);
      }
      
      protected function onAnimationStart(param1:TaskActionEvent) : void
      {
         TasksManager.taskProComplete(_taskID,_proID);
         this.uninit();
      }
      
      override public function uninit() : void
      {
         TasksManager.removeActionListener(TaskActionEvent.TASK_ANIMATION_START,"",this.onAnimationStart);
      }
      
      override public function get isComplete() : Boolean
      {
         return TasksManager.getTaskProStatus(_taskID,_proID) == TasksManager.STEP_COMPLETE;
      }
   }
}

