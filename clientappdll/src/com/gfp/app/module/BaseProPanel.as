package com.gfp.app.module
{
   import com.gfp.core.cache.SoundCache;
   import com.gfp.core.cache.SoundInfo;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.ActivityExchangeXMLInfo;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.info.dailyActivity.ActivityExchangeInfo;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.sound.SoundManager;
   import com.gfp.core.ui.ItemIconTip;
   import com.gfp.core.ui.ItemInfoTip;
   import com.gfp.core.utils.FilterUtil;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.DisplayUtil;
   
   public class BaseProPanel extends BaseExchangeModule
   {
      
      private var _numPerPage:int;
      
      private var _totleItemNum:int;
      
      private var _totlePageNum:int;
      
      private var _special:Array = [];
      
      private var _swap_id:Array = new Array();
      
      private var Info:Vector.<ActivityExchangeInfo> = new Vector.<ActivityExchangeInfo>();
      
      private var _PRO_ITEM_ID:Array = new Array();
      
      private var _item:int = 0;
      
      private var _score_id:int = 0;
      
      private var _cost:Array = new Array();
      
      private var notice:Array = new Array();
      
      private var _hasSetswap:Boolean = false;
      
      private var _isCostItem:Boolean = false;
      
      private var _isCostScore:Boolean = false;
      
      private var _perBtn:SimpleButton;
      
      private var _nextBtn:SimpleButton;
      
      private var _firstBtn:SimpleButton;
      
      private var _lastBtn:SimpleButton;
      
      private var _dpageTxt:TextField;
      
      private var _dpage:int = 0;
      
      private var _maskMc:MovieClip;
      
      private var _kengBtns:Vector.<SimpleButton> = new Vector.<SimpleButton>();
      
      private var _proPriceTxts:Vector.<TextField> = new Vector.<TextField>();
      
      private var _proNameTxts:Vector.<TextField> = new Vector.<TextField>();
      
      private var _zongTxt:TextField;
      
      private var _rollPanelMc:MovieClip;
      
      private var _rollMcLeft:MovieClip;
      
      private var _rollMcMid:MovieClip;
      
      private var _rollMcRight:MovieClip;
      
      private var _rollMcContainer:Sprite;
      
      protected var posX:Array = new Array();
      
      protected var posY:int = 0;
      
      private var _tips:Vector.<Sprite> = new Vector.<Sprite>();
      
      private var _func:Array = new Array();
      
      public var str:String = "";
      
      private var _iconPool:Vector.<ItemIconTip> = new Vector.<ItemIconTip>();
      
      private var _iconw:int = 50;
      
      private var _iconh:int = 50;
      
      private var _tipStr:Array = new Array();
      
      public function BaseProPanel()
      {
         super();
      }
      
      override protected function setMainUI(param1:Sprite) : void
      {
         super.setMainUI(param1);
         getUserGfCoins();
         this._perBtn = _mainUI["perBtn"];
         this._nextBtn = _mainUI["nextBtn"];
         this._firstBtn = _mainUI["firstBtn"];
         this._lastBtn = _mainUI["lastBtn"];
         this._dpageTxt = _mainUI["dpageTxt"];
         this._zongTxt = _mainUI["zongTxt"];
         this._rollPanelMc = _mainUI["rollPanelMc"];
         this._rollMcContainer = this._rollPanelMc["rollMc"];
         _fadeOut = true;
      }
      
      override public function show() : void
      {
         showFor(LayerManager.topLevel);
         if(this._dpageTxt)
         {
            this._dpageTxt.text = this._dpage + 1 + "/" + this._totlePageNum;
         }
         this.updateView();
         this.addEvent();
      }
      
      override protected function addEvent() : void
      {
         super.addEvent();
         if(this._perBtn)
         {
            this._perBtn.addEventListener(MouseEvent.CLICK,this.perRollPage);
         }
         if(this._nextBtn)
         {
            this._nextBtn.addEventListener(MouseEvent.CLICK,this.nextRollPage);
         }
         if(this._firstBtn)
         {
            this._firstBtn.addEventListener(MouseEvent.CLICK,this.firstRollPage);
         }
         if(this._lastBtn)
         {
            this._lastBtn.addEventListener(MouseEvent.CLICK,this.lastRollPage);
         }
      }
      
      override protected function removeEvent() : void
      {
         var _loc1_:SimpleButton = null;
         super.removeEvent();
         if(this._perBtn)
         {
            this._perBtn.removeEventListener(MouseEvent.CLICK,this.perRollPage);
         }
         if(this._nextBtn)
         {
            this._nextBtn.removeEventListener(MouseEvent.CLICK,this.nextRollPage);
         }
         if(this._firstBtn)
         {
            this._firstBtn.removeEventListener(MouseEvent.CLICK,this.firstRollPage);
         }
         if(this._lastBtn)
         {
            this._lastBtn.removeEventListener(MouseEvent.CLICK,this.lastRollPage);
         }
         for each(_loc1_ in this._kengBtns)
         {
            _loc1_.removeEventListener(MouseEvent.CLICK,this.kengClick);
         }
      }
      
      override protected function exchangeCompleteHandler(param1:ExchangeEvent) : void
      {
         super.exchangeCompleteHandler(param1);
         if(this._isCostScore)
         {
            ActivityExchangeTimesManager.addEventListener(this._score_id,this.onScoreBack);
            ActivityExchangeTimesManager.getActiviteTimeInfo(this._score_id);
         }
         this.updateView();
      }
      
      override public function destroy() : void
      {
         super.destroy();
         ItemInfoTip.hide();
      }
      
      protected function setNewRollMc(param1:Class, param2:Number = 0, param3:Number = 0) : void
      {
         if(!param1)
         {
            return;
         }
         if(param1 is Class)
         {
            this._rollMcRight = new param1()["rollPanelMc"]["rollMc"];
            this._rollMcLeft = new param1()["rollPanelMc"]["rollMc"];
            this._rollMcMid = new param1()["rollPanelMc"]["rollMc"];
            if(this._rollPanelMc["maskMc"])
            {
               this._rollMcLeft.x -= this._rollPanelMc["maskMc"].x + param2;
               this._rollMcLeft.x -= this._rollPanelMc["maskMc"].width;
               this._rollMcLeft.y -= this._rollPanelMc["maskMc"].y + param3;
               this._rollMcMid.x -= this._rollPanelMc["maskMc"].x + param2;
               this._rollMcMid.y -= this._rollPanelMc["maskMc"].y + param3;
               this._rollMcRight.x -= this._rollPanelMc["maskMc"].x + param2;
               this._rollMcRight.x += this._rollPanelMc["maskMc"].width;
               this._rollMcRight.y -= this._rollPanelMc["maskMc"].y + param3;
            }
            DisplayUtil.removeAllChild(this._rollMcContainer);
            this._rollMcContainer.addChild(this._rollMcLeft);
            this._rollMcContainer.addChild(this._rollMcMid);
            this._rollMcContainer.addChild(this._rollMcRight);
            if(this._rollMcLeft)
            {
               this.posX.push(this._rollMcLeft.x);
               this.posY = this._rollMcLeft.y;
            }
            if(this._rollMcMid)
            {
               this.posX.push(this._rollMcMid.x);
            }
            if(this._rollMcRight)
            {
               this.posX.push(this._rollMcRight.x);
            }
         }
      }
      
      private function perRollPage(param1:MouseEvent) : void
      {
         this.playSound("match_3_remove.mp3");
         --this._dpage;
         this.updateView();
         var _loc2_:Number = this._rollMcLeft.width;
         var _loc3_:MovieClip = this.getMidMc();
         TweenLite.to(this.getMidMc(),1,{
            "x":this.posX[2] + 15,
            "onComplete":this.RollBack,
            "onCompleteParams":[15,_loc3_]
         });
         _loc3_ = this.getLeftMc();
         TweenLite.to(this.getLeftMc(),1,{
            "x":this.posX[1] + 15,
            "onComplete":this.RollBack,
            "onCompleteParams":[15,_loc3_]
         });
         this.getRightMc().x = this.posX[0];
      }
      
      private function nextRollPage(param1:MouseEvent) : void
      {
         this.playSound("match_3_remove.mp3");
         ++this._dpage;
         this.updateView();
         var _loc2_:MovieClip = this.getMidMc();
         TweenLite.to(this.getMidMc(),1,{
            "x":this.posX[0] - 15,
            "onComplete":this.RollBack,
            "onCompleteParams":[-15,_loc2_]
         });
         _loc2_ = this.getRightMc();
         TweenLite.to(this.getRightMc(),1,{
            "x":this.posX[1] - 15,
            "onComplete":this.RollBack,
            "onCompleteParams":[-15,_loc2_]
         });
         this.getLeftMc().x = this.posX[2];
      }
      
      private function quickPageSet(param1:Boolean) : void
      {
         var _loc2_:MovieClip = this.getMidMc();
         var _loc3_:MovieClip = this.getRightMc();
         var _loc4_:MovieClip = this.getLeftMc();
         if(param1)
         {
            ++this._dpage;
            this.updateView();
            _loc2_.x = this.posX[0];
            _loc3_.x = this.posX[1];
            _loc4_.x = this.posX[2];
         }
         else
         {
            --this._dpage;
            this.updateView();
            _loc2_.x = this.posX[2];
            _loc4_.x = this.posX[1];
            _loc3_.x = this.posX[0];
         }
      }
      
      private function firstRollPage(param1:MouseEvent) : void
      {
         this.upFly(false);
      }
      
      private function lastRollPage(param1:MouseEvent) : void
      {
         this.upFly(true);
      }
      
      private function upFly(param1:Boolean) : void
      {
         this.playSound("match_3_add_time.mp3");
         this.updateView();
         TweenLite.to(this._rollMcRight,1,{
            "y":this.posY - this._rollMcRight.height * 1.2,
            "onComplete":this.RollBackUpDown,
            "onCompleteParams":[param1,this._rollMcRight]
         });
         TweenLite.to(this._rollMcMid,1,{
            "y":this.posY - this._rollMcMid.height * 1.2,
            "onComplete":this.RollBackUpDown,
            "onCompleteParams":[param1,this._rollMcMid]
         });
         TweenLite.to(this._rollMcLeft,1,{
            "y":this.posY - this._rollMcLeft.height * 1.2,
            "onComplete":this.RollBackUpDown,
            "onCompleteParams":[param1,this._rollMcLeft]
         });
      }
      
      private function RollBack(param1:Number, param2:MovieClip) : void
      {
         TweenLite.to(param2,0.3,{
            "x":param2.x - param1,
            "onComplete":this.rollBackComple
         });
      }
      
      private function RollBackUpDown(param1:Boolean, param2:MovieClip) : void
      {
         if(param1)
         {
            while(this._dpage != this._totlePageNum - 1)
            {
               this.quickPageSet(param1);
            }
         }
         else
         {
            while(this._dpage != 0)
            {
               this.quickPageSet(param1);
            }
         }
         this.playSound("match_3_line.mp3");
         TweenLite.to(param2,0.5,{
            "y":this.posY,
            "onComplete":this.rollBackComple
         });
         this.updateView();
      }
      
      private function rollBackComple() : void
      {
         this._nextBtn.addEventListener(MouseEvent.CLICK,this.nextRollPage);
         this._perBtn.addEventListener(MouseEvent.CLICK,this.perRollPage);
         this._firstBtn.addEventListener(MouseEvent.CLICK,this.firstRollPage);
         this._lastBtn.addEventListener(MouseEvent.CLICK,this.lastRollPage);
      }
      
      private function updateView() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:SimpleButton = null;
         var _loc5_:ActivityExchangeInfo = null;
         var _loc6_:ActivityExchangeInfo = null;
         if(this._perBtn)
         {
            this._perBtn.visible = true;
         }
         if(this._nextBtn)
         {
            this._nextBtn.visible = true;
         }
         if(this._lastBtn)
         {
            this._lastBtn.visible = true;
         }
         if(this._firstBtn)
         {
            this._firstBtn.visible = true;
         }
         if(Boolean(this._dpage == 0) && Boolean(this._perBtn) && Boolean(this._firstBtn))
         {
            this._perBtn.visible = false;
            this._firstBtn.visible = false;
         }
         if(Boolean(this._dpage == this._totlePageNum - 1) && Boolean(this._nextBtn) && Boolean(this._lastBtn))
         {
            this._nextBtn.visible = false;
            this._lastBtn.visible = false;
         }
         if(this._perBtn)
         {
            this._perBtn.removeEventListener(MouseEvent.CLICK,this.perRollPage);
         }
         if(this._nextBtn)
         {
            this._nextBtn.removeEventListener(MouseEvent.CLICK,this.nextRollPage);
         }
         if(this._firstBtn)
         {
            this._firstBtn.removeEventListener(MouseEvent.CLICK,this.firstRollPage);
         }
         if(this._lastBtn)
         {
            this._lastBtn.removeEventListener(MouseEvent.CLICK,this.lastRollPage);
         }
         if(this._zongTxt)
         {
            if(this._isCostItem)
            {
               this._zongTxt.text = ItemManager.getItemCount(this._item).toString();
            }
            if(this._isCostScore)
            {
               this._zongTxt.text = ActivityExchangeTimesManager.getTimes(this._score_id).toString();
            }
         }
         var _loc1_:int = this._dpage / 3;
         if(this._dpageTxt)
         {
            this._dpageTxt.text = this._dpage + 1 + "/" + this._totlePageNum;
         }
         for each(_loc4_ in this._kengBtns)
         {
            _loc2_ = this._kengBtns.indexOf(_loc4_);
            _loc3_ = int(this._swap_id[_loc2_ + _loc1_ * this._numPerPage * 3]);
            if(_loc2_ + _loc1_ * this._numPerPage * 3 >= this.swap_id.length)
            {
               _loc4_.visible = false;
               if(this._proNameTxts[_loc2_])
               {
                  this._proNameTxts[_loc2_].text = "";
               }
               this._proPriceTxts[_loc2_].text = "";
               this._tips[_loc2_].visible = false;
            }
            else
            {
               _loc5_ = ActivityExchangeXMLInfo.getActivityById(_loc3_);
               if(ActivityExchangeXMLInfo.getActivityById(_loc3_).restrFlag != 0)
               {
                  this._tipStr[_loc2_] = "该物品活动期间只能兑换" + ActivityExchangeXMLInfo.getActivityById(_loc3_).limit.toString() + "次";
               }
               if(ActivityExchangeXMLInfo.getActivityById(_loc3_).restrFlag == 0)
               {
                  this._tipStr[_loc2_] = "该物品每天只能兑换" + ActivityExchangeXMLInfo.getActivityById(_loc3_).limit.toString() + "次";
               }
               _loc4_.visible = true;
               this._tips[_loc2_].visible = true;
               _loc6_ = ActivityExchangeXMLInfo.getActivityById(this._swap_id[_loc2_ + _loc1_ * this._numPerPage * 3]);
               if(ActivityExchangeTimesManager.getTimes(_loc3_) == _loc6_.limit)
               {
                  _loc4_.filters = FilterUtil.GRAY_FILTER;
               }
               else
               {
                  _loc4_.filters = null;
               }
               if(this._proNameTxts[_loc2_])
               {
                  this._proNameTxts[_loc2_].text = this.Info[_loc2_ + _loc1_ * this._numPerPage * 3].rewardVect[0].name;
               }
               this._proPriceTxts[_loc2_].text = (this._cost[_loc2_ + _loc1_ * this._numPerPage * 3] as int).toString();
               ToolTipManager.add(_loc4_,this._tipStr[_loc2_]);
               this._tips[_loc2_].addEventListener(MouseEvent.MOUSE_OVER,this.showTip);
               this._tips[_loc2_].addEventListener(MouseEvent.MOUSE_OUT,this.hideTip);
               if(this._iconPool.length > _loc2_ + _loc1_ * this._numPerPage * 3)
               {
                  if(this._tips[_loc2_].numChildren > 0)
                  {
                     DisplayUtil.removeAllChild(this._tips[_loc2_]);
                  }
                  this._tips[_loc2_].addChild(this._iconPool[_loc2_ + _loc1_ * this._numPerPage * 3]);
               }
               this._tips[_loc2_].buttonMode = true;
            }
         }
      }
      
      private function getLeftMc() : MovieClip
      {
         if(this._rollMcLeft.x < this._rollMcMid.x && this._rollMcLeft.x < this._rollMcRight.x)
         {
            return this._rollMcLeft;
         }
         if(this._rollMcMid.x < this._rollMcLeft.x && this._rollMcMid.x < this._rollMcRight.x)
         {
            return this._rollMcMid;
         }
         if(this._rollMcRight.x < this._rollMcMid.x && this._rollMcRight.x < this._rollMcLeft.x)
         {
            return this._rollMcRight;
         }
         return null;
      }
      
      private function getRightMc() : MovieClip
      {
         if(this._rollMcLeft.x > this._rollMcMid.x && this._rollMcLeft.x > this._rollMcRight.x)
         {
            return this._rollMcLeft;
         }
         if(this._rollMcMid.x > this._rollMcLeft.x && this._rollMcMid.x > this._rollMcRight.x)
         {
            return this._rollMcMid;
         }
         if(this._rollMcRight.x > this._rollMcMid.x && this._rollMcRight.x > this._rollMcLeft.x)
         {
            return this._rollMcRight;
         }
         return null;
      }
      
      private function getMidMc() : MovieClip
      {
         if(this._rollMcRight != this.getRightMc() && this._rollMcRight != this.getLeftMc())
         {
            return this._rollMcRight;
         }
         if(this._rollMcLeft != this.getRightMc() && this._rollMcLeft != this.getLeftMc())
         {
            return this._rollMcLeft;
         }
         if(this._rollMcMid != this.getRightMc() && this._rollMcMid != this.getLeftMc())
         {
            return this._rollMcMid;
         }
         return null;
      }
      
      private function kengClick(param1:MouseEvent) : void
      {
         var _loc2_:int = this._kengBtns.indexOf(param1.currentTarget as SimpleButton);
         var _loc3_:int = this._dpage / 3;
         var _loc4_:ActivityExchangeInfo = ActivityExchangeXMLInfo.getActivityById(this._swap_id[_loc2_ + _loc3_ * this._numPerPage * 3]);
         mExchange = this._swap_id[_loc2_ + _loc3_ * this._numPerPage * 3];
         if(_loc4_.restrFlag != 2 && ActivityExchangeTimesManager.getTimes(mExchange) == _loc4_.limit)
         {
            AlertManager.showSimpleAlarm("小侠士，您在本次活动中能兑换该物品的次数已达上限，无法再兑换咯~");
            return;
         }
         if(_loc4_.restrFlag == 0 && ActivityExchangeTimesManager.getTimes(mExchange) == _loc4_.limit)
         {
            AlertManager.showSimpleAlarm("小侠士，您今天能兑换该物品的次数已达上限，请明天再来咯~");
            return;
         }
         var _loc5_:int = 0;
         while(_loc5_ < this._special.length)
         {
            if(mExchange == this._special[_loc5_])
            {
               if(this._func[_loc5_])
               {
                  this._func[_loc5_]();
                  return;
               }
               AlertManager.showSimpleAlarm("如果你看到这条提示，策划蛋疼需求，请传一个function进来处理一下");
            }
            _loc5_++;
         }
         if(this._item != 0)
         {
            buyItem(true,"{0}需要消耗{1}" + this.str + "，小侠士你确定要购买吗？");
         }
         else
         {
            buyItem(true,"{0}需要消耗{1}通宝，小侠士你确定要购买吗？");
         }
      }
      
      private function showTip(param1:MouseEvent) : void
      {
         var _loc2_:int = this._tips.indexOf(param1.currentTarget as MovieClip);
         ItemInfoTip.shwoSimpleInfo(this._PRO_ITEM_ID[_loc2_]);
      }
      
      private function hideTip(param1:MouseEvent) : void
      {
         ItemInfoTip.hide();
      }
      
      private function onScoreBack(param1:Event) : void
      {
         ActivityExchangeTimesManager.removeEventListener(this._score_id,this.onScoreBack);
         this.updateView();
      }
      
      public function get item() : int
      {
         return this._item;
      }
      
      public function set item(param1:int) : void
      {
         this._item = param1;
         this.str = ItemXMLInfo.getName(this._item);
         this._isCostItem = true;
      }
      
      public function set score_id(param1:int) : void
      {
         this._score_id = param1;
         this._isCostScore = true;
      }
      
      public function get swap_id() : Array
      {
         return this._swap_id;
      }
      
      public function set swap_id(param1:Array) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            this._swap_id[_loc2_] = param1[_loc2_];
            this.Info.push(ActivityExchangeXMLInfo.getActivityById(this._swap_id[_loc2_]));
            this._PRO_ITEM_ID.push(this.Info[_loc2_].rewardVect[0].id);
            this._cost.push(this.Info[_loc2_].costVect[0].count);
            _loc2_++;
         }
         this.totleItemNum = this.swap_id.length;
      }
      
      public function set totleItemNum(param1:int) : void
      {
         var _loc3_:ItemIconTip = null;
         this._totleItemNum = param1;
         if(param1 == 0)
         {
            this._totlePageNum = 0;
         }
         else
         {
            this._totlePageNum = (param1 - 1) / this._numPerPage + 1;
         }
         var _loc2_:int = 0;
         while(_loc2_ < 3 * this.numPerPage)
         {
            if(_loc2_ >= 0 && _loc2_ <= this.numPerPage - 1)
            {
               this._proNameTxts.push(this._rollMcMid["item" + _loc2_]["proNameTxt"]);
               this._proPriceTxts.push(this._rollMcMid["item" + _loc2_]["proPriceTxt"]);
               this._tips.push(this._rollMcMid["item" + _loc2_]["tips"]);
               this._kengBtns.push(this._rollMcMid["item" + _loc2_]["kengBtn"]);
            }
            else if(_loc2_ >= this.numPerPage && _loc2_ <= 2 * this.numPerPage - 1)
            {
               this._proNameTxts.push(this._rollMcRight["item" + (_loc2_ - this.numPerPage).toString()]["proNameTxt"]);
               this._proPriceTxts.push(this._rollMcRight["item" + (_loc2_ - this.numPerPage).toString()]["proPriceTxt"]);
               this._tips.push(this._rollMcRight["item" + (_loc2_ - this.numPerPage).toString()]["tips"]);
               this._kengBtns.push(this._rollMcRight["item" + (_loc2_ - this.numPerPage).toString()]["kengBtn"]);
            }
            else if(_loc2_ >= 2 * this.numPerPage && _loc2_ <= 3 * this.numPerPage - 1)
            {
               this._proNameTxts.push(this._rollMcLeft["item" + (_loc2_ - this.numPerPage * 2).toString()]["proNameTxt"]);
               this._proPriceTxts.push(this._rollMcLeft["item" + (_loc2_ - this.numPerPage * 2).toString()]["proPriceTxt"]);
               this._tips.push(this._rollMcLeft["item" + (_loc2_ - this.numPerPage * 2).toString()]["tips"]);
               this._kengBtns.push(this._rollMcLeft["item" + (_loc2_ - this.numPerPage * 2).toString()]["kengBtn"]);
            }
            if(this._proNameTxts[_loc2_])
            {
               this._proNameTxts[_loc2_].text = "";
               if(_loc2_ < this.totleItemNum)
               {
                  this._proNameTxts[_loc2_].text = this.Info[_loc2_].rewardVect[0].name;
               }
            }
            if(this._proPriceTxts[_loc2_])
            {
               this._proPriceTxts[_loc2_].text = "";
               if(_loc2_ < this.totleItemNum)
               {
                  this._proPriceTxts[_loc2_].text = (this._cost[_loc2_] as int).toString();
               }
            }
            if(this._kengBtns[_loc2_])
            {
               this._kengBtns[_loc2_].addEventListener(MouseEvent.CLICK,this.kengClick);
            }
            _loc2_++;
         }
         if(this._iconPool.length < this._totleItemNum)
         {
            _loc2_ = 0;
            while(_loc2_ < param1)
            {
               _loc3_ = new ItemIconTip();
               _loc3_.setID(this._PRO_ITEM_ID[_loc2_]);
               this._iconPool.push(_loc3_);
               _loc2_++;
            }
         }
      }
      
      private function playSound(param1:String) : void
      {
         var name:String = param1;
         if(SoundManager.isMusicEnable)
         {
            SoundCache.load(ClientConfig.getSoundOther(name),this.onSoundComplete,function():void
            {
               AlertManager.showSimpleAlarm("123");
            });
         }
      }
      
      private function onSoundComplete(param1:SoundInfo) : void
      {
         SoundManager.playSound(param1.url,0,false,0.6);
      }
      
      public function get totleItemNum() : int
      {
         return this._totleItemNum;
      }
      
      public function set numPerPage(param1:int) : void
      {
         this._numPerPage = param1;
      }
      
      public function get numPerPage() : int
      {
         return this._numPerPage;
      }
      
      public function set special(param1:Array) : void
      {
         this._special = param1;
      }
      
      public function set func(param1:Array) : void
      {
         this._func = param1;
      }
   }
}

