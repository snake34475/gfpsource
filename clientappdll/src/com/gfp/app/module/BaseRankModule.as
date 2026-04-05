package com.gfp.app.module
{
   import com.gfp.app.info.rank.BaseRankInfo;
   import com.gfp.core.CommandID;
   import com.gfp.core.info.RankInfo;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.popup.ModalType;
   import com.gfp.core.utils.PanelType;
   import com.gfp.module.BaseViewModule;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class BaseRankModule extends BaseViewModule
   {
      
      protected var _numInPage:int = 10;
      
      protected var _rankType:int = 0;
      
      protected var _maxNumber:int = 99;
      
      protected var _items:Array;
      
      protected var _scoreText:TextField;
      
      protected var _rankText:TextField;
      
      protected var _prevPageButton:SimpleButton;
      
      protected var _nextPageButton:SimpleButton;
      
      protected var _checkRewardButton:SimpleButton;
      
      protected var _pageText:TextField;
      
      protected var _totalPage:int = 1;
      
      protected var _curPage:int = 0;
      
      protected var _rankList:Array = [];
      
      protected var _selfScore:int;
      
      protected var _selfRankIndex:int;
      
      protected var _actorRankInfo:BaseRankInfo;
      
      protected var _notOnTheListFlag:MovieClip;
      
      public function BaseRankModule()
      {
         super();
      }
      
      override public function setup() : void
      {
         setMainUI(this.getMainUI());
         _type = PanelType.HIDE;
         _modalType = ModalType.DARK;
         this.initUI();
      }
      
      protected function getMainUI() : Sprite
      {
         return null;
      }
      
      private function initUI() : void
      {
         this._items = [];
         var _loc1_:int = 0;
         while(_loc1_ < this._numInPage)
         {
            this._items[_loc1_] = new RankItem(_mainUI["item" + _loc1_]);
            _loc1_++;
         }
         this._scoreText = _mainUI["scoreText"];
         this._rankText = _mainUI["rankText"];
         this._prevPageButton = _mainUI["preBtn"];
         this._nextPageButton = _mainUI["nextBtn"];
         this._pageText = _mainUI["pageText"];
         this._notOnTheListFlag = _mainUI["notOnTheListFlag"];
         if(this._notOnTheListFlag)
         {
            this._notOnTheListFlag.visible = false;
         }
         this._checkRewardButton = _mainUI["checkRewardButton"];
      }
      
      override public function show() : void
      {
         showFor(LayerManager.topLevel);
         this._requestRankData();
      }
      
      protected function _requestRankData() : void
      {
         SocketConnection.send(CommandID.SINGLE_ACTIVITY_RANK,this._rankType,0,this._maxNumber);
      }
      
      override protected function addEvent() : void
      {
         super.addEvent();
         this._prevPageButton.addEventListener(MouseEvent.CLICK,this.onClickPrev);
         this._nextPageButton.addEventListener(MouseEvent.CLICK,this.onClickNext);
         if(this._checkRewardButton)
         {
            this._checkRewardButton.addEventListener(MouseEvent.CLICK,this.onClickReward);
         }
         SocketConnection.addCmdListener(CommandID.SINGLE_ACTIVITY_RANK,this.onActivityRank);
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         this._prevPageButton.removeEventListener(MouseEvent.CLICK,this.onClickPrev);
         this._nextPageButton.removeEventListener(MouseEvent.CLICK,this.onClickNext);
         if(this._checkRewardButton)
         {
            this._checkRewardButton.removeEventListener(MouseEvent.CLICK,this.onClickReward);
         }
         SocketConnection.removeCmdListener(CommandID.SINGLE_ACTIVITY_RANK,this.onActivityRank);
      }
      
      private function onActivityRank(param1:SocketEvent) : void
      {
         var _loc6_:RankInfo = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         this._rankList = [];
         var _loc3_:int = _loc2_.readInt();
         this._selfScore = this.processScore(_loc2_.readInt());
         this._selfRankIndex = _loc2_.readInt();
         if(this._selfRankIndex != -1)
         {
            this._actorRankInfo = new BaseRankInfo();
            this._actorRankInfo.element = this._selfScore;
            this._actorRankInfo.index = this._selfRankIndex + 1;
         }
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = new RankInfo(_loc2_);
            _loc6_.socre = this.processScore(_loc6_.socre);
            _loc6_.rankIndex = _loc5_ + 1;
            this._rankList.push(_loc6_);
            if(_loc6_.userID == MainManager.actorID && _loc6_.roleType == MainManager.roleType && _loc6_.nick == MainManager.actorInfo.nick)
            {
               this._actorRankInfo.index = _loc6_.rankIndex;
            }
            _loc5_++;
         }
         this._curPage = 0;
         this._totalPage = Math.ceil(this._rankList.length / 10);
         this.refreshUI();
      }
      
      protected function processScore(param1:int) : int
      {
         return param1;
      }
      
      protected function onClickPrev(param1:MouseEvent) : void
      {
         --this._curPage;
         this.refreshUI();
      }
      
      protected function onClickNext(param1:MouseEvent) : void
      {
         this._curPage += 1;
         this.refreshUI();
      }
      
      protected function onClickReward(param1:MouseEvent) : void
      {
      }
      
      protected function refreshUI() : void
      {
         var _loc1_:RankItem = null;
         var _loc2_:int = 0;
         while(_loc2_ < this._numInPage)
         {
            _loc1_ = this._items[_loc2_];
            _loc1_.setInfo(this._rankList[this._curPage * this._numInPage + _loc2_]);
            _loc2_++;
         }
         this._pageText.text = this._curPage + 1 + "/" + this._totalPage;
         UIManager.setEnabled(this._prevPageButton,this._curPage > 0);
         UIManager.setEnabled(this._nextPageButton,this._curPage < this._totalPage - 1);
         if(this._selfScore < 0)
         {
            this._selfScore = 0;
         }
         if(this._scoreText)
         {
            this._scoreText.text = this._selfScore + "";
         }
         if(this._selfRankIndex != -1)
         {
            this._rankText.text = this._selfRankIndex + 1 + "";
            if(this._notOnTheListFlag)
            {
               this._notOnTheListFlag.visible = false;
            }
         }
         else
         {
            if(this._notOnTheListFlag)
            {
               this._notOnTheListFlag.visible = true;
            }
            this._rankText.text = "";
         }
      }
      
      override public function destroy() : void
      {
         var _loc1_:RankItem = null;
         super.destroy();
         for each(_loc1_ in this._items)
         {
            _loc1_.dispose();
         }
         this._items.length = 0;
         this._items = null;
         this._scoreText = null;
         this._rankText = null;
         this._prevPageButton = null;
         this._nextPageButton = null;
         this._checkRewardButton = null;
         this._pageText = null;
         this._rankList.length = 0;
         this._rankList = null;
         this._actorRankInfo = null;
         this._notOnTheListFlag = null;
      }
   }
}

