package com.gfp.app.manager
{
   import com.gfp.app.control.SystemTimeController;
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.ModuleManager;
   
   public class YearCallManager
   {
      
      public static const NPC_RECARD_SWAP:Array = [4046,4047,4048,4049,4050];
      
      public static const TIME_RECARD_SWAP:Array = [4057,4058,4059,4060,4061];
      
      public function YearCallManager()
      {
         super();
      }
      
      public static function NpcNewYearCall(param1:uint) : void
      {
         var npcArr:Array;
         var i:int;
         var index:int;
         var dialogs:Array;
         var selects:Array;
         var getNpcID:uint = 0;
         var anserIndex:uint = 0;
         var npcID:uint = param1;
         if(!SystemTimeController.instance.checkSysTimeAchieve(172))
         {
            AlertManager.showSimpleAlarm("小侠士，功夫派拜年时间为2014年1月28日到2014年2月6日!");
            NpcDialogController.hide();
            return;
         }
         npcArr = [];
         i = 0;
         while(i < 5)
         {
            getNpcID = uint(ActivityExchangeTimesManager.getTimes(NPC_RECARD_SWAP[i]));
            if(getNpcID > 0)
            {
               npcArr.push(getNpcID);
            }
            i++;
         }
         index = npcArr.indexOf(npcID);
         if(npcArr.length >= 5 && index == -1)
         {
            AlertManager.showSimpleAlarm("小侠士，一天最多给五位居民拜年哦，请明天再来吧");
            NpcDialogController.hide();
            return;
         }
         if(index != -1)
         {
            anserIndex = uint(ActivityExchangeTimesManager.getTimes(TIME_RECARD_SWAP[index]));
            if(anserIndex >= 3)
            {
               AlertManager.showSimpleAlarm("新年快乐！你今天已经给我拜过年啦！");
               NpcDialogController.hide();
               return;
            }
         }
         dialogs = ["小侠士，新年好！聪明的你又迎来了新的一年！我的礼物准备好了，在此之前先回答几个新年小常识吧！"];
         selects = ["好的，我准备好了"];
         NpcDialogController.showForSingles(dialogs,selects,npcID,function():void
         {
            ModuleManager.turnAppModule("AnswerForYearCall","",npcID);
         });
      }
      
      public static function getAnswerTimeSwapID(param1:uint) : int
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc2_:int = 0;
         while(_loc2_ < 5)
         {
            _loc3_ = uint(NPC_RECARD_SWAP[_loc2_]);
            _loc4_ = uint(ActivityExchangeTimesManager.getTimes(_loc3_));
            if(_loc4_ == param1 || _loc4_ == 0)
            {
               return TIME_RECARD_SWAP[_loc2_];
            }
            _loc2_++;
         }
         return 0;
      }
      
      public static function getNpcSwapID(param1:uint) : int
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc2_:int = 0;
         while(_loc2_ < 5)
         {
            _loc3_ = uint(NPC_RECARD_SWAP[_loc2_]);
            _loc4_ = uint(ActivityExchangeTimesManager.getTimes(_loc3_));
            if(_loc4_ == param1 || _loc4_ == 0)
            {
               return _loc3_;
            }
            _loc2_++;
         }
         return 0;
      }
      
      public static function getNpcNum() : uint
      {
         var _loc3_:uint = 0;
         var _loc1_:Array = [];
         var _loc2_:int = 0;
         while(_loc2_ < 5)
         {
            _loc3_ = uint(ActivityExchangeTimesManager.getTimes(NPC_RECARD_SWAP[_loc2_]));
            if(_loc3_ > 0)
            {
               _loc1_.push(_loc3_);
            }
            _loc2_++;
         }
         return _loc1_.length;
      }
   }
}

