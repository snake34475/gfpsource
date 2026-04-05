package com.gfp.app.module
{
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.ui.ItemIconTip;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import org.taomee.utils.DisplayUtil;
   
   public class CgeGetBreakStoneBasePanel extends BaseExchangeModule
   {
      
      private var _numTxt:TextField;
      
      private var _commonBtn:SimpleButton;
      
      private var _icons:Vector.<MovieClip>;
      
      protected var AWARD:Array = [1500917,1,2];
      
      protected var TIMES_EXE:int = 5528;
      
      protected var PVE0_STAGE:int = 1048;
      
      protected var MAX_TIME:uint = 5;
      
      public function CgeGetBreakStoneBasePanel()
      {
         this.setparams();
         super();
      }
      
      protected function setparams() : void
      {
         this.AWARD = [1500917,1,2];
         this.TIMES_EXE = 5528;
         this.PVE0_STAGE = 1048;
         this.MAX_TIME = 5;
      }
      
      override public function setup() : void
      {
      }
      
      override public function show() : void
      {
         var _loc2_:ItemIconTip = null;
         this._numTxt = _mainUI["numTxt"];
         this._commonBtn = _mainUI["commonBtn"];
         this._icons = new Vector.<MovieClip>();
         var _loc1_:int = 0;
         while(_loc1_ < this.AWARD.length)
         {
            this._icons.push(_mainUI["icon_" + _loc1_.toString()] as MovieClip);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.AWARD.length)
         {
            DisplayUtil.removeAllChild(this._icons[_loc1_]);
            _loc2_ = new ItemIconTip(false,100,100,"",true);
            _loc2_.setID(this.AWARD[_loc1_]);
            this._icons[_loc1_].addChild(_loc2_);
            _loc1_++;
         }
         this.getExeTime();
         this.updateView();
         super.show();
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         this._commonBtn.removeEventListener(MouseEvent.CLICK,this.onCommonBtnClick);
         ActivityExchangeTimesManager.removeEventListener(this.TIMES_EXE,this.updateView);
      }
      
      override protected function addEvent() : void
      {
         super.addEvent();
         this._commonBtn.addEventListener(MouseEvent.CLICK,this.onCommonBtnClick);
         ActivityExchangeTimesManager.addEventListener(this.TIMES_EXE,this.updateView);
      }
      
      private function updateView(... rest) : void
      {
         this._numTxt.text = (this.MAX_TIME - ActivityExchangeTimesManager.getTimes(this.TIMES_EXE)).toString();
      }
      
      protected function onCommonBtnClick(param1:MouseEvent) : void
      {
         if(this.MAX_TIME - ActivityExchangeTimesManager.getTimes(this.TIMES_EXE) <= 0)
         {
            AlertManager.showSimpleAlarm("小侠士，你今天的次数不足，请明天再来！");
            return;
         }
         PveEntry.enterTollgate(this.PVE0_STAGE);
      }
      
      private function getExeTime() : void
      {
         ActivityExchangeTimesManager.getActiviteTimeInfo(this.TIMES_EXE);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this._numTxt = null;
         this._commonBtn = null;
         this._icons.length = 0;
         this._icons = null;
      }
   }
}

