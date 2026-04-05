package com.gfp.app.task.storyAnimation
{
   import com.gfp.app.fight.PveEntry;
   import com.gfp.app.info.dialog.DialogInfoSimple;
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.MapManager;
   import flash.geom.Rectangle;
   
   public class StoryAnimationTask_40_2 extends BaseStoryAnimation
   {
      
      private var _oldCameraRect:Rectangle;
      
      public function StoryAnimationTask_40_2()
      {
         super();
      }
      
      override protected function loadAnimat() : void
      {
         loadAndPlayAnimat("task40_2","mc");
      }
      
      override protected function onLoadComplete(param1:UILoadEvent) : void
      {
         super.onLoadComplete(param1);
         _background.visible = false;
      }
      
      override public function onStart() : void
      {
         this.setCameraView();
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_START,"");
         super.onStart();
      }
      
      override public function onFinish() : void
      {
         super.onFinish();
         this.resetCameraView();
         this.initNpcDialog();
      }
      
      private function setCameraView() : void
      {
         this._oldCameraRect = MapManager.currentMap.camera.viewArea.clone();
         MapManager.currentMap.camera.scroll(455,335);
      }
      
      private function resetCameraView() : void
      {
         MapManager.currentMap.camera.scroll(this._oldCameraRect.x,this._oldCameraRect.y);
         MainManager.actorModel.execStandAction();
      }
      
      private function initNpcDialog() : void
      {
         var _loc1_:DialogInfoSimple = null;
         if(!TasksManager.isProcess(40,2) && Boolean(TasksManager.isProcess(40,3)))
         {
            _loc1_ = new DialogInfoSimple(["我看到乔伊打开了封印！他带着妖物大军前往一气学院了！小侠士，一气学院有危险了！"],"大事不妙，我这就赶回一气学院！");
            NpcDialogController.showForSimple(_loc1_,10119,this.onEnterTollgate);
         }
      }
      
      private function onEnterTollgate() : void
      {
         PveEntry.enterTollgate(922);
      }
   }
}

