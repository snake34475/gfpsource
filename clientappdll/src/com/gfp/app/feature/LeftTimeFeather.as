package com.gfp.app.feature
{
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.utils.TextUtil;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.clearTimeout;
   import flash.utils.getTimer;
   import flash.utils.setInterval;
   import org.taomee.utils.DisplayUtil;
   
   public class LeftTimeFeather
   {
      
      private var _displayText:TextField;
      
      private var _timer:uint;
      
      private var _totalTime:int;
      
      private var _startTime:int;
      
      private var _keyName:String;
      
      private var _vue:int = 0;
      
      private var _txtStr:String;
      
      public function LeftTimeFeather(param1:int, param2:String = "")
      {
         super();
         this._totalTime = param1;
         this._keyName = param2;
         this.init();
      }
      
      private function init() : void
      {
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
            this._txtStr = "剩余时间：" + TextUtil.completeString(_loc2_.minutesUTC.toString()) + ":" + TextUtil.completeString(_loc2_.secondsUTC.toString());
            this.setScreenText(this._txtStr);
         }
         else
         {
            this.setScreenText("");
            clearTimeout(this._timer);
         }
      }
      
      private function setScreenText(param1:String) : void
      {
         if(this._txtStr)
         {
            if(Boolean(this._keyName) && this._txtStr.indexOf(this._keyName) == -1)
            {
               this._txtStr += "    " + this._keyName + "：" + this._vue;
            }
            this._displayText.text = this._txtStr;
            this._displayText.visible = true;
            this.layout();
         }
         else
         {
            this._displayText.visible = false;
         }
      }
      
      public function destroy() : void
      {
         StageResizeController.instance.unregister(this.layout);
         DisplayUtil.removeForParent(this._displayText);
         clearTimeout(this._timer);
      }
      
      protected function layout() : void
      {
         this._displayText.x = LayerManager.stageWidth - this._displayText.width >> 1;
         this._displayText.y = (LayerManager.stageHeight - this._displayText.height >> 1) - 170;
      }
      
      private function initTxt() : void
      {
         this._displayText = new TextField();
         this._displayText.mouseEnabled = false;
         this._displayText.mouseWheelEnabled = false;
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
      
      public function set vue(param1:int) : void
      {
         this._vue = param1;
         var _loc2_:int = getTimer() - this._startTime;
         var _loc3_:Date = new Date();
         var _loc4_:int = this._totalTime - _loc2_;
         _loc3_.time = _loc4_;
         this._txtStr = "剩余时间：" + TextUtil.completeString(_loc3_.minutesUTC.toString()) + ":" + TextUtil.completeString(_loc3_.secondsUTC.toString());
         this.setScreenText(this._txtStr);
      }
      
      public function get vue() : int
      {
         return this._vue;
      }
   }
}

