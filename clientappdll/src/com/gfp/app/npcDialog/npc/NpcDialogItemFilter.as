package com.gfp.app.npcDialog.npc
{
   import com.gfp.app.control.RunMatchControl;
   import com.gfp.app.control.SystemTimeController;
   import com.gfp.app.info.dialog.DialogActAmbaInfo;
   import com.gfp.app.info.dialog.DialogActivityExchangeInfo;
   import com.gfp.app.info.dialog.DialogAppInfo;
   import com.gfp.app.info.dialog.DialogCustomInfo;
   import com.gfp.app.info.dialog.DialogGoToMapInfo;
   import com.gfp.app.info.dialog.DialogGotoTowerInfo;
   import com.gfp.app.info.dialog.DialogInfo;
   import com.gfp.app.info.dialog.DialogMinigameInfo;
   import com.gfp.app.info.dialog.DialogPageUrlInfo;
   import com.gfp.app.info.dialog.DialogPvPInfo;
   import com.gfp.app.info.dialog.DialogRepairInfo;
   import com.gfp.app.info.dialog.DialogSellInfo;
   import com.gfp.app.info.dialog.DialogShopInfo;
   import com.gfp.app.info.dialog.DialogTaskInfo;
   import com.gfp.app.info.dialog.DialogTollgateInfo;
   import com.gfp.app.info.dialog.NpcDialogInfo;
   import com.gfp.app.manager.EscortManager;
   import com.gfp.app.npcDialog.NPCDialogEvent;
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.app.storyProcess.StoryProcess_1;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.info.StagePassGradeInfo;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.FightTeamsManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.ClientType;
   import com.gfp.core.utils.LineType;
   import com.gfp.core.utils.RoleDisplayUtil;
   import com.gfp.core.utils.StringConstants;
   import com.gfp.core.utils.TimeUtil;
   
   public class NpcDialogItemFilter
   {
      
      private static var questionA:Array;
      
      public function NpcDialogItemFilter()
      {
         super();
      }
      
      public static function getQuestions(param1:NpcDialogInfo) : Array
      {
         var _loc2_:QuestionInfo = null;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:String = null;
         var _loc11_:Array = null;
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         var _loc14_:uint = 0;
         var _loc15_:DialogShopInfo = null;
         var _loc16_:DialogCustomInfo = null;
         var _loc17_:uint = 0;
         var _loc18_:StagePassGradeInfo = null;
         var _loc19_:StagePassGradeInfo = null;
         var _loc20_:DialogActivityExchangeInfo = null;
         var _loc21_:DialogPvPInfo = null;
         var _loc22_:DialogAppInfo = null;
         var _loc23_:Array = null;
         var _loc24_:DialogInfo = null;
         var _loc25_:DialogMinigameInfo = null;
         var _loc26_:DialogTollgateInfo = null;
         var _loc27_:DialogSellInfo = null;
         var _loc28_:DialogRepairInfo = null;
         var _loc29_:DialogActAmbaInfo = null;
         var _loc30_:DialogGotoTowerInfo = null;
         var _loc31_:DialogPageUrlInfo = null;
         var _loc32_:DialogGoToMapInfo = null;
         questionA = [];
         var _loc5_:Array = TasksXMLInfo.getLinkerOvers(param1.npcID);
         _loc4_ = _loc5_.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc9_ = uint(_loc5_[_loc3_]);
            if(Boolean(TasksManager.isReady(_loc9_)) && (_loc9_ < 1969 || _loc9_ > 2003))
            {
               _loc2_ = new QuestionInfo();
               _loc2_.desc = TasksXMLInfo.getName(_loc9_) + AppLanguageDefine.COMPLETE;
               _loc2_.procType = QuestionInfo.PROC_TASKOVER;
               _loc2_.procParams = [_loc9_];
               questionA.push(_loc2_);
            }
            _loc3_++;
         }
         var _loc6_:Array = TasksXMLInfo.getLinkerProcess(param1.npcID);
         _loc4_ = _loc6_.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc10_ = _loc6_[_loc3_];
            _loc11_ = _loc10_.split(StringConstants.TASK_PARAM_SIGN);
            _loc12_ = uint(_loc11_[0]);
            _loc13_ = uint(_loc11_[1]);
            if(TasksManager.isProcess(_loc12_,_loc13_))
            {
               _loc2_ = new QuestionInfo();
               _loc2_.desc = TasksXMLInfo.getProName(_loc12_,_loc13_) + AppLanguageDefine.TASKS;
               _loc2_.procType = QuestionInfo.PROC_TASKPROCESS;
               _loc2_.procParams = [_loc12_,_loc13_];
               questionA.push(_loc2_);
            }
            _loc3_++;
         }
         var _loc7_:Array = TasksXMLInfo.getLinkerAccepts(param1.npcID);
         _loc4_ = _loc7_.length;
         var _loc8_:Boolean = false;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc14_ = uint(_loc7_[_loc3_]);
            if(Boolean(TasksManager.isAcceptable(_loc14_)) && !TasksManager.isOutmoded(_loc14_) && TasksXMLInfo.getType(_loc14_) != 13)
            {
               _loc2_ = new QuestionInfo();
               _loc2_.desc = TasksXMLInfo.getName(_loc14_) + AppLanguageDefine.ACCEPT;
               _loc2_.procType = QuestionInfo.PROC_TASKACCEPT;
               _loc2_.procParams = [_loc14_];
               questionA.push(_loc2_);
               _loc8_ = true;
            }
            _loc3_++;
         }
         if(_loc7_.length > 0 && !_loc8_ && !TasksManager.isCountAccept())
         {
            TextAlert.show("小侠士，你接取了过多未完成的任务，不能再接取新任务了。快快完成一部分任务吧先");
         }
         _loc4_ = param1.shopDialogs.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc15_ = param1.shopDialogs[_loc3_];
            if(_loc15_.turnback == 0 || Boolean(MainManager.actorInfo.isTurnBack) && _loc15_.turnback == 2 || MainManager.actorInfo.isTurnBack == false && _loc15_.turnback == 1)
            {
               _loc2_ = new QuestionInfo();
               _loc2_.desc = _loc15_.shopDesc;
               _loc2_.procType = QuestionInfo.PROC_SHOP;
               _loc2_.procParams = [_loc15_.shopID];
               questionA.push(_loc2_);
            }
            _loc3_++;
         }
         _loc4_ = param1.customDialogs.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc16_ = param1.customDialogs[_loc3_];
            if(MainManager.actorInfo.lv >= _loc16_.lv)
            {
               if(TimeUtil.timeLimit(_loc16_.startTime,_loc16_.endTime))
               {
                  if(!(_loc16_.displaySystimeId != 0 && !SystemTimeController.instance.checkSysTimeAchieve(_loc16_.displaySystimeId)))
                  {
                     _loc2_ = new QuestionInfo(_loc16_.prior);
                     _loc2_.desc = _loc16_.desc;
                     _loc2_.procType = QuestionInfo.PROC_CUSTOM;
                     _loc2_.procParams = [_loc16_.id];
                     _loc2_.sysTime = _loc16_.sysTimeID;
                     _loc2_.visible = _loc16_.visible;
                     if(param1.npcID == 10002)
                     {
                        if(_loc16_.id == 100020)
                        {
                           questionA.push(_loc2_);
                        }
                        if(StoryProcess_1.instance.validate && StoryProcess_1.instance.step >= StoryProcess_1.CHECK_STEP_2 && _loc16_.id == 100021)
                        {
                           questionA.push(_loc2_);
                        }
                        if(_loc16_.id == 100022 || _loc16_.id == 100023 || _loc16_.id == 100024)
                        {
                           if(TasksManager.isCompleted(1319))
                           {
                              questionA.push(_loc2_);
                           }
                        }
                        if(_loc16_.id == 100025)
                        {
                           if(Boolean(TasksManager.isAccepted(3004)) && TasksManager.isReady(3004) == false)
                           {
                              questionA.push(_loc2_);
                           }
                        }
                     }
                     else if(param1.npcID == 10005)
                     {
                        if(_loc16_.id == 100051)
                        {
                           if(Boolean(TasksManager.isProcess(1730,0)) && MainManager.actorInfo.lv >= 15)
                           {
                              questionA.push(_loc2_);
                           }
                        }
                        else if(_loc16_.id == 100052 || _loc16_.id == 100053 || _loc16_.id == 100054)
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(param1.npcID == 10015)
                     {
                        if(StoryProcess_1.instance.validate)
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(param1.npcID == 10001)
                     {
                        if(_loc16_.id == 1040901)
                        {
                           if(TasksManager.isAccepted(1782))
                           {
                              questionA.push(_loc2_);
                           }
                        }
                        else if(_loc16_.id == 100011)
                        {
                           if(Boolean(TasksManager.isAccepted(3004)) && TasksManager.isReady(3004) == false)
                           {
                              questionA.push(_loc2_);
                           }
                        }
                        else if(_loc16_.id == 100013)
                        {
                           if(Boolean(MainManager.actorInfo.isTurnBack) && MainManager.actorInfo.lv == 110 && ActivityExchangeTimesManager.getTimes(6835) == 0 && MainManager.activedMaxLevel() < 111)
                           {
                              questionA.push(_loc2_);
                           }
                        }
                        else
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 101531 || _loc16_.id == 101541 || _loc16_.id == 101533 || _loc16_.id == 101543)
                     {
                        if(MainManager.actorInfo.lv >= 20)
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 101532)
                     {
                        if(ItemManager.getItemCount(1400206) > 0)
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 101542)
                     {
                        if(ItemManager.getItemCount(1400207) > 0)
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 100061)
                     {
                        if(Boolean(SummonManager.getActorSummonInfo().isHaveSummonByType(1111)) && !SummonManager.getActorSummonInfo().isHaveSummonByType(1001))
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 100041)
                     {
                        if(Boolean(TasksManager.isCompleted(1729)) && !MainManager.actorInfo.isAdvanced)
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 100042)
                     {
                        if(Boolean(TasksManager.isProcess(1725,0)) && MainManager.actorInfo.lv > 44)
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 100043)
                     {
                        if(Boolean(TasksManager.isProcess(1925,1)) && MainManager.actorInfo.lv >= 75)
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 100044)
                     {
                        if(Boolean(TasksManager.isCompleted(1926)) && Boolean(TasksManager.isCompleted(1333)) && Boolean(MainManager.actorInfo.isAdvanced) && !MainManager.actorInfo.isSuperAdvc && MainManager.actorInfo.lv >= 75)
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 100025 || _loc16_.id == 100011 || _loc16_.id == 101461 || _loc16_.id == 101211 || _loc16_.id == 101581 || _loc16_.id == 101591 || _loc16_.id == 101611)
                     {
                        if(Boolean(TasksManager.isAccepted(3004)) && TasksManager.isReady(3004) == false)
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 101501)
                     {
                        if(MainManager.actorInfo.wulinID == 0)
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 101505)
                     {
                        if(MainManager.actorInfo.wulinID > 0)
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 1055701)
                     {
                        if(Boolean(TasksManager.isProcess(2152,2)) && Boolean(TasksManager.isAccepted(2152)))
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 1056001)
                     {
                        if(Boolean(TasksManager.isProcess(2156,2)) && Boolean(TasksManager.isAccepted(2156)))
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 101422)
                     {
                        if(FightTeamsManager.instance.isFightServer())
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 104111)
                     {
                        if(RunMatchControl.onMatch)
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 1042701)
                     {
                        if(Boolean(TasksManager.isProcess(1812,2)) || Boolean(TasksManager.isProcess(1812,3)))
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 1042702)
                     {
                        if(Boolean(TasksManager.isProcess(1814,3)) || Boolean(TasksManager.isProcess(1814,4)))
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 1042703)
                     {
                        if(Boolean(TasksManager.isProcess(1816,4)) || Boolean(TasksManager.isProcess(1816,5)))
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 101512)
                     {
                        if(TasksManager.isCompleted(2013))
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 101513)
                     {
                        if(TasksManager.isProcess(2013,1))
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 101514)
                     {
                        if(TasksManager.isProcess(2011,1))
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 1042704)
                     {
                        if(Boolean(TasksManager.isProcess(1837,1)) || Boolean(TasksManager.isCompleted(1837)) || Boolean(TasksManager.isProcess(1837,2)))
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 1043201)
                     {
                        if(TasksManager.isProcess(1834,1))
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 100665)
                     {
                        if(TasksManager.isProcess(1899,1))
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 100667)
                     {
                        if(TasksManager.isCompleted(1934))
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 190206)
                     {
                        if(TasksManager.isProcess(1902,6))
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 190302)
                     {
                        if(TasksManager.isProcess(1903,2))
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 190303)
                     {
                        if(TasksManager.isProcess(1903,3))
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 1000301)
                     {
                        if(MainManager.actorInfo.lv >= 30)
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 1044601)
                     {
                        if(Boolean(TasksManager.isCompleted(1899)) && Boolean(TasksManager.isCompleted(1900)))
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 1044602)
                     {
                        if(TasksManager.isProcess(1900,1))
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 1043203)
                     {
                        if(TasksManager.isProcess(1833,2))
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 100066 || _loc16_.id == 100091)
                     {
                        questionA.push(_loc2_);
                     }
                     else if(_loc16_.id == 104281)
                     {
                        _loc17_ = uint(EscortManager.instance.escortPathId);
                        if(_loc17_ >= 29 && _loc17_ <= 34)
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 104282)
                     {
                        if(Boolean(TasksManager.isCompleted(1879)) && SystemTimeController.instance.checkSysTimeAchieve(112))
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 104283)
                     {
                        if(Boolean(TasksManager.isCompleted(1879)) && SystemTimeController.instance.checkSysTimeAchieve(112))
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 100663)
                     {
                        if(Boolean(TasksManager.isCompleted(1876)) && SystemTimeController.instance.checkSysTimeAchieve(106))
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 100664)
                     {
                        if(TasksManager.isCompleted(1882))
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 1042707)
                     {
                        if(Boolean(TasksManager.isCompleted(1878)) && SystemTimeController.instance.checkSysTimeAchieve(112))
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 1045101)
                     {
                        if(TasksManager.isCompleted(1932))
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 1042901)
                     {
                        if(TasksManager.isCompleted(2072))
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 100486)
                     {
                        if(MainManager.loginInfo.lineType == LineType.LINE_TYPE_CT2)
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(param1.npcID == 10503)
                     {
                        if(TasksManager.isCompleted(2004))
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 1051701)
                     {
                        _loc18_ = MainManager.stageRecordInfo.getPassedStageMap().getValue(583);
                        if(!_loc18_)
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 1051602)
                     {
                        _loc19_ = MainManager.stageRecordInfo.getPassedStageMap().getValue(584);
                        if(!_loc19_ && Boolean(MainManager.stageRecordInfo.getPassedStageMap().getValue(583)))
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 1051601)
                     {
                        if(!MainManager.stageRecordInfo.getPassedStageMap().getValue(583))
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 105361)
                     {
                        if(Boolean(MainManager.actorInfo.isTurnBack) && MainManager.actorInfo.lv == 110 && ActivityExchangeTimesManager.getTimes(6836) == 0 && MainManager.activedMaxLevel() < 111)
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 100481)
                     {
                        if(Boolean(MainManager.actorInfo.isTurnBack) && MainManager.actorInfo.lv == 110 && ActivityExchangeTimesManager.getTimes(6837) == 0 && MainManager.activedMaxLevel() < 111)
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 100666)
                     {
                        if(Boolean(MainManager.actorInfo.isTurnBack) && MainManager.actorInfo.lv == 110 && ActivityExchangeTimesManager.getTimes(6838) == 0 && MainManager.activedMaxLevel() < 111)
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else if(_loc16_.id == 101571)
                     {
                        if(Boolean(MainManager.actorInfo.isTurnBack) && MainManager.actorInfo.lv == 110 && ActivityExchangeTimesManager.getTimes(6839) == 0 && MainManager.activedMaxLevel() < 111)
                        {
                           questionA.push(_loc2_);
                        }
                     }
                     else
                     {
                        questionA.push(_loc2_);
                     }
                  }
               }
            }
            _loc3_++;
         }
         _loc4_ = param1.dailyActivityDialogs.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc20_ = param1.dailyActivityDialogs[_loc3_];
            _loc2_ = new QuestionInfo();
            _loc2_.desc = _loc20_.desc;
            _loc2_.procType = QuestionInfo.PROC_ACTIVITYEXCHANGE;
            _loc2_.procParams = [_loc20_.dailyActivityID,_loc20_.sysTimeID];
            if(param1.npcID == 10153 || param1.npcID == 10154)
            {
               if(MainManager.actorInfo.lv >= 20)
               {
                  questionA.push(_loc2_);
               }
            }
            else
            {
               questionA.push(_loc2_);
            }
            _loc3_++;
         }
         _loc4_ = param1.pvpDialogs.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc21_ = param1.pvpDialogs[_loc3_];
            _loc2_ = new QuestionInfo();
            _loc2_.desc = _loc21_.pvpDesc;
            _loc2_.procType = QuestionInfo.PROC_PVPENTER;
            _loc2_.procParams = [_loc21_];
            questionA.push(_loc2_);
            _loc3_++;
         }
         _loc4_ = param1.appDialogs.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc22_ = param1.appDialogs[_loc3_];
            if(_loc22_.lv <= MainManager.actorInfo.lv)
            {
               _loc2_ = new QuestionInfo(_loc22_.prior);
               _loc2_.desc = _loc22_.appDesc;
               _loc2_.lv = _loc22_.lv;
               _loc2_.procType = QuestionInfo.PROC_APPMODULE;
               _loc2_.procParams = [_loc22_.appSrc,_loc22_.appParams];
               _loc2_.visible = _loc22_.visible;
               if(_loc22_.sysTimeID > 0)
               {
                  _loc2_.sysTime = _loc22_.sysTimeID;
               }
               if(param1.npcID == 10020)
               {
                  if(ClientConfig.clientType != ClientType.KAIXIN)
                  {
                     questionA.push(_loc2_);
                  }
                  else
                  {
                     _loc23_ = ["AmberExpoPanel","ChamberHostageRewardPanel","SilverTicketExchangePanel"];
                     if(_loc23_.indexOf(_loc22_.appSrc) == -1)
                     {
                        questionA.push(_loc2_);
                     }
                  }
               }
               else if(param1.npcID == 10021)
               {
                  if(_loc22_.appSrc == "SecretNumPanel")
                  {
                     questionA.push(_loc2_);
                  }
                  else if(_loc22_.appSrc == "GFNumPanel")
                  {
                     if(ClientConfig.clientType != ClientType.KAIXIN)
                     {
                        questionA.push(_loc2_);
                     }
                  }
                  else if(_loc22_.appSrc == "GFNumRewardsPanel")
                  {
                     if(ClientConfig.clientType != ClientType.KAIXIN)
                     {
                        questionA.push(_loc2_);
                     }
                  }
               }
               else if(param1.npcID == 10003)
               {
                  if(_loc22_.appSrc == "BrainsPanel")
                  {
                     if(Boolean(TasksManager.isProcess(1313,1)) || Boolean(TasksManager.isProcess(1313,2)) || Boolean(TasksManager.isProcess(1313,3)) || Boolean(TasksManager.isProcess(1313,4)) || Boolean(TasksManager.isProcess(1313,5)) || Boolean(TasksManager.isProcess(1313,6)) || Boolean(TasksManager.isProcess(1313,7)))
                     {
                        questionA.push(_loc2_);
                     }
                     if(Boolean(TasksManager.isAccepted(1315)) && TasksManager.isReady(1315) == false)
                     {
                        questionA.push(_loc2_);
                     }
                  }
                  else if(_loc22_.appSrc == "AmbassadorTask")
                  {
                     if(MainManager.actorInfo.ambassadorTaskState == 1 && Boolean(RoleDisplayUtil.isRoleGraduate()))
                     {
                        questionA.push(_loc2_);
                     }
                  }
                  else
                  {
                     questionA.push(_loc2_);
                  }
               }
               else if(param1.npcID == 10015)
               {
                  if(StoryProcess_1.instance.validate)
                  {
                     questionA.push(_loc2_);
                  }
               }
               else if(param1.npcID == 10150)
               {
                  if(_loc22_.appSrc == "WuLinFightMemberPanel")
                  {
                     if(MainManager.actorInfo.wulinID != 0)
                     {
                        questionA.push(_loc2_);
                     }
                  }
                  else
                  {
                     questionA.push(_loc2_);
                  }
               }
               else if(param1.npcID == 10411)
               {
                  if(_loc22_.appSrc == "RunMatchAwardPanel" || _loc22_.appSrc == "RankPanel")
                  {
                     if(!RunMatchControl.onMatch)
                     {
                        questionA.push(_loc2_);
                     }
                  }
               }
               else if(_loc22_.appSrc == "SummonRaceFirstPage")
               {
                  if(MainManager.loginInfo.lineType != LineType.LINE_TYPE_CT2)
                  {
                     questionA.push(_loc2_);
                  }
               }
               else if(_loc22_.appSrc == "AccountAwardPanel")
               {
                  if(ActivityExchangeTimesManager.getTimes(3308) == 0)
                  {
                     questionA.push(_loc2_);
                  }
               }
               else if(ClientConfig.clientType != ClientType.TAOMEE)
               {
                  if(param1.npcID != 10026 && param1.npcID != 10027 && param1.npcID != 10029 && param1.npcID != 10030)
                  {
                     questionA.push(_loc2_);
                  }
               }
               else
               {
                  questionA.push(_loc2_);
               }
            }
            _loc3_++;
         }
         _loc4_ = param1.normalDialogs.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc24_ = param1.normalDialogs[_loc3_];
            _loc2_ = new QuestionInfo();
            _loc2_.desc = _loc24_.selectDesc;
            _loc2_.dialogs = _loc24_.npcDialogs;
            _loc2_.procType = QuestionInfo.PROC_DIALOG;
            questionA.push(_loc2_);
            _loc3_++;
         }
         _loc4_ = param1.minigameDialogs.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc25_ = param1.minigameDialogs[_loc3_];
            _loc2_ = new QuestionInfo(_loc25_.prior);
            _loc2_.desc = _loc25_.gameDesc;
            _loc2_.procType = QuestionInfo.PROC_MINIGAME;
            _loc2_.procParams = [_loc25_.gameSrc,_loc25_.gameParams];
            if(_loc25_.gameSrc == "OpenCardGame")
            {
               if(ClientConfig.clientType != ClientType.KAIXIN)
               {
                  questionA.push(_loc2_);
               }
            }
            else
            {
               questionA.push(_loc2_);
            }
            _loc3_++;
         }
         _loc4_ = param1.tollgateDialogs.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc26_ = param1.tollgateDialogs[_loc3_];
            _loc2_ = new QuestionInfo();
            _loc2_.desc = _loc26_.tollgateDesc;
            _loc2_.procType = QuestionInfo.PROC_TOLLGATE;
            _loc2_.procParams = [_loc26_.tollgateID,_loc26_.difficulty];
            questionA.push(_loc2_);
            _loc3_++;
         }
         _loc4_ = param1.sellDialogs.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc27_ = param1.sellDialogs[_loc3_];
            _loc2_ = new QuestionInfo();
            _loc2_.desc = _loc27_.sellDesc;
            _loc2_.procType = QuestionInfo.PROC_SELL;
            _loc2_.procParams = [_loc27_.sellID];
            questionA.push(_loc2_);
            _loc3_++;
         }
         _loc4_ = param1.repairDialogs.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc28_ = param1.repairDialogs[_loc3_];
            _loc2_ = new QuestionInfo();
            _loc2_.desc = _loc28_.repairDesc;
            _loc2_.procType = QuestionInfo.PROC_REPAIR;
            _loc2_.procParams = [_loc28_.repairID];
            questionA.push(_loc2_);
            _loc3_++;
         }
         _loc4_ = param1.actAmbaDialogs.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc29_ = param1.actAmbaDialogs[_loc3_];
            _loc2_ = new QuestionInfo();
            _loc2_.desc = _loc29_.actDesc;
            _loc2_.procType = QuestionInfo.PROC_ACTAMBA;
            if(MainManager.actorInfo.ambassadorTaskState == 0 && ClientConfig.clientType != ClientType.KAIXIN)
            {
               questionA.push(_loc2_);
            }
            _loc3_++;
         }
         _loc4_ = param1.gotoTowerDialogs.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc30_ = param1.gotoTowerDialogs[_loc3_];
            _loc2_ = new QuestionInfo();
            _loc2_.procType = QuestionInfo.PROC_GOTOTOWER;
            _loc2_.desc = _loc30_.desc;
            if(TasksManager.isCompleted(1192))
            {
               questionA.push(_loc2_);
            }
            _loc3_++;
         }
         _loc4_ = param1.pageUrlDialogs.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc31_ = param1.pageUrlDialogs[_loc3_];
            _loc2_ = new QuestionInfo(_loc31_.prior);
            _loc2_.procType = QuestionInfo.PROC_PAGEURL;
            _loc2_.desc = _loc31_.urlDesc;
            if(ClientConfig.clientType != ClientType.TAIWAN && param1.npcID == 10048)
            {
               _loc2_.procParams = [_loc31_.url];
            }
            else
            {
               _loc2_.procParams = ["http://pay.61.com.tw/service"];
            }
            if(param1.npcID != 10048)
            {
               questionA.push(_loc2_);
            }
            else if(ClientConfig.clientType != ClientType.KAIXIN)
            {
               questionA.push(_loc2_);
            }
            _loc3_++;
         }
         _loc4_ = param1.goToMapDialogs.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc32_ = param1.goToMapDialogs[_loc3_];
            _loc2_ = new QuestionInfo();
            _loc2_.procType = QuestionInfo.PROC_GOTOMAP;
            _loc2_.desc = _loc32_.desc;
            _loc2_.procParams = [_loc32_.mapID];
            questionA.push(_loc2_);
            _loc3_++;
         }
         NpcDialogController.ed.dispatchEvent(new NPCDialogEvent(param1.npcID,NPCDialogEvent.NPC_DIALOG_WILL_ADD_ITEMS));
         if(param1.resort)
         {
            questionA.sortOn("prior",Array.NUMERIC);
         }
         return questionA;
      }
      
      public static function addQuestionInfio(param1:QuestionInfo, param2:Boolean = false) : void
      {
         if(param2)
         {
            questionA.unshift(param1);
         }
         else
         {
            questionA.push(param1);
         }
      }
      
      public static function getTaskQuestion(param1:NpcDialogInfo) : DialogTaskInfo
      {
         var _loc2_:int = 0;
         var _loc3_:DialogTaskInfo = null;
         var _loc4_:Array = param1.taskOvers;
         var _loc5_:int = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc5_)
         {
            _loc3_ = _loc4_[_loc2_];
            if(Boolean(TasksManager.isReady(_loc3_.taskID)) && TasksXMLInfo.getType(_loc3_.taskID) != 13)
            {
               return _loc3_;
            }
            _loc2_++;
         }
         var _loc6_:Array = param1.taskProcess;
         _loc5_ = int(_loc6_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc5_)
         {
            _loc3_ = _loc6_[_loc2_];
            if(TasksManager.isProcess(_loc3_.taskID,_loc3_.proID))
            {
               return _loc3_;
            }
            _loc2_++;
         }
         var _loc7_:Array = param1.taskAccepts;
         _loc5_ = int(_loc7_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc5_)
         {
            _loc3_ = _loc7_[_loc2_];
            if(Boolean(TasksManager.isAcceptable(_loc3_.taskID)) && !TasksManager.isOutmoded(_loc3_.taskID) && TasksXMLInfo.getType(_loc3_.taskID) != 13)
            {
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }
   }
}

