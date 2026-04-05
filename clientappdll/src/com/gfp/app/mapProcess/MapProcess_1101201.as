package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.ShowCartoonFeather;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.utils.TextUtil;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.clearTimeout;
   import flash.utils.getTimer;
   import flash.utils.setInterval;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1101201 extends BaseMapProcess
   {
      
      private var _feather:ShowCartoonFeather;
      
      private var _displayText:TextField;
      
      private var _timer:uint;
      
      private var _totalTime:int = 180000;
      
      private var _startTime:int;
      
      public function MapProcess_1101201()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._feather = new ShowCartoonFeather("lei_sheng_tip");
         this.initTxt();
         StageResizeController.instance.register(this.layout);
         this.layout();
         this._timer = setInterval(this.onTimer,1000);
         this._startTime = getTimer();
      }
      
      private function onTimer() : void
      {
         var _loc1_:int = getTimer() - this._startTime;
         var _loc2_:Date = new Date();
         var _loc3_:int = this._totalTime - _loc1_;
         _loc2_.time = _loc3_;
         if(_loc3_ > 0)
         {
            this.setScreenText("剩余时间：" + TextUtil.completeString(_loc2_.minutesUTC.toString()) + ":" + TextUtil.completeString(_loc2_.secondsUTC.toString()));
         }
         else
         {
            this.setScreenText("挑战时间结束。");
            clearTimeout(this._timer);
         }
      }
      
      private function setScreenText(param1:String) : void
      {
         if(param1)
         {
            this._displayText.text = param1;
            this._displayText.visible = true;
            this.layout();
         }
         else
         {
            this._displayText.visible = false;
         }
      }
      
      protected function layout() : void
      {
         this._displayText.x = LayerManager.stageWidth - this._displayText.width >> 1;
         this._displayText.y = (LayerManager.stageHeight - this._displayText.height >> 1) - 170;
      }
      
      private function initTxt() : void
      {
         this._displayText = new TextField();
         this._displayText.autoSize = TextFieldAutoSize.LEFT;
         var _loc1_:TextFormat = new TextFormat();
         _loc1_.size = 20;
         _loc1_.color = 16777215;
         this._displayText.defaultTextFormat = _loc1_;
         this._displayText.setTextFormat(_loc1_);
         var _loc2_:GlowFilter = new GlowFilter();
         _loc2_.strength = 2;
         _loc2_.color = 0;
         _loc2_.blurX = 3;
         _loc2_.blurY = 3;
         this._displayText.filters = [_loc2_];
         this._displayText.visible = false;
         LayerManager.topLevel.addChild(this._displayText);
      }
      
      override public function destroy() : void
      {
         StageResizeController.instance.unregister(this.layout);
         super.destroy();
         if(this._feather)
         {
            this._feather.destroy();
         }
         DisplayUtil.removeForParent(this._displayText);
         clearTimeout(this._timer);
      }
   }
}

