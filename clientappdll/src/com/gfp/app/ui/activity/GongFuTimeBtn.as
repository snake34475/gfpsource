package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.app.manager.GongFuTimeManager;
   import com.gfp.core.manager.TimeChangeManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class GongFuTimeBtn extends BaseActivitySprite
   {
      
      private var _mc:MovieClip;
      
      public function GongFuTimeBtn(param1:ActivityNodeInfo)
      {
         var _loc2_:Sprite = null;
         super(param1);
         this._mc = _sprite["roleMc"] as MovieClip;
         this._mc.stop();
         _loc2_ = getEffect(1);
         _loc2_.mouseChildren = false;
         _loc2_.mouseEnabled = false;
         TimeChangeManager.getInstance().addEventListener(TimeChangeManager.HOUR_CHANGE,this.onHourChange);
      }
      
      protected function onHourChange(param1:Event) : void
      {
         this.checkToBeShow();
      }
      
      override public function destroy() : void
      {
         TimeChangeManager.getInstance().removeEventListener(TimeChangeManager.HOUR_CHANGE,this.onHourChange);
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
         var _loc1_:Array = GongFuTimeManager.getFlashIds();
         if(_loc1_.length > 0)
         {
            this._mc.gotoAndStop(_loc1_[0] + 1);
            return true;
         }
         return false;
      }
   }
}

