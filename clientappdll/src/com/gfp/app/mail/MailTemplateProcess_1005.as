package com.gfp.app.mail
{
   import com.gfp.core.manager.MainManager;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   
   public class MailTemplateProcess_1005 extends BaseMailTemplateProcess
   {
      
      public function MailTemplateProcess_1005()
      {
         super();
         _initType = MailInitType.TYPE_BASE;
      }
      
      override public function setup(param1:Sprite, param2:ByteArray) : void
      {
         var _loc4_:int = 0;
         var _loc5_:TextField = null;
         super.setup(param1,param2);
         var _loc3_:int = _mailSP.numChildren;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _mailSP.getChildAt(_loc4_) as TextField;
            if(_loc5_)
            {
               if(_loc5_.name == "nickName")
               {
                  _loc5_.text = MainManager.actorInfo.nick;
               }
            }
            _loc4_++;
         }
      }
   }
}

