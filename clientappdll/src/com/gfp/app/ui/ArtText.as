package com.gfp.app.ui
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.text.StaticText;
   import flash.text.TextField;
   
   public class ArtText extends Sprite
   {
      
      private static const fontURL:String = "res/font/";
      
      private var _container:Sprite;
      
      private var _bmp:Bitmap;
      
      private var _loader:Loader;
      
      private var _text:String;
      
      private var _fontName:String;
      
      private var _dis:int;
      
      private var _autoToBmp:Boolean;
      
      private var _textFilters:Array;
      
      private var _showThreeWord:Boolean;
      
      private var _index:int;
      
      public function ArtText(param1:String, param2:String = "pangwa", param3:int = 3, param4:Boolean = true, param5:Boolean = false)
      {
         super();
         this._text = param1;
         this._fontName = param2;
         this._dis = param3;
         this._autoToBmp = param4;
         this._showThreeWord = param5;
         this._container = new Sprite();
         this.startLoad();
      }
      
      public function dispose() : void
      {
         this._loader = null;
         this._container = null;
         this._bmp.bitmapData.dispose();
         this._bmp = null;
         this._textFilters = null;
      }
      
      private function startLoad() : void
      {
         this._loader = new Loader();
         this._loader.load(new URLRequest(fontURL + this._fontName + "/" + this._text.charCodeAt(this._index) + ".swf"));
         this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadOneOver);
         this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
      }
      
      private function onLoadOneOver(param1:Event) : void
      {
         var _loc5_:TextField = null;
         ++this._index;
         var _loc2_:TextField = (this._loader.content as MovieClip).getChildAt(0) as TextField;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         while(_loc4_ < this._container.numChildren)
         {
            _loc5_ = this._container.getChildAt(_loc4_) as TextField;
            if(this._textFilters)
            {
               _loc5_.filters = this._textFilters;
            }
            if(_loc5_)
            {
               _loc3_ += _loc5_.textWidth + this._dis;
            }
            _loc4_++;
         }
         _loc2_.x = _loc3_;
         _loc2_.y = 0;
         this._container.addChild(_loc2_);
         if(this._index >= this._text.length || this._showThreeWord && this._index >= 3)
         {
            this.loadOver();
         }
         else
         {
            this.nextLoad();
         }
      }
      
      private function loadOver() : void
      {
         if(this._autoToBmp)
         {
            this.toBitmap();
         }
         this.setPos();
         dispatchEvent(new Event("artText_LoadOver"));
      }
      
      private function setPos() : void
      {
         if(parent)
         {
            this.x = (parent.width - this.width) / 2;
         }
      }
      
      public function setTextFilters(param1:Array) : void
      {
         this._textFilters = param1;
      }
      
      public function toBitmap() : void
      {
         var _loc1_:BitmapData = new BitmapData(this._container.width,this._container.height,true,0);
         _loc1_.draw(this._container);
         this._bmp = new Bitmap(_loc1_);
         addChild(this._bmp);
      }
      
      private function onIOError(param1:IOErrorEvent) : void
      {
         var _loc2_:StaticText = null;
         ++this._index;
         if(this._index >= this._text.length)
         {
            this.loadOver();
         }
         else
         {
            this.nextLoad();
         }
      }
      
      private function nextLoad() : void
      {
         this._loader.load(new URLRequest(fontURL + this._fontName + "/" + this._text.charCodeAt(this._index) + ".swf"));
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      public function get fontName() : String
      {
         return this._fontName;
      }
   }
}

