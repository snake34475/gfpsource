package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.app.toolBar.DynamicActivityEntry;
   import com.gfp.core.manager.TimeChangeManager;
   import com.gfp.core.utils.TimeUtil;
   import flash.events.Event;
   
   public class MaterialPkButton extends BaseActivitySprite
   {
      
      private var _legalDates:Array;
      
      private var _isAtTime:Boolean;
      
      public function MaterialPkButton(param1:ActivityNodeInfo)
      {
         var _loc3_:Date = null;
         var _loc4_:Date = null;
         this._legalDates = [];
         super(param1);
         var _loc2_:int = 0;
         while(_loc2_ < 7)
         {
            _loc3_ = new Date(2015,10,18 + _loc2_,11,0);
            _loc4_ = new Date(2015,10,18 + _loc2_,12,0);
            this._legalDates.push(_loc3_);
            this._legalDates.push(_loc4_);
            _loc3_ = new Date(2015,10,18 + _loc2_,12,0);
            _loc4_ = new Date(2015,10,18 + _loc2_,13,0);
            this._legalDates.push(_loc3_);
            this._legalDates.push(_loc4_);
            _loc3_ = new Date(2015,10,18 + _loc2_,13,0);
            _loc4_ = new Date(2015,10,18 + _loc2_,14,0);
            this._legalDates.push(_loc3_);
            this._legalDates.push(_loc4_);
            _loc3_ = new Date(2015,10,18 + _loc2_,18,0);
            _loc4_ = new Date(2015,10,18 + _loc2_,21,0);
            this._legalDates.push(_loc3_);
            this._legalDates.push(_loc4_);
            _loc2_++;
         }
         this._isAtTime = this.isAtTime();
         TimeChangeManager.getInstance().addEventListener(TimeChangeManager.MINUTE_CHANGE,this.timeChangeHandle);
      }
      
      private function timeChangeHandle(param1:Event) : void
      {
         var _loc2_:Boolean = this.isAtTime();
         if(_loc2_ != this._isAtTime)
         {
            this._isAtTime = _loc2_;
            DynamicActivityEntry.instance.updateAlign();
         }
      }
      
      private function isAtTime() : Boolean
      {
         var _loc1_:Date = TimeUtil.getSeverDateObject();
         var _loc2_:int = 0;
         while(_loc2_ < this._legalDates.length)
         {
            if(_loc1_ >= this._legalDates[_loc2_] && _loc1_ <= this._legalDates[++_loc2_])
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      override public function executeShow() : Boolean
      {
         return Boolean(super.executeShow()) && this._isAtTime;
      }
   }
}

