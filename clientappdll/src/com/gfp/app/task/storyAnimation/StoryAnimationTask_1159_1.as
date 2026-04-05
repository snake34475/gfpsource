package com.gfp.app.task.storyAnimation
{
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.MapModel;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.events.Event;
   import org.taomee.motion.easing.Quad;
   import org.taomee.utils.DisplayUtil;
   import org.taomee.utils.Tick;
   
   public class StoryAnimationTask_1159_1 implements IStoryAnimation
   {
      
      private const CAMERA_TARGET_X:Number = 1055;
      
      private var _params:String;
      
      private var _mainMC:MovieClip;
      
      private var _cameraX:Number;
      
      private var _cameraY:Number;
      
      private var _dragonEggMC:MovieClip;
      
      private var _inBodyMC:MovieClip;
      
      private var actorX:Number;
      
      private var actorY:Number;
      
      public function StoryAnimationTask_1159_1()
      {
         super();
      }
      
      public function setParams(param1:String) : void
      {
         this._params = param1;
      }
      
      public function start() : void
      {
         this.onStart();
         this.scrollMap();
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
            this.playAnimat();
         }
      }
      
      private function playAnimat() : void
      {
         MainManager.closeOperate();
         this._mainMC = MapManager.currentMap.libManager.getMovieClip("green_dragon");
         this._mainMC.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this._mainMC.x = 1320;
         this._mainMC.y = 134;
         this.currentMap.contentLevel.addChild(this._mainMC);
         this._mainMC.play();
      }
      
      public function onEnterFrame(param1:Event) : void
      {
         if(this._mainMC.currentFrame == this._mainMC.totalFrames)
         {
            this._mainMC.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            DisplayUtil.removeForParent(this._mainMC);
            this.onFinish();
         }
         else if(this._mainMC.currentFrame == 85)
         {
            this._mainMC.stop();
            this._mainMC.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            this.moveEggToActor();
         }
      }
      
      private function moveEggToActor() : void
      {
         this.actorX = MainManager.actorModel.x;
         this.actorY = MainManager.actorModel.y - MainManager.actorModel.height / 2;
         this._dragonEggMC = MapManager.currentMap.libManager.getMovieClip("dragon_egg");
         this.currentMap.contentLevel.addChild(this._dragonEggMC);
         this._dragonEggMC.x = 1515;
         this._dragonEggMC.y = 304;
         var _loc1_:Number = this.actorX;
         var _loc2_:Number = this.actorY;
         TweenLite.to(this._dragonEggMC,1,{
            "x":_loc1_,
            "y":_loc2_,
            "ease":Quad.easeIn,
            "onComplete":this.onFinishTween
         });
      }
      
      private function onFinishTween() : void
      {
         DisplayUtil.removeForParent(this._dragonEggMC);
         this._inBodyMC = this.currentMap.libManager.getMovieClip("in_body");
         this.currentMap.contentLevel.addChild(this._inBodyMC);
         this._inBodyMC.x = this.actorX;
         this._inBodyMC.y = this.actorY + MainManager.actorModel.height / 2;
         this._inBodyMC.addEventListener(Event.ENTER_FRAME,this.onInBodyEnter);
      }
      
      private function onInBodyEnter(param1:Event) : void
      {
         if(this._inBodyMC.currentFrame == this._inBodyMC.totalFrames)
         {
            this._inBodyMC.removeEventListener(Event.ENTER_FRAME,this.onInBodyEnter);
            DisplayUtil.removeForParent(this._inBodyMC);
            this._mainMC.gotoAndPlay(86);
            this._mainMC.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
      }
      
      private function get currentMap() : MapModel
      {
         return MapManager.currentMap;
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

