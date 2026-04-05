package com.gfp.app.task.storyAnimation
{
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.MapModel;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class StoryAnimationTask_10_0 implements IStoryAnimation
   {
      
      private var _params:String;
      
      private var _mainMC:MovieClip;
      
      public function StoryAnimationTask_10_0()
      {
         super();
      }
      
      public function setParams(param1:String) : void
      {
         this._params = param1;
      }
      
      public function start() : void
      {
         MainManager.openOperate();
         this.playMC();
         this.onStart();
      }
      
      private function playMC() : void
      {
         var _loc2_:Array = null;
         var _loc1_:MapModel = MapManager.currentMap;
         if(_loc1_)
         {
            _loc2_ = this._params.split(".");
            this._mainMC = _loc1_[_loc2_[0]][_loc2_[1]] as MovieClip;
            if(this._mainMC)
            {
               this._mainMC.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
               this._mainMC.visible = true;
               this._mainMC.gotoAndPlay(2);
            }
         }
      }
      
      public function onEnterFrame(param1:Event) : void
      {
         if(this._mainMC.currentFrame == this._mainMC.totalFrames)
         {
            this._mainMC.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            this.onFinish();
         }
      }
      
      public function onStart() : void
      {
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_START,"");
      }
      
      public function onFinish() : void
      {
         if(this._mainMC)
         {
            this._mainMC.visible = false;
         }
         MainManager.openOperate();
         NpcDialogController.showForNpc(10011);
      }
   }
}

