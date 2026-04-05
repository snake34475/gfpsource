package com.gfp.app.ui.activity
{
   import com.gfp.app.control.SystemTimeController;
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.app.toolBar.DynamicActivityEntry;
   import com.gfp.core.manager.TimeChangeManager;
   import com.gfp.core.utils.TimeUtil;
   import flash.events.Event;
   
   public class ShenBingPvpButton extends BaseActivitySprite
   {
      
      private const SYSTIME_ID:int = 227;
      
      public function ShenBingPvpButton(param1:ActivityNodeInfo)
      {
         super(param1);
         resetPromptEffect();
         TimeChangeManager.getInstance().addEventListener(TimeChangeManager.HOUR_CHANGE,this.timeChangeHandle);
      }
      
      protected function timeChangeHandle(param1:Event) : void
      {
         var _loc2_:int = int(TimeUtil.getSeverHours());
         if(_loc2_ >= 13 && _loc2_ < 14)
         {
            DynamicActivityEntry.instance.updateAlign();
         }
      }
      
      override public function executeShow() : Boolean
      {
         return Boolean(super.executeShow()) && SystemTimeController.instance.checkSysTimeAchieve(this.SYSTIME_ID);
      }
      
      override public function hasProptEffect() : Boolean
      {
         return SystemTimeController.instance.checkSysTimeAchieve(this.SYSTIME_ID);
      }
   }
}

