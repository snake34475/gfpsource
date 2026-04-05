package com.gfp.app.fight
{
   import com.gfp.app.cartoon.AnimatHeadString;
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.cartoon.event.AnimatEvent;
   import com.gfp.app.manager.DpsManager;
   import com.gfp.app.manager.FightPluginManager;
   import com.gfp.app.manager.NewTitileActivityManager;
   import com.gfp.app.manager.PreviouslyLoaderManager;
   import com.gfp.app.manager.fightPlugin.AutoRecoverManager;
   import com.gfp.app.miniMap.MiniMap;
   import com.gfp.app.systems.ClientTempState;
   import com.gfp.app.systems.WallowRemindChild;
   import com.gfp.app.toolBar.FightPluginEntry;
   import com.gfp.app.toolBar.HeadHeroSoulPanel;
   import com.gfp.app.toolBar.HeadMemberPanel;
   import com.gfp.app.toolBar.HeadOgrePanel;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.config.xml.TollgateXMLInfo;
   import com.gfp.core.events.DataEvent;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.TaskCommonEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.TollgateLimitInfo;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.info.dailyActivity.SwapTimesInfo;
   import com.gfp.core.info.fight.FightReadyInfo;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.language.CoreLanguageDefine;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.FunctionManager;
   import com.gfp.core.manager.HeroSoulManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MagicChangeManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.ShaoDangMananger;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.SkillStateManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.map.FightMap;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   import com.gfp.core.model.SpriteModel;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.ExtenalUIPanel;
   import com.gfp.core.utils.Direction;
   import com.gfp.core.utils.FightMode;
   import com.gfp.core.utils.Logger;
   import com.gfp.core.utils.SpriteType;
   import com.gfp.core.utils.StringConstants;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.ds.HashMap;
   import org.taomee.net.SocketEvent;
   import org.taomee.stat.StatisticsManager;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.Delegate;
   import org.taomee.utils.DisplayUtil;
   
   public class PveEntry extends FightEntry
   {
      
      private static var _instance:PveEntry;
      
      private var _difficulty:uint;
      
      private var _status:uint;
      
      private var _beginMapID:uint;
      
      private const COUNT_DOWN_STEP:int = 10;
      
      private var _doubleExpCountDownTimer:Timer;
      
      private var _isDoubleExpState:Boolean = false;
      
      private var _isStagePass:Boolean = false;
      
      private const TOWER_STAGE_MIN:uint = 801;
      
      private const TOWER_STAGE_MAX:uint = 900;
      
      private const TASK_STAGE_MIN:uint = 901;
      
      private const TASK_STAGE_MAX:uint = 1000;
      
      private var _enterFunc:Function;
      
      public var winAlertMessage:String;
      
      private var _tstageID:int;
      
      private var _tdiff:int;
      
      private var _ttype:int;
      
      private var _ttollgateArgs:int;
      
      private var _tgodOperator:int;
      
      private var _endMc:ExtenalUIPanel;
      
      private var _timeId:int;
      
      public function PveEntry()
      {
         super();
      }
      
      public static function get instance() : PveEntry
      {
         if(_instance == null)
         {
            _instance = new PveEntry();
         }
         return _instance;
      }
      
      public static function destroy() : void
      {
         if(_instance)
         {
            _instance.destroy();
            _instance = null;
         }
      }
      
      public static function enterTollgate(param1:uint, param2:uint = 1, param3:uint = 0, param4:int = 0, param5:int = 0, param6:Boolean = true) : void
      {
         NewTitileActivityManager.inst.initEnterStage(param1,param2);
         if(ShaoDangMananger.isShaoDang)
         {
            ShaoDangMananger.instance.onFuncDis();
            return;
         }
         MainManager.stageRecordInfo.setCurrentDifficulty(param2);
         instance.enterTollgate(param1,param2,param3,param4,param5,param6);
         instance.setStagePassState(MainManager.stageRecordInfo.isStagePass(param1,param2 - 1));
      }
      
      public static function jumpTollgate(param1:uint, param2:uint = 11) : void
      {
         MainManager.stageRecordInfo.setCurrentDifficulty(param2);
         instance.jumpTollgate(param1,param2);
      }
      
      public static function changeMap(param1:uint, param2:int = 1) : void
      {
         if(_instance)
         {
            _instance.changeMap(param1,param2);
         }
      }
      
      public static function afreshTollgate() : void
      {
         if(_instance)
         {
            _instance.afreshTollgate();
         }
      }
      
      public static function onReason() : void
      {
         if(_instance)
         {
            _instance.onReason();
         }
      }
      
      public static function onWinner() : void
      {
         if(_instance)
         {
            _instance.onWinner();
         }
      }
      
      public static function onActorRevive() : void
      {
         if(_instance)
         {
            _instance.onActorRevive();
         }
      }
      
      public static function enterTollgateTeam(param1:uint, param2:uint = 1) : void
      {
         MainManager.stageRecordInfo.setCurrentDifficulty(param2);
         instance.enterTollgateTeam(param1,param2);
      }
      
      override public function setup(param1:FightReadyInfo) : void
      {
         _mapType = MapType.PVE;
         super.setup(param1);
         _resLoader.loadTollgate(_readyInfo.roles,_readyInfo.ogres,_stageID);
         PreviouslyLoaderManager.instance.calculatePreviousResoure(_newMapID,true);
         this._beginMapID = _newMapID;
         FightManager.instance.addEventListener(FightEvent.REASON,this.onIsQuitQuickly,false,100);
      }
      
      private function onIsQuitQuickly(param1:FightEvent) : void
      {
         var evt:FightEvent = param1;
         if(_stageID == 0)
         {
            return;
         }
         if(TollgateXMLInfo.getTollgateInfoById(_stageID).quitOnEnd)
         {
            setTimeout(function():void
            {
               FightManager.quit();
            },3000);
            return;
         }
      }
      
      override public function destroy() : void
      {
         CityMap.instance.disableChangeMap = false;
         super.destroy();
         this.stopDoubleTimeCountDown();
         WallowRemindChild.instance.showBlockMsg();
         FightOgreManager.removeOgreDieListner();
         SocketConnection.removeCmdListener(CommandID.STAGE_ENTRY,this.onEntryStage);
         SocketConnection.removeCmdListener(CommandID.STAGE_CHANGE_MAP,this.onStageChangeMap);
         SocketConnection.removeCmdListener(CommandID.STAGE_TEAMMATE_CHANGE_MAP,this.onStageTeammateChangeMap);
         SocketConnection.removeCmdListener(CommandID.STAGE_AFRESH,this.onStageAfresh);
         if(this._enterFunc != null)
         {
            SocketConnection.removeCmdListener(CommandID.PVE_SYN_HOME_INFO,this._enterFunc);
            this._enterFunc = null;
         }
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_OPEN,this.onStageMapComplete);
         setStageID(0);
         this._beginMapID = 0;
         this.removeMemnerHead();
         FightManager.isTeamFight = false;
         FightOgreManager.clearMember();
         RollItemPanel.destroy();
         UserManager.removeEventListener(UserEvent.DIE,this.onUserDied);
         FightPluginEntry.destroy();
         PreviouslyLoaderManager.destroy();
         MainManager.actorModel.hideBattleSoulModel();
         MagicChangeManager.instance.uninstallBlockFilter(this.disbaleMagicChange);
      }
      
      public function enterTollgate(param1:uint, param2:uint = 1, param3:uint = 0, param4:int = 0, param5:int = 0, param6:Boolean = true) : void
      {
         this.winAlertMessage = null;
         if(FunctionManager.disabledTollgate.indexOf(param1) != -1)
         {
            FunctionManager.dispatchDisabledEvt();
            return;
         }
         if(Boolean(TollgateXMLInfo.isDisableMagic(param1)) && Boolean(MagicChangeManager.instance.getCurrentInfo()))
         {
            AlertManager.showSimpleAlarm("小侠士，该关卡72变状态无法进入。");
            return;
         }
         if(MainManager.actorModel.isZhengGued)
         {
            AlertManager.showSimpleAlarm("小侠士，你正处于整蛊变身状态，不能参加任何战斗哦");
            return;
         }
         if(TollgateXMLInfo.getTollgateInfoById(param1).disabledGo)
         {
            FightGo.instance.enabledShow = false;
         }
         else
         {
            FightGo.instance.enabledShow = true;
         }
         if(FunctionManager.allowTollgate.length == 0 || FunctionManager.allowTollgate.indexOf(param1) != -1)
         {
            if(MapManager.mapInfo.mapType == MapType.MINI_ROOM && param1 == 952)
            {
               this._enterFunc = Delegate.create(this.syncEnterTollGate,param1,param2,param3,param4,param5);
               SocketConnection.addCmdListener(CommandID.PVE_SYN_HOME_INFO,this._enterFunc);
               SocketConnection.send(CommandID.PVE_SYN_HOME_INFO);
            }
            else
            {
               if(MainManager.actorInfo.wulinID != 0)
               {
                  AlertManager.showSimpleAlarm(CoreLanguageDefine.WULIN_MSG_ARR[1]);
                  return;
               }
               this.doEnterTollGate(param1,param2,param3,param4,param5,param6);
            }
         }
         else
         {
            FunctionManager.dispatchDisabledEvt();
         }
      }
      
      private function syncEnterTollGate(param1:SocketEvent, param2:uint, param3:uint = 1, param4:uint = 0, param5:int = 0) : void
      {
         SocketConnection.removeCmdListener(CommandID.PVE_SYN_HOME_INFO,this._enterFunc);
         this.doEnterTollGate(param2,param3,param4,param5);
      }
      
      private function doEnterTollGate(param1:uint, param2:uint = 1, param3:uint = 0, param4:int = 0, param5:int = 0, param6:Boolean = true) : void
      {
         var consume:int = 0;
         var leftTime:int = 0;
         var id:int = 0;
         var stageID:uint = param1;
         var diff:uint = param2;
         var type:uint = param3;
         var tollgateArgs:int = param4;
         var godOperator:int = param5;
         var checkLimitItems:Boolean = param6;
         var tollgateInfo:TollgateLimitInfo = TollgateXMLInfo.getTollgateLimtInfo(stageID,diff,type);
         if(tollgateInfo)
         {
            if(tollgateInfo.mustUseItem != 0)
            {
               type = uint(tollgateInfo.mustUseItem);
            }
            if(checkLimitItems && !this.checkUnlimitedItemsAvailible(stageID,diff,type))
            {
               AlertManager.showSimpleAlarm(this.showUnlimitedItemAlert(stageID,diff,false,type));
               return;
            }
            if(tollgateInfo.mustUseItem != 0 && Boolean(tollgateInfo.beNotice))
            {
               AlertManager.showSimpleAlert(this.showUnlimitedItemAlert(stageID,diff,true,type),Delegate.create(this.confirmEnterTollGate,stageID,diff,type,tollgateArgs));
               return;
            }
         }
         if(diff != 5)
         {
            consume = int(TollgateXMLInfo.getTollgateConsume(stageID,diff));
         }
         else
         {
            consume = 5;
         }
         if(consume != 0)
         {
            if(!MainManager.actorInfo.isTurnBack)
            {
               AlertManager.showSimpleAlarm("只有转生的侠士才能挑战转生难度哦！无数的挑战和宝藏在等着你，还不转生？");
               return;
            }
            if(MainManager.actorInfo.energyPoint < consume)
            {
               AlertManager.showSimpleAlarm("小侠士，进入该关卡需要消耗" + consume + "点活力值，您当前的活力值不够。");
               return;
            }
         }
         if(MapManager.isFightMap)
         {
            Logger.error(this,"已战斗中，不能进入关卡");
            return;
         }
         if(consume != 0)
         {
            if(ClientTempState.consumePveStatus)
            {
               this.confirmEnterTollGate(stageID,diff,type,tollgateArgs,godOperator);
            }
            else
            {
               AlertManager.showSimpleAlert("小侠士，进入该关卡需要消耗" + consume + "点活力值,是否确认？",function(param1:Boolean):void
               {
                  ClientTempState.consumePveStatus = param1;
                  confirmEnterTollGate(stageID,diff,type,tollgateArgs,godOperator);
               },null,true);
            }
         }
         else
         {
            if(stageID >= 117 && stageID <= 121)
            {
               leftTime = 5 - ActivityExchangeTimesManager.getTimes(4013);
               if(leftTime <= 0)
               {
                  AlertManager.showSimpleAlarm("小侠士，今天的挑战次数已经用完，请明天再来吧！");
                  return;
               }
               AlertManager.showSimpleAlert("小侠士，幻境崖深邃莫测，不可久留。今日剩余进入次数<font color=\'#FF0000\'>" + leftTime + "次</font>，确定进入吗？",function():void
               {
                  confirmEnterTollGate(stageID,diff,type,tollgateArgs,godOperator);
                  ActivityExchangeTimesManager.updataTimesByOnce(4013);
               });
               return;
            }
            switch(stageID)
            {
               case 1058:
               case 1051:
               case 1049:
               case 1139:
                  id = 0;
                  if(stageID == 1058)
                  {
                     id = 5641;
                  }
                  if(stageID == 1051)
                  {
                     id = 5585;
                  }
                  if(stageID == 1049)
                  {
                     id = 5528;
                  }
                  if(stageID == 1139)
                  {
                     id = 6877;
                  }
                  this._tstageID = stageID;
                  this._tdiff = diff;
                  this._ttype = type;
                  this._ttollgateArgs = tollgateArgs;
                  this._tgodOperator = godOperator;
                  ActivityExchangeTimesManager.addEventListener(id,this.getTimes);
                  ActivityExchangeTimesManager.getActiviteTimeInfo(id);
                  return;
               default:
                  this.confirmEnterTollGate(stageID,diff,type,tollgateArgs,godOperator);
            }
         }
      }
      
      private function getTimes(param1:DataEvent) : void
      {
         var evt:DataEvent = param1;
         var times:int = int((evt.data as SwapTimesInfo).times);
         if(times >= 5)
         {
            AlertManager.showSimpleAlarm("小侠士，今天的挑战次数已经用完，请明天再来吧！");
            return;
         }
         AlertManager.showSimpleAlert("今日剩余进入次数" + (5 - times).toString() + "次, 确定进入吗?",function():void
         {
            confirmEnterTollGate(_tstageID,_tdiff,_ttype,_ttollgateArgs,_tgodOperator);
         });
         ActivityExchangeTimesManager.removeEventListener((evt.data as SwapTimesInfo).dailyID,this.getTimes);
      }
      
      private function confirmEnterTollGate(param1:uint, param2:uint = 1, param3:uint = 0, param4:int = 0, param5:int = 0, param6:Boolean = true) : void
      {
         var ba:ByteArray;
         var stageID:uint = param1;
         var diff:uint = param2;
         var type:uint = param3;
         var tollgateArgs:int = param4;
         var godOperator:int = param5;
         var alertFightValue:Boolean = param6;
         if(Boolean(TollgateXMLInfo.isDisableMagic(stageID)) && Boolean(MagicChangeManager.instance.getCurrentInfo()))
         {
            AlertManager.showSimpleAlarm("小侠士，该关卡72变状态无法进入。");
            return;
         }
         if(alertFightValue && MainManager.actorInfo.fightPower < TollgateXMLInfo.getTollgateInfoById(stageID).getRecommentFightValue(diff))
         {
            AlertManager.showSimpleAlert("小侠士，你的战力未达推荐战力，是否要变强？",function():void
            {
               ModuleManager.turnAppModule("TurnStrongPanel");
            },function():void
            {
               confirmEnterTollGate(stageID,diff,type,tollgateArgs,godOperator,false);
            });
            return;
         }
         this._difficulty = diff;
         FightOgreManager.setDifficulty(diff);
         FightManager.fightMode = FightMode.PVE;
         _mapType = MapType.PVE;
         setStageID(stageID);
         this._status = MainManager.actorInfo.changeClothID > 0 ? 1 : 0;
         SocketConnection.addCmdListener(CommandID.STAGE_ENTRY,this.onEntryStage);
         ba = new ByteArray();
         ba.writeUnsignedInt(_stageID);
         ba.writeByte(diff);
         ba.writeUnsignedInt(type);
         ba.writeUnsignedInt(tollgateArgs);
         ba.writeUnsignedInt(godOperator);
         ba.writeUnsignedInt(FightPluginManager.instance.isPluginRunning ? 1 : 0);
         SocketConnection.send(CommandID.STAGE_ENTRY,ba);
         switch(stageID)
         {
            case 1063:
               StatisticsManager.sendHttpStat("魅影之谜","进入关卡1063人数",null,MainManager.actorID);
         }
         MagicChangeManager.instance.installBlockFilter(this.disbaleMagicChange);
      }
      
      private function checkUnlimitedItemsAvailible(param1:uint, param2:uint, param3:uint) : Boolean
      {
         var _loc5_:Array = null;
         var _loc6_:uint = 0;
         var _loc7_:* = 0;
         var _loc8_:Array = null;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         if(param1 >= 989 && param1 <= 997)
         {
            if(ItemManager.getItemCount(1410053) > 0)
            {
               return true;
            }
         }
         var _loc4_:TollgateLimitInfo = TollgateXMLInfo.getTollgateLimtInfo(param1,param2,param3);
         if(_loc4_)
         {
            _loc5_ = _loc4_.unlimiteItemArr;
            if((Boolean(_loc5_)) && _loc5_.length != 0)
            {
               _loc6_ = 0;
               while(_loc6_ < _loc5_.length)
               {
                  _loc7_ = 0;
                  _loc8_ = _loc5_[_loc6_++];
                  while(_loc7_ < _loc8_.length)
                  {
                     _loc9_ = uint(_loc8_[_loc7_++]);
                     _loc10_ = uint(_loc8_[_loc7_++]);
                     if(_loc9_ <= 10)
                     {
                        switch(_loc9_)
                        {
                           case 4:
                              if(MainManager.actorInfo.huntAward < _loc10_)
                              {
                                 return false;
                              }
                        }
                     }
                     else if(ItemManager.getItemCount(_loc9_) < _loc10_)
                     {
                        break;
                     }
                     if(_loc7_ == _loc8_.length)
                     {
                        return true;
                     }
                  }
               }
            }
         }
         return false;
      }
      
      private function showUnlimitedItemAlert(param1:uint, param2:uint, param3:Boolean, param4:uint) : String
      {
         var _loc5_:String = null;
         var _loc8_:Array = null;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc6_:TollgateLimitInfo = TollgateXMLInfo.getTollgateLimtInfo(param1,param2,param4);
         var _loc7_:String = "";
         if(_loc6_)
         {
            _loc8_ = _loc6_.unlimiteItemArr;
            if((Boolean(_loc8_)) && _loc8_.length != 0)
            {
               _loc8_ = _loc8_[_loc8_.length - 1];
               _loc9_ = 0;
               while(_loc9_ < _loc8_.length)
               {
                  _loc10_ = uint(_loc8_[_loc9_]);
                  _loc9_++;
                  _loc11_ = uint(_loc8_[_loc9_]);
                  _loc9_++;
                  if(_loc10_ <= 10)
                  {
                     switch(_loc10_)
                     {
                        case 4:
                           _loc7_ += AppLanguageDefine.GET_AWARD_COLLECTION[3] + " *" + _loc11_ + ",";
                     }
                  }
                  else
                  {
                     _loc7_ += ItemXMLInfo.getName(_loc10_) + " *" + _loc11_ + ",";
                  }
               }
            }
         }
         _loc5_ = AppLanguageDefine.TOLLGATE_CHARACTER_COLLECTION[5] + _loc7_;
         if(!param3)
         {
            _loc5_ += AppLanguageDefine.TOLLGATE_CHARACTER_COLLECTION[6];
         }
         else
         {
            _loc5_ += "确认进入吗？";
         }
         return _loc5_;
      }
      
      public function enterTollgateTeam(param1:uint, param2:uint = 1) : void
      {
         if(FunctionManager.disabledTollgate.indexOf(param1) != -1)
         {
            FunctionManager.dispatchDisabledEvt();
            return;
         }
         if(TollgateXMLInfo.getTollgateInfoById(param1).disabledGo)
         {
            FightGo.instance.enabledShow = false;
         }
         else
         {
            FightGo.instance.enabledShow = true;
         }
         if(FunctionManager.allowTollgate.length == 0 || FunctionManager.allowTollgate.indexOf(param1) != -1)
         {
            if(MapManager.isFightMap)
            {
               Logger.error(this,"已战斗中，不能进入关卡");
               return;
            }
            if(MainManager.actorInfo.wulinID != 0)
            {
               AlertManager.showSimpleAlarm(CoreLanguageDefine.WULIN_MSG_ARR[1]);
               return;
            }
            this._difficulty = param2;
            FightOgreManager.setDifficulty(param2);
            FightManager.fightMode = FightMode.PVE;
            _mapType = MapType.PVE;
            setStageID(param1);
            SocketConnection.addCmdListener(CommandID.STAGE_CHANGE_MAP,this.onStageChangeMap);
            if(FightManager.isTeamFight)
            {
               SocketConnection.addCmdListener(CommandID.STAGE_TEAMMATE_CHANGE_MAP,this.onStageTeammateChangeMap);
            }
            MapManager.addEventListener(MapEvent.MAP_SWITCH_OPEN,this.onStageMapComplete);
         }
         else
         {
            FunctionManager.dispatchDisabledEvt();
         }
      }
      
      public function changeMap(param1:uint, param2:int = 1) : void
      {
         _newMapID = param1;
         _mapType = MapType.PVE;
         FightMap.instance.changeMap(_newMapID,_mapType,param2);
      }
      
      public function afreshTollgate() : void
      {
         if(_firstEntry && _stageID > 0)
         {
            SocketConnection.addCmdListener(CommandID.STAGE_AFRESH,this.onStageAfresh);
            SocketConnection.send(CommandID.STAGE_AFRESH,FightPluginManager.instance.isPluginRunning ? 1 : 0);
            FightGo.destroy();
         }
      }
      
      public function jumpTollgate(param1:uint, param2:uint = 1) : void
      {
         if(!MapManager.isFightMap)
         {
            Logger.error(this,"不在战斗中，不能跳转关卡");
            return;
         }
         this.destroy();
         FightOgreManager.setDifficulty(param2);
         FightManager.fightMode = FightMode.PVE;
         _mapType = MapType.PVE;
         setStageID(param1);
         SocketConnection.addCmdListener(CommandID.STAGE_JUMP,this.onEntryStage);
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeUnsignedInt(_stageID);
         SocketConnection.send(CommandID.STAGE_JUMP,_loc3_);
      }
      
      public function initMemberHead() : void
      {
         var _loc4_:UserInfo = null;
         var _loc5_:uint = 0;
         var _loc6_:HeadMemberPanel = null;
         if(_teamMemberHead != null)
         {
            return;
         }
         _teamMemberHead = new HashMap();
         var _loc1_:Array = FightOgreManager.teamMemberMap.getKeys();
         var _loc2_:int = int(_loc1_.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = FightOgreManager.teamMemberMap.getValue(_loc1_[_loc3_]);
            _loc5_ = uint(SpriteModel.getSpriteType(_loc4_.roleType));
            if(_loc5_ == SpriteType.PEOPLE && _loc4_.userID != MainManager.actorID)
            {
               _loc6_ = new HeadMemberPanel();
               _loc6_.init(_loc4_);
               _loc6_.show();
               _loc6_.sprite.y = 120 + _loc3_ * 70;
               _teamMemberHead.add(_loc4_.userID,_loc6_);
            }
            _loc3_++;
         }
      }
      
      public function setMemberAttribute(param1:int, param2:int, param3:int) : void
      {
         if(_teamMemberHead == null)
         {
            return;
         }
         var _loc4_:HeadMemberPanel = _teamMemberHead.getValue(param1);
         if(_loc4_)
         {
            _loc4_.onHP(param2);
            if(param3 != -1)
            {
               _loc4_.onMP(param3);
            }
         }
      }
      
      public function setMemberLv(param1:int, param2:int) : void
      {
         if(_teamMemberHead == null)
         {
            return;
         }
         var _loc3_:HeadMemberPanel = _teamMemberHead.getValue(param1);
         if(_loc3_)
         {
            _loc3_.onLv(param2);
         }
      }
      
      protected function onStageAfresh(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.STAGE_AFRESH,this.onStageAfresh);
         HeadOgrePanel.instance.destroyBoss(0,true);
         FightOgreManager.clearOgre();
         FightOperatePanel.instance.onClose();
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_OPEN,this.onStageMapComplete);
         MapManager.addEventListener(MapEvent.MAP_SWITCH_OPEN,this.onStageMapComplete);
         MapManager.addEventListener(MapEvent.MAP_SWITCH_OPEN,onMapComplete);
         FightMap.instance.changeMap(this._beginMapID,_mapType);
         MiniMap.instance.reset();
         MiniMap.instance.init(_stageID);
         clearSlow();
         MainManager.actorModel.actionManager.clear();
         DpsManager.getInstance().clear();
         HeadHeroSoulPanel.destroy();
         HeroSoulManager.callSoulCount = 0;
         SummonManager.callSummonCount = 0;
         SkillStateManager.getInstance().clear();
         instance.setStagePassState(MainManager.stageRecordInfo.isStagePass(_stageID,MainManager.stageRecordInfo.currentDifficulty));
      }
      
      public function onEntryStage(param1:SocketEvent) : void
      {
         CityMap.instance.disableChangeMap = true;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         SocketConnection.removeCmdListener(CommandID.STAGE_ENTRY,this.onEntryStage);
         SocketConnection.addCmdListener(CommandID.STAGE_CHANGE_MAP,this.onStageChangeMap);
         if(FightManager.isTeamFight)
         {
            SocketConnection.addCmdListener(CommandID.STAGE_TEAMMATE_CHANGE_MAP,this.onStageTeammateChangeMap);
         }
         if(Boolean(MainManager.actorInfo.isVip) && Boolean(TollgateXMLInfo.isCanUserAddHp(MainManager.tollgateId)))
         {
            AutoRecoverManager.instance.vipSetup();
         }
         DpsManager.getInstance().clear();
         FightManager.instance.dispatchEvent(new FightEvent(FightEvent.PVE_ENTER));
         MapManager.addEventListener(MapEvent.MAP_SWITCH_OPEN,this.onStageMapComplete);
      }
      
      private function disbaleMagicChange() : Boolean
      {
         return TollgateXMLInfo.isDisableMagic(_stageID);
      }
      
      private function onStageChangeMap(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:Point = new Point(_loc2_.readUnsignedInt(),_loc2_.readUnsignedInt());
         var _loc4_:uint = _loc2_.readUnsignedByte();
         MainManager.actorInfo.pos = _loc3_;
         MainManager.actorModel.pos = _loc3_;
         MainManager.actorModel.direction = Direction.indexToStr2(_loc4_);
         SightManager.hide(SpriteType.TELEPORTER);
         FightMap.instance.initMap();
         MiniMap.instance.changeMap(MapManager.mapInfo);
         MainManager.openOperate();
      }
      
      private function onStageTeammateChangeMap(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         if(_loc3_ != MainManager.actorID)
         {
            MiniMap.instance.teammateChangeMap(_loc4_);
            if(_loc4_ == 0 && FightManager.isTeamFight)
            {
               this.clearMemberHead(_loc3_);
               FightOgreManager.removeMember(_loc3_);
            }
         }
         MainManager.openOperate();
      }
      
      private function clearMemberHead(param1:int) : void
      {
         var _loc2_:HeadMemberPanel = null;
         if(_teamMemberHead)
         {
            _loc2_ = _teamMemberHead.getValue(param1);
            if(_loc2_)
            {
               _loc2_.destroy();
               _teamMemberHead.remove(param1);
            }
         }
      }
      
      override protected function onReadyComplete(param1:SocketEvent) : void
      {
         if(MainManager.doubleExpTimeLeft > 0 && !this.isInTowerStage())
         {
            this._isDoubleExpState = true;
            this.stopDoubleTimeCountDown();
            this.startDoubleTimeCountDown();
         }
         super.onReadyComplete(param1);
      }
      
      public function isInTowerStage() : Boolean
      {
         return _stageID >= this.TOWER_STAGE_MIN && _stageID <= this.TOWER_STAGE_MAX || (_stageID == 112 || _stageID == 113);
      }
      
      public function getType() : int
      {
         return TollgateXMLInfo.getType(_stageID);
      }
      
      public function isInTaskStage() : Boolean
      {
         return TollgateXMLInfo.getType(_stageID) == 1;
      }
      
      public function isOperateAutoPop() : Boolean
      {
         if(this.isInTowerStage())
         {
            return false;
         }
         return true;
      }
      
      private function startDoubleTimeCountDown() : void
      {
         var _loc1_:int = int(MainManager.doubleExpTimeLeft);
         if(_loc1_ > 0)
         {
            this._doubleExpCountDownTimer = new Timer(this.COUNT_DOWN_STEP * 1000);
            this._doubleExpCountDownTimer.addEventListener(TimerEvent.TIMER,this.onDoubleCountDown);
            this._doubleExpCountDownTimer.start();
         }
      }
      
      private function stopDoubleTimeCountDown() : void
      {
         if(this._doubleExpCountDownTimer)
         {
            this._doubleExpCountDownTimer.stop();
            this._doubleExpCountDownTimer = null;
         }
      }
      
      private function onDoubleCountDown(param1:TimerEvent) : void
      {
         MainManager.doubleExpTimeLeft -= this.COUNT_DOWN_STEP;
         if(MainManager.doubleExpTimeLeft < 0)
         {
            MainManager.doubleExpTimeLeft = 0;
         }
      }
      
      public function checkDoubleExpState() : Boolean
      {
         return this._isDoubleExpState;
      }
      
      public function setStagePassState(param1:Boolean) : void
      {
         this._isStagePass = param1;
      }
      
      public function checkStagePassOnEnterTollstate() : Boolean
      {
         return this._isStagePass;
      }
      
      public function checkCommonTollgate(param1:uint) : Boolean
      {
         return param1 < 700;
      }
      
      private function onStageMapComplete(param1:MapEvent) : void
      {
         if(_firstEntry)
         {
            SocketConnection.send(CommandID.STAGE_CHANGE_MAP,_newMapID);
         }
         else
         {
            MiniMap.instance.init(_stageID);
         }
      }
      
      override protected function onBegin(param1:SocketEvent) : void
      {
         super.onBegin(param1);
         fightInit();
         FightPluginEntry.instance.show();
         FightOgreManager.addOgreDieListener();
         MainManager.openOperate();
         UserManager.addEventListener(UserEvent.DIE,this.onUserDied);
         initSkillCD();
         FightManager.instance.dispatchEvent(new FightEvent(FightEvent.BEGIN));
         HeroSoulManager.callSoulCount = 0;
         SummonManager.callSummonCount = 0;
         SkillStateManager.getInstance().clear();
         if(Boolean(HeroSoulManager.getActorHeroSoulInfo().currentHeroSoulInfo) && HeroSoulManager.getActorHeroSoulInfo().currentHeroSoulInfo.state != 3)
         {
            MainManager.actorModel.showBattleSoulModel();
         }
      }
      
      private function onUserDied(param1:UserEvent) : void
      {
         var _loc3_:String = null;
         var _loc2_:UserModel = param1.data;
         if(Boolean(_loc2_) && Boolean(_loc2_.info))
         {
            _loc3_ = _stageID + StringConstants.SIGN + this._difficulty + StringConstants.SIGN + _loc2_.info.roleType;
            TasksManager.dispatchActionEvent(TaskActionEvent.TASK_DIFFICULTY_MONSTERWANTED,_loc3_);
         }
      }
      
      override protected function onActorDie(param1:UserEvent) : void
      {
         var _loc2_:int = 0;
         super.onActorDie(param1);
         MainManager.closeOperate(false,true);
         if(FightManager.isAutoReasonEnd)
         {
            _loc2_ = _reasonCode == 0 ? int(MainManager.actorID) : _reasonCode;
            startSlow(0,_reasonCode);
         }
         FightManager.isAutoReasonEnd = true;
         FightManager.instance.dispatchEvent(new FightEvent(FightEvent.REASON));
      }
      
      override protected function winnerFun(param1:uint, param2:uint) : void
      {
         super.winnerFun(param1,param2);
         FightOgreManager.clearOgre();
      }
      
      override protected function reasonFun(param1:uint, param2:uint) : void
      {
         super.reasonFun(param1,param2);
      }
      
      override public function onWinner() : void
      {
         var _loc1_:uint = 0;
         FightOperatePanel.instance.onShow();
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_TOLLGATE_PASSED,String(_stageID));
         if(_awardInfo != null)
         {
            TasksManager.dispatchCommonEvent(TaskCommonEvent.TASK_PASSTIME_LESSLIMIT,_stageID + "_" + _awardInfo.passTime);
         }
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_TOLLGATE_DIFFICLTY,"0" + StringConstants.SIGN + this._difficulty);
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_TOLLGATE_DIFFICLTY,_stageID + StringConstants.SIGN + this._difficulty);
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_ALL_TOLLGATE_DIFFICLTY,String(this._difficulty));
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_TOLLGATE_ENTER_STATUS,_stageID + StringConstants.SIGN + this._status);
         if(_awardInfo)
         {
            TasksManager.dispatchParamsEvent(TaskActionEvent.TASK_TOLLGATE_DETAIL_INFO,_awardInfo);
         }
         FightOgreManager.clearOgre();
         if(_stageID == 0)
         {
            return;
         }
         if(_awardInfo)
         {
            if(Boolean(_awardInfo) && _awardInfo.point < 4294967295)
            {
               MainManager.actorInfo.huntAward += _awardInfo.point;
            }
            if(!FightManager.isTeamFight)
            {
               MainManager.stageRecordInfo.setStagePass(_stageID,_awardInfo.grade);
            }
         }
         if(TollgateXMLInfo.getTollgateInfoById(_stageID).quitOnEnd)
         {
            FightManager.quit();
            return;
         }
         if(!this.isInTowerStage())
         {
            _loc1_ = uint(MainManager.stageRecordInfo.currentDifficulty);
            if(_loc1_ < 3 && instance.getType() != 1)
            {
               if(this.checkCommonTollgate(_stageID) && !this.checkStagePassOnEnterTollstate() && Boolean(MainManager.stageRecordInfo.isStagePass(_stageID,_loc1_)))
               {
                  if(TollgateXMLInfo.isTurnBackTollgate(_stageID))
                  {
                     if(_loc1_ < 1)
                     {
                        AnimatPlay.addAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimateEnd);
                        AnimatPlay.startAnimat(AnimatHeadString.STAGE_TURN,_loc1_ + 1,true,0,0,false,false,true,0);
                        return;
                     }
                  }
                  else if(!MainManager.actorInfo.isTurnBack && _loc1_ == 0)
                  {
                  }
               }
            }
            if(Boolean(FunctionManager.disabledFightAwardPanel) || Boolean(TollgateXMLInfo.isDisabledAward(_stageID)))
            {
               MainManager.openOperate();
            }
            else
            {
               ModuleManager.turnModule(ClientConfig.getAppModule("FightAwardPanel"),AppLanguageDefine.LOAD_MATTER_COLLECTION[0],_awardInfo);
               if(_stageID == 1056)
               {
                  if(!this._endMc)
                  {
                     this._endMc = new ExtenalUIPanel("desert_angel_win");
                  }
                  LayerManager.stage.addChild(this._endMc);
                  DisplayUtil.align(this._endMc,null,AlignType.MIDDLE_CENTER);
                  this._timeId = setTimeout(this.removeDesertMc,3000);
               }
               if(this.winAlertMessage != null && this.winAlertMessage != "")
               {
                  AlertManager.showSimpleAlarm(this.winAlertMessage);
                  this.winAlertMessage = null;
               }
            }
            if(_awardInfo != null)
            {
               TasksManager.dispatchCommonEvent(TaskCommonEvent.TASK_BRUISE_LESSLIMIT,_stageID + "_" + _awardInfo.bruiseNum);
            }
         }
      }
      
      private function removeDesertMc() : void
      {
         if(this._endMc)
         {
            this._endMc.destory();
            DisplayUtil.removeForParent(this._endMc);
         }
         clearTimeout(this._timeId);
      }
      
      private function onAnimateEnd(param1:Event) : void
      {
         AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimateEnd);
         if(!FunctionManager.disabledFightAwardPanel)
         {
            ModuleManager.turnModule(ClientConfig.getAppModule("FightAwardPanel"),AppLanguageDefine.LOAD_MATTER_COLLECTION[0],_awardInfo);
         }
         TasksManager.dispatchCommonEvent(TaskCommonEvent.TASK_BRUISE_LESSLIMIT,_stageID + "_" + _awardInfo.bruiseNum);
      }
      
      override protected function onAward(param1:SocketEvent) : void
      {
         super.onAward(param1);
         if(this.isInTowerStage())
         {
            ModuleManager.turnModule(ClientConfig.getAppModule("FightAwardPanel"),AppLanguageDefine.LOAD_MATTER_COLLECTION[0],_awardInfo);
            TasksManager.dispatchCommonEvent(TaskCommonEvent.TASK_BRUISE_LESSLIMIT,_stageID + "_" + _awardInfo.bruiseNum);
         }
      }
      
      override public function onReason(param1:uint = 0) : void
      {
         var hintStr:String = null;
         var maxReviveCount:int = 0;
         var reason:uint = param1;
         if(reason == 7)
         {
            if(_stageID == 1171)
            {
               MainManager.openOperate();
               AlertManager.showSimpleAlarm(AppLanguageDefine.TOLLGATE_CHARACTER_COLLECTION[2]);
               return;
            }
            if(_stageID == 669)
            {
               hintStr = AppLanguageDefine.TOLLGATE_CHARACTER_COLLECTION[10];
            }
            else if(_stageID == 1238)
            {
               hintStr = "时间到，战斗结束!";
            }
            else if([462,463,464,465,467,466].indexOf(_stageID) != -1)
            {
               hintStr = "2分钟时限已到，关卡结束。";
            }
            else if(_stageID == 1104 || _stageID == 1105 || _stageID == 1106)
            {
               hintStr = "小侠士，关卡已结束";
            }
            else if(TollgateQuitReason.REASON.hasOwnProperty(_stageID))
            {
               hintStr = TollgateQuitReason.REASON._stageID;
            }
            else if(_stageID != 414)
            {
               hintStr = AppLanguageDefine.TOLLGATE_CHARACTER_COLLECTION[2];
            }
            if(hintStr != null && hintStr != "")
            {
               AlertManager.showSimpleAlarm(hintStr,function():void
               {
                  FightManager.quit();
               });
            }
            else
            {
               FightManager.quit();
            }
            return;
         }
         if(_stageID == 469 || _stageID == 1034)
         {
            AlertManager.showSimpleAlarm("关卡战斗失败，请重新再来！",function():void
            {
               FightManager.quit();
            });
            return;
         }
         if(!FunctionManager.disabledFightRevive)
         {
            if(MainManager.actorInfo.hp <= 0 && _stageID != 1018 && _stageID != 1030 && _stageID != 1047 && _stageID != 1062 && _stageID != 1096 && _stageID != 1097 && _stageID != 1098)
            {
               maxReviveCount = int(TollgateXMLInfo.getMaxReviveCount(_stageID));
               if(maxReviveCount == 0 || maxReviveCount != 999999 && FightManager.actorDiedCount < maxReviveCount + 1)
               {
                  ModuleManager.turnModule(ClientConfig.getAppModule("FightRevivePanel"),AppLanguageDefine.LOAD_MATTER_COLLECTION[1]);
               }
            }
         }
      }
      
      private function removeMemnerHead() : void
      {
         var _loc1_:Array = null;
         var _loc2_:HeadMemberPanel = null;
         if(FightManager.isTeamFight && Boolean(_teamMemberHead))
         {
            _loc1_ = _teamMemberHead.getValues();
            for each(_loc2_ in _loc1_)
            {
               _loc2_.destroy();
            }
         }
      }
   }
}

