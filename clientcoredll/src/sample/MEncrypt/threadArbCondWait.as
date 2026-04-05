package sample.MEncrypt
{
   public function threadArbCondWait(param1:Number) : Boolean
   {
      var _temp_1:* = this;
      var _loc2_:Boolean = false;
      return Boolean(sample.MEncrypt.threadArbConds[sample.MEncrypt.threadId & 0x1F].wait(param1));
   }
}

import flash.utils.*;
import sample.MEncrypt.*;

