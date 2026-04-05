package com.gfp.app.ui.activity
{
   import com.gfp.app.feature.LeftTimeTxtFeater;
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.app.toolBar.DynamicActivityEntry;
   import com.gfp.core.CommandID;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.TimeUtil;
   import flash.display.MovieClip;
   import flash.utils.ByteArray;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.net.SocketEvent;
   
   public class BaWangButton extends BaseActivitySprite
   {
      
      private var _needShow:Boolean = false;
      
      private var _needSec:int = 0;
      
      private var _displayTimer:int;
      
      private var _hideTimer:int;
      
      private var _displayCntTimer:int;
      
      private var _left:LeftTimeTxtFeater;
      
      private var _flagMc:MovieClip;
      
      private var _rankType:Vector.<int> = new <int>[142,143,144,145,146,147,148,192];
      
      private var _startDate1:Date = new Date(2015,9,5,13,25);
      
      private var _endDate1:Date = new Date(2015,9,5,13,30);
      
      private var _startDate2:Date = new Date(2015,9,5,13,40);
      
      private var _endDate2:Date = new Date(2015,9,5,13,45);
      
      private var _startDate3:Date = new Date(2015,9,5,13,55);
      
      private var _endDate3:Date = new Date(2015,9,5,14,0);
      
      public function BaWangButton(param1:ActivityNodeInfo)
      {
         super(param1);
         this._flagMc = _sprite["flagMc"];
         this._flagMc.stop();
         this.setTimer();
         this.requestRankData();
      }
      
      private function requestRankData() : void
      {
         SocketConnection.addCmdListener(CommandID.SINGLE_ACTIVITY_RANK,this.onRollBack);
         SocketConnection.send(CommandID.SINGLE_ACTIVITY_RANK,this._rankType[MainManager.actorInfo.roleType - 1],0,1);
      }
      
      private function onRollBack(param1:SocketEvent) : void
      {
         var _loc8_:Date = null;
         var _loc9_:Date = null;
         var _loc10_:Date = null;
         var _loc2_:int = 0;
         var _loc3_:ByteArray = param1.data as ByteArray;
         _loc3_.position = 0;
         var _loc4_:int = _loc3_.readInt();
         if(this._rankType.indexOf(_loc4_) == -1)
         {
            return;
         }
         var _loc5_:int = this._rankType.indexOf(_loc4_);
         var _loc6_:int = _loc3_.readInt();
         var _loc7_:int = _loc3_.readInt();
         if(_loc7_ == 0)
         {
            _loc8_ = TimeUtil.getSeverDateObject();
            _loc9_ = new Date(2015,9,5,13,25);
            _loc10_ = new Date(2015,9,5,14,15);
            if(_loc8_.time > _loc9_.time && _loc8_.time < _loc10_.time && MainManager.actorInfo.lv >= 60)
            {
               this._needShow = true;
               this.handleHide(_loc10_.time - _loc8_.time);
            }
            if(_loc8_.time < _loc9_.time)
            {
               this._needSec = _loc9_.time - _loc8_.time;
            }
            if(this._needSec > 0)
            {
               this._displayTimer = setTimeout(this.onTimer,this._needSec);
            }
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
      
      private function setTimer() : void
      {
         var _loc1_:int = 0;
         if(this._left != null)
         {
            this._left.destroy();
         }
         if(TimeUtil.getSeverDateObject().time - this._startDate1.time >= 0 && TimeUtil.getSeverDateObject().time - this._endDate1.time <= 0)
         {
            if(this._left == null)
            {
               this._left = new LeftTimeTxtFeater(this._endDate1.time - TimeUtil.getSeverDateObject().time,_sprite["timerTxt"],this.setTimer);
               this._left.start();
            }
         }
         if(TimeUtil.getSeverDateObject().time - this._startDate2.time >= 0 && TimeUtil.getSeverDateObject().time - this._endDate2.time <= 0)
         {
            if(this._left == null)
            {
               this._left = new LeftTimeTxtFeater(this._endDate2.time - TimeUtil.getSeverDateObject().time,_sprite["timerTxt"],this.setTimer);
               this._left.start();
            }
         }
         if(TimeUtil.getSeverDateObject().time - this._startDate3.time >= 0 && TimeUtil.getSeverDateObject().time - this._endDate3.time <= 0)
         {
            if(this._left == null)
            {
               this._left = new LeftTimeTxtFeater(this._endDate3.time - TimeUtil.getSeverDateObject().time,_sprite["timerTxt"],this.setTimer);
               this._left.start();
            }
         }
         if(TimeUtil.getSeverDateObject().time < this._startDate1.time)
         {
            _loc1_ = this._startDate1.time - TimeUtil.getSeverDateObject().time;
         }
         else if(TimeUtil.getSeverDateObject().time > this._startDate1.time && TimeUtil.getSeverDateObject().time < this._startDate2.time)
         {
            _loc1_ = this._startDate2.time - TimeUtil.getSeverDateObject().time;
         }
         else if(TimeUtil.getSeverDateObject().time > this._startDate2.time && TimeUtil.getSeverDateObject().time < this._startDate3.time)
         {
            _loc1_ = this._startDate3.time - TimeUtil.getSeverDateObject().time;
         }
         if(_loc1_ > 0)
         {
            clearTimeout(this._displayCntTimer);
            this._displayCntTimer = setTimeout(this.setTimer,_loc1_);
         }
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
         this.handleHide(45 * 60 * 1000);
      }
   }
}

