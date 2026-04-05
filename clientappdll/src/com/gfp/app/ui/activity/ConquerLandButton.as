package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityMultiNodeInfo;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.ModuleManager;
   
   public class ConquerLandButton extends BaseActivityMultiSprite
   {
      
      public function ConquerLandButton(param1:ActivityMultiNodeInfo)
      {
         super(param1);
      }
      
      override protected function doAction() : void
      {
         if(ActivityExchangeTimesManager.getTimes(10176) == 0)
         {
            super.doAction();
         }
         else
         {
            ModuleManager.turnAppModule("WulingFengYunYingFenShenPanel");
         }
      }
   }
}

