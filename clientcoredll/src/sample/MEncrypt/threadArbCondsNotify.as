package sample.MEncrypt
{
   public function threadArbCondsNotify(param1:int) : void
   {
      var _temp_1:* = this;
      var _loc2_:int = 0;
      while(Boolean(param1) && _loc2_ < 32)
      {
         if(param1 & 1)
         {
            sample.MEncrypt.threadArbConds[_loc2_].notifyAll();
         }
         param1 >>= 1;
         _loc2_++;
      }
   }
}

import flash.utils.*;
import sample.MEncrypt.*;

