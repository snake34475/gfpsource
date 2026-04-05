package com.gfp.app.chat.text
{
   import com.gfp.core.uic.UIScrollBar;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import org.taomee.text.TextMix;
   
   public class TextMixArea extends Sprite
   {
      
      public static const RIGHT:int = 0;
      
      public static const LEFT:int = 1;
      
      public var lockScroll:Boolean;
      
      private var _textMix:TextMix;
      
      private var _scrollBar:UIScrollBar;
      
      private var _width:Number;
      
      private var _height:Number;
      
      private var _direction:int = 0;
      
      private var _scrollVisible:Boolean;
      
      public function TextMixArea(param1:DisplayObjectContainer, param2:Number = 100, param3:Number = 100)
      {
         super();
         this._scrollBar = new UIScrollBar(param1);
         this._scrollBar.pageSize = this._scrollBar.height;
         this._scrollBar.addEventListener(MouseEvent.MOUSE_MOVE,this.onScroll);
         this._scrollBar.wheelObject = param1;
         this._textMix = new TextMix(param2);
         this._textMix.viewRectEnabled = true;
         this._textMix.mouseEnabled = false;
         this._textMix.textColor = 16777215;
         this._textMix.fontFamily = "宋体";
         addChild(this._textMix);
         this._textMix.addEventListener(Event.RESIZE,this.onTextResize);
         this._textMix.addEventListener(TextEvent.LINK,this.onTextLink);
         this.width = param2;
         this.height = param3;
      }
      
      public function dispose() : void
      {
         this._textMix.removeEventListener(Event.RESIZE,this.onTextResize);
         this._textMix.removeEventListener(TextEvent.LINK,this.onTextLink);
         this._textMix.dispose();
         this._textMix = null;
         this._scrollBar.removeEventListener(MouseEvent.MOUSE_MOVE,this.onScroll);
         this._scrollBar.destroy();
         this._scrollBar = null;
      }
      
      public function set direction(param1:int) : void
      {
         if(param1 != this._direction)
         {
            this._direction = param1;
            this.updateDirection();
         }
      }
      
      public function get direction() : int
      {
         return this._direction;
      }
      
      override public function set width(param1:Number) : void
      {
         if(param1 != this._width)
         {
            this._width = param1;
            this._textMix.viewWidth = this._textMix.width;
            this.invalidateScroll();
         }
      }
      
      override public function get width() : Number
      {
         return this._width;
      }
      
      override public function set height(param1:Number) : void
      {
         if(param1 != this._height)
         {
            this._height = param1;
            this._scrollBar.height = this._height;
            this._scrollBar.pageSize = this._height;
            this._textMix.viewHeight = this._height;
            this.invalidateScroll();
         }
      }
      
      override public function get height() : Number
      {
         return this._height;
      }
      
      public function set maxParagraph(param1:uint) : void
      {
         this._textMix.maxParagraph = param1;
      }
      
      public function get text() : String
      {
         return this._textMix.text;
      }
      
      public function set text(param1:String) : void
      {
         this._textMix.text = param1;
      }
      
      public function appendText(param1:String) : void
      {
         var value:String = param1;
         try
         {
            this._textMix.appendText(value);
         }
         catch(e:Error)
         {
         }
      }
      
      public function clearText() : void
      {
         this.text = "";
         this.invalidateScroll();
      }
      
      private function onTextResize(param1:Event) : void
      {
         this.invalidateScroll();
      }
      
      private function onScroll(param1:MouseEvent) : void
      {
         this._textMix.scrollH = this._scrollBar.scrollPosition;
      }
      
      private function onTextLink(param1:TextEvent) : void
      {
         dispatchEvent(param1);
      }
      
      private function updateDirection() : void
      {
         if(this._direction == RIGHT)
         {
            this._textMix.x = 0;
         }
         else if(this._direction == LEFT)
         {
            this._textMix.x = this._scrollBar.width;
         }
      }
      
      private function invalidateScroll() : void
      {
         addEventListener(Event.ENTER_FRAME,this.onInvalidateScroll);
      }
      
      protected function onInvalidateScroll(param1:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onInvalidateScroll);
         this._scrollBar.maxScrollPosition = this._textMix.contentHeight;
         if(this.lockScroll == false)
         {
            if(this._scrollBar.maxScrollPosition <= this._scrollBar.pageSize)
            {
               this._scrollBar.scrollPosition = 0;
            }
            else
            {
               this._scrollBar.scrollPosition = this._scrollBar.maxScrollPosition - this._scrollBar.pageSize;
            }
         }
      }
   }
}

