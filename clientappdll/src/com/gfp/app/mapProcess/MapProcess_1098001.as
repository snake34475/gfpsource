package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.ui.UILoader;
   import com.gfp.core.ui.loading.LoadingType;
   import flash.display.MovieClip;
   import flash.events.Event;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1098001 extends BaseMapProcess
   {
      
      private var _mainMC:MovieClip;
      
      private var _loader:UILoader;
      
      public function MapProcess_1098001()
      {
         super();
      }
      
      override protected function init() : void
      {
         FightManager.isAutoWinnerEnd = false;
         FightManager.instance.addEventListener(FightEvent.WINNER,this.onWinner);
      }
      
      private function onWinner(param1:FightEvent) : void
      {
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onWinner);
         this.loadAnimat();
      }
      
      private function loadAnimat() : void
      {
         this._loader = new UILoader(ClientConfig.getCartoon("task1724_1"),LayerManager.topLevel,LoadingType.TITLE_AND_PERCENT,"正在加载任务动画...");
         this._loader.addEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this._loader.load();
      }
      
      private function onEnterFrameBeast(param1:Event) : void
      {
         if(this._mainMC["mc"].currentFrame == this._mainMC["mc"].totalFrames)
         {
            this._mainMC.removeEventListener(Event.ENTER_FRAME,this.onEnterFrameBeast);
            DisplayUtil.removeForParent(this._mainMC);
            this.onFinish();
            PveEntry.onWinner();
         }
      }
      
      public function onFinish() : void
      {
         this._mainMC = null;
         MainManager.openOperate();
      }
      
      private function onLoadComplete(param1:UILoadEvent) : void
      {
         MainManager.closeOperate();
         this._loader.removeEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this._mainMC = param1.uiloader.loader.content as MovieClip;
         this._mainMC.addEventListener(Event.ENTER_FRAME,this.onEnterFrameBeast);
         LayerManager.topLevel.addChild(this._mainMC);
         this._mainMC.gotoAndPlay(1);
      }
      
      override public function destroy() : void
      {
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onWinner);
      }
   }
}

