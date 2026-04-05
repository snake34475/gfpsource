package com.gfp.app.toolBar.chat
{
   import com.gfp.core.Constant;
   import com.gfp.core.utils.FilterUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class ChatBtn extends Sprite
   {
      
      private var _button:Sprite;
      
      private var _textMc:MovieClip;
      
      public var btnLabel:String;
      
      public var nameArray:Array = ["当前","组队","团队","交易","世界","","","世界"];
      
      public function ChatBtn(param1:int)
      {
         super();
         this._button = new UI_Multi_Chat_Btn();
         this._textMc = this._button["currentTMc"];
         addChild(this._button);
         this._textMc.gotoAndStop(param1 + 1);
         this._textMc.mouseEnabled = false;
         buttonMode = true;
         this.btnLabel = this.nameArray[param1];
      }
      
      public function set lable(param1:String) : void
      {
         this._textMc.gotoAndStop(Constant.MSG_CHANNEL.indexOf(param1) + 1);
      }
      
      public function get textMc() : MovieClip
      {
         return this._textMc;
      }
      
      public function setSelect() : void
      {
         filters = FilterUtil.CHAT_CHANNEL_SELECT_FILTER;
      }
      
      public function unSelect() : void
      {
         filters = null;
      }
   }
}

