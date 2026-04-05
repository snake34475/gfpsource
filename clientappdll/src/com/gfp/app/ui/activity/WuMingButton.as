package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.app.toolBar.DynamicActivityEntry;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.utils.TimeUtil;
   import flash.display.MovieClip;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class WuMingButton extends BaseActivitySprite
   {
      
      private var _needShow:Boolean = false;
      
      private var _needSec:int = 0;
      
      private var _displayTimer:int;
      
      private var _hideTimer:int;
      
      private var _flagMc:MovieClip;
      
      public function WuMingButton(param1:ActivityNodeInfo)
      {
         super(param1);
         this._flagMc = _sprite["flagMc"];
         this._flagMc.stop();
         var _loc2_:Date = TimeUtil.getSeverDateObject();
         var _loc3_:Date = new Date(2017,4,5,19,0);
         var _loc4_:Date = new Date(2017,4,5,20,0);
         var _loc5_:Date = new Date(2017,4,6,13,20);
         var _loc6_:Date = new Date(2017,4,6,14,30);
         var _loc7_:Date = new Date(2017,4,7,9,20);
         var _loc8_:Date = new Date(2017,4,7,14,30);
         if(_loc2_.time > _loc3_.time && _loc2_.time < _loc4_.time && MainManager.actorInfo.lv >= 60)
         {
            this._needShow = true;
            this.handleHide(_loc4_.time - _loc2_.time);
         }
         else if(_loc2_.time > _loc5_.time && _loc2_.time < _loc6_.time && MainManager.actorInfo.lv >= 60)
         {
            this._needShow = true;
            this.handleHide(_loc6_.time - _loc2_.time);
         }
         else if(_loc2_.time > _loc7_.time && _loc2_.time < _loc8_.time && MainManager.actorInfo.lv >= 60)
         {
            this._needShow = true;
            this.handleHide(_loc8_.time - _loc2_.time);
         }
         if(_loc2_.time < _loc3_.time)
         {
            this._needSec = _loc3_.time - _loc2_.time;
         }
         else if(_loc2_.time > _loc3_.time && _loc2_.time < _loc5_.time)
         {
            this._needSec = _loc5_.time - _loc2_.time;
         }
         else if(_loc2_.time > _loc5_.time && _loc2_.time < _loc7_.time)
         {
            this._needSec = _loc7_.time - _loc2_.time;
         }
         if(this._needSec > 0)
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
            this._flagMc.play();
            return true;
         }
         this._flagMc.stop();
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

