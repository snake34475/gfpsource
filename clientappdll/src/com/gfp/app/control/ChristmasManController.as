package com.gfp.app.control
{
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.ItemManager;
   
   public class ChristmasManController
   {
      
      private static const SNOW_HAT_IDS:Array = [100400,200400,300400,400400];
      
      public function ChristmasManController()
      {
         super();
      }
      
      public static function getSwap(param1:uint) : void
      {
         var _loc2_:uint = 0;
         if(ItemManager.checkWearItems(SNOW_HAT_IDS,false))
         {
            if(param1 >= 101851)
            {
               _loc2_ = 1268 + (int(param1 / 10) - 10185);
            }
            else
            {
               _loc2_ = 1234 + (int(param1 / 10) - 10165);
            }
            ActivityExchangeCommander.exchange(_loc2_);
         }
         else
         {
            AlertManager.showSimpleAlarm("小侠士你还没有装备丰雪帽哦！只有装备了丰雪帽才能参与活动！");
         }
      }
   }
}

