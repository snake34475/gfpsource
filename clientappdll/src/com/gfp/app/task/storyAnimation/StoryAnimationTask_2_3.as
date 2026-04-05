package com.gfp.app.task.storyAnimation
{
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.ActorModel;
   import com.gfp.core.model.MapModel;
   import com.gfp.core.model.sensemodels.SightModel;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import org.taomee.utils.DisplayUtil;
   
   public class StoryAnimationTask_2_3 implements IStoryAnimation
   {
      
      private var _clothBrokenMC:MovieClip;
      
      private var _grandpaNPC:SightModel;
      
      private var _mapModel:MapModel;
      
      private var _offsetArr:Array = [new Point(65,35),new Point(35,5),new Point(75,35)];
      
      public function StoryAnimationTask_2_3()
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
         this.playClothBrokenAnimat();
         this.onStart();
      }
      
      private function playClothBrokenAnimat() : void
      {
         var _loc3_:ActorModel = null;
         var _loc1_:int = MainManager.roleType > 3 ? 1 : int(MainManager.roleType);
         var _loc2_:String = "cloth_broken_" + _loc1_;
         this._clothBrokenMC = this._mapModel.libManager.getMovieClip(_loc2_);
         this._clothBrokenMC.addEventListener(Event.ENTER_FRAME,this.clothEnterFrame);
         _loc3_ = MainManager.actorModel;
         var _loc4_:Point = this._offsetArr[_loc1_ - 1];
         this._clothBrokenMC.x = _loc3_.x - (_loc3_.width + _loc4_.x);
         this._clothBrokenMC.y = _loc3_.y - (_loc3_.height + _loc4_.y);
         MainManager.actorModel.visible = false;
         this._mapModel.contentLevel.addChild(this._clothBrokenMC);
      }
      
      private function clothEnterFrame(param1:Event) : void
      {
         if(this._clothBrokenMC.currentFrame == this._clothBrokenMC.totalFrames)
         {
            this._clothBrokenMC.removeEventListener(Event.ENTER_FRAME,this.clothEnterFrame);
            MainManager.actorModel.visible = true;
            DisplayUtil.removeForParent(this._clothBrokenMC);
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

