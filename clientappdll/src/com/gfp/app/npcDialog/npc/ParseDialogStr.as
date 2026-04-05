package com.gfp.app.npcDialog.npc
{
   public class ParseDialogStr
   {
      
      public static const SPLIT:String = "$$";
      
      private var array:Array = [];
      
      private var numArray:Array = [];
      
      private var tempStr:String;
      
      public function ParseDialogStr(param1:String)
      {
         super();
         this.spliceStr(param1);
      }
      
      private function spliceStr(param1:String) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:uint = 0;
         var _loc7_:String = null;
         var _loc2_:uint = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1.charAt(_loc2_);
            if(_loc3_ == "#")
            {
               _loc4_ = param1.charAt(_loc2_ - 1);
               _loc5_ = param1.charAt(_loc2_ + 1);
               _loc6_ = 0;
               if(_loc4_ != "$" && uint(_loc5_).toString() == _loc5_)
               {
                  this.array.push(param1.slice(0,_loc2_));
                  _loc7_ = param1.substr(_loc2_ + 1,1 + _loc6_);
                  while(uint(_loc7_) < 100 && uint(_loc7_).toString() == _loc7_ && _loc6_ < param1.length)
                  {
                     _loc6_++;
                     _loc7_ = param1.substr(_loc2_ + 1,1 + _loc6_);
                  }
                  this.tempStr = param1.substring(_loc2_ + 1 + _loc6_,param1.length);
                  this.numArray.push(uint(param1.slice(_loc2_ + 1,_loc2_ + 1 + _loc6_)));
                  this.spliceStr(this.tempStr);
                  return;
               }
            }
            if(_loc2_ == param1.length - 1)
            {
               this.array.push(param1.slice());
               return;
            }
            _loc2_++;
         }
      }
      
      public function get strArray() : Array
      {
         return this.array;
      }
      
      public function get str() : String
      {
         return this.array.join(SPLIT);
      }
      
      public function get emotionList() : Array
      {
         return this.numArray;
      }
   }
}

