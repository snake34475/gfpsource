package com.gfp.app.mapProcess
{
   import com.gfp.core.CommandID;
   import com.gfp.core.info.fightTeam.FightTeamSummonConfig;
   import com.gfp.core.info.fightTeam.FightTeamSummonInfo;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.TeamsRelationManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.net.SocketConnection;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class MapProcess_1003 extends BaseMapProcess
   {
      
      private var _treasuryBtn:InteractiveObject;
      
      private var _luckyStarBtn:InteractiveObject;
      
      private var _cultureBtn:InteractiveObject;
      
      private var _tollgateBtn:InteractiveObject;
      
      private var _teamFightBtn:InteractiveObject;
      
      private var _summonMC0:MovieClip;
      
      private var _summonMC1:MovieClip;
      
      private var _summonMC2:MovieClip;
      
      public function MapProcess_1003()
      {
         super();
      }
      
      override protected function init() : void
      {
         var _loc1_:int = 0;
         this._treasuryBtn = _mapModel.contentLevel["treasuryBtn"];
         this._luckyStarBtn = _mapModel.contentLevel["luckyStarBtn"];
         this._cultureBtn = _mapModel.contentLevel["cultureBtn"];
         this._tollgateBtn = _mapModel.contentLevel["tollgateBtn"];
         this._teamFightBtn = _mapModel.contentLevel["teamFightBtn"];
         this._summonMC0 = _mapModel.contentLevel["summonMC0"];
         this._summonMC1 = _mapModel.contentLevel["summonMC1"];
         this._summonMC2 = _mapModel.contentLevel["summonMC2"];
         this._summonMC0.gotoAndStop(1);
         this._summonMC1.gotoAndStop(1);
         this._summonMC2.gotoAndStop(1);
         this.addMapEvent();
         if(MainManager.actorInfo.fightTeamId)
         {
            TeamsRelationManager.instance.addEventListener(TeamsRelationManager.FIGHT_TEAM_MEMBER_INFO_READY,this.onFightMemberInfoReady);
            TeamsRelationManager.instance.reqFightTeamsMemberInfo();
         }
         else
         {
            _loc1_ = 0;
            while(_loc1_ < 3)
            {
               this["_summonMC" + _loc1_].gotoAndStop(2 + _loc1_ * 2);
               _loc1_++;
            }
         }
         SocketConnection.send(CommandID.GLORY_FIGHT_RANK,13,0,1);
      }
      
      private function addMapEvent() : void
      {
         this._treasuryBtn.addEventListener(MouseEvent.CLICK,this.treasuryHandle);
         this._luckyStarBtn.addEventListener(MouseEvent.CLICK,this.luckyStarHandle);
         this._cultureBtn.addEventListener(MouseEvent.CLICK,this.cultureHandle);
         this._tollgateBtn.addEventListener(MouseEvent.CLICK,this.tollgateHandle);
         this._teamFightBtn.addEventListener(MouseEvent.CLICK,this.teamFightBtnHandle);
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            this["_summonMC" + _loc1_].addEventListener(MouseEvent.CLICK,this.onSummonClick);
            this["_summonMC" + _loc1_].buttonMode = true;
            _loc1_++;
         }
         SocketConnection.addCmdListener(CommandID.TEAM_ACTIVATE_SUMMON,this.responseActivateSummon);
         TeamsRelationManager.instance.addEventListener(TeamsRelationManager.SUMMON_EVOLVE,this.onSummonEvolve);
      }
      
      private function removeMapEvent() : void
      {
         this._treasuryBtn.removeEventListener(MouseEvent.CLICK,this.treasuryHandle);
         this._luckyStarBtn.removeEventListener(MouseEvent.CLICK,this.luckyStarHandle);
         this._cultureBtn.removeEventListener(MouseEvent.CLICK,this.cultureHandle);
         this._tollgateBtn.removeEventListener(MouseEvent.CLICK,this.tollgateHandle);
         this._teamFightBtn.removeEventListener(MouseEvent.CLICK,this.teamFightBtnHandle);
         TeamsRelationManager.instance.removeEventListener(TeamsRelationManager.FIGHT_TEAM_MEMBER_INFO_READY,this.onFightMemberInfoReady);
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            this["_summonMC" + _loc1_].removeEventListener(MouseEvent.CLICK,this.onSummonClick);
            _loc1_++;
         }
         SocketConnection.removeCmdListener(CommandID.TEAM_ACTIVATE_SUMMON,this.responseActivateSummon);
         TeamsRelationManager.instance.removeEventListener(TeamsRelationManager.SUMMON_EVOLVE,this.onSummonEvolve);
      }
      
      private function onFightMemberInfoReady(param1:Event) : void
      {
         this.updateSummons();
      }
      
      private function updateSummons() : void
      {
         var _loc2_:int = 0;
         var _loc3_:FightTeamSummonInfo = null;
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            _loc2_ = int(FightTeamSummonConfig.SUMMONS[_loc1_]);
            _loc3_ = TeamsRelationManager.instance.fightTeamsMemberInfo.getSummonInfo(_loc2_);
            if(_loc3_)
            {
               this["_summonMC" + _loc1_].gotoAndStop(1 + _loc1_ * 2);
            }
            else
            {
               this["_summonMC" + _loc1_].gotoAndStop(2 + _loc1_ * 2);
            }
            _loc1_++;
         }
      }
      
      private function onSummonClick(param1:MouseEvent) : void
      {
         var configID:int;
         var summon:FightTeamSummonInfo;
         var index:int = 0;
         var maxCount:int = 0;
         var prevSummon:FightTeamSummonInfo = null;
         var event:MouseEvent = param1;
         if(MainManager.actorInfo.fightTeamId == 0)
         {
            AlertManager.showSimpleAlert("小侠士，你还没有侠士团，不能执行该操作。是否要加入一个侠士团呢？",function():void
            {
               ModuleManager.turnAppModule("FightTeamListPanel","");
            });
            return;
         }
         index = int(event.currentTarget.name.substr(-1));
         configID = int(FightTeamSummonConfig.SUMMONS[index]);
         summon = TeamsRelationManager.instance.fightTeamsMemberInfo.getSummonInfo(configID);
         if(summon)
         {
            ModuleManager.turnAppModule("FightTeamSummonPanel","loading..",{"summon":summon});
         }
         else
         {
            maxCount = int(FightTeamSummonConfig.getSummonMaxCount(TeamsRelationManager.instance.fightTeamsMemberInfo.teamLv));
            if(TeamsRelationManager.instance.fightTeamsMemberInfo.summons.length >= maxCount)
            {
               AlertManager.showSimpleAlarm("小侠士，你的侠士团当前的守护兽上限为" + maxCount);
            }
            else if(TeamsRelationManager.instance.fightTeamsMemberInfo.summons.length == index)
            {
               if(index != 0)
               {
                  prevSummon = TeamsRelationManager.instance.fightTeamsMemberInfo.getSummonInfo(FightTeamSummonConfig.SUMMONS[index - 1]);
                  if(Boolean(prevSummon) && prevSummon.level < 6)
                  {
                     AlertManager.showSimpleAlarm("请先把上一个守护兽进化到最终形态！");
                     return;
                  }
               }
               AlertManager.showSimpleAlert("是否解锁该守护兽？",function():void
               {
                  SocketConnection.send(CommandID.TEAM_ACTIVATE_SUMMON,index + 1);
               });
            }
            else
            {
               AlertManager.showSimpleAlarm("请先解锁之前的守护兽！");
            }
         }
      }
      
      private function responseActivateSummon(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         AlertManager.showSimpleAlarm("恭喜你，解锁成功！");
         TeamsRelationManager.instance.fightTeamsMemberInfo.updateFightTeamSummon(_loc2_);
         this.updateSummons();
      }
      
      private function onSummonEvolve(param1:Event) : void
      {
         this.updateSummons();
      }
      
      private function treasuryHandle(param1:MouseEvent) : void
      {
         var event:MouseEvent = param1;
         if(MainManager.actorInfo.fightTeamId == 0)
         {
            AlertManager.showSimpleAlert("小侠士，你还没有侠士团，不能执行该操作。是否要加入一个侠士团呢？",function():void
            {
               ModuleManager.turnAppModule("FightTeamListPanel","");
            });
         }
         else
         {
            ModuleManager.turnAppModule("FightTeamTreasuryPanel");
         }
      }
      
      private function luckyStarHandle(param1:MouseEvent) : void
      {
         var event:MouseEvent = param1;
         if(MainManager.actorInfo.fightTeamId == 0)
         {
            AlertManager.showSimpleAlert("小侠士，你还没有侠士团，不能执行该操作。是否要加入一个侠士团呢？",function():void
            {
               ModuleManager.turnAppModule("FightTeamListPanel","");
            });
         }
         else
         {
            ModuleManager.turnAppModule("FightTeamLuckyStarPanel");
         }
      }
      
      private function cultureHandle(param1:MouseEvent) : void
      {
         var event:MouseEvent = param1;
         if(MainManager.actorInfo.fightTeamId == 0)
         {
            AlertManager.showSimpleAlert("小侠士，你还没有侠士团，不能执行该操作。是否要加入一个侠士团呢？",function():void
            {
               ModuleManager.turnAppModule("FightTeamListPanel","");
            });
         }
         else
         {
            ModuleManager.turnAppModule("FightTeamCulturePanel");
         }
      }
      
      private function tollgateHandle(param1:MouseEvent) : void
      {
         AlertManager.showSimpleAlarm("尚未开放，敬请期待！");
      }
      
      private function teamFightBtnHandle(param1:MouseEvent) : void
      {
         AlertManager.showSimpleAlarm("尚未开放，敬请期待！");
      }
      
      override public function destroy() : void
      {
         this.removeMapEvent();
         super.destroy();
      }
   }
}

