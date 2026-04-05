package com.gfp.app.mapProcess
{
   import com.gfp.app.miniMap.MiniMap;
   import com.gfp.app.systems.ClientTempState;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.utils.SpriteType;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class MapProcess_1132802 extends BaseMapProcess
   {
      
      private var mInfoMc:MovieClip;
      
      private const RECORD_EXP_SWAP:int = 10475;
      
      public function MapProcess_1132802()
      {
         super();
      }
      
      override protected function init() : void
      {
         MiniMap.instance.hide();
         this.mInfoMc = MapManager.currentMap.libManager.getMovieClip("UI_MengJinInfo");
         LayerManager.topLevel.addChild(this.mInfoMc);
         StageResizeController.instance.register(this.layout);
         ++ClientTempState.summonJingYanMengJingLayer;
         SummonManager.airesSummonPrpsChange();
         SightManager.hide(SpriteType.TELEPORTER);
         this.update();
         this.layout();
         if(ClientTempState.summonJingYanMengJingLayer % 10 < 2)
         {
            this.requestData();
         }
         this.updateExp();
         ActivityExchangeTimesManager.addEventListener(this.RECORD_EXP_SWAP,this.responseExp);
      }
      
      private function requestData() : void
      {
         ActivityExchangeTimesManager.getActiviteTimeInfo(this.RECORD_EXP_SWAP);
      }
      
      private function responseExp(param1:Event) : void
      {
         this.updateExp();
      }
      
      private function update() : void
      {
         var _loc6_:int = 0;
         var _loc7_:MovieClip = null;
         var _loc1_:MovieClip = this.mInfoMc["numMc"];
         while(_loc1_.numChildren)
         {
            _loc1_.removeChildAt(0);
         }
         var _loc2_:String = ClientTempState.summonJingYanMengJingLayer.toString();
         var _loc3_:Sprite = new Sprite();
         var _loc4_:Number = 0;
         var _loc5_:int = 0;
         while(_loc5_ < _loc2_.length)
         {
            _loc6_ = int(_loc2_.charAt(_loc5_));
            _loc7_ = MapManager.currentMap.libManager.getMovieClip("UI_Number");
            _loc7_.gotoAndStop(_loc6_ + 1);
            _loc7_.x = _loc4_;
            _loc4_ += _loc7_.width + 4;
            _loc3_.addChild(_loc7_);
            _loc5_++;
         }
         _loc3_.x = (29 - _loc3_.width) * 0.5;
         _loc3_.y = 5;
         _loc1_.addChild(_loc3_);
      }
      
      private function updateExp() : void
      {
         var _loc1_:int = int(ActivityExchangeTimesManager.getTimes(this.RECORD_EXP_SWAP));
         this.mInfoMc["expLabel"].text = _loc1_ + "";
      }
      
      private function layout() : void
      {
         this.mInfoMc.x = LayerManager.stageWidth - 264;
         this.mInfoMc.y = LayerManager.stageHeight - 160;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         LayerManager.topLevel.removeChild(this.mInfoMc);
         StageResizeController.instance.unregister(this.layout);
         ActivityExchangeTimesManager.removeEventListener(this.RECORD_EXP_SWAP,this.responseExp);
      }
   }
}

