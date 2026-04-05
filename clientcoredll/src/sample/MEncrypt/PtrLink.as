package sample.MEncrypt
{
   internal class PtrLink
   {
      
      public const ptr:int = 0;
      
      public var next:PtrLink;
      
      public function PtrLink(param1:int)
      {
         super();
         this.ptr = param1;
      }
   }
}

import flash.utils.*;
import sample.MEncrypt.*;
import sample.MEncrypt.kernel.*;
import sample.MEncrypt.vfs.*;

