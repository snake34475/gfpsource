package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.core.utils.TimeUtil;
   
   public class MXRewardButton extends BaseActivitySprite
   {
      
      private var dateLine:Date = new Date(2017,5,2,0,0);
      
      public function MXRewardButton(param1:ActivityNodeInfo)
      {
         super(param1);
      }
      
      override public function executeShow() : Boolean
      {
         var _loc1_:Boolean = super.executeShow();
         var _loc2_:Date = TimeUtil.getSeverDateObject();
         if(_loc1_ && _loc2_.time <= this.dateLine.time)
         {
            return true;
         }
         return false;
      }
   }
}

