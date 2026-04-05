package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.LeftTimeMovFeather;
   import com.gfp.core.cache.SwfCache;
   import com.gfp.core.cache.SwfInfo;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.map.BaseMapProcess;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.utils.getTimer;
   import org.taomee.utils.DisplayUtil;
   
   public class BaseCountDownMapProcess extends BaseMapProcess
   {
      
      protected var timeLimit:int;
      
      private var _txtTimeMc:MovieClip;
      
      private var _timeText:TextField;
      
      private var _mapTimer:LeftTimeMovFeather;
      
      private var _startLoadingTime:int;
      
      public function BaseCountDownMapProcess()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.initProperties();
         this._startLoadingTime = getTimer();
         SwfCache.getSwfInfo(ClientConfig.getSubUI("left_time"),this.onIconLoaded);
      }
      
      protected function initProperties() : void
      {
         this.timeLimit = 180;
      }
      
      private function onIconLoaded(param1:SwfInfo) : void
      {
         var _loc2_:int = getTimer() - this._startLoadingTime;
         this._txtTimeMc = param1.content as MovieClip;
         LayerManager.topLevel.addChild(this._txtTimeMc);
         this._txtTimeMc.x = LayerManager.stageWidth / 2;
         this._txtTimeMc.y = 131;
         this._mapTimer = new LeftTimeMovFeather(this.timeLimit * 1000 - _loc2_,this._txtTimeMc,null,1,false);
         this._mapTimer.start();
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(this._mapTimer)
         {
            this._mapTimer.destroy();
         }
         DisplayUtil.removeForParent(this._txtTimeMc);
      }
   }
}

