package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.ui.UILoader;
   import com.gfp.core.ui.loading.LoadingType;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.setTimeout;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1000910 extends BaseMapProcess
   {
      
      private var _mainMC:MovieClip;
      
      private var _loader:UILoader;
      
      public function MapProcess_1000910()
      {
         super();
      }
      
      override protected function init() : void
      {
         if(!TasksManager.isCompleted(49))
         {
            FightManager.isAutoWinnerEnd = false;
            FightManager.instance.addEventListener(FightEvent.WINNER,this.onWinner);
         }
      }
      
      private function onWinner(param1:FightEvent) : void
      {
         var event:FightEvent = param1;
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onWinner);
         if(Boolean(TasksManager.isAccepted(49)) && Boolean(TasksManager.isReady(49)))
         {
            MainManager.closeOperate(true);
            this.playAnimation();
         }
         else
         {
            setTimeout(function():void
            {
               PveEntry.onWinner();
            },3000);
         }
      }
      
      private function playAnimation() : void
      {
         this._loader = new UILoader(ClientConfig.getCartoon("task49_2"),LayerManager.topLevel,LoadingType.TITLE_AND_PERCENT,"正在加载任务动画...");
         this._loader.addEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this._loader.load();
      }
      
      private function onLoadComplete(param1:UILoadEvent) : void
      {
         this._loader.removeEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         var _loc2_:MovieClip = param1.uiloader.loader.content as MovieClip;
         this._mainMC = _loc2_["mc"];
         LayerManager.topLevel.addChild(this._mainMC);
         this._mainMC.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this._mainMC.gotoAndPlay(1);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var event:Event = param1;
         if(this._mainMC.currentFrame == this._mainMC.totalFrames)
         {
            this._mainMC.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            DisplayUtil.removeForParent(this._mainMC);
            this._mainMC = null;
            MainManager.openOperate();
            setTimeout(function():void
            {
               PveEntry.onWinner();
            },3000);
         }
      }
   }
}

