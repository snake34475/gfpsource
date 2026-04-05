package com.gfp.app.ui.activity
{
   import com.gfp.app.control.SystemTimeController;
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.core.manager.TimeChangeManager;
   import flash.events.Event;
   
   public class FairPkButton extends BaseActivitySprite
   {
      
      private const SYSTIME_ID:int = 225;
      
      public function FairPkButton(param1:ActivityNodeInfo)
      {
         super(param1);
         resetPromptEffect();
         TimeChangeManager.getInstance().addEventListener(TimeChangeManager.HOUR_CHANGE,this.timeChangeHandle);
      }
      
      protected function timeChangeHandle(param1:Event) : void
      {
         resetPromptEffect();
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

