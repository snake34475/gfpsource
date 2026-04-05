package sample.MEncrypt
{
   public function ptr2funInit() : *
   {
      var _loc1_:Vector.<Function> = null;
      if(typeof ptr2fun != "undefined" && ptr2fun == null && sample.MEncrypt.ptr2fun_init is Array)
      {
         var _temp_3:* = new Vector.<Function>();
         _temp_3.push.apply(null,sample.MEncrypt.ptr2fun_init);
         sample.MEncrypt.ptr2fun_init.length = 0;
         sample.MEncrypt.ptr2fun_init = _temp_3;
      }
      return sample.MEncrypt.ptr2fun_init;
   }
}

import flash.utils.*;
import sample.MEncrypt.*;

const §6§:*;
