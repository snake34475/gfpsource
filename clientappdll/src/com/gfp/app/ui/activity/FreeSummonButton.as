package com.gfp.app.ui.activity
{
   import com.gfp.app.control.SystemTimeController;
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.core.manager.TimeChangeManager;
   import com.gfp.core.utils.TimeUtil;
   import flash.events.Event;
   
   public class FreeSummonButton extends BaseActivitySprite
   {
      
      private const SYSTIME_ID:int = 225;
      
      public function FreeSummonButton(param1:ActivityNodeInfo)
      {
         super(param1);
         this.timeChangeHandle(null);
         TimeChangeManager.getInstance().addEventListener(TimeChangeManager.HOUR_CHANGE,this.timeChangeHandle);
      }
      
      protected function timeChangeHandle(param1:Event) : void
      {
         resetPromptEffect();
      }
      
      override public function executeShow() : Boolean
      {
         return Boolean(super.executeShow()) && (TimeUtil.getSeverDateObject().date < 20 || TimeUtil.getSeverDateObject().date == 20 && TimeUtil.getSeverHours() < 14);
      }
      
      override public function hasProptEffect() : Boolean
      {
         return SystemTimeController.instance.checkSysTimeAchieve(this.SYSTIME_ID);
      }
   }
}

