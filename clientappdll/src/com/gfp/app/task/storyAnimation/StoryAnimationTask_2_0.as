package com.gfp.app.task.storyAnimation
{
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.MapModel;
   import com.gfp.core.model.sensemodels.SightModel;
   import flash.display.MovieClip;
   import flash.events.Event;
   import org.taomee.utils.DisplayUtil;
   
   public class StoryAnimationTask_2_0 implements IStoryAnimation
   {
      
      private var _drankMC:MovieClip;
      
      private var _grandpaNPC:SightModel;
      
      private var _mapModel:MapModel;
      
      public function StoryAnimationTask_2_0()
      {
         super();
      }
      
      public function setParams(param1:String) : void
      {
      }
      
      public function start() : void
      {
         MainManager.closeOperate();
         this._mapModel = MapManager.currentMap;
         this._grandpaNPC = SightManager.getSightModel(10001);
         this.playDrankAnimat();
         this.onStart();
      }
      
      private function playDrankAnimat() : void
      {
         if(this._mapModel)
         {
            this._drankMC = this._mapModel.libManager.getMovieClip("grandpa_drank_mc");
            this._drankMC.addEventListener(Event.ENTER_FRAME,this.drankEnterFrame);
            this._drankMC.rotationY = 180;
            this._drankMC.x = this._grandpaNPC.x + 40;
            this._drankMC.y = this._grandpaNPC.y - 70;
            this._grandpaNPC.visible = false;
            this._mapModel.contentLevel.addChild(this._drankMC);
         }
      }
      
      private function drankEnterFrame(param1:Event) : void
      {
         if(this._drankMC.currentFrame == this._drankMC.totalFrames)
         {
            this._drankMC.removeEventListener(Event.ENTER_FRAME,this.drankEnterFrame);
            this._grandpaNPC.visible = true;
            DisplayUtil.removeForParent(this._drankMC);
            this.onFinish();
         }
      }
      
      public function onStart() : void
      {
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_START,"");
      }
      
      public function onFinish() : void
      {
         MainManager.openOperate();
         NpcDialogController.showForNpc(10001);
      }
   }
}

