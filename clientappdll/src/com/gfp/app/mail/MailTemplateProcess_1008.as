package com.gfp.app.mail
{
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.utils.WebURLUtil;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   
   public class MailTemplateProcess_1008 extends BaseMailTemplateProcess
   {
      
      private var _btnBus:SimpleButton;
      
      private var _tfHello:TextField;
      
      public function MailTemplateProcess_1008()
      {
         super();
      }
      
      override public function setup(param1:Sprite, param2:ByteArray) : void
      {
         super.setup(param1,param2);
         this._btnBus = _mailSP["btnBus"] as SimpleButton;
         this._tfHello = _mailSP["tfHello"] as TextField;
         this._tfHello.text = "HI，" + MainManager.actorInfo.nick + "，我是" + TextField(_mailSP["bodyTxt"]).text;
         this._btnBus.addEventListener(MouseEvent.CLICK,this.onBus);
      }
      
      private function onBus(param1:MouseEvent) : void
      {
         WebURLUtil.intance.navigateBus();
      }
   }
}

