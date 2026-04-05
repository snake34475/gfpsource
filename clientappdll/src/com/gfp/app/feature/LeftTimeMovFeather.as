package com.gfp.app.feature
{
   import com.gfp.core.player.NumSprite;
   import flash.display.MovieClip;
   
   public class LeftTimeMovFeather extends LeftTimeBaseFeather
   {
      
      private var _mov:MovieClip;
      
      private var _num0:NumSprite;
      
      private var _num1:NumSprite;
      
      public function LeftTimeMovFeather(param1:int, param2:MovieClip, param3:Function, param4:int = 1, param5:Boolean = false)
      {
         super(param1,param3,param4,param5);
         this._mov = param2;
         if(this._mov["num0"])
         {
            this._num0 = new NumSprite(this._mov["num0"]);
         }
         if(this._mov["num1"])
         {
            this._num1 = new NumSprite(this._mov["num1"]);
         }
      }
      
      override protected function setScreenText(param1:String) : void
      {
         var _loc2_:Array = param1.split(":");
         if(_loc2_.length == 2)
         {
            if(this._num0)
            {
               this._num0.value = parseInt(_loc2_[0]);
            }
            if(this._num1)
            {
               this._num1.value = parseInt(_loc2_[1]);
            }
         }
      }
   }
}

