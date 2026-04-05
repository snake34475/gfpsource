package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.app.toolBar.DynamicActivityEntry;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TimeChangeManager;
   import com.gfp.core.utils.TimeUtil;
   import flash.events.Event;
   
   public class LiuDaoZhanShenButton extends BaseActivitySprite
   {
      
      private var _adTime:Boolean;
      
      public function LiuDaoZhanShenButton(param1:ActivityNodeInfo)
      {
         super(param1);
         TimeChangeManager.getInstance().addEventListener(TimeChangeManager.HOUR_CHANGE,this.onHourChange);
      }
      
      private function onHourChange(param1:Event) : void
      {
         var _loc2_:int = int(TimeUtil.getSeverHours());
         if(_loc2_ == 13 || _loc2_ == 14)
         {
            DynamicActivityEntry.instance.updateAlign();
         }
      }
      
      override public function executeShow() : Boolean
      {
         var _loc1_:int = int(TimeUtil.getSeverHours());
         return Boolean(super.executeShow()) && MainManager.actorInfo.lv >= 80 && _loc1_ == 13;
      }
   }
}

