package com.gfp.app.feature
{
   import flash.text.TextField;
   
   public class LeftTimeTxtFeater extends LeftTimeBaseFeather
   {
      
      private var _displayText:TextField;
      
      public function LeftTimeTxtFeater(param1:int, param2:TextField, param3:Function, param4:int = 1, param5:Boolean = false)
      {
         super(param1,param3,param4,param5);
         this._displayText = param2;
      }
      
      override protected function setScreenText(param1:String) : void
      {
         if(param1)
         {
            this._displayText.text = param1;
         }
      }
   }
}

