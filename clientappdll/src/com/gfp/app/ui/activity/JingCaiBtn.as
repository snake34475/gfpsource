package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.utils.TimeUtil;
   
   public class JingCaiBtn extends BaseActivitySprite
   {
      
      private var downDate1:Date = new Date(2017,1,3,0,0);
      
      public function JingCaiBtn(param1:ActivityNodeInfo)
      {
         super(param1);
      }
      
      override protected function doAction() : void
      {
         var _loc1_:Date = TimeUtil.getSeverDateObject();
         if(_loc1_.time > this.downDate1.time)
         {
            ModuleManager.turnAppModule("MidAutumnFestivalAllInOnePanel");
         }
         else
         {
            ModuleManager.turnAppModule("MidAutumnFestivalAllInOnePanel1");
         }
      }
   }
}

