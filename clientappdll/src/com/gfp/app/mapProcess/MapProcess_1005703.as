package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   import flash.events.Event;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class MapProcess_1005703 extends BaseMapProcess
   {
      
      private var _animatLoader:TollgateAnimationLoader;
      
      public function MapProcess_1005703()
      {
         super();
      }
      
      override protected function init() : void
      {
         if(Boolean(TasksManager.isAccepted(90)) && Boolean(TasksManager.isProcess(90,0)))
         {
            MainManager.closeOperate(true);
            FightManager.isAutoWinnerEnd = false;
            FightManager.instance.addEventListener(FightEvent.WINNER,this.onWinner);
         }
      }
      
      private function onWinner(param1:FightEvent) : void
      {
         var play:Function = null;
         var event:FightEvent = param1;
         play = function():void
         {
            clearTimeout(3000);
            FightManager.instance.removeEventListener(FightEvent.WINNER,onWinner);
            _animatLoader = new TollgateAnimationLoader();
            _animatLoader.addEventListener(Event.COMPLETE,onPlayComplete);
            _animatLoader.loadAndPlayAnimat("task90_0");
         };
         setTimeout(play,3000);
      }
      
      private function onPlayComplete(param1:Event) : void
      {
         var event:Event = param1;
         this._animatLoader.removeEventListener(Event.COMPLETE,this.onPlayComplete);
         MainManager.openOperate();
         setTimeout(function():void
         {
            PveEntry.onWinner();
         },2000);
      }
      
      override public function destroy() : void
      {
         if(this._animatLoader)
         {
            this._animatLoader.destroy();
         }
         super.destroy();
      }
   }
}

import com.gfp.core.config.ClientConfig;
import com.gfp.core.events.UILoadEvent;
import com.gfp.core.manager.LayerManager;
import com.gfp.core.ui.UILoader;
import com.gfp.core.ui.loading.LoadingType;
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.EventDispatcher;
import org.taomee.utils.DisplayUtil;

class TollgateAnimationLoader extends EventDispatcher
{
   
   private var _mainMC:MovieClip;
   
   private var _loader:UILoader;
   
   public function TollgateAnimationLoader()
   {
      super();
   }
   
   public function loadAndPlayAnimat(param1:String) : void
   {
      this._loader = new UILoader(ClientConfig.getCartoon(param1),LayerManager.topLevel,LoadingType.TITLE_AND_PERCENT,"正在加载任务动画...");
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
      if(this._mainMC.currentFrame == this._mainMC.totalFrames)
      {
         this._mainMC.stop();
         this._mainMC.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         DisplayUtil.removeForParent(this._mainMC);
         dispatchEvent(new Event(Event.COMPLETE));
      }
   }
   
   public function destroy() : void
   {
      this._loader.destroy();
      if(this._mainMC)
      {
         this._mainMC = null;
      }
   }
}
