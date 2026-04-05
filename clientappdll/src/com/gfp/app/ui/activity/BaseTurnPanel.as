package com.gfp.app.ui.activity
{
   import com.gfp.app.ParseSocketError;
   import com.gfp.core.CommandID;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.events.SocketErrorCodeEvent;
   import com.gfp.core.info.ActivityExchangeAwardInfo;
   import com.gfp.core.info.dailyActivity.ActivityExchangeAward;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.ui.ItemIcon;
   import com.gfp.core.ui.TipsManager;
   import com.gfp.core.ui.tips.CommItemTips;
   import com.greensock.TweenLite;
   import com.greensock.easing.Strong;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class BaseTurnPanel extends Sprite
   {
      
      protected var activityAwardInfo:ActivityExchangeAwardInfo;
      
      protected var tipsVec:Vector.<DisplayObject>;
      
      private var startBtn:DisplayObject;
      
      protected var itemContainer:MovieClip;
      
      protected var mainUI:MovieClip;
      
      public function BaseTurnPanel()
      {
         super();
         this.tipsVec = new Vector.<DisplayObject>();
      }
      
      protected function get itemArray() : Array
      {
         throw new Error("this function itemArray must be inherit.");
      }
      
      protected function get swapId() : int
      {
         throw new Error("this function swapId must be inherit.");
      }
      
      protected function get needToUserCustomIcon() : Boolean
      {
         return true;
      }
      
      protected function get startConfrimLang() : String
      {
         return "小侠士，是否确认开始转动";
      }
      
      public function initUI(param1:MovieClip) : void
      {
         this.mainUI = param1;
         this.startBtn = param1["startBtn"];
         this.itemContainer = param1["itemContainer"];
         this.initTurn();
         this.addEvent();
         this.updateLeftCount();
      }
      
      public function destory() : void
      {
         TweenLite.killTweensOf(this.itemContainer);
         this.clearTurnView();
         this.removeEvent();
      }
      
      protected function addEvent() : void
      {
         this.startBtn.addEventListener(MouseEvent.CLICK,this.onStartBtnClick);
         ParseSocketError.addErrorCodeListener(CommandID.ACTIVITY_EXCHANGE,this.tradeErrorHandler);
      }
      
      protected function removeEvent() : void
      {
         this.startBtn.removeEventListener(MouseEvent.CLICK,this.onStartBtnClick);
         ParseSocketError.removeErrorCodeListener(CommandID.ACTIVITY_EXCHANGE,this.tradeErrorHandler);
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.exchangeCompleteHandler);
      }
      
      private function tradeErrorHandler(param1:SocketErrorCodeEvent) : void
      {
         this.enableStage = true;
      }
      
      private function set enableStage(param1:Boolean) : void
      {
         LayerManager.topLevel.stage.mouseChildren = param1;
      }
      
      private function onStartBtnClick(param1:MouseEvent) : void
      {
         this.startRotate();
      }
      
      protected function startRotate() : void
      {
         var backFunc:Function = null;
         if(this.allowToRotate())
         {
            backFunc = function():void
            {
               enableStage = false;
               ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,exchangeCompleteHandler);
               ActivityExchangeCommander.instance.closeID(swapId);
               ActivityExchangeCommander.exchange(swapId);
            };
            AlertManager.showSimpleAnswer(this.startConfrimLang,backFunc);
         }
      }
      
      protected function exchangeCompleteHandler(param1:ExchangeEvent) : void
      {
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.exchangeCompleteHandler);
         this.activityAwardInfo = param1.info;
         var _loc2_:int = 0;
         var _loc3_:int = int(this.itemArray.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(this.itemArray[_loc4_] == this.activityAwardInfo.addVec[0].id)
            {
               break;
            }
            _loc4_++;
            _loc2_++;
         }
         this.startTurn(_loc2_);
      }
      
      protected function startTurn(param1:int) : void
      {
         this.turnTo(param1,this.itemContainer);
      }
      
      protected function turnTo(param1:int, param2:Sprite) : void
      {
         this.updateLeftCount();
         param2.rotation = 0;
         var _loc3_:Number = 360 - 360 / this.itemArray.length * param1;
         TweenLite.to(param2,6,{
            "rotation":2160 + _loc3_,
            "ease":Strong.easeInOut,
            "onComplete":this.turnCompleteHandler
         });
      }
      
      protected function turnCompleteHandler() : void
      {
         this.enableStage = true;
         if(this.activityAwardInfo)
         {
            ActivityExchangeAward.addAward(this.activityAwardInfo);
         }
         this.updateLeftCount();
      }
      
      protected function allowToRotate() : Boolean
      {
         if(ItemManager.getItemAvailableCapacity() < 1)
         {
            AlertManager.showSimpleAlarm(AppLanguageDefine.BACKPACK_LESSTHAN);
            return false;
         }
         return true;
      }
      
      protected function get itemSprite() : Sprite
      {
         return this.itemContainer;
      }
      
      protected function initTurn() : void
      {
         var _loc2_:int = 0;
         var _loc3_:DisplayObjectContainer = null;
         var _loc4_:ItemIcon = null;
         var _loc1_:int = int(this.itemArray.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.itemSprite["item" + _loc2_ + "_mc"] as DisplayObjectContainer;
            if(!this.needToUserCustomIcon)
            {
               _loc4_ = new ItemIcon();
               _loc4_.x = 4;
               _loc4_.y = 4;
               _loc4_.setID(this.itemArray[_loc2_]);
               _loc3_.addChild(_loc4_);
            }
            this.tipsVec.push(_loc3_);
            if(this.itemArray[_loc2_] is int)
            {
               TipsManager.addTip(_loc3_,new CommItemTips(this.itemArray[_loc2_]));
            }
            _loc2_++;
         }
      }
      
      protected function clearTurnView() : void
      {
         var _loc3_:DisplayObject = null;
         var _loc1_:int = int(this.tipsVec.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.tipsVec[_loc2_];
            TipsManager.removeTip(_loc3_ as InteractiveObject);
            _loc2_++;
         }
      }
      
      protected function updateLeftCount() : void
      {
      }
   }
}

