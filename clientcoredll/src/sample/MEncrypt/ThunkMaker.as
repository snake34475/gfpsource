package sample.MEncrypt
{
   import flash.utils.*;
   import sample.MEncrypt.kernel.*;
   import sample.MEncrypt.vfs.*;
   
   internal class ThunkMaker
   {
      
      private var modPkgName:String;
      
      private var thunkSet:Dictionary;
      
      private var start:int;
      
      private var end:int;
      
      private var index:int;
      
      public function ThunkMaker(param1:String, param2:Dictionary, param3:int, param4:int, param5:int)
      {
         super();
         this.modPkgName = param1;
         this.thunkSet = param2;
         this.start = param3;
         this.end = param4;
         this.index = param5;
      }
      
      public function thunk() : void
      {
         var _loc2_:int = 0;
         delete CModule.modThunks[modPkgName];
         var _loc1_:CModule = CModule.getModuleByPackage(modPkgName);
         _loc1_.getScript();
         _loc2_ = start;
         while(_loc2_ < end)
         {
            if(thunkSet[ptr2fun[_loc2_]])
            {
               delete thunkSet[ptr2fun[_loc2_]];
               ptr2fun[_loc2_] = null;
            }
            _loc2_++;
         }
         if(index >= 0)
         {
            ptr2fun[index]();
         }
      }
   }
}

import flash.utils.*;
import sample.MEncrypt.*;
import sample.MEncrypt.kernel.*;
import sample.MEncrypt.vfs.*;

const §10§:*;
