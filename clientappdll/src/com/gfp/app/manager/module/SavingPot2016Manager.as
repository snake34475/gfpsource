package com.gfp.app.manager.module
{
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   
   public class SavingPot2016Manager
   {
      
      public function SavingPot2016Manager()
      {
         super();
      }
      
      public static function execute() : void
      {
         if(MainManager.actorInfo.lv != 85)
         {
            return;
         }
         ModuleManager.turnAppModule("SavingPot1601Panel");
      }
   }
}

