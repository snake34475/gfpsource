package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.core.utils.TimeUtil;
   
   public class SendTbButton extends BaseActivitySprite
   {
      
      public function SendTbButton(param1:ActivityNodeInfo)
      {
         super(param1);
         _sprite["timeMC"].gotoAndStop(TimeUtil.getSeverDateObject().date < 12 ? 1 : 2);
      }
      
      override public function executeShow() : Boolean
      {
         var _loc1_:int = int(TimeUtil.getSeverDateObject().date);
         var _loc2_:int = int(TimeUtil.getSeverHours());
         return Boolean(super.executeShow()) && _loc2_ < 14 && (_loc1_ >= 7 && _loc1_ <= 9 || _loc1_ >= 12 && _loc1_ <= 14);
      }
   }
}

