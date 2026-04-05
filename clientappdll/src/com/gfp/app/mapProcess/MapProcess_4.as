package com.gfp.app.mapProcess
{
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.SummonModel;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_4 extends BaseMapProcess
   {
      
      private var _newsListMC_1:MovieClip;
      
      private var _newsListMC_2:MovieClip;
      
      private var _secretNewsListMC:MovieClip;
      
      private var _summonModelArr:Array;
      
      public function MapProcess_4()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._newsListMC_1 = _mapModel.contentLevel["newsListMC_1"];
         this._newsListMC_2 = _mapModel.contentLevel["newsListMC_2"];
         this._newsListMC_1.buttonMode = true;
         this._newsListMC_2.buttonMode = true;
         this._secretNewsListMC = _mapModel.contentLevel["secretNewsListMC"];
         this._secretNewsListMC.buttonMode = true;
      }
      
      private function onNewspaperList2(param1:MouseEvent) : void
      {
         ModuleManager.turnModule(ClientConfig.getAppModule("NewsPaperListPanel"),"正在加载……",{
            "beginNewsID":52,
            "displayType":1
         });
      }
      
      private function onDeskClick(param1:MouseEvent) : void
      {
         ModuleManager.turnModule(ClientConfig.getAppModule("NewsPaperListPanel"),"正在加载……",{
            "beginNewsID":1,
            "displayType":1
         });
      }
      
      private function onSecretListClick(param1:MouseEvent) : void
      {
         this._secretNewsListMC.addEventListener(Event.ENTER_FRAME,this.onSecretListEnter);
         this._secretNewsListMC.gotoAndPlay(2);
      }
      
      private function onSecretListEnter(param1:Event) : void
      {
         if(this._secretNewsListMC.currentFrame == this._secretNewsListMC.totalFrames)
         {
            this._secretNewsListMC.removeEventListener(Event.ENTER_FRAME,this.onSecretListEnter);
            ModuleManager.turnModule(ClientConfig.getAppModule("NewsPaperListPanel"),"正在加载……",{
               "beginNewsID":1,
               "displayType":2
            });
         }
      }
      
      override public function destroy() : void
      {
         var _loc1_:SummonModel = null;
         this._secretNewsListMC.removeEventListener(Event.ENTER_FRAME,this.onSecretListEnter);
         this._secretNewsListMC.removeEventListener(MouseEvent.CLICK,this.onSecretListClick);
         this._secretNewsListMC = null;
         this._newsListMC_1 = null;
         this._newsListMC_2 = null;
         for each(_loc1_ in this._summonModelArr)
         {
            DisplayUtil.removeForParent(_loc1_);
            _loc1_.destroy();
         }
      }
   }
}

