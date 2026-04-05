package com.gfp.app.toolBar.chat
{
   import com.gfp.core.utils.ArrayQueue;
   import com.gfp.core.utils.ChatUtil;
   import flash.display.Sprite;
   import flash.events.TextEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class ChatSystemInfoText extends Sprite
   {
      
      private var _text:TextField;
      
      private var _arr:ArrayQueue;
      
      private var _tmf:TextFormat = new TextFormat();
      
      public function ChatSystemInfoText()
      {
         super();
         var _loc1_:Sprite = this.drawBg();
         _loc1_.cacheAsBitmap = true;
         addChildAt(_loc1_,0);
         this._text = new TextField();
         this._text.name = "ChatSystemInfoText";
         this._text.doubleClickEnabled = true;
         this._text.multiline = true;
         this._text.wordWrap = true;
         this._arr = new ArrayQueue(3);
         this._text.width = 329;
         this._text.height = 50;
         addChild(this._text);
         this._text.addEventListener(TextEvent.LINK,this.onLink);
      }
      
      private function onLink(param1:TextEvent) : void
      {
         ChatUtil.charProcess(param1.text);
      }
      
      private function drawBg() : Sprite
      {
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(0,0.2);
         _loc1_.graphics.drawRect(0,0,329,50);
         _loc1_.graphics.endFill();
         return _loc1_;
      }
      
      public function addText(param1:String) : void
      {
         this._arr.push(param1);
         this._tmf.size = 12;
         this._tmf.font = "宋体";
         this._text.setTextFormat(this._tmf);
         this._text.htmlText = this._arr.join();
         this._text.scrollV = this._text.textHeight;
      }
   }
}

