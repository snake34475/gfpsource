package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.app.toolBar.DynamicActivityEntry;
   import com.gfp.core.manager.TimeChangeManager;
   import com.gfp.core.utils.TimeUtil;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.setInterval;
   
   public class GongQiangSummonBtn extends BaseActivitySprite
   {
      
      private var _alertMC:MovieClip;
      
      public function GongQiangSummonBtn(param1:ActivityNodeInfo)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._alertMC = _sprite["effectbmp_2"];
         setInterval(this.running,100000);
      }
      
      override public function addEvent() : void
      {
         super.addEvent();
         TimeChangeManager.getInstance().addEventListener(TimeChangeManager.MINUTE_CHANGE,this.onHourChange);
      }
      
      override public function removeEvent() : void
      {
         super.removeEvent();
         TimeChangeManager.getInstance().removeEventListener(TimeChangeManager.MINUTE_CHANGE,this.onHourChange);
      }
      
      private function running() : void
      {
         this.checkToBeShow();
         this.executeShow();
         DynamicActivityEntry.instance.updateAlign();
      }
      
      protected function onHourChange(param1:Event) : void
      {
         this.checkToBeShow();
         this.executeShow();
         DynamicActivityEntry.instance.updateAlign();
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
      
      override public function executeShow() : Boolean
      {
         var _loc1_:Boolean = super.executeShow();
         if(_loc1_)
         {
            return this.checkToBeShow();
         }
         return false;
      }
      
      private function checkToBeShow() : Boolean
      {
         var _loc1_:Date = TimeUtil.getSeverDateObject();
         if(_loc1_.hours == 18 && (_loc1_.minutes >= 30 && _loc1_.minutes < 35))
         {
            return true;
         }
         return false;
      }
   }
}

