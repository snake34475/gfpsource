package com.gfp.app.manager
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.cartoon.event.AnimatEvent;
   import com.gfp.app.fight.CustomEvent;
   import com.gfp.app.info.rank.SanGuoRankInfo;
   import com.gfp.core.CommandID;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.info.ActivityExchangeAwardInfo;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.LineType;
   import com.gfp.core.utils.OtherInfoHelper;
   import com.gfp.core.utils.RankType;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.net.SocketEvent;
   
   public class SanGuoSystemManager extends EventDispatcher
   {
      
      private static var _instance:SanGuoSystemManager;
      
      public static const MONEY_ITEM_ID:int = 2740419;
      
      public static const LOAD_COMPLETE:String = "sanGuoLoadComplete";
      
      public static const COUNTRY_CHANGE:String = "sanGuoCountryChanged";
      
      public static const GONG_XUN_SWAP_ID:int = 6230;
      
      public static const GONG_XUN_YES_SWAP_ID:int = 6231;
      
      public static const RANK_TYPES:Array = [RankType.SAN_GUO_WEI_YESTERDAY,RankType.SAN_GUO_SHU_YESTERDAY,RankType.SAN_GUO_WU_YESTERDAY,RankType.SAN_GUO_WEI_TODAY,RankType.SAN_GUO_SHU_TODAY,RankType.SAN_GUO_WU_TODAY];
      
      public static const COUNTRY_NAMES:Array = ["魏","蜀","吴"];
      
      public static const GUAN_WEI_NAMES:Array = ["武卫校尉","太史令","曷者仆射","太学博士","侍中","执金吾","中书令","大鸿胪","尚书令","卫尉","光禄勋","骠骑将军","大都督","丞相","皇帝"];
      
      public static const GUAN_WEN_SCORES:Array = [0,200,500,900,1400,2000,2700,3500,4400,5400];
      
      public static const GET_FENG_LU_SWAPS:Array = [6232,6233,6234,6235,6236,6237,6238,6239,6240,6241,6242,6243,6244,6245,6246];
      
      public static const GUO_SWAP_IDS:Array = [6247,6248,6249];
      
      public static var SAN_FIRST_MANS:Array = [null,null,null];
      
      private var _loadData:int;
      
      private var _countryId:int = -1;
      
      public var yesScore:int = 0;
      
      public var yesRankIndex:int = -1;
      
      private var _source:Array;
      
      public var allFightSource:Array;
      
      private var _gongXunCallBack:Function;
      
      private var _countryScoreCallBack:Function;
      
      public var isInit:Boolean = false;
      
      private var _hasSendFirstManAlert:Boolean;
      
      public function SanGuoSystemManager()
      {
         super();
      }
      
      public static function getInstance() : SanGuoSystemManager
      {
         if(_instance == null)
         {
            _instance = new SanGuoSystemManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         var otherInfoRequest:OtherInfoHelper;
         this._source = new Array();
         if(MainManager.actorInfo.lv >= 10)
         {
            this.isInit = true;
         }
         otherInfoRequest = new OtherInfoHelper();
         otherInfoRequest.getValue(118,function(param1:int):void
         {
            countryId = param1 - 1;
            checkFirstLogin();
            requestCountryData();
         });
         this.addEvent();
      }
      
      public function hasGetGuoAward() : Boolean
      {
         var _loc1_:int = 0;
         for each(_loc1_ in GUO_SWAP_IDS)
         {
            if(ActivityExchangeTimesManager.getTimes(_loc1_) != 0)
            {
               return true;
            }
         }
         return false;
      }
      
      private function checkFirstLogin() : void
      {
         if(ActivityExchangeTimesManager.getTimes(6228) == 0 && this.isInit && this.countryId == -1)
         {
            ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchangeComplete);
            ActivityExchangeCommander.exchange(6228);
         }
      }
      
      public function startJoinCountry() : void
      {
         if(!this.isInit)
         {
            this.isInit = true;
            this.checkFirstLogin();
         }
      }
      
      private function onExchangeComplete(param1:ExchangeEvent) : void
      {
         var _loc2_:ActivityExchangeAwardInfo = param1.info;
         if(_loc2_.id == 6228)
         {
            ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchangeComplete);
         }
      }
      
      private function addEvent() : void
      {
         SocketConnection.addCmdListener(CommandID.SAN_GUO_NOTIFY,this.onJoinDataBack);
      }
      
      private function onJoinDataBack(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:Boolean = _loc2_.readInt() == 0;
         this.countryId = _loc2_.readInt() - 1;
      }
      
      private function turnLoginModule() : void
      {
         AnimatPlay.addAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimateEnd);
         AnimatPlay.startAnimat("san_guo_start",-1,true,0,0,false,true,true,2);
      }
      
      private function onAnimateEnd(param1:Event) : void
      {
         AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimateEnd);
         ModuleManager.turnAppModule("SanGuoLoginPanel","正在加载...","first");
      }
      
      private function requestCountryData() : void
      {
         var timer1:int = 0;
         var timer2:int = 0;
         var timer3:int = 0;
         var timer4:int = 0;
         SocketConnection.addCmdListener(CommandID.SINGLE_ACTIVITY_RANK,this.onActivityRank);
         SocketConnection.send(CommandID.SINGLE_ACTIVITY_RANK,RankType.SAN_GUO_WEI_YESTERDAY,0,99);
         timer1 = int(setTimeout(function():void
         {
            clearTimeout(timer1);
            SocketConnection.send(CommandID.SINGLE_ACTIVITY_RANK,RankType.SAN_GUO_SHU_YESTERDAY,0,99);
         },1000));
         timer2 = int(setTimeout(function():void
         {
            clearTimeout(timer2);
            SocketConnection.send(CommandID.SINGLE_ACTIVITY_RANK,RankType.SAN_GUO_WU_YESTERDAY,0,99);
         },1500));
         timer3 = int(setTimeout(function():void
         {
            clearTimeout(timer3);
            SocketConnection.send(CommandID.RANK_SUMRACE_SUM,RankType.SAN_GUO_TOTAL_SCORE_YESTERDAY,0,2,0,0,0,0);
         },2000));
         timer4 = int(setTimeout(function():void
         {
            clearTimeout(timer4);
            SocketConnection.send(CommandID.SINGLE_ACTIVITY_RANK,RankType.SAN_GUO_TOTAL_YESTERDAY,0,99);
         },2500));
      }
      
      private function loadRankData(param1:ByteArray) : Array
      {
         var _loc8_:SanGuoRankInfo = null;
         var _loc2_:Array = [];
         param1.position = 0;
         var _loc3_:int = int(param1.readUnsignedInt());
         var _loc4_:int = param1.readInt();
         _loc4_ = _loc4_ < 0 ? 0 : _loc4_;
         var _loc5_:int = param1.readInt();
         if(this.countryId != -1)
         {
            if(_loc5_ > this.yesRankIndex)
            {
               this.yesScore = _loc4_;
               this.yesRankIndex = _loc5_;
            }
         }
         var _loc6_:uint = param1.readUnsignedInt();
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc8_ = new SanGuoRankInfo(param1);
            _loc8_.rankIndex = _loc7_ + 1;
            _loc8_.countryId = this.getCountryByRankType(_loc3_);
            _loc2_.push(_loc8_);
            _loc7_++;
         }
         return _loc2_;
      }
      
      private function getCountryByRankType(param1:int) : int
      {
         return RANK_TYPES.indexOf(param1) % 3;
      }
      
      private function onActivityRank(param1:SocketEvent) : void
      {
         var _loc4_:Array = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:int = _loc2_.readInt();
         if(_loc3_ == RankType.SAN_GUO_WEI_YESTERDAY || _loc3_ == RankType.SAN_GUO_SHU_YESTERDAY || _loc3_ == RankType.SAN_GUO_WU_YESTERDAY)
         {
            switch(_loc3_)
            {
               case RankType.SAN_GUO_WEI_YESTERDAY:
                  this._loadData |= 1;
                  break;
               case RankType.SAN_GUO_SHU_YESTERDAY:
                  this._loadData |= 2;
                  break;
               case RankType.SAN_GUO_WU_YESTERDAY:
                  this._loadData |= 4;
            }
            _loc4_ = this.loadRankData(_loc2_);
            this._source[this.getCountryByRankType(_loc3_)] = _loc4_;
            if(this._loadData == 7)
            {
               this.caculateYesTotal();
               this.checkFirstManAlert();
               SocketConnection.removeCmdListener(CommandID.SINGLE_ACTIVITY_RANK,this.onActivityRank);
               MainManager.actorInfo.countryId = this.countryId;
               dispatchEvent(new CustomEvent(LOAD_COMPLETE));
            }
         }
      }
      
      private function checkFirstManAlert() : void
      {
         var _loc1_:SanGuoRankInfo = null;
         if(this.countryId != -1)
         {
            _loc1_ = this.getRankInfoByRankIndex(0,this.countryId);
            if(_loc1_)
            {
               if(MainManager.actorID == _loc1_.userID && MainManager.actorInfo.createTime == _loc1_.creatTime)
               {
                  if(ActivityExchangeTimesManager.getTimes(6265) < 10)
                  {
                     ActivityExchangeCommander.exchange(6265);
                  }
               }
            }
         }
      }
      
      private function caculateYesTotal() : void
      {
         var _loc1_:Array = [];
         _loc1_ = _loc1_.concat(this.copySource(this._source[0]));
         _loc1_ = _loc1_.concat(this.copySource(this._source[1]));
         _loc1_ = _loc1_.concat(this.copySource(this._source[2]));
         _loc1_.sort(this.compareSanInfo);
         var _loc2_:int = int(_loc1_.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_[_loc3_].rankIndex = _loc3_ + 1;
            _loc3_++;
         }
         this._source[3] = _loc1_;
      }
      
      private function copySource(param1:Array) : Array
      {
         var _loc5_:SanGuoRankInfo = null;
         var _loc2_:Array = [];
         var _loc3_:int = int(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1[_loc4_].copy() as SanGuoRankInfo;
            _loc2_.push(_loc5_);
            _loc4_++;
         }
         return _loc2_;
      }
      
      public function getSourceByCountryId(param1:int) : Array
      {
         if(this._source.length > param1)
         {
            return this._source[param1];
         }
         return null;
      }
      
      private function compareSanInfo(param1:SanGuoRankInfo, param2:SanGuoRankInfo) : int
      {
         if(param1.socre > param2.socre)
         {
            return -1;
         }
         if(param1.socre < param2.socre)
         {
            return 1;
         }
         return 0;
      }
      
      public function getFenglu() : int
      {
         return ItemManager.getItemCount(MONEY_ITEM_ID);
      }
      
      public function getGongXunToday() : int
      {
         return ActivityExchangeTimesManager.getTimes(GONG_XUN_SWAP_ID);
      }
      
      public function getGongXunYesterDay() : int
      {
         return ActivityExchangeTimesManager.getTimes(GONG_XUN_YES_SWAP_ID);
      }
      
      public function requestGongXun(param1:Function) : void
      {
         this._gongXunCallBack = param1;
         ActivityExchangeTimesManager.addEventListener(GONG_XUN_SWAP_ID,this.onGongXunBack);
         ActivityExchangeTimesManager.getActiviteTimeInfo(GONG_XUN_SWAP_ID);
      }
      
      private function onGongXunBack(param1:Event) : void
      {
         ActivityExchangeTimesManager.removeEventListener(GONG_XUN_SWAP_ID,this.onGongXunBack);
         if(this._gongXunCallBack != null)
         {
            this._gongXunCallBack();
         }
      }
      
      public function requestCurrentCountryScore(param1:Function) : void
      {
         this._countryScoreCallBack = param1;
         SocketConnection.addCmdListener(CommandID.RANK_SUMRACE_SUM,this.onScoreRank);
         SocketConnection.send(CommandID.RANK_SUMRACE_SUM,RankType.SAN_GUO_TOTAL_SCORE_TODAY,0,2,0,0,0,0);
      }
      
      private function onScoreRank(param1:SocketEvent) : void
      {
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:Number = NaN;
         SocketConnection.removeCmdListener(CommandID.RANK_SUMRACE_SUM,this.onScoreRank);
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:int = _loc2_.readInt();
         if(_loc3_ == RankType.SAN_GUO_TOTAL_SCORE_TODAY)
         {
            _loc4_ = [0,0,0];
            _loc5_ = int(_loc2_.readUnsignedInt());
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc7_ = int(_loc2_.readUnsignedInt());
               if(_loc7_ >= 1 && _loc7_ <= 3)
               {
                  _loc8_ = _loc2_.readUnsignedInt();
                  _loc9_ = _loc2_.readUnsignedInt();
                  _loc10_ = (_loc8_ << 32) + _loc9_;
                  _loc4_[_loc7_ - 1] = _loc10_;
               }
               _loc6_++;
            }
            if(this._countryScoreCallBack != null)
            {
               this._countryScoreCallBack(_loc4_);
            }
         }
      }
      
      public function getCurrentFengluSwapId() : int
      {
         return GET_FENG_LU_SWAPS[this.getGuanMingIndex(this.getGongXunYesterDay(),MainManager.actorID,MainManager.actorInfo.createTime,this.countryId)];
      }
      
      public function hasGetFenglu() : Boolean
      {
         var _loc2_:int = 0;
         var _loc1_:Array = GET_FENG_LU_SWAPS;
         for each(_loc2_ in _loc1_)
         {
            if(ActivityExchangeTimesManager.getTimes(_loc2_) != 0)
            {
               return true;
            }
         }
         return false;
      }
      
      public function getRankInfoByRankIndex(param1:int, param2:int) : SanGuoRankInfo
      {
         var _loc3_:Array = this._source[param2];
         return _loc3_[param1];
      }
      
      public function getFirstMan(param1:int) : SanGuoRankInfo
      {
         var _loc2_:SanGuoRankInfo = this.getRankInfoByRankIndex(0,param1);
         if(Boolean(_loc2_) && _loc2_.socre >= 5400)
         {
            return _loc2_;
         }
         return null;
      }
      
      public function getRankInfo(param1:int, param2:int, param3:int = -1) : SanGuoRankInfo
      {
         var _loc4_:SanGuoRankInfo = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         if(param3 != -1)
         {
            _loc5_ = this._source[param3];
            _loc4_ = this.getRankInfoInSource(param1,param2,_loc5_);
         }
         else
         {
            _loc6_ = Math.min(3,this._source.length);
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               _loc5_ = this._source[_loc7_];
               _loc4_ = this.getRankInfoInSource(param1,param2,_loc5_);
               if(_loc4_)
               {
                  break;
               }
               _loc7_++;
            }
         }
         return _loc4_;
      }
      
      private function getRankInfoInSource(param1:int, param2:int, param3:Array) : SanGuoRankInfo
      {
         var _loc4_:SanGuoRankInfo = null;
         var _loc5_:SanGuoRankInfo = null;
         for each(_loc5_ in param3)
         {
            if(_loc5_.userID == param1 && _loc5_.creatTime == param2)
            {
               return _loc5_;
            }
         }
         return null;
      }
      
      public function getGuanMingIndex(param1:int, param2:int, param3:int, param4:int) : int
      {
         var _loc6_:SanGuoRankInfo = null;
         var _loc5_:int = 0;
         if(param1 >= 5400)
         {
            _loc6_ = this.getRankInfo(param2,param3,param4);
            if(_loc6_)
            {
               if(_loc6_.rankIndex == 1)
               {
                  _loc5_ = 14;
               }
               else if(_loc6_.rankIndex <= 3)
               {
                  _loc5_ = 13;
               }
               else if(_loc6_.rankIndex <= 10)
               {
                  _loc5_ = 12;
               }
               else if(_loc6_.rankIndex <= 30)
               {
                  _loc5_ = 11;
               }
               else
               {
                  _loc5_ = 10;
               }
            }
            else
            {
               _loc5_ = 9;
            }
         }
         else if(param1 >= 4400)
         {
            _loc5_ = 8;
         }
         else if(param1 >= 3500)
         {
            _loc5_ = 7;
         }
         else if(param1 >= 2700)
         {
            _loc5_ = 6;
         }
         else if(param1 >= 2000)
         {
            _loc5_ = 5;
         }
         else if(param1 >= 1400)
         {
            _loc5_ = 4;
         }
         else if(param1 >= 900)
         {
            _loc5_ = 3;
         }
         else if(param1 >= 500)
         {
            _loc5_ = 2;
         }
         else if(param1 >= 200)
         {
            _loc5_ = 1;
         }
         else
         {
            _loc5_ = 0;
         }
         return _loc5_;
      }
      
      public function getGuanMing(param1:int, param2:int, param3:int, param4:int) : String
      {
         return GUAN_WEI_NAMES[this.getGuanMingIndex(param1,param2,param3,param4)];
      }
      
      public function get countryId() : int
      {
         return this._countryId;
      }
      
      public function set countryId(param1:int) : void
      {
         this._countryId = param1;
         MainManager.actorInfo.countryId = param1;
      }
      
      public function getCityWarFirstCountry() : int
      {
         if(MainManager.loginInfo.lineType == LineType.LINE_TYPE_CT)
         {
            return 2;
         }
         return 0;
      }
   }
}

