package sample.MEncrypt
{
   public function yield(param1:int = 1) : void
   {
      var _temp_1:* = this;
      var _loc2_:* = undefined;
      if(!sample.MEncrypt.yieldCond)
      {
         _loc2_ = new mutexClass();
         _loc2_.lock();
         sample.MEncrypt.yieldCond = new conditionClass(_loc2_);
      }
      sample.MEncrypt.yieldCond.wait(param1);
   }
}

import flash.utils.*;
import sample.MEncrypt.*;

