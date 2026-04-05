package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.app.toolBar.DynamicActivityEntry;
   import com.gfp.core.utils.TimeUtil;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class HeroFightMidButton extends BaseActivitySprite
   {
      
      private var _needShow:Boolean = false;
      
      private var _needSec:int = 0;
      
      private var _displayTimer:int;
      
      private var _hideTimer:int;
      
      public function HeroFightMidButton(param1:ActivityNodeInfo)
      {
         super(param1);
         var _loc2_:Date = TimeUtil.getSeverDateObject();
         var _loc3_:Date = new Date(_loc2_.fullYear,_loc2_.month,_loc2_.date,13,20,0);
         var _loc4_:Date = new Date(_loc2_.fullYear,_loc2_.month,_loc2_.date,14,30,0);
         if(_loc2_.time > _loc3_.time && _loc2_.time < _loc4_.time && _loc2_.date >= 12 && _loc2_.date <= 14)
         {
            this._needShow = true;
            this.handleHide(_loc4_.time - _loc2_.time);
         }
         this._needSec = _loc3_.time - _loc2_.time;
         if(this._needSec > 0 && _loc2_.date >= 12 && _loc2_.date <= 14)
         {
            this._displayTimer = setTimeout(this.onTimer,this._needSec);
         }
      }
      
      private function handleHide(param1:int) : void
      {
         var time:int = param1;
         this._hideTimer = setTimeout(function():void
         {
            clearTimeout(_hideTimer);
            _needShow = false;
            executeShow();
            DynamicActivityEntry.instance.updateAlign();
         },time);
      }
      
      override public function executeShow() : Boolean
      {
         var _loc1_:Boolean = super.executeShow();
         if(this._needShow)
         {
            return true;
         }
         return false;
      }
      
      public function onTimer() : void
      {
         clearTimeout(this._displayTimer);
         this._needShow = true;
         this.executeShow();
         DynamicActivityEntry.instance.updateAlign();
         this.handleHide(70 * 60 * 1000);
      }
   }
}

