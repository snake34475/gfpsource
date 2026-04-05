package com.gfp.app.mail
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   
   public class MailTemplateProcess_1006 extends BaseMailTemplateProcess
   {
      
      private var _mcRank:MovieClip;
      
      private var _tfGetDesc:TextField;
      
      public function MailTemplateProcess_1006()
      {
         super();
         _initType = MailInitType.TYPE_BASE;
      }
      
      override public function setup(param1:Sprite, param2:ByteArray) : void
      {
         super.setup(param1,param2);
         this._mcRank = _mailSP["mcRank"] as MovieClip;
         this._tfGetDesc = _mailSP["tfGetDesc"] as TextField;
         var _loc3_:uint = uint(TextField(_mailSP["bodyTxt"]).text);
         this._mcRank.gotoAndStop(_loc3_);
         this._tfGetDesc.text = "小侠士可以获得伏魔套装" + (11 - _loc3_).toString() + "件装备中的1件，请慎重选择。";
      }
   }
}

