package com.gfp.app.task.storyAnimation
{
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.MapManager;
   import com.greensock.TweenLite;
   import com.greensock.easing.Quad;
   import flash.display.MovieClip;
   import flash.events.Event;
   import org.taomee.manager.DepthManager;
   import org.taomee.utils.Tick;
   
   public class StoryAnimationTask_2_1 implements IStoryAnimation
   {
      
      private const CAMERA_TARGET_X:Number = 420;
      
      private var _cameraX:Number;
      
      private var _cameraY:Number;
      
      private var _params:String;
      
      private var _curtainMC:MovieClip;
      
      private var _bibleMC:MovieClip;
      
      public function StoryAnimationTask_2_1()
      {
         super();
      }
      
      public function setParams(param1:String) : void
      {
         this._params = param1;
      }
      
      public function start() : void
      {
         MainManager.closeOperate();
         this.playCurtainAnimation();
         MainManager.actorModel.execStandAction();
         this.onStart();
      }
      
      public function onStart() : void
      {
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_START,"");
      }
      
      private function scrollMap() : void
      {
         this._cameraX = MapManager.currentMap.camera.viewArea.x;
         this._cameraY = MapManager.currentMap.camera.viewArea.y;
         Tick.instance.addCallback(this.onTick);
      }
      
      private function onTick(param1:int) : void
      {
         if(this.CAMERA_TARGET_X - this._cameraX > 2)
         {
            this._cameraX += (this.CAMERA_TARGET_X - this._cameraX) * 0.1;
            MapManager.currentMap.camera.scroll(this._cameraX,this._cameraY);
         }
         else
         {
            Tick.instance.removeCallback(this.onTick);
            this.playCurtainAnimation();
         }
      }
      
      private function playCurtainAnimation() : void
      {
         var _loc1_:Array = this._params.split(".");
         this._curtainMC = MapManager.currentMap[_loc1_[0]][_loc1_[1]] as MovieClip;
         this._curtainMC.visible = true;
         this._curtainMC.addEventListener(Event.ENTER_FRAME,this.onCurtainPlay);
         this._curtainMC.play();
      }
      
      public function onCurtainPlay(param1:Event) : void
      {
         if(this._curtainMC.currentFrame == this._curtainMC.totalFrames)
         {
            this._curtainMC.removeEventListener(Event.ENTER_FRAME,this.onCurtainPlay);
            this._bibleMC = this._curtainMC["bible"];
            MapManager.currentMap.contentLevel.addChild(this._curtainMC);
            this.moveBibleToActor();
         }
      }
      
      private function moveBibleToActor() : void
      {
         var _loc1_:Number = Number(MainManager.actorModel.x);
         var _loc2_:Number = MainManager.actorModel.y - MainManager.actorModel.height - 10;
         var _loc3_:Number = _loc1_ - this._curtainMC.x;
         var _loc4_:Number = _loc2_ - this._curtainMC.y;
         TweenLite.to(this._bibleMC,1,{
            "x":_loc3_,
            "y":_loc4_,
            "ease":Quad.easeIn,
            "onComplete":this.onFinishTween
         });
      }
      
      private function onFinishTween() : void
      {
         this._bibleMC.addEventListener(Event.ENTER_FRAME,this.onBiblePlay);
         this._bibleMC.gotoAndPlay(21);
      }
      
      private function onBiblePlay(param1:Event) : void
      {
         if(this._bibleMC.currentFrame == this._bibleMC.totalFrames)
         {
            this._bibleMC.removeEventListener(Event.ENTER_FRAME,this.onBiblePlay);
            this._curtainMC.visible = false;
            this.onFinish();
         }
      }
      
      public function onFinish() : void
      {
         this._curtainMC.play();
         DepthManager.swapDepthAll(MapManager.currentMap.contentLevel);
         MainManager.openOperate();
         NpcDialogController.showForNpc(10001);
      }
   }
}

