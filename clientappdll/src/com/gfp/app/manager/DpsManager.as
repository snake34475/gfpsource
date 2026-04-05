package com.gfp.app.manager
{
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.fight.BruiseInfo;
   import com.gfp.core.manager.GodManager;
   import com.gfp.core.manager.HeroSoulManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.manager.UserManager;
   
   public class DpsManager
   {
      
      private static var _instance:DpsManager;
      
      private var _sumHurtTotal:int;
      
      private var _heroSoulHurtTotal:int;
      
      private var _godHurtTotal:int;
      
      private var _playerHurtTotal:int;
      
      public function DpsManager()
      {
         super();
      }
      
      public static function getInstance() : DpsManager
      {
         if(!_instance)
         {
            _instance = new DpsManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         UserManager.addEventListener(UserEvent.USER_DPS_HIT,this.onDpsHit);
      }
      
      private function onDpsHit(param1:UserEvent) : void
      {
         var _loc2_:BruiseInfo = param1.data as BruiseInfo;
         if(Boolean(SummonManager.getActorSummonInfo().fightSummonInfo) && _loc2_.atkerID == SummonManager.getActorSummonInfo().fightSummonInfo.stageID)
         {
            this.sumHurtTotal += _loc2_.decHP;
         }
         if(GodManager.fightGodStageID > 0 && _loc2_.atkerID == GodManager.fightGodStageID)
         {
            this._godHurtTotal += _loc2_.decHP;
         }
         if(MainManager.actorInfo.heroSoulType > 0 && _loc2_.atkerID == HeroSoulManager.getActorHeroSoulInfo().currentHeroSoulInfo.stageID)
         {
            this._heroSoulHurtTotal += _loc2_.decHP;
         }
         if(_loc2_.atkerID == MainManager.actorID)
         {
            this.playerHurtTotal += _loc2_.decHP;
         }
      }
      
      public function close() : void
      {
         UserManager.removeEventListener(UserEvent.USER_DPS_HIT,this.onDpsHit);
      }
      
      public function clear() : void
      {
         this._heroSoulHurtTotal = 0;
         this._godHurtTotal = 0;
         this.sumHurtTotal = 0;
         this.playerHurtTotal = 0;
      }
      
      public function get heroSoulHurtTotal() : int
      {
         return this._heroSoulHurtTotal;
      }
      
      public function get godHurtTotal() : int
      {
         return this._godHurtTotal;
      }
      
      public function get sumHurtTotal() : int
      {
         return this._sumHurtTotal;
      }
      
      public function set sumHurtTotal(param1:int) : void
      {
         this._sumHurtTotal = param1;
      }
      
      public function get playerHurtTotal() : int
      {
         return this._playerHurtTotal;
      }
      
      public function set playerHurtTotal(param1:int) : void
      {
         this._playerHurtTotal = param1;
      }
   }
}

