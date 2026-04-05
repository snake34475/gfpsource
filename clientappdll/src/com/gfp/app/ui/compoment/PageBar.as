package com.gfp.app.ui.compoment
{
   import com.gfp.app.ui.compoment.events.PageBarEvent;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class PageBar extends EventDispatcher
   {
      
      public var updateFunc:Function;
      
      private var _pagecells:Array;
      
      private var _items:*;
      
      private var _page:int = 0;
      
      private var _maxpage:int;
      
      private var _prevbtn:SimpleButton;
      
      private var _nextbtn:SimpleButton;
      
      private var _pagestxt:TextField;
      
      public function PageBar(param1:Array)
      {
         super();
         this._pagecells = param1;
      }
      
      public function set items(param1:*) : void
      {
         this._items = param1;
         this._maxpage = Math.ceil(this._items.length / this._pagecells.length);
         if(this._maxpage <= 0)
         {
            this._maxpage = 1;
         }
         this._page = 0;
      }
      
      public function get items() : *
      {
         return this._items;
      }
      
      public function get page() : int
      {
         return this._page;
      }
      
      public function get maxpage() : int
      {
         return this._maxpage;
      }
      
      public function get currentIndex() : int
      {
         return this._page * this._pagecells.length;
      }
      
      public function set pagecells(param1:Array) : void
      {
         this._pagecells = param1;
      }
      
      public function setUI(param1:SimpleButton, param2:SimpleButton, param3:TextField) : void
      {
         this._prevbtn = param2;
         this._nextbtn = param1;
         this._pagestxt = param3;
         this.initEvent();
      }
      
      public function update() : void
      {
         if(this._prevbtn.stage)
         {
            this._prevbtn.stage.addEventListener(Event.ENTER_FRAME,this._update);
         }
         else
         {
            this._update(null);
         }
      }
      
      private function _update(param1:Event) : void
      {
         if(this._prevbtn.stage)
         {
            this._prevbtn.stage.removeEventListener(Event.ENTER_FRAME,this._update);
         }
         var _loc2_:int = this._pagecells.length * this._page;
         var _loc3_:int = this._pagecells.length * (this._page + 1);
         var _loc4_:int = _loc2_;
         var _loc5_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(_loc4_ >= this._items.length)
            {
               this.updateFunc(this._pagecells[_loc5_],null);
            }
            else
            {
               this.updateFunc(this._pagecells[_loc5_],this._items[_loc4_]);
            }
            _loc4_++;
            _loc5_++;
         }
         this.initpages();
         dispatchEvent(new PageBarEvent(PageBarEvent.UPDATE));
      }
      
      public function nextpage() : void
      {
         if(this._page >= this._maxpage - 1)
         {
            return;
         }
         ++this._page;
         this.update();
      }
      
      public function prevpage() : void
      {
         if(this._page <= 0)
         {
            return;
         }
         --this._page;
         this.update();
      }
      
      public function updatepage(param1:uint) : void
      {
         if(param1 >= this._maxpage)
         {
            param1 = this._maxpage - 1;
         }
         if(param1 <= 0)
         {
            param1 = 0;
         }
         this._page = param1;
         this.update();
      }
      
      private function initEvent() : void
      {
         this._prevbtn.addEventListener(MouseEvent.CLICK,this.onPrevClick);
         this._nextbtn.addEventListener(MouseEvent.CLICK,this.onNextClick);
      }
      
      private function removeEvent() : void
      {
         this._prevbtn.removeEventListener(MouseEvent.CLICK,this.onPrevClick);
         this._nextbtn.removeEventListener(MouseEvent.CLICK,this.onNextClick);
      }
      
      private function onPrevClick(param1:MouseEvent) : void
      {
         this.prevpage();
         dispatchEvent(new PageBarEvent(PageBarEvent.PREV_PAGE));
      }
      
      private function onNextClick(param1:MouseEvent) : void
      {
         this.nextpage();
         dispatchEvent(new PageBarEvent(PageBarEvent.NEXT_PAGE));
      }
      
      private function initpages() : void
      {
         if(this._pagestxt)
         {
            this._pagestxt.text = this.page + 1 + "/" + this.maxpage;
         }
      }
      
      public function removeItem(param1:int) : void
      {
      }
      
      public function dispose() : void
      {
         this.removeEvent();
      }
   }
}

