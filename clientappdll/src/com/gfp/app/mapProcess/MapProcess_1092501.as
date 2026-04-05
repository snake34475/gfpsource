package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightGo;
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.app.miniMap.MiniMap;
   import com.gfp.app.toolBar.FightToolBar;
   import com.gfp.app.toolBar.HeadOgrePanel;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.MagicChangeEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.KeyInfo;
   import com.gfp.core.manager.KeyManager;
   import com.gfp.core.manager.MagicChangeManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.ui.alert.TextAlert;
   import flash.events.Event;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   
   public class MapProcess_1092501 extends BaseMapProcess
   {
      
      private var _timerID:uint;
      
      private var _stepCount:uint;
      
      public function MapProcess_1092501()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.resetSkill();
         FightToolBar.instance.disabledSkillQuickKeys();
         FightToolBar.instance.clearSkillQuickKeys();
         FightToolBar.instance.disabledBag();
         MiniMap.instance.hide();
         FightGo.instance.enabledShow = false;
         this.addItemListener();
         this.execAlert();
         this._timerID = setInterval(this.execAlert,20000);
      }
      
      private function resetSkill() : void
      {
         var _loc3_:KeyInfo = null;
         KeyManager.reset();
         var _loc1_:Vector.<KeyInfo> = new Vector.<KeyInfo>(5,true);
         var _loc2_:int = 0;
         while(_loc2_ < 5)
         {
            _loc3_ = new KeyInfo();
            if(_loc2_ == 0)
            {
               _loc3_.dataID = 1700065;
               _loc3_.funcID = 41;
            }
            if(_loc2_ == 4)
            {
               _loc3_.dataID = 1700066;
               _loc3_.funcID = 45;
            }
            _loc1_[_loc2_] = _loc3_;
            _loc2_++;
         }
         KeyManager.upDateItemQuickKeys(_loc1_);
         KeyManager.setItemQuickAutoAddable(false);
      }
      
      private function magicHandle(param1:Event) : void
      {
         this.resetSkill();
      }
      
      private function addItemListener() : void
      {
         FightManager.isAutoWinnerEnd = false;
         FightManager.instance.addEventListener(FightEvent.WINNER,this.onWin);
         UserManager.addEventListener(UserEvent.EXPLODED,this.onOrgeExploded);
         UserManager.addEventListener(UserEvent.BORN,this.onBossBorn);
         MagicChangeManager.instance.addEventListener(MagicChangeEvent.CALL_FIGHT,this.magicHandle);
         MagicChangeManager.instance.addEventListener(MagicChangeEvent.CALL_FIGHT_END,this.magicHandle);
      }
      
      private function removeItemListener() : void
      {
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onWin);
         UserManager.removeEventListener(UserEvent.EXPLODED,this.onOrgeExploded);
         UserManager.removeEventListener(UserEvent.BORN,this.onBossBorn);
         MagicChangeManager.instance.removeEventListener(MagicChangeEvent.CALL_FIGHT,this.magicHandle);
         MagicChangeManager.instance.removeEventListener(MagicChangeEvent.CALL_FIGHT_END,this.magicHandle);
      }
      
      private function onWin(param1:FightEvent) : void
      {
         setTimeout(this.toWinFun,2000);
      }
      
      private function toWinFun() : void
      {
         PveEntry.onWinner();
         HeadOgrePanel.instance.destroyBoss(13083);
      }
      
      private function onOrgeExploded(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         if(_loc2_)
         {
            TextAlert.show(_loc2_.info.nick + "自爆了！");
         }
      }
      
      private function onBossBorn(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         if(_loc2_.info.roleType == 13084)
         {
            _loc2_.showBloodBar();
         }
         if(_loc2_.info.roleType == 13083)
         {
            this.destroyTimer();
            TextAlert.show("桃之夭夭露出了真面目，原来她是个老太婆！");
         }
      }
      
      private function execAlert() : void
      {
         ++this._stepCount;
         TextAlert.show("第" + this._stepCount + "波妖桃已经到来");
      }
      
      private function destroyTimer() : void
      {
         if(this._timerID != 0)
         {
            clearInterval(this._timerID);
            this._timerID = 0;
            this._stepCount = 0;
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         FightToolBar.instance.enabledSkillQuickKeys();
         FightToolBar.instance.enabledBag();
         MiniMap.instance.show();
         FightGo.instance.enabledShow = true;
         KeyManager.setItemQuickAutoAddable(true);
         this.removeItemListener();
         this.destroyTimer();
         MagicChangeManager.instance.updateActorSkillController();
      }
   }
}

