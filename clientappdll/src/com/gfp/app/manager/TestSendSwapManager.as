package com.gfp.app.manager
{
   import com.gfp.core.config.xml.ActivityExchangeXMLInfo;
   import com.gfp.core.info.dailyActivity.ActivityExchangeInfo;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.utils.TickManager;
   import com.greensock.TweenLite;
   
   public class TestSendSwapManager
   {
      
      private static var _instance:TestSendSwapManager;
      
      public static const SEND_INTERVAL_IN_MS:int = 100;
      
      private var _requestDatas:Array;
      
      private var _progressUI:TestSendSwapProgressUI;
      
      private var _isSending:Boolean;
      
      private var _totalNum:uint;
      
      public function TestSendSwapManager()
      {
         super();
      }
      
      public static function get instance() : TestSendSwapManager
      {
         if(_instance == null)
         {
            _instance = new TestSendSwapManager();
         }
         return _instance;
      }
      
      public static function getAllFreeSwaps() : Array
      {
         var _loc3_:ActivityExchangeInfo = null;
         var _loc1_:Array = ActivityExchangeXMLInfo.getAllActivity();
         var _loc2_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < _loc1_.length)
         {
            _loc3_ = _loc1_[_loc4_];
            if(_loc3_.costVect == null || _loc3_.costVect.length == 0)
            {
               _loc2_.push(_loc3_);
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public function startAll(param1:Array = null) : void
      {
         this._isSending = true;
         this._requestDatas = param1 ? param1 : getAllFreeSwaps();
         this._totalNum = this._requestDatas.length;
         TickManager.instance.addRender(this._sendOne,SEND_INTERVAL_IN_MS);
      }
      
      public function showProgress(param1:Number, param2:Number) : void
      {
         this._progressUI = new TestSendSwapProgressUI();
         LayerManager.toolUiLevel.addChild(this._progressUI);
         this._progressUI.x = param1 - this._progressUI.width / 2;
         this._progressUI.y = param2 - this._progressUI.height / 2;
         TweenLite.to(this._progressUI,0.5,{
            "x":90,
            "y":90
         });
      }
      
      private function _sendOne() : void
      {
         if(this._requestDatas.length == 0)
         {
            TickManager.instance.removeRender(this._sendOne);
            if(this._progressUI)
            {
               this._progressUI.complete();
            }
            this._isSending = false;
            return;
         }
         var _loc1_:ActivityExchangeInfo = this._requestDatas.pop();
         ActivityExchangeCommander.exchange(_loc1_.id);
         this._progressUI.update(this._requestDatas.length);
      }
      
      public function cancel() : void
      {
         if(this._requestDatas.length == 0)
         {
            this.closeUIAndClear();
         }
         else
         {
            AlertManager.showSimpleAlert("兑换列表正在发送中，是否中断测试？",this.closeUIAndClear);
         }
      }
      
      public function closeUIAndClear() : void
      {
         TickManager.instance.removeRender(this._sendOne);
         this._isSending = false;
         this._requestDatas = null;
         if(this._progressUI)
         {
            if(this._progressUI.parent)
            {
               this._progressUI.parent.removeChild(this._progressUI);
            }
            this._progressUI.dispose();
            this._progressUI = null;
         }
      }
      
      public function get isSending() : Boolean
      {
         return this._isSending;
      }
      
      public function get totalNum() : uint
      {
         return this._totalNum;
      }
   }
}

import com.gfp.core.manager.LayerManager;
import com.gfp.core.utils.TimeUtil;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.GlowFilter;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

class TestSendSwapProgressUI extends Sprite
{
   
   private static const WIDTH:int = 220;
   
   private static const HEIGHT:int = 20;
   
   private var _bg:Shape;
   
   private var _textField:TextField;
   
   private var _closeBtn:SimpleButton;
   
   public function TestSendSwapProgressUI()
   {
      super();
      this._createBackground();
      this._textField = new TextField();
      var _loc1_:TextFormat = this._textField.defaultTextFormat;
      _loc1_.font = "Microsoft Yahei";
      _loc1_.size = 14;
      _loc1_.color = 41704;
      _loc1_.letterSpacing = 1;
      this._textField.defaultTextFormat = _loc1_;
      this._textField.setTextFormat(_loc1_);
      this._textField.filters = [new GlowFilter(0,1,2,2,4)];
      this._textField.x = 5;
      this._textField.y = -2;
      this._textField.autoSize = TextFieldAutoSize.LEFT;
      this._textField.mouseEnabled = false;
      addChild(this._textField);
      this._createCloseBtn();
   }
   
   private function _createCloseBtn() : void
   {
      var _loc1_:Sprite = new Sprite();
      var _loc2_:Graphics = _loc1_.graphics;
      _loc2_.lineStyle(1);
      _loc2_.beginFill(16777215,0.5);
      _loc2_.drawRect(0,0,HEIGHT,HEIGHT);
      _loc2_.endFill();
      var _loc3_:Shape = new Shape();
      _loc2_ = _loc3_.graphics;
      var _loc4_:Number = HEIGHT / 5 * 3;
      _loc2_.lineStyle(2);
      _loc2_.lineTo(_loc4_,_loc4_);
      _loc2_.moveTo(0,_loc4_);
      _loc2_.lineTo(_loc4_,0);
      _loc3_.x = (_loc1_.width - _loc3_.width) / 2 + 1;
      _loc3_.y = (_loc1_.height - _loc3_.height) / 2 + 1;
      _loc1_.addChild(_loc3_);
      var _loc5_:BitmapData = new BitmapData(_loc1_.width,_loc1_.height,true,0);
      _loc5_.draw(_loc1_);
      _loc3_.scaleX = _loc3_.scaleY = 1.2;
      _loc3_.x -= _loc3_.width * 0.1;
      _loc3_.y -= _loc3_.height * 0.1;
      var _loc6_:BitmapData = new BitmapData(_loc5_.width,_loc5_.height,true,0);
      _loc6_.draw(_loc1_);
      var _loc7_:BitmapData = _loc5_.clone();
      this._closeBtn = new SimpleButton(new Bitmap(_loc5_),new Bitmap(_loc6_),new Bitmap(_loc7_),new Bitmap(_loc5_));
      addChild(this._closeBtn);
      this._closeBtn.x = WIDTH - HEIGHT;
      this._closeBtn.addEventListener(MouseEvent.CLICK,this._onClose);
      LayerManager.stage.addEventListener(MouseEvent.CLICK,this._testHandler);
   }
   
   protected function _testHandler(param1:MouseEvent) : void
   {
   }
   
   private function _createBackground() : void
   {
      this._bg = new Shape();
      var _loc1_:Graphics = this._bg.graphics;
      _loc1_.lineStyle(1);
      _loc1_.beginFill(16777215,0.5);
      _loc1_.drawRect(0,0,WIDTH,HEIGHT);
      _loc1_.endFill();
      addChild(this._bg);
   }
   
   private function _onClose(param1:MouseEvent) : void
   {
      TestSendSwapManager.instance.cancel();
   }
   
   public function complete() : void
   {
      this._textField.text = "发送完毕！";
   }
   
   public function update(param1:uint) : void
   {
      var _loc2_:int = int(TestSendSwapManager.instance.totalNum);
      var _loc3_:int = _loc2_ - param1;
      var _loc4_:int = param1 * TestSendSwapManager.SEND_INTERVAL_IN_MS / 1000;
      var _loc5_:String = TimeUtil.formatSeconds(_loc4_);
      this._textField.text = "兑换发送:" + _loc3_ + "/" + _loc2_ + " " + _loc5_;
   }
   
   public function dispose() : void
   {
      removeChild(this._bg);
      this._bg = null;
      removeChild(this._textField);
      this._textField.filters = null;
      this._textField = null;
      this._closeBtn.removeEventListener(MouseEvent.CLICK,this._onClose);
      this._closeBtn = null;
   }
}
