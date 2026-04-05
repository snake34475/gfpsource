package com.gfp.app.ui.compoment
{
   import flash.display.MovieClip;
   
   public class McNumber
   {
      
      private var skin:MovieClip;
      
      private var numbers:Vector.<MovieClip>;
      
      private var value:int;
      
      private var showZero:Boolean = false;
      
      public function McNumber(param1:MovieClip, param2:String = "number", param3:Boolean = false)
      {
         super();
         this.skin = param1;
         this.skin.mouseEnabled = false;
         this.skin.mouseChildren = false;
         this.showZero = param3;
         this.numbers = new Vector.<MovieClip>();
         var _loc4_:int = 0;
         while(_loc4_ < 10)
         {
            if(this.skin[param2 + _loc4_] == null)
            {
               break;
            }
            this.numbers[_loc4_] = this.skin[param2 + _loc4_];
            this.numbers[_loc4_].gotoAndStop(1);
            this.numbers[_loc4_].visible = false;
            _loc4_++;
         }
      }
      
      public function setValue(param1:int, param2:Boolean = true) : void
      {
         var _loc6_:int = 0;
         var _loc7_:* = 0;
         var _loc8_:MovieClip = null;
         this.value = param1;
         var _loc3_:String = this.value.toString();
         var _loc4_:int = _loc3_.length;
         var _loc5_:int = int(this.numbers.length);
         if(this.showZero)
         {
            _loc6_ = 0;
            _loc7_ = int(_loc5_ - 1);
            while(_loc7_ >= 0)
            {
               _loc8_ = this.numbers[_loc7_];
               if(_loc6_ < _loc4_)
               {
                  param1 = parseInt(_loc3_.charAt(_loc4_ - 1 - _loc6_)) + 1;
                  _loc8_.gotoAndStop(param1);
                  _loc8_.visible = true;
                  _loc6_++;
               }
               else
               {
                  _loc8_.visible = true;
                  _loc8_.gotoAndStop(1);
               }
               _loc7_--;
            }
         }
         else if(param2)
         {
            _loc7_ = 0;
            while(_loc7_ < _loc5_)
            {
               _loc8_ = this.numbers[_loc7_];
               if(_loc7_ >= _loc4_)
               {
                  _loc8_.visible = false;
               }
               else
               {
                  _loc8_.gotoAndStop(parseInt(_loc3_.charAt(_loc7_)) + 1);
                  _loc8_.visible = true;
               }
               _loc7_++;
            }
         }
         else
         {
            _loc7_ = 0;
            while(_loc7_ < _loc5_)
            {
               _loc8_ = this.numbers[_loc7_];
               if(_loc7_ < _loc5_ - _loc4_)
               {
                  _loc8_.visible = false;
               }
               else
               {
                  _loc8_.gotoAndStop(parseInt(_loc3_.charAt(_loc7_ - (_loc5_ - _loc4_))) + 1);
                  _loc8_.visible = true;
               }
               _loc7_++;
            }
         }
      }
      
      public function destroy() : void
      {
         this.numbers.length = 0;
         this.numbers = null;
         this.skin = null;
      }
   }
}

