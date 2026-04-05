package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.ModuleManager;
   import flash.events.Event;
   
   public class WishGiftButton extends BaseActivitySprite
   {
      
      public function WishGiftButton(param1:ActivityNodeInfo)
      {
         super(param1);
      }
      
      override protected function doAction() : void
      {
         ActivityExchangeTimesManager.addEventListener(10771,this.onWishTree);
         ActivityExchangeTimesManager.getActiviteTimeInfo(10771);
      }
      
      private function onWishTree(param1:Event) : void
      {
         ActivityExchangeTimesManager.removeEventListener(10771,this.onWishTree);
         var _loc2_:int = int(ActivityExchangeTimesManager.getTimes(10771));
         if(_loc2_ == 0)
         {
            ModuleManager.turnAppModule("WishTreePanel");
         }
         else
         {
            ModuleManager.turnAppModule("WishTreeSecPanel");
         }
      }
   }
}

