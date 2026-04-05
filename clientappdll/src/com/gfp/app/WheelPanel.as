package com.gfp.app
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.GlowFilter;
   
   public class WheelPanel extends Sprite
   {
      
      private var source:Vector.<Class>;
      
      private var w:Number;
      
      private var h:Number;
      
      private var count:int;
      
      private var radiusX:int;
      
      private var radiusY:int;
      
      private var centerX:int;
      
      private var centerY:int;
      
      private var angle:Number;
      
      private var sortArray:Array;
      
      private var filter:Array;
      
      public function WheelPanel(param1:Vector.<Class>, param2:Number, param3:Number, param4:int = 270, param5:int = 36)
      {
         super();
         this.source = param1;
         this.w = param2;
         this.h = param3;
         this.count = param1.length;
         this.radiusX = param4;
         this.radiusY = param5;
         this.centerX = param2 / 2;
         this.centerY = param3 / 2;
         this.angle = Math.PI * 2 / this.count;
         this.sortArray = new Array();
         this.filter = new Array();
         var _loc6_:GlowFilter = new GlowFilter();
         _loc6_.strength = 2;
         _loc6_.quality = BitmapFilterQuality.LOW;
         _loc6_.blurX = 2;
         _loc6_.blurY = 2;
         _loc6_.color = 6750207;
         this.filter.push(_loc6_);
         this.createChildren();
      }
      
      private function createChildren() : void
      {
         var _loc2_:Class = null;
         var _loc3_:MovieClip = null;
         var _loc4_:Number = NaN;
         var _loc1_:int = 0;
         while(_loc1_ < this.count)
         {
            _loc2_ = this.source[_loc1_];
            _loc3_ = new _loc2_();
            _loc4_ = _loc1_ * this.angle + Math.PI / 2 * 3;
            _loc3_.name = "item" + _loc1_;
            _loc3_.angle = _loc4_;
            _loc3_.targetAngle = _loc4_;
            this.addChild(_loc3_);
            this.sortArray.push(_loc3_);
            if(_loc1_ == 0)
            {
               _loc3_.filters = this.filter;
            }
            _loc1_++;
         }
      }
      
      public function start() : void
      {
         this.addEventListener(Event.ENTER_FRAME,this.onEventEnterFrame);
      }
      
      public function goLeft() : void
      {
         var _loc2_:MovieClip = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.count)
         {
            _loc2_ = this.getChildByName("item" + _loc1_) as MovieClip;
            _loc2_.targetAngle -= this.angle;
            _loc2_.filters = null;
            _loc1_++;
         }
      }
      
      public function goRight() : void
      {
         var _loc2_:MovieClip = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.count)
         {
            _loc2_ = this.getChildByName("item" + _loc1_) as MovieClip;
            _loc2_.targetAngle += this.angle;
            _loc2_.filters = null;
            _loc1_++;
         }
      }
      
      private function onEventEnterFrame(param1:Event) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:Number = NaN;
         var _loc2_:int = 0;
         while(_loc2_ < this.count)
         {
            _loc3_ = this.getChildByName("item" + _loc2_) as MovieClip;
            _loc3_.angle += (_loc3_.targetAngle - _loc3_.angle) / 5;
            _loc3_.x = Math.cos(_loc3_.angle) * this.radiusX + this.centerX;
            _loc3_.y = -Math.sin(_loc3_.angle) * this.radiusY + this.centerY;
            _loc4_ = 0.8 - 0.2 * Math.sin(_loc3_.angle);
            _loc3_.scaleX = _loc3_.scaleY = _loc4_;
            if(Math.abs(_loc3_.angle - _loc3_.targetAngle) < 0.0001 && Math.abs(_loc4_ - 1) < 0.0001)
            {
               this.mcStoped(_loc3_);
            }
            _loc2_++;
         }
         this.sortChildren();
      }
      
      private function mcStoped(param1:MovieClip) : void
      {
         if(!param1.filters || Boolean(param1.filters) && Boolean(param1.filters.length == 0))
         {
            param1.filters = this.filter;
         }
      }
      
      public function getRotateAngle(param1:Number) : Number
      {
         var _loc2_:Number = NaN;
         if(param1 < 0)
         {
            _loc2_ = param1 % Math.PI / Math.PI + Math.PI * 2;
         }
         else
         {
            _loc2_ = param1 % Math.PI / Math.PI + Math.PI;
         }
         var _loc3_:Number = _loc2_ / Math.PI;
         return _loc2_;
      }
      
      public function destory() : void
      {
         this.removeEventListener(Event.ENTER_FRAME,this.onEventEnterFrame);
      }
      
      private function sortChildren() : void
      {
         var _loc2_:MovieClip = null;
         this.sortArray.sortOn("scaleX");
         var _loc1_:int = 0;
         while(_loc1_ < this.sortArray.length)
         {
            _loc2_ = this.sortArray[_loc1_];
            this.setChildIndex(_loc2_,_loc1_);
            _loc1_++;
         }
      }
   }
}

