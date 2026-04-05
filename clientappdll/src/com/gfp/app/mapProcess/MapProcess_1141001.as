package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.cache.SwfCache;
   import com.gfp.core.cache.SwfInfo;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1141001 extends BaseMapProcess
   {
      
      public function MapProcess_1141001()
      {
         super();
      }
      
      override public function destroy() : void
      {
         FightManager.instance.removeEventListener(FightEvent.REASON,this.failHandler);
      }
      
      override protected function init() : void
      {
         FightManager.instance.addEventListener(FightEvent.REASON,this.failHandler);
      }
      
      private function failHandler(param1:FightEvent) : void
      {
         SwfCache.getSwfInfo(ClientConfig.getSubUI("fight_fail_from_panda"),this.loadComplete);
      }
      
      private function loadComplete(param1:SwfInfo) : void
      {
         var _mainUI:MovieClip = null;
         var info:SwfInfo = param1;
         _mainUI = info.content as MovieClip;
         _mainUI.height = 72;
         _mainUI.width = 645;
         _mainUI.x = 278;
         _mainUI.y = 195;
         LayerManager.topLevel.addChild(_mainUI);
         TweenLite.to(_mainUI,5,{
            "alpha":0,
            "onComplete":function():void
            {
               DisplayUtil.removeForParent(_mainUI);
            }
         });
      }
   }
}

