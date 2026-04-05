package com.gfp.app.mapProcess
{
   import com.gfp.app.cartoon.AnimatLimitPlay;
   import com.gfp.app.cartoon.event.AnimatEvent;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.BuffEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.player.SpngPlayer;
   import com.gfp.core.ui.alert.TextAlert;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class MapProcess_1004803 extends BaseMapProcess
   {
      
      private const GRP_RADIUS:uint = 40;
      
      private var _boss:UserModel;
      
      private var _firePosList:Vector.<Point>;
      
      public function MapProcess_1004803()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._firePosList = new Vector.<Point>();
         UserManager.addEventListener(UserEvent.BORN,this.onBossBorn);
         UserManager.addEventListener(UserEvent.DIE,this.onBossDie);
      }
      
      private function onBossBorn(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         if(_loc2_.info.roleType == 13080)
         {
            this.addBossBuffListener();
            TextAlert.show("火炬台已全部点亮，斗兽场的主人终于回来了！");
         }
      }
      
      private function onBossDie(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         if(_loc2_.info.roleType == 13080)
         {
            this.removeBossMoveListener();
         }
      }
      
      private function addBossBuffListener() : void
      {
         this._boss = UserManager.getModelByRoleType(13080);
         this._boss.addEventListener(BuffEvent.BUFF_START,this.onBuffStart);
         this._boss.addEventListener(BuffEvent.BUFF_END,this.onBuffEnd);
      }
      
      private function removeBossBuffListener() : void
      {
         if(this._boss)
         {
            this._boss.removeEventListener(BuffEvent.BUFF_START,this.onBuffStart);
            this._boss.removeEventListener(BuffEvent.BUFF_END,this.onBuffEnd);
            this.removeBossMoveListener();
         }
         AnimatLimitPlay.removeEventListener(AnimatEvent.ANIMAT_END,this.onFireDestroy);
         UserManager.removeEventListener(UserEvent.BORN,this.onBossBorn);
         UserManager.removeEventListener(UserEvent.DIE,this.onBossDie);
      }
      
      private function removeBossMoveListener() : void
      {
         if(this._boss.hasEventListener(Event.ENTER_FRAME))
         {
            this._boss.removeEventListener(Event.ENTER_FRAME,this.onBossMove);
         }
      }
      
      private function onBuffStart(param1:BuffEvent) : void
      {
         if(param1.buffID == 27)
         {
            this.creatFire();
            if(!this._boss.hasEventListener(Event.ENTER_FRAME))
            {
               this._boss.addEventListener(Event.ENTER_FRAME,this.onBossMove);
            }
         }
      }
      
      private function onBuffEnd(param1:BuffEvent) : void
      {
         if(param1.buffID == 27)
         {
            this._boss.removeEventListener(Event.ENTER_FRAME,this.onBossMove);
         }
      }
      
      private function onBossMove(param1:Event) : void
      {
         if(this.checkFireGap())
         {
            this.creatFire();
         }
      }
      
      private function onFireDestroy(param1:AnimatEvent) : void
      {
         var _loc2_:SpngPlayer = param1.data as SpngPlayer;
         this.removeFromList(_loc2_);
      }
      
      private function creatFire() : void
      {
         var _loc1_:SpngPlayer = null;
         _loc1_ = new SpngPlayer();
         _loc1_.setView(ClientConfig.getBuff("fire_land"));
         MapManager.currentMap.downLevel.addChild(_loc1_);
         _loc1_.x = this._boss.x;
         _loc1_.y = this._boss.y;
         this._firePosList.push(new Point(_loc1_.x,_loc1_.y));
         AnimatLimitPlay.addEventListener(AnimatEvent.ANIMAT_END,this.onFireDestroy);
         AnimatLimitPlay.spngPlayForDuration(_loc1_,10000);
      }
      
      private function checkFireGap() : Boolean
      {
         return this._firePosList.every(function(param1:Point, param2:uint, param3:Vector.<Point>):Boolean
         {
            if(Point.distance(_boss.pos,param1) >= GRP_RADIUS)
            {
               return true;
            }
            return false;
         });
      }
      
      private function removeFromList(param1:SpngPlayer) : void
      {
         var target:SpngPlayer = param1;
         this._firePosList = this._firePosList.filter(function(param1:Point, param2:uint, param3:Vector.<Point>):Boolean
         {
            if(target.x == param1.x && target.y == param1.y)
            {
               return false;
            }
            return true;
         });
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this._firePosList.length = 0;
         this.removeBossBuffListener();
         this._boss = null;
      }
   }
}

