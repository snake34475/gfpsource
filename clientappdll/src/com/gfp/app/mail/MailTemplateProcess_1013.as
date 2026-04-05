package com.gfp.app.mail
{
   import com.gfp.core.utils.WebURLUtil;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   
   public class MailTemplateProcess_1013 extends BaseMailTemplateProcess
   {
      
      private var _btnBus:SimpleButton;
      
      private var _tfHello:TextField;
      
      public function MailTemplateProcess_1013()
      {
         super();
      }
      
      override public function setup(param1:Sprite, param2:ByteArray) : void
      {
         super.setup(param1,param2);
         this._btnBus = _mailSP["btn_yes"] as SimpleButton;
         this._btnBus.addEventListener(MouseEvent.CLICK,this.onBus);
      }
      
      private function onBus(param1:MouseEvent) : void
      {
         WebURLUtil.intance.navigateBusApp();
      }
   }
}

