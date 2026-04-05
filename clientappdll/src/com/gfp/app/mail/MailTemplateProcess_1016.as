package com.gfp.app.mail
{
   import com.gfp.core.utils.WebURLUtil;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   
   public class MailTemplateProcess_1016 extends BaseMailTemplateProcess
   {
      
      private var _btn:SimpleButton;
      
      public function MailTemplateProcess_1016()
      {
         super();
         _initType = MailInitType.TYPE_NONE;
      }
      
      override public function setup(param1:Sprite, param2:ByteArray) : void
      {
         super.setup(param1,param2);
         this._btn = _mailSP["btn"];
         this._btn.addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         WebURLUtil.intance.navigateWSJ();
      }
      
      override public function destroy() : void
      {
         this._btn.removeEventListener(MouseEvent.CLICK,this.onClick);
         this._btn = null;
         super.destroy();
      }
   }
}

