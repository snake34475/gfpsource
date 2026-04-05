package com.gfp.app.mail
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.utils.ByteArray;
   
   public class MailTemplateProcess_1017 extends BaseMailTemplateProcess
   {
      
      private var _awardItem:MovieClip;
      
      public function MailTemplateProcess_1017()
      {
         super();
         _initType = MailInitType.TYPE_BASE;
      }
      
      override public function setup(param1:Sprite, param2:ByteArray) : void
      {
         super.setup(param1,param2);
         this._awardItem = _mailSP["awardItem"];
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
   }
}

