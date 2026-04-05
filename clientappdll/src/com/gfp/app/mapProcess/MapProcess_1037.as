package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.PveEntry;
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.app.task.storyAnimation.StoryAnimationTask_1901_1;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.sensemodels.SightModel;
   import flash.display.MovieClip;
   import flash.events.Event;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1037 extends BaseMapProcess
   {
      
      private var sightModel_10446:SightModel;
      
      private var sightModel_10447:SightModel;
      
      private var sightModel_10448:SightModel;
      
      private var _missAnimat:MovieClip;
      
      public function MapProcess_1037()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.sightModel_10446 = SightManager.getSightModel(10446);
         this.sightModel_10447 = SightManager.getSightModel(10447);
         this.sightModel_10448 = SightManager.getSightModel(10448);
         if(this.sightModel_10447 == null)
         {
            return;
         }
         this.sightModel_10447.hide();
         if(this.sightModel_10448 == null)
         {
            return;
         }
         this.sightModel_10448.hide();
         if(TasksManager.isProcess(1899,4))
         {
            this.sightModel_10447.show();
            this.sightModel_10448.show();
         }
         if(Boolean(TasksManager.isCompleted(1916)) && Boolean(this.sightModel_10446))
         {
            this.sightModel_10446.hide();
         }
         TasksManager.addListener(TaskEvent.ACCEPT,this.onTaskAccept);
         TasksManager.addListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
         TasksManager.addListener(TaskEvent.COMPLETE,this.onTaskComplete);
      }
      
      private function onTaskAccept(param1:TaskEvent) : void
      {
         if(param1.taskID == 1916)
         {
            PveEntry.enterTollgate(506);
         }
      }
      
      private function onTaskProComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 1899 && param1.proID == 4)
         {
            this.sightModel_10447.hide();
            this.sightModel_10448.hide();
         }
         else if(param1.taskID == 1901 && param1.proID == 0)
         {
            new StoryAnimationTask_1901_1().onStart();
         }
         else if(param1.taskID == 1901 && param1.proID == 1)
         {
            NpcDialogController.showForNpc(10446);
         }
      }
      
      private function onTaskComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 1916 && Boolean(this.sightModel_10446))
         {
            this._missAnimat = MapManager.currentMap.libManager.getMovieClip("missAnimat");
            this._missAnimat.x = 1422.4;
            this._missAnimat.y = 8.95;
            this._missAnimat.scaleX = -0.66;
            this._missAnimat.scaleY = 0.66;
            MapManager.currentMap.contentLevel.addChild(this._missAnimat);
            this._missAnimat.addEventListener(Event.ENTER_FRAME,this.onAnimatFrame);
            this._missAnimat.gotoAndPlay(1);
            this.sightModel_10446.hide();
         }
      }
      
      private function onAnimatFrame(param1:Event) : void
      {
         if(this._missAnimat.currentFrame == this._missAnimat.totalFrames)
         {
            this._missAnimat.removeEventListener(Event.ENTER_FRAME,this.onAnimatFrame);
            DisplayUtil.removeForParent(this._missAnimat);
            this._missAnimat = null;
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(this._missAnimat)
         {
            this._missAnimat.removeEventListener(Event.ENTER_FRAME,this.onAnimatFrame);
         }
         DisplayUtil.removeForParent(this._missAnimat);
         this._missAnimat = null;
         TasksManager.removeListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
         TasksManager.removeListener(TaskEvent.COMPLETE,this.onTaskComplete);
      }
   }
}

