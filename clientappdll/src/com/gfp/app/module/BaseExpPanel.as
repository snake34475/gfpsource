package com.gfp.app.module
{
   import com.gfp.core.events.DataEvent;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.info.SummonInfo;
   import com.gfp.core.info.dailyActivity.SwapTimesInfo;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.model.CustomUserModel;
   import com.gfp.core.popup.ModalType;
   import com.gfp.core.utils.FilterUtil;
   import com.gfp.module.BaseViewModule;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   
   public class BaseExpPanel extends BaseViewModule
   {
      
      protected var _expSwapId:int = 0;
      
      protected var _expV:Number;
      
      protected var _growSwapId:int = 0;
      
      protected var _growV:int;
      
      protected var _model:CustomUserModel;
      
      protected var _selectSummonInfo:SummonInfo;
      
      protected var _sumList:Array;
      
      protected var _sumObj:Object;
      
      protected var _expPanel:*;
      
      protected var _bornPanel:*;
      
      protected var _qingLongSumInfo:Array = new Array();
      
      protected var _summonType:int = 0;
      
      protected var _monsterMc:MovieClip;
      
      protected var _repCntId:int = 1;
      
      protected var lvLimit:int = 0;
      
      protected var bornLimit:int = 0;
      
      protected var distributionExpSwapId:int = 0;
      
      protected var distributionBornSwapId:int = 0;
      
      private var offX:Number;
      
      private var offY:Number;
      
      private var isMonsterMcShow:Boolean = true;
      
      public function BaseExpPanel()
      {
         super();
      }
      
      override public function setup() : void
      {
         super.setup();
      }
      
      override protected function setMainUI(param1:Sprite) : void
      {
         var _loc5_:SummonInfo = null;
         super.setMainUI(param1);
         _modalType = ModalType.DARK;
         _fadeOut = true;
         (_mainUI["expPanel"]["setExpTxt"] as TextField).restrict = "0-9";
         (_mainUI["growPanel"]["setGrowTxt"] as TextField).restrict = "0-9";
         (_mainUI["expPanel"]["curLvTxt"] as TextField).mouseEnabled = false;
         (_mainUI["growPanel"]["curGrowTxt"] as TextField).mouseEnabled = false;
         var _loc2_:Class = getDefinitionByName("com.gfp.module.app.summon.SummonNewExpPanel") as Class;
         this._expPanel = new _loc2_(_mainUI["expPanel"]);
         this._expPanel.expSwapId = this._expSwapId;
         this._expPanel.distributionExpSwapId = this.distributionExpSwapId;
         this._expPanel.lvLimit = this.lvLimit;
         _loc2_ = UIManager.getClass("com.gfp.module.app.summon.SummonNewBornPanel");
         this._bornPanel = new _loc2_(_mainUI["growPanel"]);
         this._bornPanel.growSwapId = this._growSwapId;
         this._bornPanel.bornLimit = this.bornLimit;
         this._bornPanel.distributionSwapId = this.distributionBornSwapId;
         if(!this._sumList)
         {
            this._sumList = SummonManager.getActorSummonInfo().summonList.concat();
         }
         if(!this._sumObj)
         {
            this._sumObj = new Object();
            this._sumObj.callback = this.selSumOver;
         }
         var _loc3_:int = int(this._qingLongSumInfo.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            this._qingLongSumInfo.pop();
            _loc4_++;
         }
         for each(_loc5_ in this._sumList)
         {
            if(_loc5_.summonType == this._summonType)
            {
               this._qingLongSumInfo.push(_loc5_);
            }
         }
         if(this._qingLongSumInfo.length == 1)
         {
            this.selSumOver(this._qingLongSumInfo[0]);
            return;
         }
      }
      
      protected function showData() : void
      {
         this.getExpGrowV();
      }
      
      protected function getExpGrowV() : void
      {
         ActivityExchangeTimesManager.getActiviteTimeInfo(this._expSwapId);
         ActivityExchangeTimesManager.getActiviteTimeInfo(this._growSwapId);
      }
      
      protected function getTimes(param1:DataEvent) : void
      {
         var _loc2_:int = int((param1.data as SwapTimesInfo).dailyID);
         if(_loc2_ == this._expSwapId)
         {
            this.expV = (param1.data as SwapTimesInfo).times;
         }
         if(_loc2_ == this._growSwapId)
         {
            this._growV = (param1.data as SwapTimesInfo).times;
            this._bornPanel.onTotalGrowChange(this._growV);
         }
         this.updateView();
      }
      
      override protected function addEvent() : void
      {
         ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.exchangeCompleteHandler);
         ActivityExchangeTimesManager.addEventListener(this._expSwapId,this.getTimes);
         ActivityExchangeTimesManager.addEventListener(this._growSwapId,this.getTimes);
         _mainUI.addEventListener(MouseEvent.CLICK,this.onMainUiClick);
         super.addEvent();
      }
      
      protected function onMainUiClick(param1:MouseEvent) : void
      {
         var _loc2_:String = param1.target.name;
         var _loc3_:int = int(_loc2_.substr(_loc2_.length - 1,1));
         if(_loc2_.indexOf("chooseSumBtn") != -1)
         {
            this.chooseSummon();
            return;
         }
         if(_loc2_.indexOf("leftButton") != -1)
         {
            ModuleManager.turnAppModule("DarkPhoenixPanel");
            return;
         }
         if(_loc2_.indexOf("rightButton") != -1)
         {
            ModuleManager.turnAppModule("DarkPhoenixPanel");
            return;
         }
      }
      
      protected function chooseSummon() : void
      {
         var _loc3_:SummonInfo = null;
         if(!this._sumList)
         {
            this._sumList = SummonManager.getActorSummonInfo().summonList.concat();
         }
         if(!this._sumObj)
         {
            this._sumObj = new Object();
            this._sumObj.callback = this.selSumOver;
         }
         var _loc1_:int = int(this._qingLongSumInfo.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            this._qingLongSumInfo.pop();
            _loc2_++;
         }
         for each(_loc3_ in this._sumList)
         {
            if(_loc3_.summonType == this._summonType)
            {
               this._qingLongSumInfo.push(_loc3_);
            }
         }
         if(this._qingLongSumInfo.length == 0)
         {
            AlertManager.showSimpleAlarm("小侠士，没有可以分配的仙兽！");
            return;
         }
         this._sumObj.summonInfos = this._qingLongSumInfo;
         ModuleManager.turnAppModule("SelectSummonPanel","",this._sumObj);
      }
      
      override protected function removeEvent() : void
      {
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.exchangeCompleteHandler);
         ActivityExchangeTimesManager.removeEventListener(this._expSwapId,this.getTimes);
         ActivityExchangeTimesManager.removeEventListener(this._growSwapId,this.getTimes);
         _mainUI.removeEventListener(MouseEvent.CLICK,this.onMainUiClick);
         super.removeEvent();
      }
      
      protected function updateView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _mainUI["totalExpTxt"].text = this._expV.toString();
         _mainUI["totalExpTxt"].mouseEnabled = false;
      }
      
      protected function selSumOver(param1:SummonInfo = null) : void
      {
         if(this._model != null)
         {
            this._model.destroy();
         }
         if(param1)
         {
            if(this.isMonsterMcShow)
            {
               if(this._monsterMc)
               {
                  this._monsterMc.visible = false;
               }
               this._selectSummonInfo = param1;
               this._selectSummonInfo = param1;
               this._model = new CustomUserModel(this._selectSummonInfo.roleID);
               this._model.show(new Point(this.offX,this.offY),_mainUI,false);
               _mainUI.addChild(_mainUI["chooseSumBtn"]);
               _mainUI["expPanel"]["curLvTxt"].text = param1.lv.toString();
               _mainUI["growPanel"]["curGrowTxt"].text = SummonManager.getSummonBornGrow(param1).toString();
               this._expPanel.setInfo(param1);
               this._bornPanel.setInfo(param1);
            }
         }
         else
         {
            if(this._monsterMc)
            {
               this._monsterMc.visible = true;
               this._monsterMc.filters = FilterUtil.GRAY_FILTER;
            }
            (_mainUI["expPanel"]["setExpTxt"] as TextField).text = "0";
            (_mainUI["growPanel"]["setGrowTxt"] as TextField).text = "0";
         }
      }
      
      override public function destroy() : void
      {
         this._sumList = null;
         this._sumObj = null;
         this._bornPanel.destroy();
         this._expPanel.destroy();
         super.destroy();
      }
      
      override public function show() : void
      {
         showFor(LayerManager.topLevel);
         this.getExpGrowV();
      }
      
      override protected function layout() : void
      {
         _mainUI.x = LayerManager.stageWidth - 1200 >> 1;
         _mainUI.y = LayerManager.stageHeight - 660 >> 1;
      }
      
      public function set expV(param1:Number) : void
      {
         this._expV = param1;
         this._expPanel.onTotalExpChange(this._expV);
      }
      
      protected function exchangeCompleteHandler(param1:ExchangeEvent) : void
      {
         ActivityExchangeTimesManager.getActiviteTimeInfo(this._growSwapId);
         ActivityExchangeTimesManager.getActiviteTimeInfo(this._expSwapId);
         this.updateView();
      }
   }
}

