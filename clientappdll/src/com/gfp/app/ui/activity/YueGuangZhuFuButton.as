package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.app.toolBar.DynamicActivityEntry;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.utils.TimeUtil;
   
   public class YueGuangZhuFuButton extends BaseActivitySprite
   {
      
      private var upDate1:Date = new Date(2016,8,26,18,55);
      
      private var downDate1:Date = new Date(2016,8,26,19,30);
      
      public function YueGuangZhuFuButton(param1:ActivityNodeInfo)
      {
         super(param1);
      }
      
      override public function addEvent() : void
      {
         super.addEvent();
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onSwitchComplete);
      }
      
      override public function removeEvent() : void
      {
         super.removeEvent();
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onSwitchComplete);
      }
      
      private function onSwitchComplete(param1:MapEvent) : void
      {
         DynamicActivityEntry.instance.updateAlign();
      }
      
      override public function executeShow() : Boolean
      {
         var _loc1_:Boolean = super.executeShow();
         var _loc2_:Date = TimeUtil.getSeverDateObject();
         if(_loc2_.hours == this.upDate1.hours && _loc2_.minutes >= this.upDate1.minutes)
         {
            return _loc1_;
         }
         if(_loc2_.hours == this.downDate1.hours && _loc2_.minutes <= this.downDate1.minutes)
         {
            return _loc1_;
         }
         return false;
      }
   }
}

