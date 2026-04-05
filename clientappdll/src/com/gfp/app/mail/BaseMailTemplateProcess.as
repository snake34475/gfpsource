package com.gfp.app.mail
{
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.manager.ModuleManager;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   
   public class BaseMailTemplateProcess
   {
      
      public static const TYPE_TRUNAPP:String = "trunApp";
      
      protected var _initType:uint = 0;
      
      protected var _mailSP:Sprite;
      
      protected var _mailContent:ByteArray;
      
      public function BaseMailTemplateProcess()
      {
         super();
      }
      
      public function setup(param1:Sprite, param2:ByteArray) : void
      {
         this._mailSP = param1;
         this._mailContent = param2;
         if(this._initType == MailInitType.TYPE_BASE)
         {
            this.baseInit();
         }
         this.init();
      }
      
      protected function init() : void
      {
      }
      
      private function baseInit() : void
      {
         this._mailSP.addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var _loc3_:String = null;
         var _loc2_:SimpleButton = param1.target as SimpleButton;
         if(_loc2_ != null)
         {
            _loc3_ = _loc2_.name;
            if(_loc3_.indexOf(TYPE_TRUNAPP) != -1)
            {
               this.turnAppp(_loc3_);
            }
         }
      }
      
      private function turnAppp(param1:String) : void
      {
         var _loc2_:Array = param1.split("_");
         if(_loc2_.length == 2)
         {
            ModuleManager.turnModule(ClientConfig.getAppModule(_loc2_[1]),"正在加载...");
            ModuleManager.destroy(ClientConfig.getAppModule("MailSysBox"));
         }
      }
      
      public function destroy() : void
      {
         this._mailSP.removeEventListener(MouseEvent.CLICK,this.onClick);
      }
   }
}

