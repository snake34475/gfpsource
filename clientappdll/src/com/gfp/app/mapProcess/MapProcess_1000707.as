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
   import flash.events.MouseEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1000707 extends BaseMapProcess
   {
      
      private var _mainMC:MovieClip;
      
      private var _loader:UILoader;
      
      public function MapProcess_1000707()
      {
         super();
      }
      
      override protected function init() : void
      {
         if(Boolean(TasksManager.isAccepted(48)) && Boolean(TasksManager.isProcess(48,2)))
         {
            FightManager.isAutoWinnerEnd = false;
            FightManager.outToMapID = 14;
            FightManager.instance.addEventListener(FightEvent.WINNER,this.onWinner);
         }
      }
      
      private function onWinner(param1:FightEvent) : void
      {
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onWinner);
         FightManager.outToMapID = 14;
         MainManager.closeOperate(false);
         this.playAnimation();
      }
      
      private function playAnimation() : void
      {
         this._loader = new UILoader(ClientConfig.getCartoon("task48_2"),LayerManager.topLevel,LoadingType.TITLE_AND_PERCENT,"正在加载任务动画...");
         this._loader.addEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this._loader.load();
      }
      
      private function onLoadComplete(param1:UILoadEvent) : void
      {
         this._loader.removeEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this._mainMC = param1.uiloader.loader.content as MovieClip;
         LayerManager.topLevel.addChild(this._mainMC);
         this._mainMC["dialog"].visible = false;
         this._mainMC["dialog"].btn.addEventListener(MouseEvent.CLICK,this.onClick);
         this._mainMC["mc1"].addEventListener(Event.ENTER_FRAME,this.onEnterFrame1);
         this._mainMC["mc1"].gotoAndPlay(1);
      }
      
      private function onEnterFrame1(param1:Event) : void
      {
         if(this._mainMC["mc1"].currentFrame == this._mainMC["mc1"].totalFrames)
         {
            this._mainMC["mc1"].removeEventListener(Event.ENTER_FRAME,this.onEnterFrame1);
            this._mainMC["dialog"].visible = true;
         }
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(this._mainMC["dialog"].currentFrame != 8)
         {
            this._mainMC["dialog"].gotoAndStop(this._mainMC["dialog"].currentFrame + 1);
         }
         else
         {
            this._mainMC.gotoAndStop(2);
            this._mainMC.addEventListener(Event.ENTER_FRAME,this.frame2);
         }
      }
      
      private function frame2(param1:Event) : void
      {
         if(this._mainMC["mc2"])
         {
            this._mainMC.removeEventListener(Event.ENTER_FRAME,this.frame2);
            this._mainMC["mc2"].addEventListener(Event.ENTER_FRAME,this.onEnterFrame2);
            this._mainMC["mc2"].gotoAndPlay(1);
         }
      }
      
      private function onEnterFrame2(param1:Event) : void
      {
         if(this._mainMC["mc2"].currentFrame == this._mainMC["mc2"].totalFrames)
         {
            this._mainMC["mc2"].removeEventListener(Event.ENTER_FRAME,this.onEnterFrame2);
            this._mainMC.gotoAndStop(3);
            this._mainMC.addEventListener(Event.ENTER_FRAME,this.frame3);
         }
      }
      
      private function frame3(param1:Event) : void
      {
         if(this._mainMC["mc3"])
         {
            this._mainMC.removeEventListener(Event.ENTER_FRAME,this.frame3);
            this._mainMC["mc3"].addEventListener(Event.ENTER_FRAME,this.onEnterFrame3);
            this._mainMC["mc3"].gotoAndPlay(1);
         }
      }
      
      private function onEnterFrame3(param1:Event) : void
      {
         if(this._mainMC["mc3"].currentFrame == this._mainMC["mc3"].totalFrames)
         {
            this._mainMC["mc3"].removeEventListener(Event.ENTER_FRAME,this.onEnterFrame3);
            DisplayUtil.removeForParent(this._mainMC);
            this._mainMC = null;
            MainManager.openOperate();
            PveEntry.onWinner();
         }
      }
   }
}

