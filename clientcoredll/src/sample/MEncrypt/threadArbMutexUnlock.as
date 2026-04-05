package sample.MEncrypt
{
   public function threadArbMutexUnlock() : void
   {
      var _temp_1:* = this;
      var _loc1_:Number = sample.MEncrypt.threadArbLockDepth - 1;
      §§push(_loc1_);
      sample.MEncrypt.threadArbLockDepth = _loc1_;
      if(!_temp_4)
      {
         sample.MEncrypt.threadArbMutex.unlock();
      }
   }
}

import flash.utils.*;
import sample.MEncrypt.*;

