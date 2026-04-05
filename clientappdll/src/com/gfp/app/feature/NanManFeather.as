package com.gfp.app.feature
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.cache.SwfCache;
   import com.gfp.core.cache.SwfInfo;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.fight.BruiseInfo;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UserManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.utils.clearInterval;
   import flash.utils.getTimer;
   import flash.utils.setInterval;
   import org.taomee.utils.DisplayUtil;
   
   public class NanManFeather
   {
      
      private static const ALARM:Array = ["小侠士，你在此次活动中伤害排名第一，获得功勋*30，俸禄*15！","小侠士，你在此次活动中伤害排名第二，获得功勋*20，俸禄*10！","小侠士，你在此次活动中伤害排名第三，获得功勋*10，俸禄*5！"];
      
      private var _sumDamage:Array = [0,0,0];
      
      private var _users:Array = PveEntry.instance.fightReadyInfo.roles;
      
      private var _startTime:Number;
      
      private var _damagePosition:Vector.<int> = new Vector.<int>();
      
      private var _ui:Sprite;
      
      private var _timeId:int = 0;
      
      public function NanManFeather()
      {
         super();
         this.init();
         this.addEvent();
      }
      
      private function init() : void
      {
         SwfCache.getSwfInfo(ClientConfig.getSubUI("nanman_dpsrank"),this.onUILoaded);
      }
      
      private function addEvent() : void
      {
         FightManager.instance.addEventListener(FightEvent.WINNER,this.onFightWinner);
         UserManager.addEventListener(UserEvent.USER_DPS_HIT,this.onDpsHit);
      }
      
      private function removeEvent() : void
      {
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onFightWinner);
      }
      
      protected function layout() : void
      {
         if(this._ui)
         {
            this._ui.x = LayerManager.stageWidth + 350 >> 1;
            this._ui.y = 120;
         }
      }
      
      private function updateView() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            this._ui["damageRank" + _loc1_]["damageTxt"].text = this._sumDamage[_loc1_].toString();
            _loc1_++;
         }
         this.sortDamagePanel();
      }
      
      private function onUILoaded(param1:SwfInfo) : void
      {
         var _loc2_:int = 0;
         if(this._ui == null)
         {
            this._ui = param1.content as MovieClip;
            _loc2_ = 0;
            while(_loc2_ < 3)
            {
               this._ui["damageRank" + _loc2_]["flagMc"].gotoAndStop(this._users[_loc2_].countryId + 1);
               this._ui["damageRank" + _loc2_]["nameTxt"].text = this._users[_loc2_].nick;
               this._damagePosition.push(this._ui["damageRank" + _loc2_].y);
               _loc2_++;
            }
            LayerManager.uiLevel.addChild(this._ui);
            this.layout();
            this.updateView();
         }
         this._startTime = getTimer();
         this._timeId = setInterval(this.updateView,1000);
      }
      
      private function sortDamagePanel() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this._sumDamage[0] > this._sumDamage[1])
         {
            _loc1_ = 0;
            _loc2_ = 1;
         }
         else
         {
            _loc1_ = 1;
            _loc2_ = 0;
         }
         if(this._sumDamage[_loc1_] > this._sumDamage[2])
         {
            this._ui["damageRank" + _loc1_].y = this._damagePosition[0];
            if(this._sumDamage[_loc2_] > this._sumDamage[2])
            {
               this._ui["damageRank" + _loc2_].y = this._damagePosition[1];
               this._ui["damageRank" + 2].y = this._damagePosition[2];
            }
            else
            {
               this._ui["damageRank" + 2].y = this._damagePosition[1];
               this._ui["damageRank" + _loc2_].y = this._damagePosition[2];
            }
         }
         else
         {
            this._ui["damageRank" + 2].y = this._damagePosition[0];
            this._ui["damageRank" + _loc1_].y = this._damagePosition[1];
            this._ui["damageRank" + _loc2_].y = this._damagePosition[2];
         }
      }
      
      private function onFightWinner(param1:FightEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < 3)
         {
            if(this._ui["damageRank" + _loc3_]["nameTxt"].text == MainManager.actorInfo.nick)
            {
               _loc2_ = this._damagePosition.indexOf(this._ui["damageRank" + _loc3_].y);
            }
            _loc3_++;
         }
         AlertManager.showSimpleAlarm(ALARM[_loc2_]);
      }
      
      private function onDpsHit(param1:UserEvent) : void
      {
         var _loc2_:BruiseInfo = param1.data as BruiseInfo;
         var _loc3_:int = 0;
         while(_loc3_ < 3)
         {
            if(this._users[_loc3_].userID == _loc2_.atkerID)
            {
               this._sumDamage[_loc3_] += _loc2_.decHP;
            }
            _loc3_++;
         }
      }
      
      private function myDestroy() : void
      {
         clearInterval(this._timeId);
         DisplayUtil.removeForParent(this._ui);
         this._ui = null;
         UserManager.removeEventListener(UserEvent.USER_DPS_HIT,this.onDpsHit);
      }
      
      public function destroy() : void
      {
         this.myDestroy();
         this.removeEvent();
         this._damagePosition = null;
      }
   }
}

