package com.gfp.app.module
{
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.popup.ModalType;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class BasePvePanel extends BaseExchangeModule
   {
      
      protected var FREE_SWAP_ID:int = 0;
      
      protected var COST_SWAP_ID:int = 0;
      
      protected var SWAP_KENG_ID:int = 0;
      
      protected var MONSTER_ID:int = 0;
      
      protected var STAGE_ID:int = 0;
      
      protected var _times:int = 0;
      
      protected var _leftTxt:TextField;
      
      protected var _kengBtn:SimpleButton;
      
      protected var _fightBtn:SimpleButton;
      
      protected var _addBtn:SimpleButton;
      
      protected var _showBtn:SimpleButton;
      
      protected var _isSpecial:Boolean;
      
      protected var _tb:int = 20;
      
      protected var str:String = "";
      
      protected var dFreeTimes:int = 3;
      
      public function BasePvePanel()
      {
         super();
      }
      
      override protected function setMainUI(param1:Sprite) : void
      {
         super.setMainUI(param1);
         _modalType = ModalType.DARK;
         this._kengBtn = _mainUI["kengBtn"];
         this._showBtn = _mainUI["showBtn"];
         this._fightBtn = _mainUI["fightBtn"];
         this._addBtn = _mainUI["addBtn"];
         this._leftTxt = _mainUI["leftTxt"];
      }
      
      override protected function addEvent() : void
      {
         super.addEvent();
         if(this._fightBtn)
         {
            this._fightBtn.addEventListener(MouseEvent.CLICK,this.onFightClick);
         }
         if(this._showBtn)
         {
            this._showBtn.addEventListener(MouseEvent.CLICK,this.onShowClick);
         }
         if(this._kengBtn)
         {
            this._kengBtn.addEventListener(MouseEvent.CLICK,this.onKengClick);
         }
         if(this._addBtn)
         {
            this._addBtn.addEventListener(MouseEvent.CLICK,this.onAddClick);
         }
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         if(this._fightBtn)
         {
            this._fightBtn.removeEventListener(MouseEvent.CLICK,this.onFightClick);
         }
         if(this._showBtn)
         {
            this._showBtn.removeEventListener(MouseEvent.CLICK,this.onShowClick);
         }
         if(this._kengBtn)
         {
            this._kengBtn.removeEventListener(MouseEvent.CLICK,this.onKengClick);
         }
         if(this._addBtn)
         {
            this._addBtn.removeEventListener(MouseEvent.CLICK,this.onAddClick);
         }
      }
      
      override protected function layout() : void
      {
         super.layout();
         _mainUI.x = LayerManager.stageWidth - _mainUI.width >> 1;
         _mainUI.y = LayerManager.stageHeight - _mainUI.height >> 1;
      }
      
      override protected function exchangeCompleteHandler(param1:ExchangeEvent) : void
      {
         super.exchangeCompleteHandler(param1);
         if(param1.info.id == this.COST_SWAP_ID)
         {
            this.requestLeftCount();
         }
      }
      
      override public function show() : void
      {
         showFor(LayerManager.topLevel);
         getUserGfCoins();
         this.requestLeftCount();
         this.updateLeftCount();
      }
      
      protected function getLeftCount() : int
      {
         var _loc1_:int = this.dFreeTimes - ActivityExchangeTimesManager.getTimes(this.FREE_SWAP_ID);
         if(_loc1_ < 0)
         {
            _loc1_ = 0;
         }
         var _loc2_:int = int(ActivityExchangeTimesManager.getTimes(this.COST_SWAP_ID));
         return _loc1_ + _loc2_;
      }
      
      protected function getFreeCount() : int
      {
         return this.dFreeTimes - ActivityExchangeTimesManager.getTimes(this.FREE_SWAP_ID);
      }
      
      protected function updateLeftCount() : void
      {
         if(this._leftTxt)
         {
            this._leftTxt.text = this.getLeftCount().toString();
         }
      }
      
      protected function onKengClick(param1:MouseEvent) : void
      {
         mExchange = this.SWAP_KENG_ID;
         buyItem(true,"{0}需要消耗{1}通宝，小侠士你确定要购买吗？");
      }
      
      protected function onShowClick(param1:MouseEvent) : void
      {
         if(!this._isSpecial)
         {
            ModuleManager.turnAppModule("SkillShowPanel","正在加载...",{
               "monster":[this.MONSTER_ID],
               "newOpen":true
            });
         }
         else
         {
            ModuleManager.turnAppModule("SummonPreviewPanel","正在加载...",{"summon":this.MONSTER_ID});
         }
      }
      
      protected function onFightClick(param1:MouseEvent) : void
      {
         if(this.getLeftCount() <= 0)
         {
            AlertManager.showSimpleAlarm("小侠士，您当前的剩余挑战次数不足。");
            return;
         }
         this.doFight();
      }
      
      protected function doFight() : void
      {
         PveEntry.enterTollgate(this.STAGE_ID);
         MapManager.setMapEndAction("open:" + this.str);
      }
      
      protected function onAddClick(param1:MouseEvent) : void
      {
         mExchange = this.COST_SWAP_ID;
         buyItem(true,"增加一次挑战机会需要" + this._tb + "通宝，小侠士你确定要购买吗？");
      }
      
      protected function onZongClick(param1:MouseEvent) : void
      {
         destroy();
         ModuleManager.turnAppModule("SevenAllInOnePanel");
      }
      
      protected function requestLeftCount() : void
      {
         if(this.FREE_SWAP_ID > 0)
         {
            ActivityExchangeTimesManager.addEventListener(this.FREE_SWAP_ID,this.onFreeBack);
            ActivityExchangeTimesManager.getActiviteTimeInfo(this.FREE_SWAP_ID);
         }
         if(this.COST_SWAP_ID > 0)
         {
            ActivityExchangeTimesManager.addEventListener(this.COST_SWAP_ID,this.onCostBack);
            ActivityExchangeTimesManager.getActiviteTimeInfo(this.COST_SWAP_ID);
         }
      }
      
      protected function onFreeBack(param1:Event) : void
      {
         ActivityExchangeTimesManager.removeEventListener(this.FREE_SWAP_ID,this.onFreeBack);
         this.updateLeftCount();
      }
      
      protected function onCostBack(param1:Event) : void
      {
         ActivityExchangeTimesManager.removeEventListener(this.COST_SWAP_ID,this.onCostBack);
         this.updateLeftCount();
      }
   }
}

