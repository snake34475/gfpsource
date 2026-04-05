package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.LeftTimeMovFeather;
   import com.gfp.core.cache.SwfCache;
   import com.gfp.core.cache.SwfInfo;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.map.BaseMapProcess;
   import flash.display.MovieClip;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1125607 extends BaseMapProcess
   {
      
      private var _mapTimer:LeftTimeMovFeather;
      
      private var _txtTimeMc:MovieClip;
      
      public function MapProcess_1125607()
      {
         super();
         SwfCache.getSwfInfo(ClientConfig.getSubUI("left_time"),this.onIconLoaded);
      }
      
      private function onIconLoaded(param1:SwfInfo) : void
      {
         this._txtTimeMc = param1.content as MovieClip;
         LayerManager.topLevel.addChild(this._txtTimeMc);
         this._txtTimeMc.x = (LayerManager.stageWidth - this._txtTimeMc.width) / 2;
         this._txtTimeMc.y = 131;
         this._mapTimer = new LeftTimeMovFeather(3 * 60 * 1000,this._txtTimeMc,null,1,false);
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

