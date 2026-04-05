package com.gfp.app.task.storyAnimation
{
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.model.sensemodels.SightModel;
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import flash.display.MovieClip;
   import flash.events.Event;
   import org.taomee.utils.DisplayUtil;
   
   public class StoryAnimationTask_2079_3 extends BaseStoryAnimation
   {
      
      private var npc10532:SightModel;
      
      public function StoryAnimationTask_2079_3()
      {
         super();
      }
      
      override protected function loadAnimat() : void
      {
         loadAndPlayAnimat("task2079_3","mc");
      }
      
      override protected function onLoadComplete(param1:UILoadEvent) : void
      {
         var complete:Function = null;
         var event:UILoadEvent = param1;
         complete = function():void
         {
            onFinish();
            DisplayUtil.removeForParent(_mainMC);
            TweenLite.killTweensOf(_mainMC);
         };
         super.onLoadComplete(event);
         _mainMC = event.uiloader.loader.content as MovieClip;
         this.npc10532.parent.addChild(_mainMC);
         _mainMC.x = this.npc10532.x;
         _mainMC.y = this.npc10532.y;
         _mainMC.mc.gotoAndPlay(1);
         this.npc10532.hide();
         TweenLite.to(_mainMC,0.5,{
            "x":_mainMC.x + 200,
            "ease":Linear.easeNone,
            "onComplete":complete
         });
         _background.visible = false;
      }
      
      override public function onStart() : void
      {
         this.npc10532 = SightManager.getSightModel(10532);
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ANIMATION_START,"");
         super.onStart();
      }
      
      override public function onFinish() : void
      {
         super.onFinish();
         CityMap.instance.changeMap(64);
      }
      
      override protected function layout() : void
      {
      }
      
      override protected function onEnterFrame(param1:Event) : void
      {
      }
   }
}

