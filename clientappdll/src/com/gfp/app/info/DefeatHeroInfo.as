package com.gfp.app.info
{
   import flash.utils.IDataInput;
   
   public class DefeatHeroInfo
   {
      
      public var heroID:uint;
      
      public var defeatTime:uint;
      
      public function DefeatHeroInfo(param1:IDataInput = null)
      {
         super();
         if(param1)
         {
            this.heroID = param1.readUnsignedInt();
            this.defeatTime = param1.readUnsignedInt();
         }
      }
   }
}

