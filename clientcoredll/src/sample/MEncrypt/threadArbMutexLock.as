package sample.MEncrypt
{
   public function threadArbMutexLock() : void
   {
      var _temp_1:* = this;
      var _temp_2:* = sample.MEncrypt.threadArbLockDepth;
      §§push(_temp_2);
      sample.MEncrypt.threadArbLockDepth = _temp_2 + 1;
      if(!_temp_2)
      {
         sample.MEncrypt.threadArbMutex.lock();
      }
   }
}

import flash.utils.*;
import sample.MEncrypt.*;

