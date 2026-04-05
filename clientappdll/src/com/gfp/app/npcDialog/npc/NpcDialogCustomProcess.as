package com.gfp.app.npcDialog.npc
{
   import com.gfp.app.cartoon.AdvanceAnimat;
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.cartoon.event.AnimatEvent;
   import com.gfp.app.config.xml.DialogExXmlInfo;
   import com.gfp.app.control.ChristmasManController;
   import com.gfp.app.control.HelpNcpConroller;
   import com.gfp.app.control.RunMatchControl;
   import com.gfp.app.control.SystemTimeController;
   import com.gfp.app.feature.BreakWeddingFeather;
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.app.fight.PvpEntry;
   import com.gfp.app.fight.SinglePkManager;
   import com.gfp.app.im.talk.TalkManager;
   import com.gfp.app.info.dialog.DialogInfoMultiple;
   import com.gfp.app.info.dialog.DialogInfoSimple;
   import com.gfp.app.info.dialog.DialogPvPInfo;
   import com.gfp.app.info.dialogex.DialogExInfo;
   import com.gfp.app.manager.CatchBigGhostManager;
   import com.gfp.app.manager.EscortManager;
   import com.gfp.app.manager.FightGroupManager;
   import com.gfp.app.manager.GhostWellManager;
   import com.gfp.app.manager.GroupViolenceMatchManager;
   import com.gfp.app.manager.PvpManager;
   import com.gfp.app.manager.TeamAutoFightManager;
   import com.gfp.app.manager.TeamTaskManager;
   import com.gfp.app.manager.YearCallManager;
   import com.gfp.app.npcDialog.DialogAdapter;
   import com.gfp.app.npcDialog.NpcAppMoudleParamsConvert;
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.app.npcDialog.PuzzleController;
   import com.gfp.app.systems.ClientTempState;
   import com.gfp.app.task.tc.TaskXML_HeartFight;
   import com.gfp.app.toolBar.AmbassadorEntry;
   import com.gfp.core.CommandID;
   import com.gfp.core.behavior.ChangeRoleBehavior;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.EscortXMLInfo;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.config.xml.NpcXMLInfo;
   import com.gfp.core.config.xml.ShopXMLInfo;
   import com.gfp.core.events.DataEvent;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.ServerUniqDataEvent;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.info.ActivityExchangeAwardInfo;
   import com.gfp.core.info.ServerUniqDataInfo;
   import com.gfp.core.info.SwapActionLimitInfo;
   import com.gfp.core.info.TransportPoint;
   import com.gfp.core.info.dailyActivity.SwapTimesInfo;
   import com.gfp.core.info.item.SingleEquipInfo;
   import com.gfp.core.info.subCareer.SubCareerType;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AdvancedManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.BuyMallItemManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.MasterManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.OnHookManager;
   import com.gfp.core.manager.RideManager;
   import com.gfp.core.manager.ServerUniqDataManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.manager.TeamsRelationManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.manager.alert.AlertType;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.sensemodels.SightModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.ActivityTimeUtil;
   import com.gfp.core.utils.ByteArrayUtil;
   import com.gfp.core.utils.ClientType;
   import com.gfp.core.utils.RankType;
   import com.gfp.core.utils.StringConstants;
   import com.gfp.core.utils.TextFormatUtil;
   import com.gfp.core.utils.TimeUtil;
   import com.gfp.core.utils.VipUtil;
   import com.gfp.core.utils.WallowUtil;
   import com.gfp.core.utils.WebURLUtil;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.net.SharedObject;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.Delegate;
   
   public class NpcDialogCustomProcess
   {
      
      public static const COINDOUBLE:uint = 1820;
      
      public static const EXPDOUBLE:uint = 1821;
      
      public static const SWAPID:int = 1978;
      
      private static const EXCHANGE_ID:int = 2072;
      
      private static const TIME_COIN:int = 97;
      
      private static const TIME_WATER:int = 100;
      
      public static const SHANGE_GU_TASKIDS:Array = [2007,2008,2009,2010];
      
      private var isTakeoff1302000:Boolean = true;
      
      private var isIgnore:Boolean;
      
      private const JOKING_SWIPID:uint = 4219;
      
      private var isWinner:Boolean = false;
      
      private var _swapCallBacks:Dictionary = new Dictionary();
      
      public function NpcDialogCustomProcess()
      {
         super();
      }
      
      private static function generateDuration(param1:int, param2:int) : int
      {
         var _loc3_:int = 50;
         var _loc4_:Number = param1 / (param2 * _loc3_);
         var _loc5_:int = 50;
         if(_loc4_ > 0.5)
         {
            _loc5_ = Math.ceil(param1 / _loc3_);
         }
         else
         {
            _loc5_ = Math.floor(param1 / _loc3_);
         }
         return _loc5_;
      }
      
      public function processQuestion(param1:QuestionInfo) : void
      {
         if(param1.sysTime > 0 && !SystemTimeController.instance.checkSysTimeAchieve(param1.sysTime))
         {
            SystemTimeController.instance.showOutTimeAlert(param1.sysTime);
            return;
         }
         if(param1.callback != null)
         {
            param1.callback();
         }
         else if(param1.procType == QuestionInfo.PROC_SHOP)
         {
            this.shopModuleTurn(param1.procParams[0]);
         }
         else if(param1.procType == QuestionInfo.PROC_TASKACCEPT)
         {
            this.taskAccept(param1.procParams[0]);
         }
         else if(param1.procType == QuestionInfo.PROC_TASKPROCESS)
         {
            this.taskProcess(param1.procParams[0],param1.procParams[1]);
         }
         else if(param1.procType == QuestionInfo.PROC_TASKOVER)
         {
            this.taskOver(param1.procParams[0]);
         }
         else if(param1.procType == QuestionInfo.PROC_MINIGAME)
         {
            if(param1.procParams[0] == "FindMajority")
            {
               this.isCanPlayFindMajority();
               return;
            }
            if(param1.procParams[0] != "HammerHit")
            {
               this.minigameStart(param1.procParams[0],param1.procParams[1]);
            }
            else if(WallowUtil.isWallow())
            {
               WallowUtil.showWallowMsg(AppLanguageDefine.WALLOW_MSG_ARR[11]);
            }
            else
            {
               this.minigameStart(param1.procParams[0],param1.procParams[1]);
            }
         }
         else if(param1.procType == QuestionInfo.PROC_TOLLGATE)
         {
            this.tollgateTo(param1.procParams[0],param1.procParams[1]);
         }
         else if(param1.procType == QuestionInfo.PROC_PVPENTER)
         {
            this.pvpStart(param1.procParams[0]);
         }
         else if(param1.procType == QuestionInfo.PROC_SELL)
         {
            this.sellItemEnter(param1.procParams[0]);
         }
         else if(param1.procType == QuestionInfo.PROC_REPAIR)
         {
            this.equiptRepairEnter(param1.procParams[0]);
         }
         else if(param1.procType == QuestionInfo.PROC_APPMODULE)
         {
            if(param1.lv != 0 && MainManager.actorInfo.lv < param1.lv)
            {
               AlertManager.showSimpleAlarm("小侠士你的等级不足" + param1.lv + "级，不能参加该活动。");
            }
            else
            {
               this.appModule(param1.procParams[0],param1.procParams[1]);
            }
         }
         else if(param1.procType == QuestionInfo.PROC_ACTAMBA)
         {
            this.activeAmbassadorTask();
         }
         else if(param1.procType == QuestionInfo.PROC_CUSTOM)
         {
            this.processCostum(param1.procParams[0]);
         }
         else if(param1.procType == QuestionInfo.PROC_GOTOTOWER)
         {
            this.gotoTower();
         }
         else if(param1.procType == QuestionInfo.PROC_PAGEURL)
         {
            this.pageTo(param1.procParams[0]);
         }
         else if(param1.procType == QuestionInfo.PROC_GOTOMAP)
         {
            this.gotoMap(param1.procParams[0]);
         }
         else if(param1.procType == QuestionInfo.PROC_ACTIVITYEXCHANGE)
         {
            this.exchangeActivity(param1.procParams[0],param1.procParams[1]);
         }
         else if(param1.procType == QuestionInfo.PROC_ESCORT)
         {
            EscortManager.instance.endEscort();
         }
      }
      
      private function processCostum(param1:uint) : void
      {
         var swapId:int = 0;
         var swapID:uint = 0;
         var advance:AdvanceAnimat = null;
         var tollgateId:int = 0;
         var dialogs:String = null;
         var selects:Array = null;
         var multiDialog:DialogInfoMultiple = null;
         var npcid:int = 0;
         var so:SharedObject = null;
         var npcID:uint = 0;
         var s1:String = null;
         var dialog:DialogInfoSimple = null;
         var dia101583:DialogInfoSimple = null;
         var customId:uint = param1;
         switch(customId)
         {
            case 13518:
            case 13519:
            case 13520:
            case 13521:
            case 13522:
            case 13523:
            case 13524:
               NpcDialogController.hide();
               ActivityExchangeCommander.exchange(customId);
               break;
            case 10018:
               this.openStorehouse();
               break;
            case 100020:
               this.applyForPharmStudent();
               break;
            case 100021:
               this.showStoryDialog_1();
               break;
            case 10020:
               this.showClearGhostDialog();
               break;
            case 10015:
               this.getIcebucket();
               break;
            case 10019:
               this.getElementsSpirit();
               break;
            case 100022:
               if(!SystemTimeController.instance.checkSysTimeAchieve(153))
               {
                  AlertManager.showSimpleAlarm("小侠士，药师后花园的进入时间为每天12:00到21::00哦。");
                  break;
               }
               LayerManager.closeMouseEvent();
               PveEntry.enterTollgate(925,1,0);
               NpcDialogController.hide();
               break;
            case 100023:
               this.buyArmory();
               break;
            case 100024:
               ModuleManager.turnModule(ClientConfig.getAppModule("Activity110407AwardPanel"),"药师爷爷的奖励...");
               NpcDialogController.hide();
               break;
            case 100222:
               this.showTreasureTurnpanelAlert();
               NpcDialogController.hide();
               break;
            case 10048:
               ActivityExchangeTimesManager.addEventListener(1032,this.onCheck1032Times);
               ActivityExchangeTimesManager.getActiviteTimeInfo(1032);
               break;
            case 100482:
               this.getMiMiAward();
               NpcDialogController.hide();
               break;
            case 100483:
               this.func100483();
               NpcDialogController.hide();
               break;
            case 100485:
               NpcDialogController.hide();
               swapID = 2598 + MainManager.roleType;
               if(ActivityExchangeTimesManager.getTimes(swapID) > 0)
               {
                  AlertManager.showSimpleAlarm("你已经领取过了。");
                  return;
               }
               ActivityExchangeCommander.exchange(swapID);
               break;
            case 100486:
               this.func100486();
               break;
            case 101531:
               Delegate.create(this.openLockGame,0)();
               NpcDialogController.hide();
               break;
            case 101541:
               Delegate.create(this.openLockGame,1)();
               NpcDialogController.hide();
               break;
            case 101532:
               NpcDialogController.hide();
               PveEntry.enterTollgate(this.randomTollgate(0),1,1);
               break;
            case 101542:
               NpcDialogController.hide();
               PveEntry.enterTollgate(this.randomTollgate(1),1,1);
               break;
            case 101533:
               NpcDialogController.hide();
               AlertManager.showSimpleAlert("进入关卡消耗20点伏魔点，开启宝箱需要黄色魔石*1和灵溪花*1，确认进入关卡吗？",Delegate.create(this.zouHouMen,2));
               break;
            case 101543:
               NpcDialogController.hide();
               AlertManager.showSimpleAlert("进入关卡消耗20点伏魔点，开启宝箱需要紫色魔石*1和灵溪花*1，确认进入关卡吗？",Delegate.create(this.zouHouMen,3));
               break;
            case 100061:
               NpcDialogController.hide();
               this.reGetWhiteFox();
               break;
            case 100067:
               NpcDialogController.hide();
               ModuleManager.turnAppModule("BingHeMengMaPanel");
               break;
            case 10016:
               this.applyForComposeStudent();
               break;
            case 101561:
               NpcDialogController.hide();
               this.openOnHook();
               break;
            case 101562:
               NpcDialogController.hide();
               this.getHookAward();
               break;
            case 101421:
               NpcDialogController.hide();
               this.LouLanTreasureEntry();
               break;
            case 101422:
               NpcDialogController.hide();
               this.gloryFightApply();
               break;
            case 101423:
               NpcDialogController.hide();
               ModuleManager.turnAppModule("LoulanDonatePanel");
               break;
            case 101601:
               NpcDialogController.hide();
               PveEntry.enterTollgate(980);
               break;
            case 101611:
               NpcDialogController.hide();
               PveEntry.enterTollgate(981);
               break;
            case 100041:
               NpcDialogController.hide();
               advance = new AdvanceAnimat();
               advance.play();
               return;
            case 100042:
               this.aevanceCertificate();
               NpcDialogController.hide();
               break;
            case 100043:
               tollgateId = TaskXML_HeartFight.getTollgateID();
               if(0 != tollgateId)
               {
                  PveEntry.enterTollgate(tollgateId);
               }
               break;
            case 100044:
               NpcDialogController.hide();
               AdvancedManager.instance.advanced3();
               return;
            case 100045:
               this.func100045();
               break;
            case 100046:
               if(MainManager.actorInfo.lv < 30)
               {
                  s1 = "小侠士，你的等级还不足<font color=\'#FF0000\'>30</font>级，快去加强锻炼，升级到<font color=\'#FF0000\'>30</font>级后再来我进练功房修炼吧";
                  dialog = new DialogInfoSimple([s1],"我知道了。");
                  NpcDialogController.showForSimple(dialog,10004);
                  break;
               }
               CityMap.instance.changeMap(1056);
               break;
            case 100047:
               if(ActivityExchangeTimesManager.getTimes(4479) > 0)
               {
                  AlertManager.showSimpleAlarm("小侠士，你已经进行过武器转生了！");
                  break;
               }
               if(MainManager.actorInfo.isTurnBack == false)
               {
                  AlertManager.showSimpleAlarm("小侠士，你还没有转生哦！");
                  break;
               }
               ModuleManager.turnAppModule("WeaponTurnBackPanel");
               break;
            case 100025:
            case 100011:
            case 101461:
            case 101211:
            case 101581:
            case 101591:
            case 101611:
               this.showSubDialogEntry(customId);
               break;
            case 101651:
            case 101661:
            case 101671:
            case 101681:
            case 101691:
            case 101701:
            case 101711:
            case 101721:
            case 101731:
            case 101741:
            case 101751:
            case 101761:
            case 101771:
            case 101781:
            case 101791:
            case 101801:
            case 101811:
            case 101821:
            case 101831:
            case 101841:
            case 101851:
            case 101861:
            case 101871:
            case 101881:
            case 101891:
               ChristmasManController.getSwap(customId);
               break;
            case 100051:
               PveEntry.enterTollgate(987);
               break;
            case 100054:
               NpcDialogController.hide();
               ModuleManager.turnAppModule("ActivityTaskPanel");
               break;
            case 101551:
               NpcDialogController.showOptionsNpcDialog(10155,0,this.dialog101551OptionSelectHandler);
               break;
            case 101552:
               NpcDialogController.hide();
               if(ActivityExchangeTimesManager.getTimes(2454) > 0)
               {
                  ModuleManager.turnAppModule("SummonRaceForecastPanel","",0);
                  break;
               }
               ModuleManager.turnAppModule("SummonRaceFirstPage");
               break;
            case 100223:
               AlertManager.showSimpleAlert("一宝券可兑换10伏魔点，确定兑换吗？",this.exchangeBaby);
               break;
            case 100225:
               NpcDialogController.hide();
               this.handleShangGuBaoTu();
               break;
            case 100226:
               NpcDialogController.hide();
               ModuleManager.turnAppModule("ShangGuBaoTuDesPanel");
               break;
            case 100227:
               NpcDialogController.hide();
               this.function100227();
               break;
            case 101553:
               this.maydaymakewish();
               break;
            case 100224:
               if(MainManager.actorInfo.lv < 30)
               {
                  TextAlert.show("小侠士,只有30级以上侠士才能购买宝图");
                  return;
               }
               AlertManager.showSimpleAlert("购买一个宝图需消耗25点伏魔点，宝图类型将随机获得， 确定购买吗？",this.buyBabyMap);
               break;
            case 100661:
               if(ItemManager.getItemCount(1500580) >= 20)
               {
                  ModuleManager.turnModule(ClientConfig.getAppModule("RequestGodPanel"),"正在加载");
               }
               else
               {
                  AlertManager.showSimpleAlarm("小侠士,还没有足够的“请神符”请侠士去所有关卡中战斗获得后再来吧！记住，20个请神符才能请出神仙哦！");
               }
               NpcDialogController.hide();
               break;
            case 100662:
               ModuleManager.turnModule(ClientConfig.getAppModule("GodFourCartoonPanel"),"正在加载");
               NpcDialogController.hide();
               break;
            case 100663:
               if(ItemManager.getItemCount(1500580) >= 20)
               {
                  AlertManager.showSimpleAlert("进入艾尔幻境需要20个请神符,确认进入吗？",function():void
                  {
                     PveEntry.instance.enterTollgate(668);
                  });
                  break;
               }
               AlertManager.showSimpleAlarm("进入艾尔幻境需要20个请神符,小侠士物品不足,点击确定立即进入商城购买。",function():void
               {
                  ModuleManager.turnModule(ClientConfig.getAppModule("Mall"),"正在加载",{
                     "firstPage":4,
                     "childPage":2,
                     "targetHintIconID":1700107
                  });
               });
               break;
            case 100665:
               NpcDialogController.hide();
               ModuleManager.turnModule(ClientConfig.getAppModule("Drinking"),"正在加载");
               break;
            case 100669:
               dialogs = "小侠士定是一位有大机缘的人，九转天机以九宫盒为基础，<font  color=\'#FF0000\'>点击打开背包中的九宫盒</font>即可进入神秘的九转天机，小侠士从今日到7月11日为止每日都可在老夫这领取一枚九宫盒，无字天书中亦有机会获得，剩下的就看你自己的造化了！";
               selects = ["领取九宫盒"];
               multiDialog = new DialogInfoMultiple([dialogs],selects);
               NpcDialogController.showForMultiple(multiDialog,10066,function():void
               {
                  ActivityExchangeCommander.exchange(2627);
               });
               break;
            case 1006610:
               NpcDialogController.hide();
               this.handleWestTreasure();
               break;
            case 1006611:
               NpcDialogController.hide();
               this.handleDayHappy();
               break;
            case 1006612:
               ModuleManager.turnAppModule("VipFightPanel");
               NpcDialogController.hide();
               break;
            case 1006613:
               ModuleManager.turnAppModule("MarsDownPanel");
               NpcDialogController.hide();
               break;
            case 1006615:
               NpcDialogController.hide();
               this.handleWuTouQiShi();
               break;
            case 1007201:
               NpcDialogController.hide();
               if(MainManager.actorInfo.lv < 60)
               {
                  AlertManager.showSimpleAlarm("比赛异常凶险，小侠士修炼到60级再来吧！");
                  break;
               }
               ModuleManager.turnAppModule("EgoisticSignPanel","正在加载");
               break;
            case 101501:
               this.WuLinApply();
               NpcDialogController.hide();
               break;
            case 101502:
               this.challengeEachBigBull();
               NpcDialogController.hide();
               break;
            case 1056201:
               this.wanShenDian();
               break;
            case 101503:
               NpcDialogController.hide();
               if(SystemTimeController.instance.checkSysTimeAchieve(33))
               {
                  GroupViolenceMatchManager.instance.signUpKingFight();
                  break;
               }
               SystemTimeController.instance.showOutTimeAlert(33);
               break;
            case 101504:
               NpcDialogController.hide();
               this.function101504();
               break;
            case 101505:
               NpcDialogController.hide();
               this.function101505();
               break;
            case 101506:
               NpcDialogController.hide();
               ModuleManager.turnAppModule("GroupViolenceMatchPanel");
               break;
            case 101507:
               NpcDialogController.hide();
               ModuleManager.turnAppModule("GroupViolenceMatchIntrPanel");
               break;
            case 1055701:
               NpcDialogController.hide();
               ModuleManager.turnAppModule("Task2152GamePanel");
               break;
            case 1056001:
               NpcDialogController.hide();
               ModuleManager.turnAppModule("Task2156GamePanel");
               break;
            case 1056002:
               NpcDialogController.hide();
               ActivityExchangeCommander.exchange(4471);
               break;
            case 101508:
               NpcDialogController.hide();
               ModuleManager.turnAppModule("GroupViolenceMatchRewardPanel");
               break;
            case 101510:
               NpcDialogController.hide();
               if(MainManager.actorInfo.lv >= 30)
               {
                  ModuleManager.turnAppModule("DragonTigerFightPanel");
                  break;
               }
               AlertManager.showSimpleAlarm("小侠士，需要30级才能参加龙虎斗比赛哦。");
               break;
            case 101582:
               if(MainManager.actorInfo.lv >= 45 || Boolean(MainManager.actorInfo.isVip))
               {
                  ActivityExchangeCommander.exchange(1364);
                  break;
               }
               AlertManager.showSimpleAlarm("亲爱的小侠士，只有角色等级在45级以上或者是超灵侠士才能领取哦！");
               break;
            case 101583:
               if(MainManager.actorInfo.lv >= 45 || Boolean(MainManager.actorInfo.isVip))
               {
                  ModuleManager.turnModule(ClientConfig.getAppModule("ButchDragenPannel"),AppLanguageDefine.LOAD_MATTER_COLLECTION[0]);
                  NpcDialogController.hide();
                  break;
               }
               dia101583 = new DialogInfoSimple(["魔龙太过强大，只有45级以上的小侠士或者超灵侠士才能去挑战。不过，我还需要一些封印符来加强对魔龙力量的封印，在3.23—3.24的14:00—16:00之间，你可以在各个关卡里获取封印符来给我，我将给你丰厚的奖励."],"好的，我这就去");
               NpcDialogController.showForSimple(dia101583,10158);
               break;
            case 101584:
               ModuleManager.turnModule(ClientConfig.getAppModule("KillGargonAwardPanel"),AppLanguageDefine.LOAD_MATTER_COLLECTION[0]);
               NpcDialogController.hide();
               break;
            case 1044601:
               this.func1044601();
               break;
            case 1044602:
               this.func1044602();
               break;
            case 1044603:
               this.func1044603();
               break;
            case 1044604:
               PveEntry.enterTollgate(506);
               break;
            case 1044701:
               break;
            case 1044702:
               CityMap.instance.changeMap(59);
               break;
            case 1044801:
               PveEntry.enterTollgate(500);
               break;
            case 1010401:
               this.func1010401();
               break;
            case 1010301:
               this.func1010301();
               break;
            case 1010302:
            case 1010402:
               this.func1010302();
               break;
            case 1002401:
               this.func1002401();
               break;
            case 1002402:
               this.func1002402();
               break;
            case 1012301:
               this.func1012301();
               break;
            case 1012302:
               this.func1012302();
               break;
            case 1012303:
               this.func1012303();
               break;
            case 101941:
               PveEntry.enterTollgate(706);
               break;
            case 101942:
               PveEntry.enterTollgate(707);
               NpcDialogController.hide();
               break;
            case 101951:
               ModuleManager.turnAppModule("GhostWellEffectPanel","正在加载...");
               NpcDialogController.hide();
               break;
            case 101952:
               ModuleManager.turnAppModule("GhostWellNoticePanel","正在加载...");
               NpcDialogController.hide();
               break;
            case 101953:
               NpcDialogController.hide();
               if(!SystemTimeController.instance.checkSysTimeAchieve(14))
               {
                  AlertManager.showSimpleAlarm("亲爱的小侠士，你不能进入神魔井战斗，进入时间为3月10日的13:30~14:00。");
                  break;
               }
               GhostWellManager.instance.enterGhostWell();
               break;
            case 102001:
               NpcDialogController.hide();
               if(MapManager.curMapIsMiniRoomMap())
               {
                  CityMap.instance.leaveMiniRoom(0,0,1,1002,0);
               }
               break;
            case 102011:
               PveEntry.enterTollgate(714);
               break;
            case 103981:
               PveEntry.enterTollgate(719);
               NpcDialogController.hide();
               break;
            case 103982:
               NpcDialogController.hide();
               break;
            case 104001:
               NpcDialogController.hide();
               SocketConnection.send(CommandID.GLORY_FIGHT_ROOMINFO);
               break;
            case 104011:
               NpcDialogController.hide();
               ModuleManager.turnAppModule("RankPanel","加载排行榜......",RankType.TYPE_MULTI_PVP);
               break;
            case 1005801:
               CityMap.instance.changeMap(56,0,1,new Point(450,800));
               NpcDialogController.hide();
               break;
            case 1040201:
               TalkManager.showTalkPanel(NpcXMLInfo.GF_HELPER_ID,0);
               NpcDialogController.hide();
               break;
            case 1040202:
               NpcDialogController.hide();
               if(MainManager.actorInfo.lv < 70)
               {
                  AlertManager.showSimpleAlarm("对不起小侠士，不是优秀老玩家无法领取推广码，优秀老玩家的等级必须至少为70。");
                  break;
               }
               ModuleManager.turnAppModule("GetPromCodePanel","加载领取推广码面板......");
               break;
            case 1040203:
               NpcDialogController.hide();
               ModuleManager.turnAppModule("ActPromCodePanel","加载激活推广码面板......");
               break;
            case 1040204:
               NpcDialogController.hide();
               ModuleManager.turnAppModule("PromotersRewardPanel","加载推广员奖励面板......");
               break;
            case 1040205:
               NpcDialogController.hide();
               ModuleManager.turnAppModule("ExplainPromCodePanel","加载推广码说明面板......");
               break;
            case 1051603:
               NpcDialogController.hide();
               this.exchangeMoonCake();
               break;
            case 1051602:
               NpcDialogController.hide();
               this.beatPig();
               break;
            case 1051604:
               NpcDialogController.hide();
               this.getPigGod();
               break;
            case 1051701:
               NpcDialogController.hide();
               this.talkToChange();
               break;
            case 1051702:
               NpcDialogController.hide();
               this.beatChange();
               break;
            case 1051801:
               NpcDialogController.hide();
               this.useTuzi();
               break;
            case 1051601:
               NpcDialogController.hide();
               this.loveRabbit();
               break;
            case 1040206:
               NpcDialogController.hide();
               if(SummonManager.getActorSummonInfo().currentSummonInfo == null)
               {
                  AlertManager.showSimpleAlarm("对不起小侠士，你没有出战仙兽，不能参加比赛！");
                  return;
               }
               if(SystemTimeController.instance.checkSysTimeAchieve(29))
               {
                  PvpEntry.instance.fightWithEnter(23);
                  break;
               }
               SystemTimeController.instance.showOutTimeAlert(29);
               break;
            case 1040207:
               NpcDialogController.hide();
               ModuleManager.turnModule(ClientConfig.getAppModule("PromotersRewardPanel"),"打开招募面板...");
               break;
            case 1040208:
               NpcDialogController.hide();
               ModuleManager.turnModule(ClientConfig.getAppModule("ExplainPromCodePanel"),"打开说明面板...");
               break;
            case 1040209:
               NpcDialogController.hide();
               ModuleManager.turnModule(ClientConfig.getAppModule("TellStory"),"打开说明面板...");
               break;
            case 1040210:
               NpcDialogController.hide();
               ModuleManager.turnModule(ClientConfig.getAppModule("NianAppearCheckPanel"),"打开说明面板...");
               break;
            case 1040211:
               NpcDialogController.hide();
               ModuleManager.turnModule(ClientConfig.getAppModule("LanternFestivalPanel"),"打开面板...");
               break;
            case 1040212:
               NpcDialogController.hide();
               this.func_1040212();
               break;
            case 10402010:
               NpcDialogController.hide();
               WebURLUtil.intance.callKeFuQuestion();
               break;
            case 1040220:
               PuzzleController.instance.start(PuzzleController.ONE);
               break;
            case 1004820:
               PuzzleController.instance.start(PuzzleController.TWO);
               break;
            case 1012320:
               PuzzleController.instance.start(PuzzleController.THREE);
               break;
            case 1040221:
            case 1004821:
            case 1012321:
               NpcDialogController.hide();
               ModuleManager.closeAllModule();
               ModuleManager.turnAppModule("Puzzle180Panel","加载中......");
               break;
            case 10402011:
               NpcDialogController.hide();
               ModuleManager.closeAllModule();
               ModuleManager.turnAppModule("QingMingChildOne","加载中......");
               break;
            case 10402012:
               NpcDialogController.hide();
               ModuleManager.closeAllModule();
               ModuleManager.turnAppModule("MoneyTreePanel","加载中......");
               break;
            case 10402013:
               this.checkMayDayAward();
               break;
            case 1040214:
               this.func1040214();
               break;
            case 1040215:
               this.breakWedding();
               break;
            case 1040216:
               this.awardWedding();
               break;
            case 1040217:
               this.func1040217();
               break;
            case 170301801:
               NpcDialogController.hide();
               ModuleManager.closeAllModule();
               ModuleManager.turnAppModule("CatchSoulPanel","加载中.....");
               break;
            case 100484:
               NpcDialogController.hide();
               ModuleManager.closeAllModule();
               ModuleManager.turnAppModule("PromotionSuperUserPanel","加载中.....");
               break;
            case 1040901:
               if(ItemManager.getItemCount(1410037) > 0)
               {
                  ActivityExchangeCommander.exchange(1681);
                  break;
               }
               if(ItemManager.getItemCount(1410035) > 0)
               {
                  ActivityExchangeCommander.exchange(1682);
               }
               break;
            case 104071:
               PveEntry.enterTollgate(741);
               break;
            case 104111:
               if(RunMatchControl.chechRunOver())
               {
                  PveEntry.enterTollgate(743);
                  break;
               }
               AlertManager.showSimpleAlarm("小侠士，你还没有跑完比赛！");
               break;
            case 1001301:
               ActivityExchangeCommander.exchange(1852);
               break;
            case 1001302:
               ActivityExchangeCommander.exchange(1853);
               break;
            case 1042701:
               PveEntry.enterTollgate(755);
               break;
            case 1042702:
               PveEntry.enterTollgate(756);
               break;
            case 1042703:
               PveEntry.enterTollgate(768);
               break;
            case 101512:
               NpcDialogController.hide();
               this.onFirstStudentFight();
               break;
            case 101513:
               NpcDialogController.hide();
               EscortManager.instance.selectEscortType(0,EscortManager.AI_XIN_KAO_YAN);
               break;
            case 101514:
               NpcDialogController.hide();
               ModuleManager.turnAppModule("DragonTigerFightPanel");
               break;
            case 1042704:
               NpcDialogController.hide();
               ModuleManager.turnAppModule("PetIslandPanel","加载仙兽面板......");
               break;
            case 1042705:
               NpcDialogController.hide();
               ActivityTimeUtil.check(111,function():void
               {
                  if(ActivityExchangeTimesManager.getTimes(2324) > 0)
                  {
                     AlertManager.showSimpleAlert("本次挑战貔貅需要消耗2个圣光魂石，小侠士是否确定进入？",function():void
                     {
                        PveEntry.enterTollgate(608);
                     });
                  }
                  else
                  {
                     ActivityExchangeTimesManager.updataTimesByOnce(2324);
                     PveEntry.enterTollgate(605);
                  }
               });
               break;
            case 1042706:
               NpcDialogController.hide();
               ModuleManager.turnAppModule("Mall","",{
                  "firstPage":3,
                  "targetHintIconID":1740028
               });
               break;
            case 100012:
               this.function100012();
               break;
            case 100052:
               npcid = int(customId / 10);
               this.halloweenCandyHandler(npcid);
               break;
            case 1043001:
               this.func1043001();
               break;
            case 1043202:
               this.func1043202();
               break;
            case 101921:
               PveEntry.enterTollgate(604);
               break;
            case 104281:
               NpcDialogController.hide();
               EscortManager.instance.endEscort();
               break;
            case 104361:
               if(this.check104361())
               {
                  this.func104361();
               }
               break;
            case 10437:
               this.playCityAnimat(2);
               NpcDialogController.hide();
               break;
            case 1043701:
               ModuleManager.closeAllModule();
               ModuleManager.turnAppModule("CityWarSignPanel");
               NpcDialogController.hide();
               break;
            case 1043702:
               ModuleManager.closeAllModule();
               ModuleManager.turnAppModule("TeamCityWarSignPanel");
               NpcDialogController.hide();
               break;
            case 190206:
               NpcDialogController.hide();
               TasksManager.exeTaskPro(1902,6);
               break;
            case 190302:
               NpcDialogController.hide();
               TasksManager.exeTaskPro(1903,2);
               break;
            case 190303:
               NpcDialogController.hide();
               TasksManager.exeTaskPro(1903,3);
               break;
            case 1000301:
               NpcDialogController.hide();
               ModuleManager.closeAllModule();
               ModuleManager.turnAppModule("NewRoleStoryPanel");
               break;
            case 1044901:
               NpcDialogController.hide();
               if(MainManager.actorInfo.lv < 30)
               {
                  AlertManager.showSimpleAlarm("亲爱的小侠士，小侠士修炼到30级再来挑战吧");
                  break;
               }
               if(ItemManager.getItemCount(1500568) < 3)
               {
                  AlertManager.showSimpleAlarm("小侠士携带的土龙珠不足3颗，无法进入一画一世界！\n土龙珠可在关卡掉落拾取，万博会也能购买。");
                  break;
               }
               AlertManager.showSimpleAlert("本次进入一画一世界需要消耗3颗土龙珠，侠士是否前往？",function():void
               {
                  PveEntry.instance.enterTollgate(517 + int(Math.random() * 3));
               });
               break;
            case 100053:
               NpcDialogController.hide();
               MasterManager.instance.openMasterPanel();
               break;
            case 1045001:
               NpcDialogController.hide();
               if(MainManager.actorInfo.coins < 500000)
               {
                  AlertManager.showSimpleAlarm("进入此关卡需要50w功夫豆。");
                  break;
               }
               if(SystemTimeController.instance.checkSysTimeAchieve(133))
               {
                  ModuleManager.turnAppModule("PvpAlertPanel","正在加载。。。。",46);
                  break;
               }
               SystemTimeController.instance.showOutTimeAlert(133);
               break;
            case 1045002:
               if(ItemManager.getItemCount(1500580) <= 0)
               {
                  AlertManager.showSimpleAlarm("我这法宝没有请神符的灵力相助是没法使用的，想要他就拿请神符来换吧！");
               }
               else
               {
                  ActivityExchangeCommander.exchange(2542);
               }
               NpcDialogController.hide();
               break;
            case 1045003:
               NpcDialogController.hide();
               this.blackPvp2v2();
               break;
            case 1006501:
               NpcDialogController.hide();
               ModuleManager.turnAppModule("DragonBoatModule");
               break;
            case 1045101:
               NpcDialogController.hide();
               this.killSnake();
               break;
            case 1045601:
               NpcDialogController.hide();
               this.func1045601();
               break;
            case 1045602:
               NpcDialogController.hide();
               this.func1045602();
               break;
            case 1053701:
               NpcDialogController.hide();
               this.func1053701();
               break;
            case 1045603:
               NpcDialogController.hide();
               this.func1045603();
               break;
            case 1006661:
               NpcDialogController.hide();
               this.func1006661();
               break;
            case 101515:
               NpcDialogController.hide();
               if(!SystemTimeController.instance.checkSysTimeAchieve(166))
               {
                  AlertManager.showSimpleAlarm("小侠士，2014年2月1日后才能查看上月排行榜哦。");
                  return;
               }
               ModuleManager.turnAppModule("WuLingFengYunRankPanel","正在加载...",RankType.TYPE_LING_FENG_YUN_PRE_MONTH_FIGHT);
               break;
            case 1050101:
               NpcDialogController.hide();
               this.function1050101();
               break;
            case 100667:
               NpcDialogController.hide();
               ModuleManager.turnAppModule("BeatChiYouPanel");
               break;
            case 100668:
               NpcDialogController.hide();
               ModuleManager.turnAppModule("ChiYouTurnPanel");
               break;
            case 1050301:
               NpcDialogController.hide();
               this.setTeamTask(1);
               break;
            case 1050302:
               NpcDialogController.hide();
               this.setTeamTask(2);
               break;
            case 1050303:
               NpcDialogController.hide();
               this.setTeamTask(3);
               break;
            case 1004901:
               NpcDialogController.hide();
               so = SharedObject.getLocal(MainManager.actorID + "_" + MainManager.actorInfo.createTime + "_FallFurnace");
               if(so.data.value == 1)
               {
                  ModuleManager.turnAppModule("FallFurnacePanel");
                  break;
               }
               so.data.value = 1;
               ModuleManager.turnAppModule("FallFurnaceIntroducePanel");
               break;
            case 1051401:
               NpcDialogController.hide();
               ModuleManager.turnAppModule("AmoresPerrosPanel");
               break;
            case 1051402:
               this.func1051402();
               break;
            case 1050304:
               NpcDialogController.hide();
               this.goGuangHanGong();
               break;
            case 1041001:
               NpcDialogController.hide();
               this.fightThreeHeroPve();
               break;
            case 1041002:
               NpcDialogController.hide();
               ModuleManager.turnAppModule("TopThreeHeroFightPanel");
               break;
            case 1041003:
               NpcDialogController.hide();
               ModuleManager.turnAppModule("TopThreeHeroFightEggPanel");
               break;
            case 1041004:
               NpcDialogController.hide();
               this.pvpSideActivity();
               break;
            case 1041005:
               NpcDialogController.hide();
               PvpManager.openYaBiaoPanel();
               break;
            case 1041006:
            case 1041007:
            case 1041008:
            case 1041009:
               HelpNcpConroller.inst.getSwap(customId);
               break;
            case 1090000:
               if(MainManager.actorInfo.lv >= 30)
               {
                  this.fun1090000();
                  break;
               }
               AlertManager.showSimpleAlarm("小侠士需要30级才能参加活动！");
               break;
            case 1006616:
               NpcDialogController.hide();
               this.fun1006616();
               break;
            case 1006618:
               NpcDialogController.hide();
               this.zhaoCaiJinBao();
               break;
            case 1006614:
               NpcDialogController.hide();
               if(MainManager.actorInfo.lv < 30)
               {
                  AlertManager.showSimpleAlarm("前方有危险，小侠士30级再来吧。");
                  return;
               }
               CityMap.instance.changeMap(1053);
               break;
            case 1052301:
               NpcDialogController.hide();
               if(MainManager.actorInfo.lv < 20)
               {
                  AlertManager.showSimpleAlarm("小侠士需要20级才能参加狼多多特训计划！");
                  return;
               }
               ModuleManager.turnAppModule("WolfAddAddTrainPlainPanel");
               break;
            case 1040223:
               NpcDialogController.hide();
               ModuleManager.turnAppModule("RankPanel","正在加载排行榜...",RankType.TYPE_FIGHT_POWER_RANK_NEXT_WEEK);
               break;
            case 1040224:
               NpcDialogController.hide();
               ModuleManager.turnAppModule("RankPanel","正在加载排行榜...",RankType.TYPE_FIGHT_POWER_RANK_CURRENT_WEEK);
               break;
            case 1042901:
               ModuleManager.turnAppModule("ChariotPanel");
               NpcDialogController.hide();
               break;
            case 1021601:
               break;
            case 1014001:
            case 1004822:
            case 1000601:
            case 1040225:
            case 1053601:
            case 1000101:
            case 1006617:
            case 1002403:
            case 1015801:
            case 1042708:
               npcID = uint(customId / 100);
               YearCallManager.NpcNewYearCall(npcID);
               break;
            case 105561:
               this.function105561();
               break;
            case 101516:
               this.protecteFightGame();
               break;
            case 105631:
               NpcDialogController.tryGotoTianGong();
               break;
            case 1058101:
               if(5 - ActivityExchangeTimesManager.getTimes(5201) > 0)
               {
                  PveEntry.enterTollgate(1029);
                  break;
               }
               AlertManager.showSimpleAlarm("剩余挑战次数不足！");
               break;
            case 100013:
               this.func100013();
               break;
            case 105361:
               this.func105361();
               break;
            case 100481:
               this.func100481();
               break;
            case 100666:
               this.func100666();
               break;
            case 101571:
               this.func101571();
               break;
            case 105451:
               PveEntry.enterTollgate(421);
               break;
            case 102331:
               PveEntry.enterTollgate(1242);
               break;
            case 105701:
               this.func105701();
               break;
            case 105702:
               NpcDialogController.hide();
               this.func105702();
               break;
            case 105703:
               this.func105703();
               break;
            case 102461:
               NpcDialogController.hide();
               swapId = 11393;
               this.getSwapInfo(swapId,function(param1:SwapTimesInfo):void
               {
                  if(param1.times == 0)
                  {
                     ActivityExchangeCommander.exchange(swapId);
                  }
                  else
                  {
                     AlertManager.showSimpleAlarm("一天只能送一次礼物");
                  }
               });
               break;
            default:
               throw new Error("FUCK!");
         }
      }
      
      private function getSwapInfo(param1:int, param2:Function) : void
      {
         var _loc3_:Array = this._swapCallBacks[param1];
         if(_loc3_ == null)
         {
            _loc3_ = this._swapCallBacks[param1] = [];
         }
         _loc3_.push(param2);
         ActivityExchangeTimesManager.addEventListener(param1,this._getSwapDataBackHandler);
         ActivityExchangeTimesManager.getActiviteTimeInfo(param1);
      }
      
      private function _getSwapDataBackHandler(param1:DataEvent) : void
      {
         var _loc4_:Function = null;
         var _loc2_:SwapTimesInfo = param1.data as SwapTimesInfo;
         ActivityExchangeTimesManager.removeEventListener(_loc2_.dailyID,this._getSwapDataBackHandler);
         var _loc3_:Array = this._swapCallBacks[_loc2_.dailyID];
         if(Boolean(_loc3_) && _loc3_.length > 0)
         {
            for each(_loc4_ in _loc3_)
            {
               if(_loc4_ != null)
               {
                  _loc4_(_loc2_);
               }
            }
            _loc3_.length = 0;
            delete this._swapCallBacks[_loc2_.dailyID];
         }
      }
      
      private function enterProtectedFightGame() : void
      {
         PveEntry.enterTollgate(942,1,1);
      }
      
      private function fightGameSure(param1:Boolean) : void
      {
         ClientTempState.isProtectedFightGameAlert = param1;
         PveEntry.enterTollgate(942,1,1);
      }
      
      private function protecteFightGame() : void
      {
         var _loc1_:String = null;
         if(SystemTimeController.instance.checkSysTimeAchieve(9))
         {
            if(ClientTempState.isProtectedFightGameAlert)
            {
               PveEntry.enterTollgate(942,1,1);
            }
            else
            {
               AlertManager.showSimpleAlert("小侠士合理利用副本中的机关，成功保卫比武大会中的3个石蛙守卫就有机会获得幽冥虎兑换道具。",this.fightGameSure,null,true);
            }
         }
         else
         {
            _loc1_ = SystemTimeController.instance.getActivityOutTimeMsg(9);
            if(Boolean(_loc1_) && _loc1_ != "")
            {
               AlertManager.showSimpleAlarm(_loc1_);
            }
            else
            {
               AlertManager.showSimpleAlarm("亲爱的小侠士，比赛未开始");
            }
         }
      }
      
      private function pvpSideActivity() : void
      {
         if(MainManager.actorInfo.side == 0)
         {
            ModuleManager.turnAppModule("JoinPvpSidePanel");
         }
         else
         {
            ModuleManager.turnAppModule("PvpSideMainPanel");
         }
      }
      
      private function function105561() : void
      {
         if(ActivityExchangeTimesManager.getTimes(this.JOKING_SWIPID) > 0)
         {
            NpcDialogController.hide();
            ModuleManager.turnAppModule("BattleJokingPanel");
         }
         else
         {
            ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchange);
            ActivityExchangeCommander.exchange(this.JOKING_SWIPID);
         }
      }
      
      private function onExchange(param1:ExchangeEvent) : void
      {
         var confirmFunc:Function;
         var dialogs0:String = null;
         var dialogs1:String = null;
         var dialogs2:String = null;
         var dialogs3:String = null;
         var dialogsArr:Array = null;
         var selects:Array = null;
         var event:ExchangeEvent = param1;
         var info:ActivityExchangeAwardInfo = event.info;
         if(info.id == this.JOKING_SWIPID)
         {
            confirmFunc = function():void
            {
               NpcDialogController.hide();
               ModuleManager.turnAppModule("BattleJokingPanel");
            };
            dialogs0 = "我与月老本是专门帮助人间有缘人牵线搭桥的神仙，突然有一天我们遭到黑暗军团的袭击，我身受重伤逃了出来，月老更是为了我被封印住了！呜呜呜。。。";
            dialogs1 = "啊？可恶！又是他们！";
            dialogs2 = "他们还要假冒我们来欺骗众人！小侠士快帮帮我吧！随我一起前往救出月老赶走黑暗军团。";
            dialogs3 = "好！且看我斗一斗那假月老！";
            dialogsArr = [dialogs0,dialogs2];
            selects = [dialogs1,dialogs3];
            NpcDialogController.showForSingles(dialogsArr,selects,10556,confirmFunc);
         }
      }
      
      private function function100012() : void
      {
         var confirmFunc:Function;
         var dialogsArr:Array = null;
         var selects:Array = null;
         var dialogs0:String = "开启无尽之门的小侠士，只要等级达到100级，并且完成了3阶任务，就可转生。";
         var dialogs1:String = "我已经达到条件了。";
         var dialogs2:String = "转生时要六根清净，身无杂物，小侠士需先脱下自身的装备和时装，才可开始转生。";
         var dialogs3:String = "我知道了。";
         var dialogs4:String = "转生后灵魂重置会造成部分记忆丧失，若有已经接取未完成的任务需小侠士重新接取。";
         var dialogs5:String = "我都准备好了。";
         if(ActivityExchangeTimesManager.getTimes(3589) == 0)
         {
            confirmFunc = function():void
            {
               ModuleManager.turnAppModule("TurnBackPanel");
            };
            ActivityExchangeCommander.exchange(3589);
            dialogsArr = [dialogs0,dialogs2,dialogs4];
            selects = [dialogs1,dialogs3,dialogs5];
            NpcDialogController.showForSingles(dialogsArr,selects,10001,confirmFunc);
         }
         else
         {
            ModuleManager.turnAppModule("TurnBackPanel");
         }
      }
      
      private function fun1006616() : void
      {
         var severData:Date = null;
         var onCityAnimatEnd:Function = null;
         onCityAnimatEnd = function(param1:Event):void
         {
            var confirmFunc:Function = null;
            var e:Event = param1;
            confirmFunc = function():void
            {
               if(severData.day < 8 && severData.date > 10)
               {
                  AlertManager.showSimpleAlarm("小侠士只能在11.8-11.10期间每天13:00-14:00 19:00-20:00进入幽都地牢救出姑娘们！");
                  return;
               }
               if(severData.hours >= 13 && severData.hours < 14 && severData.minutes < 60 || severData.hours >= 19 && severData.hours < 20 && severData.minutes < 60)
               {
                  PveEntry.enterTollgate(404);
               }
               else
               {
                  AlertManager.showSimpleAlarm("小侠士只能在11.8-11.10期间每天13:00-14:00 19:00-20:00进入幽都地牢救出姑娘们！");
               }
            };
            var nameStr:String = "雅静,梦洁,梦璐,惠茜,漫妮,语嫣,桑榆,倩雪,香怡,灵芸,倩雪,玉珍,茹雪,正梅,美琳,欢馨,优璇,雨嘉,娅楠,明美,可馨,惠茜,漫妮,香茹,月婵,嫦曦,静香,梦洁,凌薇,美莲,雅静,雪丽,依娜,雅芙,雨婷,怡香,珺瑶,梦瑶,婉婷,睿婕,雅琳,静琪,彦妮,馨蕊,静宸,雪慧,淑颖,乐姗,玥怡,芸熙,钰彤,璟雯,天瑜,婧琪,梦瑶,静宸,诗琪,美萱,雪雁,煜婷,笑怡,优璇,雨嘉,娅楠,雨婷,玥婷,芸萱,馨彤,沛玲,语嫣,凌菲,羽馨,靖瑶,瑾萱,漫妮,灵芸,欣妍,玉珍,茹雪,正梅,美琳,欢馨,优璇,雨嘉,娅楠,明美,可馨,惠茜,漫妮,香茹,月婵,嫦曦,静香,梦洁,凌薇,美莲,雅静,雪丽,韵寒,莉姿,梦璐,沛玲,欣妍,曼玉,歆瑶,凌菲,靖瑶,瑾萱,佑怡";
            var names:Array = nameStr.split(",");
            var index:int = Math.random() * names.length;
            var dialogs0:String = "硕硕小强居然乘冰雪女王失踪将附近的姑娘都掳去幽都地牢了，拜托小侠士前去地牢将<font color=\'#ff0000\'>" + names[index] + "</font>姑娘救出来吧！地牢只在<font color=\'#ff0000\'>11.8-11.10</font>期间每天下午<font color=\'#ff0000\'>13:00-14:00</font> 晚上<font color=\'#ff0000\'>19:00-20:00</font>开放。产出大量仙兽<font color=\'#ff0000\'>飞升材料</font>与<font color=\'#ff0000\'>高级首饰模具</font>，首次救出姑娘更能获得5倍的经验值奖励。";
            var dialogs1:String = "我这就去！";
            NpcDialogController.showForSingles([dialogs0],[dialogs1],10066,confirmFunc);
         };
         severData = TimeUtil.getSeverDateObject();
         if(ActivityExchangeTimesManager.getTimes(3420) == 0)
         {
            ActivityExchangeCommander.exchange(3420);
            AnimatPlay.addAnimatListener(AnimatEvent.ANIMAT_END,onCityAnimatEnd);
            AnimatPlay.startAnimat("qiangmingnv",-1,true,1,0,false,true,false);
         }
         else
         {
            onCityAnimatEnd(null);
         }
      }
      
      private function fun1090000() : void
      {
         var bool:Boolean = false;
         var bool1:Boolean = false;
         var confirmFunc:Function = null;
         var btnIndex0Click:Function = null;
         var btnIndex1Click:Function = null;
         confirmFunc = function():void
         {
            var _loc1_:Array = bool1 ? ["我要兑换奖励","帮老侠士们驱毒要紧"] : ["我要兑换奖励","挑战菊花仙子"];
            var _loc2_:DialogInfoMultiple = new DialogInfoMultiple(["看你这么热心想助我除去村民身上的毒，要是真的成功驱除了，我还可以让你见到菊花仙子。"],_loc1_);
            NpcDialogController.showForMultiple(_loc2_,10066,btnIndex0Click,btnIndex1Click);
            if(bool)
            {
               ActivityExchangeCommander.exchange(3207);
            }
         };
         btnIndex0Click = function():void
         {
            ModuleManager.turnAppModule("ChungYeungFestivalPanel","加载拯救“老侠士”兑换奖励面板......");
         };
         btnIndex1Click = function():void
         {
            var confirmFunc1:Function = null;
            var npc:SightModel = null;
            var mc:MovieClip = null;
            var onEnterFrame:Function = null;
            confirmFunc1 = function():void
            {
               if(ItemManager.getItemCount(1500580) < 20)
               {
                  AlertManager.showSimpleAlarm("小侠士，需要20个" + ItemXMLInfo.getName(1500580) + "才能挑战。");
               }
               else
               {
                  PveEntry.enterTollgate(592);
               }
            };
            if(!bool1)
            {
               confirmFunc1();
               return;
            }
            if(ItemManager.getItemCount(2740106) < 3)
            {
               NpcDialogController.showForSingles(["小侠士还没有去东篱收集满3个仙菊花瓣，我无法为“老侠士”们驱毒。 "],["我这就去东篱收集仙菊花瓣。"],10066);
            }
            else
            {
               onEnterFrame = function(param1:Event):void
               {
                  var _loc2_:String = null;
                  var _loc3_:String = null;
                  var _loc4_:String = null;
                  var _loc5_:String = null;
                  var _loc6_:String = null;
                  var _loc7_:String = null;
                  var _loc8_:String = null;
                  var _loc9_:String = null;
                  var _loc10_:Array = null;
                  var _loc11_:Array = null;
                  if(mc.currentFrame == mc.totalFrames)
                  {
                     _loc2_ = "多谢小侠士的相助，村民们身上的毒已经基本驱除，但离恢复原貌还需要些时日。我刚在驱毒的时候发现一些怪异，这些毒似乎不是出于黑暗军团之手，而是……";
                     _loc3_ = "是谁？";
                     _loc4_ = "是藤儿！那些毒素是藤儿身上才会有的，自腾蛇飞升之后，能力也大幅度提升，但它行为变的怪异，估计是飞升时产生了邪念，正斜两股势力在它体内流窜，平日里也会偶尔的做些坏事，没想到这次居然对村民下手了。";
                     _loc5_ = "那怎么办？";
                     _loc6_ = "只要联合其它小侠士一起将恶念的藤儿战胜就可以了。";
                     _loc7_ = "放心吧，我们一定会战胜的！";
                     _loc8_ = "真是勇敢热心的小侠士，现在你已经帮助我驱除了村民身上的毒，你只要是30级以上的小侠士且准备好20个请神符就可以挑战菊花仙子，战胜有机会获得菊花仙子守护神。";
                     _loc9_ = "挑战菊花仙子";
                     _loc10_ = [_loc2_,_loc4_,_loc6_,_loc8_];
                     _loc11_ = [_loc3_,_loc5_,_loc7_,_loc9_];
                     NpcDialogController.showForSingles(_loc10_,_loc11_,10066,confirmFunc1);
                     npc.player.visible = true;
                     AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,onCityAnimatEnd);
                     if(bool1)
                     {
                        ActivityExchangeCommander.exchange(3227);
                     }
                     mc.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
                     mc.parent.removeChild(mc);
                     mc = null;
                  }
               };
               npc = SightManager.getSightModel(10066);
               npc.player.visible = false;
               mc = UIManager.getMovieClip("UI_laotou");
               mc.x = -10;
               mc.y = 95;
               LayerManager.topLevel.addChild(mc);
               mc.addEventListener(Event.ENTER_FRAME,onEnterFrame);
            }
         };
         bool = ActivityExchangeTimesManager.getTimes(3207) == 0;
         bool1 = ActivityExchangeTimesManager.getTimes(3227) == 0;
         var dialogs0:String = "南瓜怪人回来要说句话？";
         var dialogs1:String = "原来功夫城村民一夜变老是黑暗军团在作祟！";
         var dialogs2:String = "近日有小侠士在附近看到不明黑影闪现，据我猜测，十有八九是黑暗军团，他们对这里的村民下了毒，或许只有“仙菊花瓣”才能解除这种毒，恢复他们原来的样貌了。";
         var dialogs3:String = "我在哪里可以采到仙菊花瓣。";
         var dialogs4:String = "东篱在重阳节期间开满了仙菊，你去采集3个仙菊花瓣过来我就有办法拯救“老侠士”，顺便去调查下真正的下毒凶手是谁。切记因仙菊珍贵，<font color=\'#ff0000\'>每日最多只能采摘10次！</font>";
         var dialogs5:String = "我现在就去。";
         var dialogs8:String = "看你这么热心想助我除去村民身上的毒，要是真的成功驱除了，我还可以让你见到菊花仙子。";
         var dialogsArr:Array = [dialogs0,dialogs2,dialogs4];
         var selects:Array = [dialogs1,dialogs3,dialogs5];
         if(bool)
         {
            NpcDialogController.showForSingles(dialogsArr,selects,10066,confirmFunc);
         }
         else
         {
            confirmFunc();
         }
      }
      
      private function fightThreeHeroPve() : void
      {
         var _loc1_:DialogExInfo = DialogExXmlInfo.getDialogInfoById(8001);
         var _loc2_:DialogAdapter = new DialogAdapter(10410,_loc1_,this.onThreeHeroCallBack);
         _loc2_.show();
      }
      
      private function onThreeHeroCallBack(param1:DialogExInfo) : void
      {
         if(param1.id == 8002)
         {
            if(MainManager.actorInfo.lv < 45)
            {
               AlertManager.showSimpleAlarm("小侠士，必须45级以上才能参加三雄争霸相关活动哦。");
               return;
            }
            if(MainManager.actorInfo.coins < 200000)
            {
               AlertManager.showSimpleAlarm("小侠士，您身上的功夫豆不足20w哦。");
               return;
            }
            if(this.isIgnore)
            {
               PveEntry.enterTollgate(586);
            }
            else
            {
               AlertManager.showSimpleAlert("小侠士，报名三雄争霸需要20w功夫豆，是否继续报名？",this.tipCallBackFunction,null,true);
            }
         }
      }
      
      private function tipCallBackFunction(param1:Boolean) : void
      {
         this.isIgnore = param1;
         PveEntry.enterTollgate(586);
      }
      
      private function exchangeMoonCake() : void
      {
         var _loc1_:DialogExInfo = DialogExXmlInfo.getDialogInfoById(2001);
         var _loc2_:DialogAdapter = new DialogAdapter(10516,_loc1_,this.onPigCallBack);
         _loc2_.show();
      }
      
      private function beatPig() : void
      {
         var _loc1_:DialogExInfo = DialogExXmlInfo.getDialogInfoById(3001);
         var _loc2_:DialogAdapter = new DialogAdapter(10516,_loc1_,this.onBeatPigCallBack);
         _loc2_.show();
      }
      
      private function onBeatPigCallBack(param1:DialogExInfo) : void
      {
         if(param1.id == 3002)
         {
            PveEntry.enterTollgate(584);
         }
      }
      
      private function goGuangHanGong() : void
      {
         var _loc1_:DialogExInfo = DialogExXmlInfo.getDialogInfoById(4001);
         var _loc2_:DialogAdapter = new DialogAdapter(10516,_loc1_);
         _loc2_.show();
      }
      
      private function getPigGod() : void
      {
         if(ItemManager.getItemCount(1500580) >= 20)
         {
            PveEntry.enterTollgate(581);
         }
         else
         {
            AlertManager.showSimpleAlert("请神符不足，是否购买请神符？",this.onPigGodCard);
         }
      }
      
      private function talkToChange() : void
      {
         var _loc1_:DialogExInfo = DialogExXmlInfo.getDialogInfoById(6001);
         var _loc2_:DialogAdapter = new DialogAdapter(10517,_loc1_,this.onTalkToChangeCallBack);
         _loc2_.show();
      }
      
      private function onTalkToChangeCallBack(param1:DialogExInfo) : void
      {
         if(param1.id == 6002)
         {
            PveEntry.enterTollgate(583);
         }
      }
      
      private function useTuzi() : void
      {
         if(ItemManager.getItemCount(2740088) > 0)
         {
            ItemManager.useItem(2740088);
         }
         else
         {
            AlertManager.showSimpleAlarm("小侠士，您身上的没有兔子变身符，无法变身。");
         }
      }
      
      private function beatChange() : void
      {
         if(ItemManager.getItemCount(1500580) >= 20)
         {
            PveEntry.enterTollgate(582);
         }
         else
         {
            AlertManager.showSimpleAlert("请神符不足，是否购买请神符？",this.onPigGodCard);
         }
      }
      
      private function onPigGodCard() : void
      {
         ModuleManager.turnModule(ClientConfig.getAppModule("Mall"),"正在加载",{"targetHintIconID":1700107});
      }
      
      private function loveRabbit() : void
      {
         var _loc1_:DialogExInfo = DialogExXmlInfo.getDialogInfoById(5001);
         var _loc2_:DialogAdapter = new DialogAdapter(10516,_loc1_,this.onLoveRabbitCallBack);
         _loc2_.show();
      }
      
      private function onLoveRabbitCallBack(param1:DialogExInfo) : void
      {
         if(param1.id == 5002)
         {
            if(ItemManager.getItemCount(2740088) > 0)
            {
               ItemManager.useItem(2740088);
            }
            else
            {
               AlertManager.showSimpleAlarm("小侠士，你身上的没有兔子变身符，无法变身。");
            }
         }
      }
      
      private function onPigCallBack(param1:DialogExInfo) : void
      {
         if(param1.id == 2002)
         {
            ModuleManager.turnAppModule("BigMoonCakePanel");
         }
      }
      
      private function onFirstStudentFight() : void
      {
         ModuleManager.turnAppModule("FirstStudentFightPanel");
      }
      
      private function handleShangGuBaoTu() : void
      {
         var _loc1_:int = 0;
         if(MainManager.actorInfo.lv < 30)
         {
            AlertManager.showSimpleAlarm("小侠士，必须达到30级才能进行上古宝图活动。");
            return;
         }
         for each(_loc1_ in SHANGE_GU_TASKIDS)
         {
            if(TasksManager.isAccepted(_loc1_))
            {
               AlertManager.showSimpleAlarm("小侠士，您已经接取了一个上古宝图活动任务，请先完成哦。");
               return;
            }
         }
         if(ActivityExchangeTimesManager.getTimes(2983) >= 5)
         {
            AlertManager.showSimpleAlarm("小侠士，上古宝图系列任务每天只能完成五次哦。");
            return;
         }
         var _loc2_:DialogExInfo = DialogExXmlInfo.getDialogInfoById(1001);
         var _loc3_:DialogAdapter = new DialogAdapter(10022,_loc2_,this.shangGuBaoZhangCallBack);
         _loc3_.show();
      }
      
      private function shangGuBaoZhangCallBack(param1:DialogExInfo) : void
      {
         var _loc2_:int = parseInt(param1.params);
         TasksManager.accept(_loc2_,false,CommandID.TASK_ACTIVITY_ACCEPT);
      }
      
      private function function100227() : void
      {
         if(MainManager.actorInfo.lv < 30)
         {
            AlertManager.showSimpleAlarm("小侠士，必须达到30级才能参加仙兽宝图活动。");
            return;
         }
         var _loc1_:uint = 2024;
         while(_loc1_ <= 2027)
         {
            if(TasksManager.isAccepted(_loc1_))
            {
               AlertManager.showSimpleAlarm("小侠士，您已经接取了一个仙兽宝图活动任务，请先完成哦。");
               return;
            }
            _loc1_++;
         }
         if(ActivityExchangeTimesManager.getTimes(3131) >= 5)
         {
            AlertManager.showSimpleAlarm("小侠士，仙兽宝图系列任务每天只能完成五次哦。");
            return;
         }
         var _loc2_:DialogExInfo = DialogExXmlInfo.getDialogInfoById(7001);
         var _loc3_:DialogAdapter = new DialogAdapter(10022,_loc2_,this.acceptSummonTrea);
         _loc3_.show();
      }
      
      private function wanShenDian() : void
      {
         var _loc1_:DialogExInfo = DialogExXmlInfo.getDialogInfoById(15001);
         var _loc2_:DialogAdapter = new DialogAdapter(10562,_loc1_,this.wanShenDianErJi);
         _loc2_.show();
      }
      
      private function wanShenDianErJi(param1:DialogExInfo) : void
      {
         switch(param1.id)
         {
            case 15002:
               CityMap.instance.changeMap(1062);
               break;
            case 15003:
               ModuleManager.turnAppModule("WanShenDianTurnPanel");
         }
      }
      
      private function acceptSummonTrea(param1:DialogExInfo) : void
      {
         var _loc2_:int = 0;
         if(param1.params)
         {
            _loc2_ = parseInt(param1.params);
            TasksManager.accept(_loc2_,false,CommandID.TASK_ACTIVITY_ACCEPT);
            ActivityExchangeTimesManager.updataTimesByOnce(3131);
         }
      }
      
      private function func1051402() : void
      {
         var leftTime:int = 0;
         var dialogs:String = "牛郎织女拜托小侠士在七夕期间，将爱传播给艾尔大陆的每个人，一起分享他们的快乐。事成之后，小侠士还能得到不菲的奖赏哦！";
         leftTime = 7 - ActivityExchangeTimesManager.getTimes(2796);
         var selects:Array = ["乐意效劳（每天可传递7次，当前剩余" + leftTime + "次）"];
         var multiDialog:DialogInfoMultiple = new DialogInfoMultiple([dialogs],selects);
         NpcDialogController.showForMultiple(multiDialog,10514,function():void
         {
            if(leftTime <= 0)
            {
               AlertManager.showSimpleAlarm("小侠士，你今天已经进行了7次爱的传播，请注意身体，休息一下明天再来吧！");
               return;
            }
            EscortManager.instance.selectEscortType(0,EscortManager.LOVE_TRANS_TYPE);
         });
      }
      
      private function func1045601() : void
      {
         var dialogs:String = "小侠士组成<font color=\'#FF0000\'>两人队伍</font>后，合力施法使魔界邪神显形，大战邪神时会有奇遇发生哦！还有机会赢得转生装备材料！";
         var selects:Array = ["2人组队大战邪神","捉拿魔界邪神入活动说明"];
         var multiDialog:DialogInfoMultiple = new DialogInfoMultiple([dialogs],selects);
         NpcDialogController.showForMultiple(multiDialog,10066,function():void
         {
            CatchBigGhostManager.instance.signUp();
         },function():void
         {
            ModuleManager.turnAppModule("CatchBigGhostExplainPanel");
         });
      }
      
      private function func1045603() : void
      {
         var dialogs:String = "两人组队的侠士可由队长来领取神器并合力施法使魔界邪神显形，大战邪神时更会有奇遇发生！更能赢得传说中珍藏大量仙兽材料的古天庭宝箱，以及大量装备材料、铁匠装备！";
         var selects:Array = ["两人组队大战上古魔神","活动说明"];
         var multiDialog:DialogInfoMultiple = new DialogInfoMultiple([dialogs],selects);
         NpcDialogController.showForMultiple(multiDialog,10066,function():void
         {
            if(ActivityExchangeTimesManager.getTimes(3590) >= 10)
            {
               AlertManager.showSimpleAlarm("你今日参与活动已达10次上限，明天再来吧！");
               return;
            }
            CatchBigGhostManager.instance.signUp();
         },function():void
         {
            ModuleManager.turnAppModule("CatchBigGhostExplainPanel");
         });
      }
      
      private function func1006661() : void
      {
         var dialogs:Array = ["小侠士也是准备前往盘古大殿帮助人族与仙族共同御敌的吗？就让老夫送你们过去吧！"];
         var selects:Array = ["多谢剑仙！"];
         NpcDialogController.showForSingles(dialogs,selects,10066,function():void
         {
            CityMap.instance.changeMap(1052);
         });
      }
      
      private function func1045602() : void
      {
         var bool:Boolean = false;
         bool = ActivityExchangeTimesManager.getTimes(3196) == 0;
         var dialogs:Array = bool ? ["国庆期间，人声鼎沸，一片欢腾，可是。。。","黑暗军团他们仿制上古神兽制造了上古魔兽，并唤醒了上古魔神，想借此机会侵入艾尔大陆，毁坏这里。","他们会在12:00~20:00每隔15分钟出现一次，上古魔兽的身上还携带着首饰大师所需的材料。","这些首饰材料可不多见，但他们携带已久，沾染上了魔气，已经失去了灵力，你要是能拿回来我会有丰厚的奖励回报你哦。","为了确保小侠士们的安全，30级以上才可参与，还要记清楚上古魔兽出现的时间是12:00~20:00每隔15分钟出现一次。"] : ["为了确保小侠士们的安全，30级以上才可参与，还要记清楚上古魔兽出现的时间是12:00~20:00每隔15分钟出现一次。"];
         var selects:Array = bool ? ["发生了什么？","啊！他们什么时候来，有什么办法阻止？","首饰材料？","我一定会消灭他们拿到材料的。","驱除上古魔兽。"] : ["驱除上古魔兽。"];
         NpcDialogController.showForSingles(dialogs,selects,10066,function():void
         {
            ModuleManager.turnAppModule("CatachGhostIntroducePanel");
            if(bool)
            {
               ActivityExchangeCommander.exchange(3196);
            }
         });
      }
      
      private function func1053701() : void
      {
         ModuleManager.turnAppModule("DigTreasurePanel");
      }
      
      private function setTeamTask(param1:uint) : void
      {
         var _loc2_:uint = 0;
         if(TeamTaskManager.instance.taskType != 0 && TeamTaskManager.instance.taskType != param1)
         {
            AlertManager.showSimpleAlarm("小侠士，你已经接取了初探仙界的任务，请完成后再来接取下一个吧！");
            return;
         }
         if(MainManager.actorInfo.lv < 30)
         {
            AlertManager.showSimpleAlarm("只有达到30级的小侠士才有能力接取初探仙界的任务。");
            return;
         }
         switch(param1)
         {
            case 1:
               _loc2_ = 1045;
               break;
            case 2:
               _loc2_ = 1046;
               break;
            case 3:
               _loc2_ = 1047;
         }
         CityMap.instance.changeMap(_loc2_);
      }
      
      private function handleDayHappy() : void
      {
         if(MainManager.actorInfo.lv < 10)
         {
            AlertManager.showSimpleAlarm("小侠士，到达10级就可以来参与活动了哦！");
            return;
         }
         if(MainManager.actorInfo.coins < 100000)
         {
            AlertManager.showSimpleAlarm("小侠士你功夫豆不够哦，交付10万功夫豆剑仙爷爷才放心让你送蟠桃。");
            return;
         }
         var _loc1_:String = "天降祥瑞，众仙齐聚艾尔大陆，为艾尔大陆人民带来仙界蟠桃。这些仙界蟠桃代表着众仙的祝福，需要送给各大陆的居民，小侠士愿意帮忙送蟠桃吗？成功送到将有惊喜奖励！";
         var _loc2_:Array = ["什么奖励呢？好期待！"];
         var _loc3_:DialogInfoMultiple = new DialogInfoMultiple([_loc1_],_loc2_);
         NpcDialogController.showForMultiple(_loc3_,10066,this.puTianTongQinYaBiao);
      }
      
      private function puTianTongQinYaBiao() : void
      {
         var leftTime:int = 5 - ActivityExchangeTimesManager.getTimes(2953);
         if(leftTime <= 0)
         {
            AlertManager.showSimpleAlarm("小侠士，你今天已经进行了5次普天同庆送祝福，请注意身体，休息一下明天再来吧！");
            return;
         }
         AlertManager.showSimpleAlert("小侠士运送代表祝福的蟠桃需要10万功夫豆哦，成功将获得丰厚回报。你今天还有" + leftTime + "次运送机会！",function():void
         {
            EscortManager.instance.selectEscortType(0,EscortManager.PU_TIAN_TONG_QING);
         });
      }
      
      private function handleWestTreasure() : void
      {
         var _loc1_:String = "两人组队的侠士可由队长来领取仙器并合力施法使盗走秘宝的黑暗魔将显形，大战魔将时更会有奇遇发生！更能赢得传说中珍藏的大量仙兽飞升材料和饰品模具的万圣节宝箱，以及大量的项链、戒指模具和火凤凰进阶材料。";
         var _loc2_:Array = ["2人组队西部秘宝","众仙齐聚之西部秘宝活动说明"];
         var _loc3_:DialogInfoMultiple = new DialogInfoMultiple([_loc1_],_loc2_);
         NpcDialogController.showForMultiple(_loc3_,10066,this.startWestTreasure,this.westTreasureDes);
      }
      
      private function handleWuTouQiShi() : void
      {
         if(!SystemTimeController.instance.checkSysTimeAchieve(155))
         {
            SystemTimeController.instance.showOutTimeAlert(155);
            return;
         }
         var _loc1_:DialogExInfo = DialogExXmlInfo.getDialogInfoById(9001);
         var _loc2_:DialogAdapter = new DialogAdapter(10066,_loc1_,this.onWuTouCallBack);
         _loc2_.show();
      }
      
      private function onWuTouCallBack(param1:DialogExInfo) : void
      {
         if(param1.id == 9002)
         {
            CatchBigGhostManager.instance.signUp();
         }
      }
      
      private function startWestTreasure() : void
      {
         CatchBigGhostManager.instance.signUp();
      }
      
      private function westTreasureDes() : void
      {
         ModuleManager.turnAppModule("XiBuMiBaoPanel");
      }
      
      private function blackPvp2v2() : void
      {
         if(!SystemTimeController.instance.checkSysTimeAchieve(133))
         {
            SystemTimeController.instance.showOutTimeAlert(133);
            return;
         }
         AlertManager.showSimpleAlert("每场比赛队长和队员各缴纳50万功夫豆参赛费，是否继续？",function():void
         {
            ModuleManager.turnAppModule("MultBlackiPvpSignPanel");
         });
      }
      
      private function killSnake() : void
      {
         var _loc1_:int = int(ItemManager.getItemCount(1500580));
         if(_loc1_ <= 0)
         {
            AlertManager.showSimpleAlarm("请神符不足，无法配制雄黄酒！");
            return;
         }
         ActivityExchangeCommander.exchange(2565);
      }
      
      private function get isJoinBull() : Boolean
      {
         return ActivityExchangeTimesManager.getTimes(2571) == 1;
      }
      
      private function get isJoinBear() : Boolean
      {
         return ActivityExchangeTimesManager.getTimes(2573) == 1;
      }
      
      private function get isJoinFish() : Boolean
      {
         return ActivityExchangeTimesManager.getTimes(2572) == 1;
      }
      
      private function showActiveDialog() : void
      {
         var _loc2_:Array = null;
         var _loc1_:String = "为纪念投河的古代先烈，铸剑谷每年都会举办龙舟赛跑大赛。今年龙舟大赛我们邀请了三位大力士：玄铁铺震烁、牛角、熊震三兄弟担任三支队伍队长，由他们来决出队伍胜负，但划龙舟是个力气活，需要大量五彩仙粽提供力气，你可以加入一支队伍，帮助队长哦！";
         var _loc3_:Boolean = false;
         if(this.isJoinBear || this.isJoinFish || this.isJoinBull)
         {
            _loc2_ = ["捐献五彩仙粽","规则说明级奖励说明"];
            _loc3_ = true;
         }
         else
         {
            _loc2_ = ["报名参赛","规则说明级奖励说明"];
         }
         var _loc4_:DialogInfoMultiple = new DialogInfoMultiple([_loc1_],_loc2_);
         if(_loc3_)
         {
            NpcDialogController.showForMultiple(_loc4_,10065,this.onApply,this.onInfo);
         }
         else
         {
            NpcDialogController.showForMultiple(_loc4_,10065,this.onJoin,this.onInfo);
         }
      }
      
      private function onJoin() : void
      {
         ModuleManager.closeAllModule();
         ModuleManager.turnAppModule("DragonBoatModule");
      }
      
      private function onApply() : void
      {
         ModuleManager.closeAllModule();
         ModuleManager.turnAppModule("DragonBoatModule");
      }
      
      private function onInfo() : void
      {
         ModuleManager.closeAllModule();
         ModuleManager.turnAppModule("DragonDescriptionPanel");
      }
      
      public function playCityAnimat(param1:int) : void
      {
         if(param1 == 3)
         {
            this.onCityAnimatEnd(param1);
         }
         else
         {
            AnimatPlay.addAnimatListener(AnimatEvent.ANIMAT_END,this.onCityAnimatEnd);
            AnimatPlay.startAnimat("CityWar_",param1,true,1,0,false,true,false);
            if(param1 == 2)
            {
               AnimatPlay.addAnimatListener(AnimatEvent.ANIMAT_START,this.onCityAnimatStart);
            }
         }
      }
      
      private function checkMayDayAward() : void
      {
         if(!MainManager.actorInfo.isVip)
         {
            AlertManager.showSimpleAlarm("小侠士，成为超灵侠士才可领取哦!");
            return;
         }
         var _loc1_:uint = uint(ActivityExchangeTimesManager.getTimes(2464));
         if(_loc1_ > 0)
         {
            AlertManager.showSimpleAlarm("小侠士，做人不能贪心哦!");
            return;
         }
         ActivityExchangeCommander.exchange(2464);
      }
      
      public function onCityAnimatEnd(param1:Object) : void
      {
         var _loc2_:int = 0;
         if(param1 == 3)
         {
            _loc2_ = 3;
         }
         else
         {
            AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onCityAnimatEnd);
            _loc2_ = int(param1.data.slice(8));
            if(_loc2_ == 0)
            {
               this.playCityAnimat(1);
            }
            else if(_loc2_ == 1)
            {
               this.playCityAnimat(2);
            }
            else if(_loc2_ == 2)
            {
               if(ActivityExchangeTimesManager.getTimes(2364) == 0)
               {
                  _loc2_ = 3;
                  ActivityExchangeCommander.exchange(2364);
               }
            }
         }
      }
      
      public function onCityAnimatStart(param1:AnimatEvent) : void
      {
         AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_START,this.onCityAnimatStart);
         AnimatPlay.getAnimat().addEventListener("gotoTollgate",this.gotoTollgate);
         FightManager.instance.addEventListener(FightEvent.WINNER,this.onWinner);
      }
      
      private function onWinner(param1:FightEvent) : void
      {
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onWinner);
         this.isWinner = true;
      }
      
      private function fightQuiteHandler(param1:FightEvent) : void
      {
         FightManager.instance.removeEventListener(FightEvent.QUITE,this.fightQuiteHandler);
         var _loc2_:MovieClip = AnimatPlay.getAnimat();
         if(MapManager.mapInfo.id == 1067601 || MapManager.mapInfo.id == 1067701 || MapManager.mapInfo.id == 1067801)
         {
            if(this.isWinner)
            {
               if(_loc2_.parent == null)
               {
                  LayerManager.root.addChild(_loc2_);
               }
               _loc2_.play();
               FightManager.instance.addEventListener(FightEvent.WINNER,this.onWinner);
            }
            else
            {
               AnimatPlay.getAnimat().removeEventListener("gotoTollgate",this.gotoTollgate);
               AnimatPlay.destory();
            }
         }
      }
      
      private function gotoTollgate(param1:Event) : void
      {
         FightManager.instance.addEventListener(FightEvent.QUITE,this.fightQuiteHandler);
         var _loc2_:MovieClip = AnimatPlay.getAnimat();
         if(_loc2_.parent)
         {
            _loc2_.parent.removeChild(_loc2_);
         }
         if(AnimatPlay.getAnimat().currentFrame == 185)
         {
            PveEntry.instance.enterTollgate(676);
         }
         else if(AnimatPlay.getAnimat().currentFrame == 218)
         {
            PveEntry.instance.enterTollgate(677);
         }
         else
         {
            PveEntry.instance.enterTollgate(678);
         }
      }
      
      private function func_1040212() : void
      {
         var _loc1_:int = int(MainManager.actorInfo.lv);
         if(_loc1_ < 30)
         {
            AlertManager.showSimpleAlarm("亲爱的小侠士，你的等级不够哦，30级后再来吧。");
            return;
         }
         ModuleManager.turnAppModule("LaGrandChefPanel","加载中......");
      }
      
      private function check104361() : Boolean
      {
         if(EscortManager.instance.checkLimit())
         {
            return false;
         }
         if(MainManager.actorInfo.lv < 45)
         {
            AlertManager.showSimpleAlarm("小侠士修炼到45级再来吧！");
            return false;
         }
         var _loc1_:uint = MainManager.actorInfo.isVip ? 5 : 3;
         var _loc2_:uint = uint(EscortXMLInfo.getSwapID(35));
         if(ActivityExchangeTimesManager.getTimes(_loc2_) >= _loc1_)
         {
            AlertManager.showSimpleAlarm("亲亲小侠士不能贪心哦，你今天已经送了好几次了！");
            return false;
         }
         return true;
      }
      
      private function func104361() : void
      {
         var swapID:uint = 0;
         var dialogs:Array = ["亲亲小侠士你真的能帮我把这些礼物送给倚天塔的小公鸡喔喔哦？","路上可是会遇到我的情敌派来的烈焰灵猿，不过你若能战胜它们，那真真是极好的，而且有可能获得灵猿的哦！"];
         var selects:Array = ["放心吧，我这就去！","（浑身起鸡皮疙瘩中。。。）我。。。我这就去！"];
         swapID = uint(EscortXMLInfo.getSwapID(35));
         NpcDialogController.showForSingles(dialogs,selects,10436,function():void
         {
            EscortManager.instance.selectEscortType(swapID,EscortManager.SAVE_VILLAGER);
         });
      }
      
      private function func1044601() : void
      {
         var _loc1_:Array = ["春","夏","秋","冬","梅","兰","竹","菊","小"];
         var _loc2_:Array = ["香","萱","嫣","然","惠","雅","倩","蕾","妮"];
         var _loc3_:int = Math.ceil(8 * Math.random());
         var _loc4_:int = Math.ceil(8 * Math.random());
         var _loc5_:String = _loc1_[_loc3_] + _loc2_[_loc4_];
         var _loc6_:Array = ["白山老妖强抢了一名叫<font color=\'#E59110\'>" + _loc5_ + "</font>的女孩，侠士速去营救。每次进入幽冥死牢会对地府轮回殿造成损耗，还劳烦侠士每次支付10万功夫豆给本王进行日常维护。"];
         var _loc7_:Array = ["前往白山老妖巢穴"];
         var _loc8_:DialogInfoMultiple = new DialogInfoMultiple([_loc6_],_loc7_);
         NpcDialogController.showForMultiple(_loc8_,10446,this.func1044602);
      }
      
      private function func1010401() : void
      {
         var _loc1_:String = "进入阴曹地府可不是开玩笑的，为了保你一路平安，交给我20000功夫豆，我帮你在地府打点一切，你愿意吗？";
         var _loc2_:Array = ["这点钱，小意思，给我塞牙缝都不够……","骗子，不需要你的打点，本小侠士不去了！"];
         var _loc3_:DialogInfoMultiple = new DialogInfoMultiple([_loc1_],_loc2_);
         NpcDialogController.showForMultiple(_loc3_,10104,this.goSelects,this.notGoSelects);
      }
      
      private function func1010301() : void
      {
         var _loc1_:String = "进入阴曹地府可不是开玩笑的，为了保你一路平安，交给我20000功夫豆，我帮你在地府打点一切，你愿意吗？";
         var _loc2_:Array = ["这点钱，小意思，给我塞牙缝都不够……","骗子，不需要你的打点，本小侠士不去了！"];
         var _loc3_:DialogInfoMultiple = new DialogInfoMultiple([_loc1_],_loc2_);
         NpcDialogController.showForMultiple(_loc3_,10103,this.goSelects,this.notGoSelects);
      }
      
      private function func1010302() : void
      {
         if(MainManager.actorInfo.roleType == 7)
         {
            AlertManager.showSimpleAlarm("小侠士，天策暂时还未开放南瓜帽兑换哦！");
            return;
         }
         ModuleManager.turnAppModule("MelonHatPrivilegePanel");
      }
      
      private function goSelects() : void
      {
         if(MainManager.actorInfo.coins > 20000)
         {
            AnimatPlay.startAnimat("exchange2423_",1,false,0,0,false,true);
            AnimatPlay.addAnimatListener(AnimatEvent.ANIMAT_END,this.on2423AnimatEnd);
         }
         else
         {
            AlertManager.showSimpleAlarm("小侠士，在功夫派20000功夫豆都没有的人会错过很多精彩游戏哦，加油吧，看好你！！！");
         }
      }
      
      private function on2423AnimatEnd(param1:Event) : void
      {
         ActivityExchangeCommander.exchange(2423);
         var _loc2_:TransportPoint = new TransportPoint();
         _loc2_.mapId = 1037;
         _loc2_.pos = new Point(813,743);
         CityMap.instance.tranChangeMap(_loc2_);
      }
      
      private function notGoSelects() : void
      {
         NpcDialogController.hide();
      }
      
      private function breakWedding() : void
      {
         NpcDialogController.hide();
         SocketConnection.addCmdListener(CommandID.ACTIVITY_EXCHANGE_TIMES,this.onGetSwapActionTime);
         SocketConnection.send(CommandID.ACTIVITY_EXCHANGE_TIMES);
      }
      
      private function onGetSwapActionTime(param1:SocketEvent) : void
      {
         var _loc3_:Array = null;
         var _loc4_:DialogInfoMultiple = null;
         (param1.data as ByteArray).position = 0;
         SocketConnection.removeCmdListener(CommandID.ACTIVITY_EXCHANGE_TIMES,this.onGetSwapActionTime);
         ActivityExchangeTimesManager.readForLogin(param1.data as ByteArray);
         var _loc2_:String = "6月28—7月11日每天<font color=\"#FF0000\">13:00-14:00</font>抢走艾尔大陆第一美女的黑龙大圣出现在桃花源，众侠士可去解救美女，赢取惊喜回报！";
         var _loc5_:int = BreakWeddingFeather.hasSelectId();
         if(_loc5_ == 0 || ActivityExchangeTimesManager.getTimes(1935) == 0)
         {
            _loc3_ = ["“大圣”抢亲来龙去脉","前往桃花源","活动说明"];
            _loc4_ = new DialogInfoMultiple([_loc2_],_loc3_);
            NpcDialogController.showForMultiple(_loc4_,10402,this.breakWeddingInfo,this.gotoWeddingPlace,this.breakWeddingInfo2);
         }
         else
         {
            _loc3_ = ["“大圣”抢亲来龙去脉","前往桃花源","活动说明","领取“大圣”抢亲奖励"];
            _loc4_ = new DialogInfoMultiple([_loc2_],_loc3_);
            NpcDialogController.showForMultiple(_loc4_,10402,this.breakWeddingInfo,this.gotoWeddingPlace,this.breakWeddingInfo2,this.getWeddingAward);
         }
      }
      
      private function breakWeddingInfo2() : void
      {
         NpcDialogController.hide();
         ModuleManager.turnAppModule("BreakWeddingInfoPanel");
      }
      
      private function getWeddingAward() : void
      {
         ServerUniqDataManager.addListener(ServerUniqDataEvent.EVENT_GAOCHAN_ICE,this.onServerData);
         ServerUniqDataManager.requestDateByType(ServerUniqDataManager.TYPE_ICE_NUM);
      }
      
      private function onServerData(param1:ServerUniqDataEvent) : void
      {
         var _loc8_:SwapActionLimitInfo = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Date = null;
         ServerUniqDataManager.removeListener(ServerUniqDataEvent.EVENT_GAOCHAN_ICE,this.onServerData);
         var _loc2_:int = BreakWeddingFeather.hasSelectId();
         if(_loc2_ == 0)
         {
            return;
         }
         var _loc3_:int = _loc2_ + 100544;
         var _loc4_:ServerUniqDataInfo = param1.serverUniqDataInfo;
         var _loc5_:Vector.<SwapActionLimitInfo> = _loc4_.infoArr;
         var _loc6_:int = int(_loc5_.length);
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc8_ = _loc5_[_loc7_];
            _loc9_ = int(TimeUtil.getSeverDayIndex());
            _loc10_ = _loc9_ % 3 + 100545;
            if(_loc8_.dailyID == _loc3_)
            {
               if(_loc8_.limitCount == 0)
               {
                  if(_loc10_ == _loc3_)
                  {
                     if(ActivityExchangeTimesManager.getTimes(2628) == 0)
                     {
                        ActivityExchangeCommander.exchange(2628);
                     }
                     else
                     {
                        AlertManager.showSimpleAlarm("小侠士，该奖励只能领取一次哦。");
                     }
                  }
                  else if(ActivityExchangeTimesManager.getTimes(2629) == 0)
                  {
                     ActivityExchangeCommander.exchange(2629);
                  }
                  else
                  {
                     AlertManager.showSimpleAlarm("小侠士，该奖励只能领取一次哦。");
                  }
               }
               else
               {
                  _loc11_ = TimeUtil.getSeverDateObject();
                  if(_loc11_.hours > 12 && _loc11_.hours < 14)
                  {
                     AlertManager.showSimpleAlarm("小侠士，大圣抢亲活动尚未结束，快去桃花源抢回杰西卡吧！");
                  }
                  else if(ActivityExchangeTimesManager.getTimes(2629) == 0)
                  {
                     ActivityExchangeCommander.exchange(2629);
                  }
                  else
                  {
                     AlertManager.showSimpleAlarm("小侠士，该奖励只能领取一次哦。");
                  }
               }
            }
            _loc7_++;
         }
      }
      
      private function awardWedding() : void
      {
         AlertManager.showSimpleAlarm("领取抢亲奖励");
      }
      
      private function breakWeddingInfo() : void
      {
         NpcDialogController.hide();
         ModuleManager.turnAppModule("BreakWeddingDesPanel");
      }
      
      private function gotoWeddingPlace() : void
      {
         CityMap.instance.changeMap(1043);
      }
      
      private function func1040214() : void
      {
         var _loc1_:String = "昔日屈原怀沙忠死，后人每年以五彩仙粽祭奠之。我这里正好有许多五彩仙粽，需要用五彩仙绳来换取。答对我出的题目能获得五彩仙绳，你愿意试试吗？";
         var _loc2_:Array = ["开始答题","活动规则","换取五彩仙粽"];
         var _loc3_:DialogInfoMultiple = new DialogInfoMultiple([_loc1_],_loc2_);
         NpcDialogController.showForMultiple(_loc3_,10402,this.startGame,this.explainGame,this.exchangeZong);
      }
      
      private function startGame() : void
      {
         if(MainManager.actorInfo.lv < 30)
         {
            AlertManager.showSimpleAlarm("小侠士，参加该活动的最低等级为30级，你的等级还不够！");
            return;
         }
         if(ActivityExchangeTimesManager.getTimes(2574) >= 15)
         {
            AlertManager.showSimpleAlarm("今天你已经完成答题了，大量经验和五彩仙绳，明天继续等你拿哦！");
            return;
         }
         ModuleManager.turnAppModule("AnswerForZongzi");
      }
      
      private function explainGame() : void
      {
         ModuleManager.turnAppModule("AnswerForZongziExplain");
      }
      
      private function exchangeZong() : void
      {
         if(ItemManager.getItemCount(1500714) <= 0)
         {
            AlertManager.showSimpleAlarm("很遗憾你没有五彩仙绳，万通通还不能将五彩仙棕给你。");
            return;
         }
         ActivityExchangeCommander.exchange(2578);
      }
      
      private function func1040217() : void
      {
         var dialogs:String = "据可靠消息，黑暗军团经过精心筹划，倾巢而出，准备抢夺庆典宝藏。小侠士你是否愿意来守卫庆典宝藏，守卫成功将获得丰厚奖励！";
         var selects:Array = ["庆典宝藏守卫战","庆典宝藏守卫战规则说明"];
         var multiDialog:DialogInfoMultiple = new DialogInfoMultiple([dialogs],selects);
         NpcDialogController.showForMultiple(multiDialog,10402,function():void
         {
            if(MainManager.actorInfo.lv < 30)
            {
               AlertManager.showSimpleAlarm("小侠士，你还没满30级，不能参加该战斗。");
               return;
            }
            if(MainManager.actorInfo.coins < 100000)
            {
               AlertManager.showSimpleAlarm("小侠士，参加庆典宝藏守卫战需要消耗10万功夫豆，你功夫豆不足！");
               return;
            }
            if(FightGroupManager.instance.groupId == 0)
            {
               PveEntry.enterTollgate(558);
            }
            else if(FightGroupManager.instance.groupUserList.length == 2)
            {
               if(FightGroupManager.instance.myIsTheLeader)
               {
                  TeamAutoFightManager.instance.signPVE(558);
               }
               else
               {
                  AlertManager.showSimpleAlarm("小侠士，你不是队长不能报名，若要单独挑战请先解散组队。");
               }
            }
            else
            {
               AlertManager.showSimpleAlarm("小侠士，你组的不是两人队伍，不能进入战斗，若要单独挑战请先解散组队。");
            }
         },function():void
         {
            ModuleManager.turnAppModule("ThreeYearsFightExplainPanel");
         });
      }
      
      private function func1044602() : void
      {
         AlertManager.showSimpleAlert("每次进入幽冥死牢会对地府轮回殿造成损耗，还劳烦侠士每次支付10万功夫豆给本王进行日常维护。",function():void
         {
            if(MainManager.actorInfo.coins < 100000)
            {
               AlertManager.showSimpleAlarm("小侠士，你的功夫豆不足十万！");
               return;
            }
            MainManager.actorInfo.coins -= 100000;
            if(Math.random() < 0.5)
            {
               PveEntry.enterTollgate(501);
            }
            else
            {
               PveEntry.enterTollgate(502);
            }
         });
      }
      
      private function func1044603() : void
      {
         var _loc1_:String = "4月3日至4月11日，两位小侠士各自领取法器" + TextFormatUtil.getRedText("桃木剑") + "与" + TextFormatUtil.getRedText("八卦镜") + "，在正确的地图中使用法器即可施展八卦两仪阵前去捉拿鬼王，有几率驯化燃眉小鬼！中途更有可能发生奇遇！需要两人组队才能参与！";
         var _loc2_:Array = ["领取法器","我要换另一个法器"];
         var _loc3_:DialogInfoMultiple = new DialogInfoMultiple([_loc1_],_loc2_);
         NpcDialogController.showForMultiple(_loc3_,10446,this.getItem,this.exchangeItem);
      }
      
      private function getItem() : void
      {
         if(MainManager.actorInfo.lv < 30)
         {
            AlertManager.showSimpleAlarm("小侠士，参加该活动的最低等级为30级，你的等级还不够！");
            return;
         }
         AlertManager.showSimpleAlert("领取法器需要消耗一个请神符，是否确认领取",function():void
         {
            ActivityExchangeCommander.exchange(CatchBigGhostManager.GET_ITEM_ID);
         });
      }
      
      private function exchangeItem() : void
      {
         if(!CatchBigGhostManager.instance.hasItemForGhost())
         {
            AlertManager.showSimpleAlarm("小侠士，你现在还没有法器，领取法器后再来兑换吧！");
            return;
         }
         if(ItemManager.getItemCount(1570015) > 0)
         {
            ActivityExchangeCommander.exchange(CatchBigGhostManager.ITEM_EXCHANGE_0);
         }
         else if(ItemManager.getItemCount(1570014) > 0)
         {
            ActivityExchangeCommander.exchange(CatchBigGhostManager.ITEM_EXCHANGE_1);
         }
      }
      
      private function func1043001() : void
      {
         if(MainManager.actorInfo.lv < 60)
         {
            AlertManager.showSimpleAlarm("小侠士，等练到60级再去前往黑暗武斗场吧！");
            return;
         }
         var _loc1_:String = "这个场子是我罩的，想进去先拿50万功夫豆意思意思！";
         var _loc2_:Array = ["（真够黑，不过我还是想一探究竟）给你。","切，我才不稀罕呢！"];
         var _loc3_:DialogInfoMultiple = new DialogInfoMultiple([_loc1_],_loc2_);
         NpcDialogController.showForMultiple(_loc3_,10430,this.enterMap);
      }
      
      private function enterMap() : void
      {
         if(MainManager.actorInfo.coins > 500000)
         {
            if(RideManager.isOnRide)
            {
               MainManager.actorModel.execBehavior(new ChangeRoleBehavior(0,true));
            }
            CityMap.instance.changeMap(1039);
         }
         else
         {
            TextAlert.show("走开走开，没钱就一边凉快着去。");
         }
      }
      
      private function func1043202() : void
      {
         var _loc1_:String = "用20个请神符进入冰雪秘境，即可挑战雪神守卫，更有较高几率获得全新守护神“雪神”（需消耗道具请神符20个）";
         var _loc2_:Array = ["我已经收集20个请神符，进入冰雪秘境"];
         var _loc3_:DialogInfoMultiple = new DialogInfoMultiple([_loc1_],_loc2_);
         NpcDialogController.showForMultiple(_loc3_,10432,this.entryPve797);
      }
      
      private function halloweenCandyHandler(param1:int) : void
      {
         var swapDic:Object = null;
         var onSwapInfoBack:Function = null;
         var npc:int = param1;
         onSwapInfoBack = function(param1:DataEvent):void
         {
            var _loc5_:int = 0;
            var _loc6_:Date = null;
            var _loc7_:String = null;
            ActivityExchangeTimesManager.removeEventListener(swapDic[npc],onSwapInfoBack);
            var _loc2_:SwapTimesInfo = param1.data as SwapTimesInfo;
            var _loc3_:Date = TimeUtil.getSeverDateObject();
            var _loc4_:int = int(_loc3_.time / 1000) - _loc2_.senconds;
            if(_loc4_ >= 600 || _loc2_.senconds == 0)
            {
               if(Math.random() < 0.6)
               {
                  halloweenCandyDialog_1(npc);
               }
               else
               {
                  halloweenCandyDialog_2(npc);
               }
            }
            else
            {
               NpcDialogController.hide();
               _loc5_ = 600 - _loc4_;
               if(_loc5_ < 600)
               {
                  AlertManager.showSimpleAlarm("尊敬的小侠士，每10分钟才能领取一次糖果哦！你还需要再等" + _loc5_ + "秒才可以再次领取。");
               }
               else
               {
                  _loc6_ = new Date();
                  _loc6_.setTime(_loc2_.senconds * 1000);
                  _loc7_ = _loc6_.fullYear + "-" + (_loc6_.month + 1) + "-" + _loc6_.date;
                  AlertManager.showSimpleAlarm("系统时间出错啦！您上次兑换时间是: " + _loc7_ + " " + _loc6_.toLocaleTimeString() + "。");
               }
            }
         };
         swapDic = {
            10001:1973,
            10005:1974,
            10006:1975,
            10009:1976
         };
         if(MainManager.actorInfo.lv < 15)
         {
            AlertManager.showSimpleAlarm(AppLanguageDefine.NPC_DIALOG_COLLECTION[1] + 15 + "级。");
            return;
         }
         ActivityExchangeTimesManager.addEventListener(swapDic[npc],onSwapInfoBack);
         ActivityExchangeTimesManager.getActiviteTimeInfo(swapDic[npc]);
      }
      
      private function halloweenCandyDialog_1(param1:int) : void
      {
         var _loc2_:String = "小孩子不听话是要受到惩罚的！";
         var _loc3_:DialogInfoSimple = new DialogInfoSimple([_loc2_],"嘻嘻！不给糖果我就捣乱");
         NpcDialogController.showForSimple(_loc3_,param1,Delegate.create(this.halloweenFightToNpc,param1));
      }
      
      private function halloweenCandyDialog_2(param1:int) : void
      {
         var _loc2_:String = "我算被你们整怕了%>_&#60;%我这里的南瓜糖你们拿去吧!";
         var _loc3_:DialogInfoSimple = new DialogInfoSimple([_loc2_],"那就谢谢啦！我们还会回来的......");
         NpcDialogController.showForSimple(_loc3_,param1,Delegate.create(this.getCandy,param1));
      }
      
      private function halloweenFightToNpc(param1:int) : void
      {
         var _loc2_:Object = {
            10001:757,
            10005:758,
            10006:759,
            10009:760
         };
         PveEntry.enterTollgate(_loc2_[param1]);
      }
      
      private function getCandy(param1:int) : void
      {
         var onExchangeComplete:Function = null;
         var npc:int = param1;
         onExchangeComplete = function(param1:ExchangeEvent):void
         {
            ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,onExchangeComplete);
         };
         var swapDic:Object = {
            10001:1949,
            10005:1950,
            10006:1951,
            10009:1952
         };
         ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,onExchangeComplete);
         ActivityExchangeCommander.exchange(swapDic[npc]);
      }
      
      private function challengeEachBigBull() : void
      {
         if(SystemTimeController.instance.checkSysTimeAchieve(23))
         {
            PveEntry.enterTollgate(721);
         }
         else
         {
            SystemTimeController.instance.showOutTimeAlert(23);
         }
      }
      
      private function exchangeBaby() : void
      {
         ActivityExchangeCommander.exchange(1291);
      }
      
      private function buyBabyMap() : void
      {
         ActivityExchangeCommander.exchange(1292);
      }
      
      private function zouHouMen(param1:uint) : void
      {
         PveEntry.enterTollgate(this.randomTollgate(param1),1,1);
      }
      
      private function randomTollgate(param1:uint) : uint
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc5_:uint = 0;
         switch(param1)
         {
            case 0:
               _loc2_ = [5,15,50,100];
               _loc3_ = [944,945,946,947];
               break;
            case 1:
               _loc2_ = [5,45,80,100];
               _loc3_ = [948,949,950,951];
               break;
            case 2:
               _loc3_ = [955,956,957,958];
               _loc2_ = [5,15,50,100];
               break;
            case 3:
               _loc3_ = [959,960,961,962];
               _loc2_ = [5,45,80,100];
         }
         var _loc4_:uint = Math.random() * 100;
         var _loc6_:uint = 0;
         while(_loc6_ < _loc2_.length)
         {
            if(_loc4_ < _loc2_[_loc6_])
            {
               _loc5_ = uint(_loc3_[_loc6_]);
               break;
            }
            _loc6_++;
         }
         return _loc5_;
      }
      
      private function onCheck1032Times(param1:DataEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc2_:SwapTimesInfo = param1.data as SwapTimesInfo;
         if(_loc2_.dailyID == 1032)
         {
            ActivityExchangeTimesManager.removeEventListener(1032,this.onCheck1032Times);
            NpcDialogController.hide();
            _loc3_ = _loc2_.limits - _loc2_.times;
            if(_loc3_ <= 0)
            {
               AlertManager.showSimpleAlarm("小侠士已领取所有奖励，可以通过开通超灵侠士包月获得更多机会。");
               return;
            }
            AlertManager.showSimpleAlert("小侠士还可领取" + _loc3_ + "次,现在领取吗？",this.exchange1032);
         }
      }
      
      private function exchange1032() : void
      {
         ActivityExchangeCommander.instance.exchangeActivity(1032);
      }
      
      private function shopModuleTurn(param1:uint) : void
      {
         NpcDialogController.hide();
         ModuleManager.turnModule(ClientConfig.getAppModule(ShopXMLInfo.getModule(param1)),AppLanguageDefine.LOAD_MATTER_COLLECTION[9],param1);
      }
      
      private function taskAccept(param1:uint) : void
      {
         NpcDialogController.hide();
         if(param1 == 3004 && !SystemTimeController.instance.checkSysTimeAchieve(86))
         {
            SystemTimeController.instance.showOutTimeAlert(86);
            return;
         }
         ModuleManager.turnModule(ClientConfig.getAppModule("TaskPanel"),AppLanguageDefine.LOAD_MATTER_COLLECTION[4],param1);
      }
      
      private function taskProcess(param1:uint, param2:uint) : void
      {
         NpcDialogController.hide();
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_TALKTO,param1.toString() + StringConstants.SIGN + param2.toString());
      }
      
      private function taskOver(param1:uint) : void
      {
         NpcDialogController.hide();
         ModuleManager.turnModule(ClientConfig.getAppModule("TaskPanel"),AppLanguageDefine.LOAD_MATTER_COLLECTION[4],param1);
      }
      
      private function minigameStart(param1:String, param2:String) : void
      {
         NpcDialogController.hide();
         if(param2 == "")
         {
            ModuleManager.turnModule(ClientConfig.getGameModule(param1),AppLanguageDefine.LOAD_MATTER_COLLECTION[5]);
            return;
         }
         ModuleManager.turnModule(ClientConfig.getGameModule(param1),AppLanguageDefine.LOAD_MATTER_COLLECTION[5],param2);
      }
      
      private function tollgateTo(param1:uint, param2:uint) : void
      {
         NpcDialogController.hide();
         LayerManager.closeMouseEvent();
         PveEntry.enterTollgate(param1,param2);
      }
      
      private function pvpStart(param1:DialogPvPInfo) : void
      {
         NpcDialogController.hide();
         if(!this.checkUserLevel(param1.pvpLv))
         {
            AlertManager.showSimpleAlarm(AppLanguageDefine.NPC_DIALOG_COLLECTION[1] + param1.pvpLv.toString() + AppLanguageDefine.NPC_DIALOG_COLLECTION[2]);
            return;
         }
         if(!this.checkUserCoin(param1.pvpPay))
         {
            AlertManager.showSimpleAlarm(AppLanguageDefine.NPC_DIALOG_COLLECTION[3] + param1.pvpPay.toString() + AppLanguageDefine.NPC_DIALOG_COLLECTION[4]);
            return;
         }
         if(param1.entryPvpID != 0)
         {
            SinglePkManager.instance.isApplyPvP = true;
            PvpEntry.instance.fightWithEnter(param1.entryPvpID);
            return;
         }
         ModuleManager.turnModule(ClientConfig.getAppModule("PvpAlertPanel"),"正在加载...",param1.pvpID);
      }
      
      private function enterPvp(param1:uint) : void
      {
         SinglePkManager.instance.isApplyPvP = true;
         PvpEntry.instance.fightWithEnter(param1);
      }
      
      private function checkUserLevel(param1:uint) : Boolean
      {
         return MainManager.actorModel.info.lv >= param1;
      }
      
      private function checkUserCoin(param1:uint) : Boolean
      {
         return MainManager.actorModel.info.coins >= param1;
      }
      
      private function sellItemEnter(param1:uint) : void
      {
         NpcDialogController.hide();
         ModuleManager.turnModule(ClientConfig.getAppModule("ItemSalePanel"),AppLanguageDefine.LOAD_MATTER_COLLECTION[10]);
      }
      
      private function equiptRepairEnter(param1:uint) : void
      {
         NpcDialogController.hide();
         if(this.getNeedRepairEquipt())
         {
            ModuleManager.turnModule(ClientConfig.getAppModule("EquiptRepairPanel"),AppLanguageDefine.LOAD_MATTER_COLLECTION[11]);
         }
         else
         {
            AlertManager.show(AlertType.ALARM,AppLanguageDefine.NPC_DIALOG_COLLECTION[5],"",LayerManager.topLevel);
            TasksManager.dispatchActionEvent(TaskActionEvent.TASK_SIMPLEACTION,"EquiptRepairPanel_open");
         }
      }
      
      private function appModule(param1:String, param2:XMLList) : void
      {
         NpcDialogController.hide();
         ModuleManager.turnModule(ClientConfig.getAppModule(param1),AppLanguageDefine.LOAD_MATTER_COLLECTION[12],NpcAppMoudleParamsConvert.convert(param1,param2));
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_SIMPLEACTION,param1 + "_open");
      }
      
      private function activeAmbassadorTask() : void
      {
         NpcDialogController.hide();
         SocketConnection.addCmdListener(CommandID.SET_ANBASSADOR_STATE,this.onSetAnbState);
         var _loc1_:ByteArray = new ByteArray();
         _loc1_.writeByte(1);
         SocketConnection.send(CommandID.SET_ANBASSADOR_STATE,_loc1_);
      }
      
      private function openStorehouse() : void
      {
         NpcDialogController.hide();
         ModuleManager.turnModule(ClientConfig.getAppModule("StorehousePanel"),AppLanguageDefine.LOAD_MATTER_COLLECTION[13],new Object());
      }
      
      private function applyForPharmStudent() : void
      {
         NpcDialogController.hide();
         if(MainManager.actorInfo.lv < 10)
         {
            AlertManager.showSimpleAlarm(AppLanguageDefine.NPC_DIALOG_COLLECTION[6]);
            return;
         }
         if(MainManager.actorInfo.getSubCareer(SubCareerType.TYPE_PHARM) == null)
         {
            AlertManager.showApplySubCareerAnswer(SubCareerType.TYPE_PHARM);
         }
         else
         {
            AlertManager.showSimpleAlarm(AppLanguageDefine.NPC_DIALOG_COLLECTION[7]);
         }
      }
      
      private function applyForComposeStudent() : void
      {
         NpcDialogController.hide();
         if(MainManager.actorInfo.lv < 20)
         {
            AlertManager.showSimpleAlarm(AppLanguageDefine.NPC_DIALOG_COLLECTION[30]);
            return;
         }
         if(MainManager.actorInfo.getSubCareer(SubCareerType.TYPE_COMPOSE) == null)
         {
            AlertManager.showApplySubCareerAnswer(SubCareerType.TYPE_COMPOSE);
         }
         else if(MainManager.actorInfo.getSubCareer(SubCareerType.TYPE_NEW_COMPOSE) == null)
         {
            AlertManager.showApplySubCareerAnswer(SubCareerType.TYPE_NEW_COMPOSE);
         }
         else
         {
            AlertManager.showSimpleAlarm(AppLanguageDefine.NPC_DIALOG_COLLECTION[31]);
         }
      }
      
      private function showStoryDialog_1() : void
      {
         var _loc1_:String = AppLanguageDefine.NPC_DIALOG_COLLECTION[8];
         var _loc2_:DialogInfoSimple = new DialogInfoSimple([_loc1_],AppLanguageDefine.NPC_DIALOG_COLLECTION[9]);
         NpcDialogController.showForSimple(_loc2_,10002);
      }
      
      private function getIcebucket() : void
      {
         SocketConnection.send(CommandID.DAILY_ACTIVITY,240);
         NpcDialogController.hide();
      }
      
      private function showTreasureTurnpanelAlert() : void
      {
         var _loc2_:String = null;
         if(MainManager.actorInfo.lv < 30)
         {
            AlertManager.showSimpleAlarm(AppLanguageDefine.TURNPLATE_GAME_ALERT[0]);
            return;
         }
         var _loc1_:uint = ActivityExchangeTimesManager.getTimes(1033) + ActivityExchangeTimesManager.getTimes(1034) + ActivityExchangeTimesManager.getTimes(1035) + ActivityExchangeTimesManager.getTimes(1036);
         if(_loc1_ >= 5)
         {
            AlertManager.showSimpleAlarm(AppLanguageDefine.TURNPLATE_GAME_ALERT[1]);
            return;
         }
         if(MainManager.actorInfo.huntAward < 10)
         {
            _loc2_ = TextFormatUtil.substitute(AppLanguageDefine.TURNPLATE_GAME_ALERT[2],"10");
            AlertManager.showSimpleAlarm(_loc2_);
            return;
         }
         if(ItemManager.getItemAvailableCapacity() < 1)
         {
            AlertManager.showSimpleAlarm(AppLanguageDefine.BACKPACK_LESSTHAN);
            return;
         }
         this.openTurnpanel();
      }
      
      private function openLockGame(param1:uint) : void
      {
         var _loc4_:String = null;
         var _loc2_:uint = param1 == 0 ? 1051 : 1052;
         var _loc3_:uint = uint(ActivityExchangeTimesManager.getTimes(_loc2_));
         if(_loc3_ >= 5)
         {
            AlertManager.showSimpleAlarm(AppLanguageDefine.TURNPLATE_GAME_ALERT[1]);
         }
         else if(MainManager.actorInfo.huntAward < 20)
         {
            _loc4_ = TextFormatUtil.substitute(AppLanguageDefine.TURNPLATE_GAME_ALERT[2],"20");
            AlertManager.showSimpleAlarm(_loc4_);
         }
         else
         {
            if(ItemManager.getItemAvailableCapacity() < 1)
            {
               AlertManager.showSimpleAlarm(AppLanguageDefine.BACKPACK_LESSTHAN);
               return;
            }
            ModuleManager.turnModule(ClientConfig.getGameModule("OpenLockGame"),"",{"lv":param1});
         }
      }
      
      private function openTurnpanel() : void
      {
         ModuleManager.turnModule(ClientConfig.getGameModule("TreasureTurnplateGame"),"打开转盘...");
      }
      
      private function getElementsSpirit() : void
      {
         SocketConnection.send(CommandID.DAILY_ACTIVITY,235);
         NpcDialogController.hide();
      }
      
      private function buyArmory() : void
      {
         var _loc1_:String = null;
         if(ItemManager.getItemCount(1700063) > 0)
         {
            LayerManager.closeMouseEvent();
            PveEntry.enterTollgate(925,2,1);
            NpcDialogController.hide();
         }
         else
         {
            _loc1_ = TextFormatUtil.substitute(AppLanguageDefine.BUY_ITEM_WARM_COLLECTION[0],"8","功夫圣纹");
            AlertManager.showSimpleAlert(_loc1_,Delegate.create(this.confirmbByItem,1700063));
         }
      }
      
      private function confirmbByItem(param1:uint) : void
      {
         SocketConnection.addCmdListener(CommandID.BUY_MALL_ITEMS,this.onBuyItem);
         if(param1 == 1700063)
         {
            BuyMallItemManager.instance.buyItem(320815,1,1,1700063);
         }
         else if(param1 == 1700069)
         {
            if(ClientConfig.clientType == ClientType.TAOMEE)
            {
               BuyMallItemManager.instance.buyItem(320915,1,1,1700069);
            }
            else
            {
               BuyMallItemManager.instance.buyItem(320910,1,1,1700069);
            }
         }
      }
      
      private function onBuyItem(param1:SocketEvent) : void
      {
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:String = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:ByteArray = ByteArrayUtil.clone(_loc2_);
         var _loc4_:uint = _loc3_.readUnsignedInt();
         var _loc5_:uint = _loc3_.readUnsignedInt();
         if(_loc5_ == 0)
         {
            _loc6_ = _loc3_.readUnsignedInt();
            _loc7_ = _loc3_.readUnsignedInt();
            _loc8_ = _loc3_.readUnsignedInt();
            if(_loc7_ == 1700063)
            {
               ItemManager.addItem(_loc7_,_loc8_);
               LayerManager.closeMouseEvent();
               PveEntry.enterTollgate(925,2,1);
            }
            else if(_loc7_ == 1700069)
            {
               ItemManager.addItem(_loc7_,_loc8_);
               _loc9_ = AppLanguageDefine.GET_AWARD + _loc8_ + AppLanguageDefine.SPECIAL_CHARACTER_SPACE[0] + ItemXMLInfo.getName(_loc7_);
               AlertManager.showSimpleItemAlarm(_loc9_,ClientConfig.getItemIcon(_loc7_));
            }
         }
         NpcDialogController.hide();
      }
      
      private function showClearGhostDialog() : void
      {
         var _loc1_:DialogInfoSimple = null;
         _loc1_ = new DialogInfoSimple([AppLanguageDefine.NPC_DIALOG_COLLECTION[19]],AppLanguageDefine.NPC_DIALOG_COLLECTION[20]);
         NpcDialogController.showForSimple(_loc1_,10020,this.lostGhostRewardPanel);
      }
      
      private function lostGhostRewardPanel() : void
      {
         var _loc1_:DialogInfoSimple = null;
         var _loc2_:String = "<font color=\'#E59110\'>" + AppLanguageDefine.NPC_DIALOG_COLLECTION[21] + "</font>";
         var _loc3_:String = "<font color=\'#E59110\'>" + AppLanguageDefine.NPC_DIALOG_COLLECTION[22] + "</font>";
         _loc1_ = new DialogInfoSimple([AppLanguageDefine.NPC_DIALOG_COLLECTION[23] + _loc2_ + AppLanguageDefine.NPC_DIALOG_COLLECTION[24] + _loc3_ + AppLanguageDefine.NPC_DIALOG_COLLECTION[25]],AppLanguageDefine.NPC_DIALOG_COLLECTION[26]);
         NpcDialogController.showForSimple(_loc1_,10020,this.showGhostRewardPanel);
      }
      
      private function showGhostRewardPanel() : void
      {
         ModuleManager.turnModule(ClientConfig.getAppModule("AmberPanel"),AppLanguageDefine.NPC_DIALOG_COLLECTION[27]);
      }
      
      private function findHallowmasNpcId() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = int(MainManager.loginTimeInSecond);
         var _loc3_:Date = new Date();
         _loc3_.setTime(_loc2_ * 1000);
         var _loc4_:int = _loc3_.getHours();
         if(_loc4_ > 6 && _loc4_ < 18)
         {
            _loc1_ = 10104;
         }
         else
         {
            _loc1_ = 10103;
         }
         return _loc1_;
      }
      
      private function gotoTower() : void
      {
         CityMap.instance.changeMap(24,0,1,new Point(805,436));
      }
      
      private function pageTo(param1:String) : void
      {
         NpcDialogController.hide();
         if(ClientConfig.clientType != ClientType.TAIWAN)
         {
            WebURLUtil.intance.navigatePayVip();
         }
         else
         {
            navigateToURL(new URLRequest(param1),"_blank");
         }
      }
      
      private function gotoMap(param1:String) : void
      {
         var _loc2_:Array = param1.split("_");
         if(_loc2_.length == 3)
         {
            CityMap.instance.changeMap(_loc2_[0],0,1,new Point(_loc2_[1],_loc2_[2]));
         }
         else if(_loc2_.length == 1)
         {
            CityMap.instance.changeMap(_loc2_[0]);
         }
      }
      
      private function exchangeActivity(param1:uint, param2:uint) : void
      {
         if(this.checkExchangAvailable(param1))
         {
            if(param2 != 0)
            {
               if(SystemTimeController.instance.checkSysTimeAchieve(param2))
               {
                  ActivityExchangeCommander.exchange(param1);
               }
               else
               {
                  AlertManager.showSimpleAlarm(SystemTimeController.instance.getActivityOutTimeMsg(param2));
               }
            }
            else
            {
               ActivityExchangeCommander.exchange(param1);
            }
            NpcDialogController.hide();
         }
      }
      
      private function checkExchangAvailable(param1:uint) : Boolean
      {
         return true;
      }
      
      private function getNeedRepairEquipt() : Boolean
      {
         if(this.getNeedRepair(ItemManager.equipList))
         {
            return true;
         }
         return false;
      }
      
      private function getNeedRepair(param1:Array) : Boolean
      {
         var _loc2_:SingleEquipInfo = null;
         for each(_loc2_ in param1)
         {
            if(this.isNeedRepair(_loc2_))
            {
               return true;
            }
         }
         return false;
      }
      
      private function isNeedRepair(param1:SingleEquipInfo) : Boolean
      {
         var _loc2_:int = int(ItemXMLInfo.getDuration(param1.itemID));
         var _loc3_:int = generateDuration(param1.duration,_loc2_);
         if(_loc2_ > _loc3_)
         {
            return true;
         }
         return false;
      }
      
      private function isCanPlayFindMajority() : void
      {
         if(WallowUtil.isWallow())
         {
            WallowUtil.showWallowMsg(AppLanguageDefine.WALLOW_MSG_ARR[8]);
         }
         else
         {
            this.showFindMajority();
         }
      }
      
      private function showFindMajority() : void
      {
         ModuleManager.turnModule(ClientConfig.getGameModule("FindMajority"),AppLanguageDefine.LOAD_MATTER_COLLECTION[5]);
      }
      
      private function reGetWhiteFox() : void
      {
         ActivityExchangeCommander.instance.exchangeActivity(1147);
      }
      
      private function openOnHook() : void
      {
         var _loc1_:int = int(ActivityExchangeTimesManager.getTimes(1169));
         if(_loc1_ == 0 && !OnHookManager.isOnHookIng())
         {
            ModuleManager.turnAppModule("OpenOnHook","正在开始伏魔阵");
         }
         else
         {
            ModuleManager.turnAppModule("OnHookPanel","正在开始伏魔阵");
         }
      }
      
      private function getHookAward() : void
      {
         if(this.chechHookAwardLimit())
         {
            ActivityExchangeCommander.exchange(1393);
         }
      }
      
      private function chechHookAwardLimit() : Boolean
      {
         if(MainManager.actorInfo.coins > 5000000)
         {
            AlertManager.showSimpleAlarm("小侠士你的功夫豆已超过500万");
            return false;
         }
         if(MainManager.actorInfo.lv < 35)
         {
            AlertManager.showSimpleAlarm("小侠士你的等级未满35级，快去修炼到35级再来吧");
            return false;
         }
         if(MainManager.olToday < 3620)
         {
            AlertManager.showSimpleAlarm("小侠士你今天累计在线未满一小时，请稍后再来");
            return false;
         }
         return true;
      }
      
      private function LouLanTreasureEntry() : void
      {
         if(ItemManager.getItemCount(1500392) > 0)
         {
            CityMap.instance.changeMap(42);
         }
         else
         {
            AlertManager.showSimpleAlarm("小侠士，你还没有楼兰密钥，无法寻找宝藏！");
         }
      }
      
      private function onSetAnbState(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.SET_ANBASSADOR_STATE,this.onSetAnbState);
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:int = _loc2_.readByte();
         MainManager.actorInfo.ambassadorTaskState = _loc3_;
         AmbassadorEntry.instance.show();
         AlertManager.showSimpleAlarm(AppLanguageDefine.NPC_DIALOG_COLLECTION[28]);
         ModuleManager.turnModule(ClientConfig.getAppModule("AmbassadorTask"),AppLanguageDefine.LOAD_MATTER_COLLECTION[6]);
      }
      
      public function removeEvent() : void
      {
         SocketConnection.removeCmdListener(CommandID.BUY_MALL_ITEMS,this.onBuyItem);
         ActivityExchangeTimesManager.removeEventListener(1032,this.onCheck1032Times);
      }
      
      private function aevanceCertificate() : void
      {
         if(MainManager.actorInfo.coins < 10000)
         {
            AlertManager.showSimpleAlarm("小侠士，你的功夫豆不够哟，购买进阶证书需要10000功夫豆");
            return;
         }
         if(MainManager.actorInfo.huntAward < 100)
         {
            AlertManager.showSimpleAlarm("小侠士，你的伏魔点不够哟，购买进阶证书需要100伏魔点");
            return;
         }
         ActivityExchangeCommander.exchange(1209);
      }
      
      private function showSubDialogEntry(param1:uint) : void
      {
         switch(param1)
         {
            case 100025:
               this.showDialog100025();
               break;
            case 100011:
               this.showDialog100011();
               break;
            case 101461:
               this.showDialog101461();
               break;
            case 101211:
               this.showDialog101211();
               break;
            case 101581:
               this.showDialog101581();
               break;
            case 101591:
               this.showDialog101591();
         }
      }
      
      private function showDialog100025() : void
      {
         var onDialog:Function = function():void
         {
            PveEntry.instance.enterTollgate(985);
         };
         var s:String = "七星连珠现，仙履奇缘启；小侠士你的仙缘之旅可是刚刚开始，看你能不能过的了老夫这一关！";
         var simpeDialog:DialogInfoSimple = new DialogInfoSimple([s],"进入挑战");
         NpcDialogController.showForSimple(simpeDialog,10002,onDialog);
      }
      
      private function showDialog100011() : void
      {
         var onDialog:Function = function():void
         {
            PveEntry.instance.enterTollgate(986);
         };
         var s:String = "仙缘之路上艰险多,仙兽是你可以信赖的伙伴；小侠士，挑战爷爷时带上你最强力的仙兽吧！";
         var simpeDialog:DialogInfoSimple = new DialogInfoSimple([s],"进入挑战");
         NpcDialogController.showForSimple(simpeDialog,10001,onDialog);
      }
      
      private function zhaoCaiJinBao() : void
      {
         if(!ClientTempState.isZhaoCaiJinBao)
         {
            ClientTempState.isZhaoCaiJinBao = true;
            ModuleManager.turnAppModule("ShanCaiTongZiDesPanel");
         }
         else
         {
            ModuleManager.turnAppModule("ShanCaiTongZiPanel");
         }
      }
      
      private function showDialog101461() : void
      {
         var onDialog:Function = function():void
         {
            PveEntry.instance.enterTollgate(984);
         };
         var s:String = "我等你很久了，小侠士，准备好开启你的仙履奇缘了吗？但你得先完成我的考验。";
         var simpeDialog:DialogInfoSimple = new DialogInfoSimple([s],"进入挑战");
         NpcDialogController.showForSimple(simpeDialog,10146,onDialog);
      }
      
      private function showDialog101211() : void
      {
         var onDialog:Function = function():void
         {
            if(Boolean(TasksManager.isAccepted(3004)) && !TasksManager.isProcess(3004,3))
            {
               AlertManager.showSimpleAlarm("小侠士，你已经完成了本次挑战。");
            }
            else
            {
               ModuleManager.turnAppModule("TaskQuestionPanel","...");
            }
         };
         var s:String = "人老了，不能像你们年轻人这样打打杀杀了，我这把老骨头可禁不起折腾，谁把我加在上古仪式的挑战名单里的！真是不敬老！小侠士你只要正确回答老头子几个问题就可以了，很方便的，呵呵！";
         var simpeDialog:DialogInfoSimple = new DialogInfoSimple([s],"开始答题");
         NpcDialogController.showForSimple(simpeDialog,10121,onDialog);
      }
      
      private function showDialog101581() : void
      {
         var onDialog:Function = function():void
         {
            PveEntry.instance.enterTollgate(983);
         };
         var s:String = "七星连珠之象出现后，遗落在沙海深处的宝藏纷纷出世，小侠士你能战胜里面的守护者吗？";
         var simpeDialog:DialogInfoSimple = new DialogInfoSimple([s],"进入挑战");
         NpcDialogController.showForSimple(simpeDialog,10158,onDialog);
      }
      
      private function showDialog101591() : void
      {
         var onDialog:Function = function():void
         {
            enterPvp(15);
         };
         var s:String = "我是万圣山来的使者，仙缘之旅上必定是凶险异常的，来一场对抗赛证明你的实力吧！";
         var simpeDialog:DialogInfoSimple = new DialogInfoSimple([s],"进入挑战");
         NpcDialogController.showForSimple(simpeDialog,10159,onDialog);
      }
      
      private function dialog101551OptionSelectHandler(param1:int) : void
      {
         switch(param1)
         {
            case 0:
               ModuleManager.turnModule(ClientConfig.getAppModule("PassingRedEnvelope"),"正在加载...");
               break;
            case 1:
               ModuleManager.turnModule(ClientConfig.getAppModule("PassingRedEnvelopeIntrPanel"),"正在加载...");
               break;
            case 2:
               NpcDialogController.hide();
         }
      }
      
      private function WuLinApply() : void
      {
         if(WallowUtil.isWallow())
         {
            WallowUtil.showWallowMsg(AppLanguageDefine.WALLOW_MSG_ARR[14]);
            return;
         }
         if(MainManager.actorInfo.lv < 11)
         {
            AlertManager.showSimpleAlarm("对不起，小侠士，参加武林盛典需要达到至少11级。");
            return;
         }
         if(!SystemTimeController.instance.checkSysTimeAchieve(11))
         {
            SystemTimeController.instance.showOutTimeAlert(11);
            return;
         }
         if(MainManager.actorInfo.coins < 100000)
         {
            AlertManager.showSimpleAlarm("报名需要10w功夫豆，小侠士功夫豆不足哦。");
         }
         else
         {
            AlertManager.showSimpleAlert("本次报名需要10w功夫豆，夺冠将获得更丰厚奖励，确认报名吗？",this.confirmWuLinApply);
         }
      }
      
      private function showKillDargonDialog() : void
      {
         var _loc3_:QuestionInfo = null;
         var _loc1_:String = "勇敢的小侠士，魔龙拥有冰、火、水、毒多种厉害的法术，在和它对抗之前，我将赋予你一种能力，请选择你希望得到的能力！选择后将直接开始屠龙！打败魔龙有机会获得三头龙仙兽，运气好的话还有金龙珠和冰魄魂石哦！";
         var _loc2_:Array = new Array();
         _loc3_ = new QuestionInfo();
         _loc3_.desc = "冰免疫";
         _loc3_.procType = QuestionInfo.PROC_CUSTOM;
         _loc3_.procParams = [101585];
         _loc2_.push(_loc3_);
         _loc3_ = new QuestionInfo();
         _loc3_.desc = "水免疫";
         _loc3_.procType = QuestionInfo.PROC_CUSTOM;
         _loc3_.procParams = [101586];
         _loc2_.push(_loc3_);
         _loc3_ = new QuestionInfo();
         _loc3_.desc = "火免疫";
         _loc3_.procType = QuestionInfo.PROC_CUSTOM;
         _loc3_.procParams = [101587];
         _loc2_.push(_loc3_);
         _loc3_ = new QuestionInfo();
         _loc3_.desc = "毒免疫";
         _loc3_.procType = QuestionInfo.PROC_CUSTOM;
         _loc3_.procParams = [101588];
         _loc2_.push(_loc3_);
         NpcDialogController.showForArr(10158,[_loc1_],_loc2_);
      }
      
      private function confirmWuLinApply() : void
      {
         SocketConnection.send(CommandID.WuLin_APPLY);
      }
      
      private function gloryFightApply() : void
      {
         if(WallowUtil.isWallow())
         {
            WallowUtil.showWallowMsg(AppLanguageDefine.WALLOW_MSG_ARR[14]);
            return;
         }
         if(!TeamsRelationManager.instance.isTeamLeader())
         {
            AlertManager.showSimpleAlarm("对不起小侠士，只有侠士团团长才能报名参加荣誉之战。");
            return;
         }
         if(TeamsRelationManager.instance.fightTeamsMemberInfo.teamIntegral < 1000000)
         {
            AlertManager.showSimpleAlarm("对不起小侠士，你的侠士团资金不足。报名需要花费100万侠士团资金。");
            return;
         }
         if(!SystemTimeController.instance.checkSysTimeAchieve(22))
         {
            SystemTimeController.instance.showOutTimeAlert(22);
            return;
         }
         AlertManager.showSimpleAlert("小侠士，你确定要花费100万侠士团资金来报名参赛吗？",this.confirmGloryFightApply);
      }
      
      private function fun104131() : void
      {
         var _loc1_:String = null;
         if(ActivityExchangeTimesManager.getTimes(EXPDOUBLE) == 0)
         {
            if(ActivityExchangeTimesManager.getTimes(COINDOUBLE) == 0)
            {
               _loc1_ = "要获得功夫豆翻倍祝福就要通过我的试炼，小侠士你准备好挑战了吗？";
               AlertManager.showSimpleAlert(_loc1_,this.applyGetCoin);
            }
            else
            {
               AlertManager.showSimpleAlarm("小侠士,你今天已经挑战过金使者！");
            }
         }
         else
         {
            AlertManager.showSimpleAlarm("小侠士,每天只能选择一种祝福哦！");
         }
      }
      
      private function applyGetCoin() : void
      {
         PveEntry.enterTollgate(745);
      }
      
      private function fun104141() : void
      {
         var _loc1_:String = null;
         if(ActivityExchangeTimesManager.getTimes(COINDOUBLE) == 0)
         {
            if(ActivityExchangeTimesManager.getTimes(EXPDOUBLE) == 0)
            {
               _loc1_ = "要获得经验翻倍祝福就要通过我的试炼，小侠士你准备好挑战了吗？";
               AlertManager.showSimpleAlert(_loc1_,this.applyGetExp);
            }
            else
            {
               AlertManager.showSimpleAlarm("小侠士,你今天已经挑战过银使者！");
            }
         }
         else
         {
            AlertManager.showSimpleAlarm("小侠士,每天只能选择一种祝福哦！");
         }
      }
      
      private function applyGetExp() : void
      {
         PveEntry.enterTollgate(746);
      }
      
      private function confirmGloryFightApply() : void
      {
         SocketConnection.send(CommandID.GLORY_FIGHT_APPLY);
      }
      
      private function function101504() : void
      {
         AnimatPlay.startAnimat("scenceAnimat_38_",1,false,0,0,false,true);
         AnimatPlay.addAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimatEnd);
      }
      
      private function function101505() : void
      {
         ModuleManager.turnAppModule("WuLinFightMemberPanel");
      }
      
      private function onAnimatEnd(param1:AnimatEvent) : void
      {
         AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimatEnd);
         if(ActivityExchangeTimesManager.getTimes(SWAPID) == 0)
         {
            ActivityExchangeCommander.exchange(SWAPID);
            ActivityExchangeTimesManager.updataTimesByOnce(SWAPID);
         }
      }
      
      private function function1050101() : void
      {
         if(ActivityExchangeTimesManager.getTimes(2586) == 0 && ActivityExchangeTimesManager.getTimes(2585) == 0)
         {
            if(Boolean(MainManager.actorInfo.isVip) && VipUtil.getLeftVipDay() > 15)
            {
               ActivityExchangeCommander.exchange(2586);
            }
            else
            {
               ActivityExchangeCommander.exchange(2585);
            }
         }
         if(ActivityExchangeTimesManager.getTimes(2587) > 0 || ActivityExchangeTimesManager.getTimes(2588) > 0)
         {
            AlertManager.showSimpleAlarm("小侠士，今日的奖励已领取，请明天再来吧。");
            return;
         }
         if(Boolean(MainManager.actorInfo.isVip) && VipUtil.getLeftVipDay() > 15)
         {
            ActivityExchangeCommander.exchange(2588);
         }
         else
         {
            ActivityExchangeCommander.exchange(2587);
         }
      }
      
      private function getMiMiAward() : void
      {
         SocketConnection.addCmdListener(CommandID.MIMI_AWARD,this.onMiniAward);
         SocketConnection.send(CommandID.MIMI_AWARD);
      }
      
      private function onMiniAward(param1:SocketEvent) : void
      {
         var data:ByteArray;
         var currentMoney:uint;
         var canExchangeTime:uint;
         var e:SocketEvent = param1;
         SocketConnection.removeCmdListener(CommandID.MIMI_AWARD,this.onMiniAward);
         data = e.data as ByteArray;
         currentMoney = data.readUnsignedInt();
         canExchangeTime = data.readUnsignedInt();
         if(ActivityExchangeTimesManager.getTimes(2189) < canExchangeTime)
         {
            ActivityExchangeCommander.exchange(2189);
         }
         else
         {
            AlertManager.showSimpleAlert("小侠士，满足充值实体米米卡的条件就能领取充值礼包！现在是否去充值？",function():void
            {
               WebURLUtil.intance.navigatePayVip();
            },null);
         }
      }
      
      private function useForzenHerb() : void
      {
         if(ItemManager.getItemCount(1500672) >= 10)
         {
            ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onUseForzenHerb);
            ActivityExchangeCommander.exchange(EXCHANGE_ID);
         }
         else
         {
            AlertManager.showSimpleAlarm("亲爱的小侠士,你的解冻草数量不足哟，快去副本内获取吧！");
         }
      }
      
      private function onUseForzenHerb(param1:ExchangeEvent) : void
      {
         var _loc2_:ActivityExchangeAwardInfo = param1.info;
         if(_loc2_.id == EXCHANGE_ID)
         {
            TasksManager.dispatchActionEvent(TaskActionEvent.TASK_CUSTOM_FINISH,"1833_2");
         }
      }
      
      private function useLifeHerb() : void
      {
         if(ItemManager.getItemCount(1302000) >= 10)
         {
            SocketConnection.addCmdListener(CommandID.TASK1834_INFO,this.takeOffItem);
            SocketConnection.send(CommandID.TASK1834_INFO);
         }
         else if(ItemManager.getItemCount(1302001) >= 10)
         {
            this.isTakeoff1302000 = false;
            SocketConnection.addCmdListener(CommandID.TASK1834_INFO,this.takeOffItem);
            SocketConnection.send(CommandID.TASK1834_INFO);
         }
         else
         {
            AlertManager.showSimpleAlarm("亲爱的小侠士，你的起死回生草数量不足哟！");
         }
      }
      
      private function takeOffItem(param1:SocketEvent) : void
      {
         if(this.isTakeoff1302000)
         {
            ItemManager.removeItem(1302000,10);
         }
         else
         {
            ItemManager.removeItem(1302001,10);
         }
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_CUSTOM_FINISH,"1833_2");
      }
      
      private function entryPve797() : void
      {
         if(ItemManager.getItemCount(1500580) >= 20)
         {
            PveEntry.enterTollgate(797);
         }
         else
         {
            AlertManager.showSimpleAlarm("亲爱的小侠士,你的请神符数量不足哟，暂时不能进入关卡！");
         }
      }
      
      private function func100483() : void
      {
         if(SystemTimeController.instance.checkSysTimeAchieve(TIME_COIN))
         {
            ModuleManager.turnModule(ClientConfig.getAppModule("CleanCoinPannel"),"正在加载...");
         }
         else
         {
            SystemTimeController.instance.showOutTimeAlert(TIME_COIN);
         }
      }
      
      private function func100486() : void
      {
         var dialogs:String;
         var swapArr:Array = null;
         var index:uint = 0;
         var lv:uint = 0;
         var selects:Array = null;
         var multiDialog:DialogInfoMultiple = null;
         if(!SystemTimeController.instance.checkSysTimeAchieve(137))
         {
            SystemTimeController.instance.showOutTimeAlert(137);
            return;
         }
         dialogs = "开新区，送大礼！为了提升大家冲级修炼的积极性，凡是在6月30日前（含）修炼到55级、65级、75级、80级的小侠士均可在我陆半仙这里领取大量的金币和米币来作为今后争雄艾尔大陆的资本，到时可别忘了我的好啊！";
         swapArr = [2613,2614,2615];
         while(ActivityExchangeTimesManager.getTimes(swapArr[index]) > 0 && index < 3)
         {
            index++;
         }
         if(ActivityExchangeTimesManager.getTimes(swapArr[index]) == 0 && index < 3)
         {
            lv = 55 + 10 * index;
            selects = ["我已修炼到" + lv + "级"];
            multiDialog = new DialogInfoMultiple([dialogs],selects);
            NpcDialogController.showForMultiple(multiDialog,10048,function():void
            {
               if(MainManager.actorInfo.lv >= lv)
               {
                  ActivityExchangeCommander.exchange(swapArr[index]);
               }
               else
               {
                  AlertManager.showSimpleAlarm("小侠士，你的等级还不够！");
               }
            });
         }
         else
         {
            selects = ["我已修炼到80级"];
            multiDialog = new DialogInfoMultiple([dialogs],selects);
            NpcDialogController.showForMultiple(multiDialog,10048,function():void
            {
               if(MainManager.actorInfo.lv >= 80)
               {
                  TextAlert.show("米币奖励将于7月1日统一发给获奖侠士");
               }
               else
               {
                  AlertManager.showSimpleAlarm("小侠士，你的等级还不够！");
               }
            });
         }
      }
      
      private function func101462() : void
      {
         var _loc1_:String = "想挑战我的秘术•傀儡大阵？你们要做好失败的觉悟！多带点请神符来吧，不过就算失败，我也不会让你们一无所获。";
         var _loc2_:Array = ["我准备好了！"];
         var _loc3_:DialogInfoMultiple = new DialogInfoMultiple([_loc1_],_loc2_);
         NpcDialogController.showForMultiple(_loc3_,10146,this.openPanel);
      }
      
      private function openPanel() : void
      {
         if(MainManager.actorInfo.lv < 20)
         {
            AlertManager.showSimpleAlarm("连20级都没有，本法师不屑于跟你挑战！");
         }
         else
         {
            ModuleManager.turnModule(ClientConfig.getAppModule("KillPuppetPannel"),"....");
            NpcDialogController.hide();
         }
      }
      
      private function maydaymakewish() : void
      {
         var _loc1_:uint = uint(ActivityExchangeTimesManager.getTimes(2460));
         var _loc2_:uint = uint(ActivityExchangeTimesManager.getTimes(2463));
         if(_loc1_ > 0 || _loc2_ > 0)
         {
            AlertManager.showSimpleAlarm("每天只能许愿一次哦！");
            return;
         }
         ModuleManager.turnModule(ClientConfig.getAppModule("MaydaywishPanel"),"正在加载...");
      }
      
      private function func1002401() : void
      {
         var _loc1_:String = null;
         var _loc2_:Array = null;
         var _loc3_:DialogInfoMultiple = null;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:DialogInfoMultiple = null;
         if(MainManager.actorInfo.lv < 30)
         {
            _loc1_ = "冰块库存有限，我只卖给30级以上高富帅侠士哦！";
            _loc2_ = ["我这就去练级。"];
            _loc3_ = new DialogInfoMultiple([_loc1_],_loc2_);
            NpcDialogController.showForMultiple(_loc3_,10024,this.lianjifunc);
         }
         else
         {
            _loc4_ = "刚进入五月，已经感受到这炎炎夏日的温度了，真是热死了，我希望有个人能帮我从冰河小镇运些冰块过来。";
            _loc5_ = ["运送冰块"];
            _loc6_ = new DialogInfoMultiple([_loc4_],_loc5_);
            NpcDialogController.showForMultiple(_loc6_,10024,this.getIce);
         }
      }
      
      private function getIce() : void
      {
         this.applyFun();
      }
      
      private function lianjifunc() : void
      {
         NpcDialogController.hide();
      }
      
      private function func1002402(param1:Boolean = false) : void
      {
         var onServerData:Function = null;
         var isBuy:Boolean = param1;
         onServerData = function(param1:ServerUniqDataEvent):void
         {
            var _loc5_:SwapActionLimitInfo = null;
            var _loc6_:uint = 0;
            ServerUniqDataManager.removeListener(ServerUniqDataEvent.EVENT_GAOCHAN_ICE,onServerData);
            var _loc2_:ServerUniqDataInfo = param1.serverUniqDataInfo;
            var _loc3_:Vector.<SwapActionLimitInfo> = _loc2_.infoArr;
            var _loc4_:int = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc5_ = _loc3_[_loc4_];
               if(_loc5_.dailyID == 2477)
               {
                  _loc6_ = uint(_loc5_.limitCount);
               }
               _loc4_++;
            }
            if(isBuy && _loc6_ > 0)
            {
               ActivityExchangeCommander.exchange(2477);
               return;
            }
            if(_loc6_ > 0)
            {
               AlertManager.showSimpleAlarm("我这里冰块太抢手了，只剩下" + String(_loc6_) + "块，高富帅小侠士要赶紧下手哦!");
            }
            else
            {
               AlertManager.showSimpleAlert("我这里冰块太抢手了,已经没有库存，小侠士要帮我去运送冰块吗?",applyFun,cancelFun);
               MainManager.closeOperate();
            }
         };
         ServerUniqDataManager.addListener(ServerUniqDataEvent.EVENT_GAOCHAN_ICE,onServerData);
         ServerUniqDataManager.requestDateByType(ServerUniqDataManager.TYPE_ICE_NUM);
      }
      
      private function applyFun() : void
      {
         ModuleManager.turnAppModule("TransportIcePanel");
         MainManager.openOperate();
      }
      
      private function cancelFun() : void
      {
         MainManager.openOperate();
      }
      
      private function func1012301() : void
      {
         var dialogs:Array = ["到龙宫的最深处寻找月饼王，只有最快的侠士才能找到他，实现愿望哦！"];
         var selects:Array = ["我要参赛(报名费10万功夫豆)","比赛说明"];
         var multiDialog0:DialogInfoMultiple = new DialogInfoMultiple(dialogs,selects);
         NpcDialogController.showForMultiple(multiDialog0,10123,function():void
         {
            if(MainManager.actorInfo.lv < 30)
            {
               AlertManager.showSimpleAlarm("30级以上侠士才能参赛哦！");
               return;
            }
            if(!SystemTimeController.instance.checkSysTimeAchieve(143))
            {
               SystemTimeController.instance.showOutTimeAlert(143);
               return;
            }
            if(MainManager.actorInfo.coins < 100000)
            {
               AlertManager.showSimpleAlarm("参加该比赛需要十万功夫豆，小侠士，你功夫豆不足！");
               return;
            }
         },function():void
         {
            ModuleManager.turnAppModule("DragonMazeExplainPanel");
         });
      }
      
      private function func1012302() : void
      {
         if(MainManager.actorInfo.lv < 30)
         {
            AlertManager.showSimpleAlarm("只有30级以上的小侠士才能参加哦！");
         }
         else
         {
            ModuleManager.turnAppModule("RunningManPanel");
            NpcDialogController.hide();
         }
      }
      
      private function func1012303() : void
      {
         ActivityExchangeTimesManager.addEventListeners([2499,9032],this.applyPunish);
         ActivityExchangeTimesManager.getActivitesTimeInfo([2499,9032]);
      }
      
      private function getPayMoney() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = int(ActivityExchangeTimesManager.getTimes(2499));
         var _loc3_:int = _loc2_ - ActivityExchangeTimesManager.getTimes(9032);
         if(_loc3_ > 0)
         {
            if(_loc3_ == 1)
            {
               if(_loc2_ == 1)
               {
                  return 1;
               }
               if(_loc2_ == 2)
               {
                  return 2;
               }
               return 5;
            }
            if(_loc3_ == 2)
            {
               if(_loc2_ == 2)
               {
                  return 3;
               }
               return 7;
            }
            if(_loc3_ >= 3)
            {
               return 8;
            }
         }
         return _loc1_;
      }
      
      private function applyPunish(param1:DataEvent) : void
      {
         var money:int = 0;
         var simpeDialog:DialogInfoSimple = null;
         var payFunish:Function = null;
         var childDialog3:Function = null;
         var childDialog2:Function = null;
         var childDialog1:Function = null;
         var event:DataEvent = param1;
         payFunish = function():void
         {
            AlertManager.showSimpleAlert("小侠士需缴纳" + money + "千万功夫豆的罚单才能取消记录在案的不良记录！\n是否现在就缴纳？",function():void
            {
               if(MainManager.actorInfo.coins < money * 1000 * 10000)
               {
                  AlertManager.showSimpleAlarm("这位小侠士，你的功夫豆不足哦！");
               }
               else
               {
                  startPayFunish();
               }
            });
         };
         childDialog3 = function():void
         {
            simpeDialog = new DialogInfoSimple(["喏！公平竞赛委员会可是有专门规定的，对违反规则的侠士们都是可以网开一面的！在我这缴吧！" + getPayMoney() + "千万功夫豆的罚金吧！"],"好吧，以后再也不干这种事了。");
            NpcDialogController.showForSimple(simpeDialog,10123,payFunish);
         };
         childDialog2 = function():void
         {
            simpeDialog = new DialogInfoSimple(["乖乖在我这交罚单吧！知錯能改善莫大焉！"],"…感謝海振兴大叔！");
            NpcDialogController.showForSimple(simpeDialog,10123,childDialog3);
         };
         childDialog1 = function():void
         {
            simpeDialog = new DialogInfoSimple(["你一定是违反了艾尔大陆的公平竞赛原则!"],"被你发现了…");
            NpcDialogController.showForSimple(simpeDialog,10123,childDialog2);
         };
         ActivityExchangeTimesManager.removeEventListeners([2499,9032],this.applyPunish);
         money = this.getPayMoney();
         if(money == 0)
         {
            AlertManager.showSimpleAlarm("公平比武的小侠士是不需要缴纳罚金的！");
            return;
         }
         simpeDialog = new DialogInfoSimple(["小俠士没法跟人比武了？"],"额…是啊。");
         NpcDialogController.showForSimple(simpeDialog,10123,childDialog1);
      }
      
      private function startPayFunish() : void
      {
         SocketConnection.addCmdListener(CommandID.ILLEGALITY_PVP_PAY,this.onPayFunishCompleteHandler);
         SocketConnection.send(CommandID.ILLEGALITY_PVP_PAY);
      }
      
      private function onPayFunishCompleteHandler(param1:SocketEvent) : void
      {
         AlertManager.showSimpleAlarm("小侠士今后比武可要遵从艾尔大陆公平竞赛原则啊！公平比武才能笑傲江湖！");
         ActivityExchangeTimesManager.getActivitesTimeInfo([2499,9032]);
      }
      
      private function func100045() : void
      {
         var dialogs:Array = ["有部分小侠士可能弄丢了进阶资格证书，无法完成进阶，我受武圣爷爷所托，增加兑换进阶资格证书的入口。接取了进阶任务，弄丢了资格证书的小侠士可以来兑换哦！"];
         var selects:Array = ["兑换无章","兑换一章","兑换二章","兑换三章"];
         var multiDialog:DialogInfoMultiple = new DialogInfoMultiple(dialogs,selects);
         NpcDialogController.showForMultiple(multiDialog,10004,function():void
         {
            if(Boolean(TasksManager.isAccepted(1728)) && ItemManager.getItemCount(1400387) == 0)
            {
               ActivityExchangeCommander.exchange(2954);
            }
            else
            {
               AlertManager.showSimpleAlarm("小侠士，你暂时还不需要这个物品！");
            }
         },function():void
         {
            if(Boolean(TasksManager.isAccepted(1729)) && ItemManager.getItemCount(1400388) == 0)
            {
               ActivityExchangeCommander.exchange(2955);
            }
            else
            {
               AlertManager.showSimpleAlarm("小侠士，你暂时还不需要这个物品！");
            }
         },function():void
         {
            if(Boolean(TasksManager.isAccepted(1728)) && ItemManager.getItemCount(1400389) == 0)
            {
               ActivityExchangeCommander.exchange(2867);
            }
            else
            {
               AlertManager.showSimpleAlarm("小侠士，你暂时还不需要这个物品！");
            }
         },function():void
         {
            if(Boolean(TasksManager.isAccepted(1729)) && ItemManager.getItemCount(1400390) == 0)
            {
               ActivityExchangeCommander.exchange(2956);
            }
            else
            {
               AlertManager.showSimpleAlarm("小侠士，你暂时还不需要这个物品！");
            }
         });
      }
      
      private function func100013() : void
      {
         var dialogs:Array = ["没想到你成长如此迅速，已经到如此地步了！","实力倒是长了，口气也大了，想必今日过来找我是有事相求。","我是一路看你成长过来的，这忙怎会不帮。当我释放祝福的时候记得收好了。（鼠标滑过祝福特效即可获得）"];
         var selects:Array = ["我还嫌慢了点呢！","我正要突破110级，需要得到你的祝福。","我准备着呢！"];
         NpcDialogController.showForSingles(dialogs,selects,10001,function():void
         {
            ModuleManager.turnAppModule("UnlockLevel111GamePanel","正在加载..",0);
         });
      }
      
      private function func105361() : void
      {
         var dialogs:Array = ["来者何人，有何事！","是" + MainManager.actorInfo.nick + "啊，我记得你，看你精力充沛，功力肯定又精进了不少。","为了感谢你昔日的相助，这忙我肯定帮，准备好接收我的祝福了吗？（鼠标滑过祝福特效即可获得）"];
         var selects:Array = ["是我，我曾经还帮助过你呢。","我正要突破110级，需要得到你的祝福。","来吧，祝福越多越好！"];
         NpcDialogController.showForSingles(dialogs,selects,10536,function():void
         {
            ModuleManager.turnAppModule("UnlockLevel111GamePanel","正在加载..",1);
         });
      }
      
      private function func100481() : void
      {
         var dialogs:Array = ["别看我是半仙，我可上知天文地理，下晓阴沟烂泥，小侠士此次来是有求于我吧~","除了借钱，啥都好商量~","哦？难道小侠士已经到了要突破110级上限的时候了，那我可要大展神威了。（鼠标滑过祝福特效即可获得）"];
         var selects:Array = ["半仙好厉害！猜中了！","囧，我才不会来向你借钱呢，我只要你的祝福。","来吧，来吧。"];
         NpcDialogController.showForSingles(dialogs,selects,10048,function():void
         {
            ModuleManager.turnAppModule("UnlockLevel111GamePanel","正在加载..",2);
         });
      }
      
      private function func100666() : void
      {
         var dialogs:Array = ["近日有诸多侠士来寻找老夫，都是为了同一件事。","祝福给不给，那也是因人而异。","别着急，待我稍施展小法术，你就能获得满满的祝福了。（鼠标滑过祝福特效即可获得）"];
         var selects:Array = ["啊？这么多侠士都来找你要祝福了吗？","那我呢，我可是最最最正义，最最最勇敢，最最最……","嘿嘿，我准备收祝福喽。"];
         NpcDialogController.showForSingles(dialogs,selects,10066,function():void
         {
            ModuleManager.turnAppModule("UnlockLevel111GamePanel","正在加载..",3);
         });
      }
      
      private function func101571() : void
      {
         var dialogs:Array = ["最近家园里挤满了来自各个大陆的侠士，都说是想借我的祝福突破自己。","哦？难道最近天灵地杰，正适合人物突破，那我得好好研究下我的仙兽能不能也借这个机会突破一下。","好吧，看在你这么努力想要上进，我也就帮你一把。（鼠标滑过祝福特效即可获得）"];
         var selects:Array = ["我就是为这个来的！","那在你研究仙兽之前，能不能先帮我呢。","太好了！"];
         NpcDialogController.showForSingles(dialogs,selects,10157,function():void
         {
            ModuleManager.turnAppModule("UnlockLevel111GamePanel","正在加载..",4);
         });
      }
      
      private function func105701() : void
      {
         if(ItemManager.getItemCount(2740683) < 100)
         {
            AlertManager.showSimpleAlarm("小侠士，需要100个狼王石才可兑换霸王狼哦~");
            return;
         }
         ActivityExchangeCommander.exchange(8337);
      }
      
      private function func105703() : void
      {
         if(ItemManager.getItemCount(2740717) < 100)
         {
            AlertManager.showSimpleAlarm("小侠士你还没有100个鲨王石，无法兑换哦~");
            return;
         }
         AlertManager.showSimpleAlert("小侠士你是否要消耗100个鲨王石兑换1只霸王鲨？",function():void
         {
            ActivityExchangeCommander.exchange(8684);
         });
      }
      
      private function func105702() : void
      {
         if(ItemManager.getItemCount(2740685) < 100)
         {
            AlertManager.showSimpleAlarm("召唤霸王龙所需的龙王石数量不足，无法进化！");
            return;
         }
         ActivityExchangeCommander.exchange(8596);
      }
   }
}

