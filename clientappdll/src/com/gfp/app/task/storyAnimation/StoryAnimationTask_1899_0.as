package com.gfp.app.task.storyAnimation
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.cartoon.event.AnimatEvent;
   import com.gfp.core.info.TransportPoint;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.CityMap;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import org.taomee.utils.DisplayUtil;
   
   public class StoryAnimationTask_1899_0 implements IStoryAnimation
   {
      
      private var _mainMC:MovieClip;
      
      public function StoryAnimationTask_1899_0()
      {
         super();
      }
      
      public function setParams(param1:String) : void
      {
      }
      
      public function start() : void
      {
         AnimatPlay.addAnimatListener(AnimatEvent.ANIMAT_END,this.onFinishHandler);
         this.playAnimate();
      }
      
      private function playAnimate() : void
      {
         AnimatPlay.startAnimat("StoryAnimationTask_1899_",0,false,231,133,false,true);
      }
      
      public function onStart() : void
      {
      }
      
      public function onFinishHandler(param1:AnimatEvent) : void
      {
         this.onFinish();
         AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onFinishHandler);
      }
      
      public function onFinish() : void
      {
         DisplayUtil.removeForParent(this._mainMC);
         this._mainMC = null;
         TasksManager.taskProComplete(1899,2);
         var _loc1_:TransportPoint = new TransportPoint();
         _loc1_.mapId = 1037;
         _loc1_.pos = new Point(813,743);
         CityMap.instance.tranChangeMap(_loc1_);
      }
   }
}

