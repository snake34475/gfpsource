package com.gfp.app.mapProcess
{
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.app.task.storyAnimation.StoryAnimationTask_35_1;
   import com.gfp.core.action.mouse.MouseProcess;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.taomee.manager.DepthManager;
   import org.taomee.utils.DisplayUtil;
   import org.taomee.utils.Tick;
   
   public class MapProcess_22 extends MapProcessAnimat
   {
      
      private var _stoneGroup:MovieClip;
      
      private var _animat1:StoryAnimationTask_35_1;
      
      private var _stones:MovieClip;
      
      private const CAMERA_TARGET_Y:Number = 372;
      
      private var _cameraX:Number;
      
      private var _cameraY:Number;
      
      public function MapProcess_22()
      {
         _mangoType = 1;
         super();
      }
      
      override protected function init() : void
      {
         _mangoType = 1;
         this.isAcceptTask35();
         this._stones = _mapModel.libManager.getMovieClip("_stones");
         this._stones.x = 604;
         this._stones.y = 510;
         TasksManager.addListener(TaskEvent.ACCEPT,this.onTaskAccept);
         TasksManager.addListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
         TasksManager.addListener(TaskEvent.COMPLETE,this.onTaskComplete);
      }
      
      private function onTaskAccept(param1:TaskEvent) : void
      {
         if(param1.taskID == 33)
         {
            NpcDialogController.showForNpc(10063);
         }
         if(param1.taskID == 57)
         {
            NpcDialogController.showForNpc(10064);
         }
      }
      
      private function onTaskProComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 56)
         {
            if(param1.proID == 1)
            {
               MouseProcess.execWalk(MainManager.actorModel,new Point(1847,1027));
            }
         }
      }
      
      private function onTaskComplete(param1:TaskEvent) : void
      {
      }
      
      private function isAcceptTask35() : void
      {
         if(Boolean(TasksManager.isAccepted(35)) && !TasksManager.isCompleted(35))
         {
            this._stoneGroup = _mapModel.libManager.getMovieClip("_stoneGroup");
            this._stoneGroup.x = 604;
            this._stoneGroup.y = 509;
            _mapModel.contentLevel.addChild(this._stoneGroup);
            this._stoneGroup.buttonMode = true;
            this._stoneGroup.addEventListener(MouseEvent.CLICK,this.scrollMap);
         }
      }
      
      private function scrollMap(param1:MouseEvent) : void
      {
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_MAPCOLLECT,"setCrystal");
         this._stoneGroup.removeEventListener(MouseEvent.CLICK,this.scrollMap);
         this._cameraX = _mapModel.camera.viewArea.x;
         this._cameraY = _mapModel.camera.viewArea.y;
         Tick.instance.addCallback(this.onTick);
      }
      
      private function onTick(param1:int) : void
      {
         if(this._cameraY - this.CAMERA_TARGET_Y > 20)
         {
            this._cameraY += (this.CAMERA_TARGET_Y - this._cameraY) * 0.1;
            _mapModel.camera.scroll(this._cameraX,this._cameraY);
         }
         else if(this.CAMERA_TARGET_Y - this._cameraY > 20)
         {
            this._cameraY += (this.CAMERA_TARGET_Y - this._cameraY) * 0.1;
            _mapModel.camera.scroll(this._cameraX,this._cameraY);
         }
         else
         {
            Tick.instance.removeCallback(this.onTick);
            this.onPlayAnimat();
         }
      }
      
      private function onPlayAnimat() : void
      {
         if(Boolean(TasksManager.isAccepted(35)) && !TasksManager.isCompleted(35))
         {
            DisplayUtil.removeForParent(this._stoneGroup);
            this._stoneGroup.removeEventListener(MouseEvent.CLICK,this.onPlayAnimat);
            this.playAnimat();
         }
      }
      
      private function playAnimat() : void
      {
         this._animat1 = new StoryAnimationTask_35_1();
         this._animat1.addEventListener(Event.COMPLETE,this.playAnimat2);
         this._animat1.start();
      }
      
      private function playAnimat2(param1:Event) : void
      {
         this._animat1.removeEventListener(Event.COMPLETE,this.playAnimat2);
         this._stones.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         _mapModel.contentLevel.addChild(this._stones);
         this._stones.visible = true;
         this._stones.gotoAndPlay(1);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         if(this._stones.currentFrame == this._stones.totalFrames)
         {
            DisplayUtil.removeForParent(this._stones);
            this._stones.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            this.onTask32Complete();
         }
      }
      
      private function onTask32Complete() : void
      {
         DepthManager.swapDepthAll(_mapModel.contentLevel);
         MainManager.openOperate();
         NpcDialogController.showForNpc(10063);
      }
      
      override public function destroy() : void
      {
         TasksManager.removeListener(TaskEvent.ACCEPT,this.onTaskAccept);
         this._stoneGroup = null;
         this._animat1 = null;
         this._stones = null;
         super.destroy();
      }
   }
}

