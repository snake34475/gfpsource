package com.gfp.app.ui.activity
{
   import com.greensock.TweenLite;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class ScrollItems extends Sprite
   {
      
      private var _movies:Vector.<DisplayObject>;
      
      private var _container:Sprite;
      
      private var _pos:Vector.<Number>;
      
      private var _isTween:Boolean;
      
      private var _index:int;
      
      private const TIME:Number = 0.2;
      
      public function ScrollItems(param1:Vector.<DisplayObject>, param2:int = 0, param3:int = 0)
      {
         var _loc5_:int = 0;
         super();
         this._movies = param1;
         this._container = new Sprite();
         this._pos = new Vector.<Number>(param1.length + 1);
         if(param2 == 0)
         {
            param2 = this._movies[0].width;
         }
         var _loc4_:Number = 0;
         _loc5_ = 0;
         while(_loc5_ < param1.length)
         {
            param1[_loc5_].y = 0;
            param1[_loc5_].x = _loc4_;
            _loc4_ += param2 + param3;
            this._container.addChild(param1[_loc5_]);
            this._pos[_loc5_ + 1] = param1[_loc5_].x;
            _loc5_++;
         }
         this._pos[0] = -param2 - param3;
         var _loc6_:Shape = new Shape();
         _loc6_.graphics.beginFill(0,1);
         _loc6_.graphics.drawRect(0,0,1,1);
         _loc6_.graphics.endFill();
         _loc6_.width = param2 * (param1.length - 1) + param3 * (param1.length - 2);
         _loc6_.height = param1[0].height;
         addChild(this._container);
         addChild(_loc6_);
         this._container.mask = _loc6_;
      }
      
      public function get movies() : Vector.<DisplayObject>
      {
         return this._movies;
      }
      
      public function set index(param1:int) : void
      {
         this._index = param1;
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function get isTween() : Boolean
      {
         return this._isTween;
      }
      
      public function next() : void
      {
         if(this._isTween)
         {
            return;
         }
         ++this._index;
         this._isTween = true;
         TweenLite.to(this._movies[0],this.TIME,{
            "x":this._pos[0],
            "onComplete":this.onTweenComplete
         });
         this._movies[this._movies.length - 1].x = this._pos[this._movies.length];
         this._movies.push(this._movies.shift());
         var _loc1_:int = 0;
         while(_loc1_ < this._movies.length - 1)
         {
            TweenLite.to(this._movies[_loc1_],this.TIME,{"x":this._pos[_loc1_ + 1]});
            _loc1_++;
         }
         dispatchEvent(new Event(Event.SCROLL));
      }
      
      public function prev() : void
      {
         if(this._isTween)
         {
            return;
         }
         --this._index;
         this._isTween = true;
         TweenLite.to(this._movies[this._movies.length - 2],this.TIME,{
            "x":this._pos[this._movies.length],
            "onComplete":this.onTweenComplete
         });
         this._movies[this._movies.length - 1].x = this._pos[0];
         this._movies.unshift(this._movies.pop());
         var _loc1_:int = 0;
         while(_loc1_ < this._movies.length - 1)
         {
            TweenLite.to(this._movies[_loc1_],this.TIME,{"x":this._pos[_loc1_ + 1]});
            _loc1_++;
         }
         dispatchEvent(new Event(Event.SCROLL));
      }
      
      private function onTweenComplete() : void
      {
         this._isTween = false;
         dispatchEvent(new Event(Event.COMPLETE));
      }
   }
}

