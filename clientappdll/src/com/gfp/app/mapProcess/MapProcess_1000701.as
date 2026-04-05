package com.gfp.app.mapProcess
{
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.TaskActionEvent;
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
   
   public class MapProcess_1000701 extends BaseMapProcess
   {
      
      private var _mainMC:MovieClip;
      
      private var _loader:UILoader;
      
      public function MapProcess_1000701()
      {
         super();
      }
      
      override protected function init() : void
      {
         if(Boolean(TasksManager.isAccepted(48)) && Boolean(TasksManager.isProcess(48,1)))
         {
            MainManager.closeOperate(false);
            this.playAnimation();
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
      
      private function playAnimation() : void
      {
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_SIMPLEACTION,"Access_Pass");
         this._loader = new UILoader(ClientConfig.getCartoon("task48_1"),LayerManager.topLevel,LoadingType.TITLE_AND_PERCENT,"正在加载任务动画...");
         this._loader.addEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this._loader.load();
      }
      
      private function onLoadComplete(param1:UILoadEvent) : void
      {
         this._loader.removeEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this._mainMC = param1.uiloader.loader.content as MovieClip;
         LayerManager.topLevel.addChild(this._mainMC);
         this._mainMC["dialog1"].visible = false;
         this._mainMC["mc1"].addEventListener(Event.ENTER_FRAME,this.onEnterFrame1);
         this._mainMC["mc1"].gotoAndPlay(1);
      }
      
      private function onEnterFrame1(param1:Event) : void
      {
         if(this._mainMC["mc1"].currentFrame == this._mainMC["mc1"].totalFrames)
         {
            this._mainMC["mc1"].removeEventListener(Event.ENTER_FRAME,this.onEnterFrame1);
            this._mainMC["dialog1"].visible = true;
            this._mainMC["dialog1"].btn.addEventListener(MouseEvent.CLICK,this.onClick1);
         }
      }
      
      private function onClick1(param1:MouseEvent) : void
      {
         if(this._mainMC["dialog1"].currentFrame != 7)
         {
            this._mainMC["dialog1"].gotoAndStop(this._mainMC["dialog1"].currentFrame + 1);
         }
         else
         {
            this._mainMC.gotoAndStop(2);
            this._mainMC.addEventListener(Event.ENTER_FRAME,this.mainFrame);
         }
      }
      
      private function mainFrame(param1:Event) : void
      {
         if(this._mainMC["mc2"])
         {
            this._mainMC.removeEventListener(Event.ENTER_FRAME,this.mainFrame);
            this._mainMC["mc2"].addEventListener(Event.ENTER_FRAME,this.onEnterFrame2);
            this._mainMC["mc2"].gotoAndPlay(1);
         }
      }
      
      private function onEnterFrame2(param1:Event) : void
      {
         if(this._mainMC["mc2"].currentFrame == this._mainMC["mc2"].totalFrames)
         {
            this._mainMC["mc2"].removeEventListener(Event.ENTER_FRAME,this.onEnterFrame2);
            DisplayUtil.removeForParent(this._mainMC);
            this._mainMC = null;
            MainManager.openOperate();
         }
      }
   }
}

