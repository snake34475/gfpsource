package com.gfp.app.systems
{
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SOManager;
   import com.gfp.core.utils.TimeUtil;
   import flash.display.MovieClip;
   import flash.net.SharedObject;
   import flash.utils.ByteArray;
   
   public class ClientTempState
   {
      
      public static var quickAddItemCallBack:Function;
      
      public static var storedBuffInfo:String;
      
      public static var isCleanGodAlert:Boolean;
      
      public static var isMohunDoAlert:Boolean;
      
      public static var airLandSideScore:int;
      
      public static var moLandSideScore:int;
      
      public static var isPvpSideAlert:Boolean;
      
      public static var isPickPeachAlert:Boolean;
      
      public static var isZhaoCaiJinBao:Boolean;
      
      public static var isProtectedFightGameAlert:Boolean;
      
      public static var isAddLeiShengAlert:Boolean;
      
      public static var isZhiShangYunXiaoAlert:Boolean;
      
      public static var skillRevolutionRoleType:int;
      
      public static var summonExpUpAlert:Boolean;
      
      public static var washGoldShovelType:int;
      
      public static var wanSummonSelectedIndex:int;
      
      public static var isNanBuCiShuAlert:Boolean;
      
      public static var isNanBuPayTurnAlert:Boolean;
      
      public static var summonAuctionTimer:int;
      
      public static var prevCallEquipSummonUniqueID:int;
      
      public static var EquipSummonGuardAnima:Boolean;
      
      public static var isQingLongAlert:Boolean;
      
      public static var materialPvpWin:Boolean;
      
      public static var isHeroFightMidAlert:Boolean;
      
      public static var characterLeagueTimer:int;
      
      public static var ForbiddenCountDownMc:MovieClip;
      
      public static var CKMondorManHua:Boolean;
      
      public static var summonJingYanMengJingLayer:int;
      
      public static var endlessTowerFirstLayer:int;
      
      public static var endlessTowerSecondLayer:int;
      
      public static var endlessTowerThirdLayer:int;
      
      public static var isSnowCarnival:Boolean = false;
      
      public static var isHighFanTian:Boolean = false;
      
      public static var isGuoQingTeQuan:Boolean = true;
      
      public static var StartTime:int = 0;
      
      public static var PlayTime:int = 0;
      
      public static var isStrengthAnimatPlayed:Boolean = false;
      
      public static var isComposeAnimatPlayed:Boolean = false;
      
      public static var isNineChainAnimatPlayed:Boolean = false;
      
      public static var isReapFruitAlert:Boolean = false;
      
      public static var isLongAnimatPlayed:Boolean = false;
      
      public static var isDragonStepsAnimatPlayed:Boolean = false;
      
      public static var isCovertHeroAnimatPlayed:Boolean = false;
      
      public static var isNpcSleepAnimatPlayed:Boolean = false;
      
      public static var isPhenixAnimatPlayed:Boolean = false;
      
      public static var isCatDrawerAward:Boolean = false;
      
      public static var isCloseDefaultAwardAlert:Boolean = false;
      
      public static var isOpenPetIslandPannel:Boolean = false;
      
      public static var isPlayTASKAnimate:Boolean = false;
      
      public static var isFight673Winner:Boolean = false;
      
      public static var isShowGodPetHint:Boolean = false;
      
      public static var isShowBoBoTimeHint:Boolean = false;
      
      public static var isShangGuMonster:Boolean = false;
      
      public static var isFirstEnchanted:Boolean = true;
      
      public static var isFirstRefined:Boolean = true;
      
      public static var isFirstInherited:Boolean = true;
      
      public static var jewelryComposeForbidMaterials:Array = [];
      
      public static var jewelryComposeUseMaterialNeedConfirm:Boolean = true;
      
      public static var summonPracticeBuyNeedConfirm:Boolean = true;
      
      public static var summonPracticeClearCDConfirm:Boolean = true;
      
      public static var summonPracticePayConfirm:Boolean = true;
      
      public static var plantExpClearCDConfirm:Boolean = true;
      
      public static var plantExpMaxLevelConfirm:Boolean = true;
      
      public static var plantExpRefreshConfirm:Boolean = true;
      
      public static var isOpenDragonTreatmentPane:Boolean = false;
      
      public static var isThreeHeroAlert:Boolean = false;
      
      public static var isStrengthenAlert:Boolean = false;
      
      public static var isZhanBuAlert:Boolean = false;
      
      public static var isZhanBuFightCount:Boolean = false;
      
      public static var isWarnChaosLordPanel:Boolean = false;
      
      public static var isQuickGetFiveAlert:Boolean = false;
      
      public static var isBuyActivityPointAlert:Boolean = false;
      
      public static var isBuyCleanTimesAlert:Boolean = false;
      
      public static var consumePveStatus:Boolean = false;
      
      public static var isNextNotShowTurnVIPPrivage:Boolean = false;
      
      public static var isNextNotShowMysteriousTreasure:Boolean = false;
      
      public static var moyinEnvoNotShowAlert:Boolean = false;
      
      public static var isShowSummonTurnPanel:Boolean = false;
      
      public static var pvpYaBiaoFirstSelect:int = 0;
      
      public static var pvpYaBiaoSecondSelect:int = 0;
      
      public static var yaBiaoStatus:Array = [0,0,0];
      
      public static var peachTreeInfos:Array = [];
      
      public static var summonAuctionRankList:Array = [];
      
      public static var snowBallCnt:Array = [];
      
      public static var LEGEND_EQUIP_POT_OPEN_ALERT:Boolean = true;
      
      public static const QingLongManHua:String = "QingLongManHua";
      
      public static var materialPvpActivityIndex:int = -1;
      
      public static var characterLeagueRankList:Array = [];
      
      public static var miniGameRankLists:Object = {};
      
      public static var miniGameRankTimers:Object = {};
      
      public static var miniGameRank2Lists:Vector.<ByteArray> = new Vector.<ByteArray>();
      
      public static var miniGameRank2Timers:Vector.<uint> = new Vector.<uint>();
      
      public static var IsForbiddenShowHePlaying:Boolean = false;
      
      public static var LastWorld:Array = new Array();
      
      public static var IsNewUser:Boolean = false;
      
      public static var bawangRankList:Array = [];
      
      public static var zhanQuZhengBaWinners:Array = [];
      
      public function ClientTempState()
      {
         super();
      }
      
      public static function get isSideBetter() : Boolean
      {
         if(MainManager.actorInfo.side == 1)
         {
            if(ClientTempState.airLandSideScore >= ClientTempState.moLandSideScore)
            {
               return true;
            }
            return false;
         }
         if(ClientTempState.airLandSideScore >= ClientTempState.moLandSideScore)
         {
            return false;
         }
         return true;
      }
      
      private static function getShareTypeString(param1:String, param2:int) : String
      {
         if(param2 == 0)
         {
            return param1;
         }
         if(param2 == 1)
         {
            return param1 + MainManager.actorID;
         }
         if(param2 == 2)
         {
            return param1 + MainManager.actorID + "-" + MainManager.actorInfo.createTime;
         }
         return param1;
      }
      
      public static function addShareObject(param1:String, param2:Object, param3:int = 0) : void
      {
         param1 = getShareTypeString(param1,param3);
         var _loc4_:SharedObject = SOManager.getUserSO(param1);
         _loc4_.data[param1] = param2;
         SOManager.flush(_loc4_);
      }
      
      public static function getShareObject(param1:String, param2:int = 0) : Object
      {
         param1 = getShareTypeString(param1,param2);
         var _loc3_:SharedObject = SOManager.getUserSO(param1);
         return _loc3_.data[param1];
      }
      
      public static function addShared(param1:String, param2:Boolean = true) : void
      {
         var _loc3_:SharedObject = SOManager.getUserSO(param1);
         if(param2)
         {
            _loc3_.data[param1] = MainManager.actorInfo.userID;
         }
         else
         {
            _loc3_.data[param1] = MainManager.actorInfo.userID + "_" + MainManager.actorInfo.createTime;
         }
         flushNum(param1,1);
         SOManager.flush(_loc3_);
      }
      
      public static function flushNum(param1:String, param2:uint = 1) : void
      {
         var _loc3_:SharedObject = SOManager.getUserSO(param1);
         var _loc4_:int = int(_loc3_.data[param1 + "n"]);
         _loc4_ = _loc4_ + param2;
         _loc3_.data[param1 + "n"] = _loc4_;
      }
      
      public static function getShared(param1:String, param2:Boolean = true, param3:uint = 1) : Boolean
      {
         var _loc4_:SharedObject = SOManager.getUserSO(param1);
         var _loc5_:* = _loc4_.data[param1];
         var _loc6_:int = int(_loc4_.data[param1 + "n"]);
         if(param2)
         {
            return int(_loc5_) == MainManager.actorInfo.userID && _loc6_ >= param3;
         }
         return String(_loc5_) == MainManager.actorInfo.userID + "_" + MainManager.actorInfo.createTime && _loc6_ >= param3;
      }
      
      public static function isActivityExpired(param1:int, param2:int, param3:int, param4:int = 0, param5:int = 0, param6:int = 0) : Boolean
      {
         var _loc7_:Number = Number(TimeUtil.getServerSecond());
         var _loc8_:Number = new Date(param1,param2 - 1,param3,param4,param5,param6).getTime() / 1000;
         return _loc7_ > _loc8_;
      }
   }
}

