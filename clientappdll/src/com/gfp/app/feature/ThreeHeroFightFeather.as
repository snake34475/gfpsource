package com.gfp.app.feature
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.fight.PvpEntry;
   import com.gfp.app.miniMap.MiniMap;
   import com.gfp.app.toolBar.FightToolBar;
   import com.gfp.core.CommandID;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.info.KeyInfo;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.KeyManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.SummonModel;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.FightBloodBar;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.KeyCodeType;
   import com.gfp.core.utils.TextUtil;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   import org.taomee.utils.DisplayUtil;
   
   public class ThreeHeroFightFeather
   {
      
      public static var isIgnoreAlert:Boolean;
      
      private var bossUI:Sprite;
      
      private var bossID:int;
      
      private var isPve:Boolean;
      
      private const skills:Array = [1,2,3,4,5,6];
      
      private var selectSkills:Array = [];
      
      private var skillIds:Array = [4120458,4120459,4120460,4120461,4120462,4120463];
      
      private var disableSkillIds:Array = [];
      
      public function ThreeHeroFightFeather(param1:Boolean = true)
      {
         super();
         this.isPve = param1;
         this.init();
         this.addEvent();
      }
      
      private function init() : void
      {
         var _loc1_:Array = null;
         var _loc2_:UserInfo = null;
         MiniMap.instance.hide();
         if(this.isPve)
         {
            this.initBoss(MainManager.actorInfo.userID);
         }
         else
         {
            _loc1_ = PvpEntry.instance.fightReadyInfo.roles;
            for each(_loc2_ in _loc1_)
            {
               if(_loc2_.troop == 2)
               {
                  this.initBoss(_loc2_.userID);
                  break;
               }
            }
            if(_loc2_.userID != MainManager.actorInfo.userID)
            {
               KeyManager.upDateItemQuickKeys(new Vector.<KeyInfo>());
               KeyManager.setItemQuickAutoAddable(false);
            }
         }
      }
      
      private function addEvent() : void
      {
         FightManager.instance.addEventListener(FightEvent.WINNER,this.onFightWinner);
         FightManager.instance.addEventListener(FightEvent.REASON,this.onFightFail);
         LayerManager.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         FightToolBar.instance.getQickBar().getQuickBarBtn(0).addEventListener(MouseEvent.CLICK,this.onQuick1Click);
         FightToolBar.instance.getQickBar().getQuickBarBtn(1).addEventListener(MouseEvent.CLICK,this.onQuick2Click);
         MapManager.addEventListener(MapEvent.STAGE_USER_LISET_COMPLETE,this.onUserLoadComplete);
      }
      
      private function removeEvent() : void
      {
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onFightWinner);
         FightManager.instance.removeEventListener(FightEvent.REASON,this.onFightFail);
         LayerManager.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         FightToolBar.instance.getQickBar().getQuickBarBtn(0).removeEventListener(MouseEvent.CLICK,this.onQuick1Click);
         FightToolBar.instance.getQickBar().getQuickBarBtn(1).removeEventListener(MouseEvent.CLICK,this.onQuick2Click);
         MapManager.removeEventListener(MapEvent.STAGE_USER_LISET_COMPLETE,this.onUserLoadComplete);
      }
      
      private function onUserLoadComplete(param1:MapEvent) : void
      {
         var _loc3_:UserModel = null;
         var _loc4_:UserInfo = null;
         this.initBossFlag();
         var _loc2_:Array = UserManager.getModels();
         for each(_loc3_ in _loc2_)
         {
            if(MainManager.actorInfo.userID != _loc3_.info.userID)
            {
               if(_loc3_ is SummonModel)
               {
                  _loc4_ = UserManager.getModel(SummonModel(_loc3_).summonInfo.masterID).info;
                  _loc3_.info.troop = _loc4_.troop;
               }
               if(_loc3_.info.troop == MainManager.actorInfo.troop)
               {
                  _loc3_.setBloodBar(new FightBloodBar(FightBloodBar.COLOR_SELF));
               }
               else
               {
                  _loc3_.setBloodBar(new FightBloodBar());
               }
               _loc3_.initHP(_loc3_.info.hp);
            }
         }
      }
      
      private function onQuick1Click(param1:MouseEvent) : void
      {
         var _loc2_:KeyboardEvent = new KeyboardEvent(KeyboardEvent.KEY_DOWN);
         _loc2_.keyCode = Keyboard.NUMBER_1;
         this.onKeyDown(_loc2_);
      }
      
      private function onQuick2Click(param1:MouseEvent) : void
      {
         var _loc2_:KeyboardEvent = new KeyboardEvent(KeyboardEvent.KEY_DOWN);
         _loc2_.keyCode = Keyboard.NUMBER_2;
         this.onKeyDown(_loc2_);
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         switch(param1.keyCode)
         {
            case Keyboard.NUMBER_1:
               _loc2_ = int(this.selectSkills[0]);
               _loc3_ = int(this.skillIds[this.skills.indexOf(_loc2_)]);
               _loc4_ = 1;
               break;
            case Keyboard.NUMBER_2:
               _loc2_ = int(this.selectSkills[1]);
               _loc3_ = int(this.skillIds[this.skills.indexOf(_loc2_)]);
               _loc4_ = 2;
               break;
            case Keyboard.NUMBER_3:
               _loc2_ = int(this.selectSkills[2]);
               _loc3_ = int(this.skillIds[this.skills.indexOf(_loc2_)]);
               _loc4_ = 3;
         }
         if(_loc2_ != 0 && this.disableSkillIds.indexOf(_loc3_) == -1)
         {
            SocketConnection.send(CommandID.FIGHT_ACTIVITY_EFFECT,2,this.isPve ? 586 : 1004,_loc2_);
            FightToolBar.instance.getQickBar().getQuickBarBtn(_loc4_ - 1).enabled = false;
            this.disableSkillIds.push(_loc3_);
         }
      }
      
      private function onFightWinner(param1:FightEvent) : void
      {
         if(this.bossID == MainManager.actorInfo.userID)
         {
            TextAlert.show("恭喜你赢得了本场三雄争霸胜利。快去领取你的胜利宝箱吧！");
         }
         else
         {
            TextAlert.show("你和你的小伙伴战胜了魔王，赢得了胜利！快去领取你们的胜利宝箱吧！");
         }
      }
      
      private function onFightFail(param1:FightEvent) : void
      {
         if(!this.isPve)
         {
            if(this.bossID == MainManager.actorInfo.userID)
            {
               TextAlert.show("你被打败了，请下次再接再厉吧");
            }
            else
            {
               TextAlert.show("你和你的小伙伴被魔王打败了，请下次再接再厉吧。");
            }
         }
      }
      
      public function destory() : void
      {
         KeyManager.upDateItemQuickKeys(MainManager.actorInfo.items);
         KeyManager.setItemQuickAutoAddable(true);
         this.removeEvent();
         if(this.bossUI)
         {
            DisplayUtil.removeForParent(this.bossUI);
            this.bossUI = null;
         }
      }
      
      private function initBoss(param1:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Vector.<KeyInfo> = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:KeyInfo = null;
         TextUtil.calculateRandomInfo(this.skills.concat(),this.selectSkills,3);
         var _loc2_:Array = [];
         for each(_loc3_ in this.selectSkills)
         {
            _loc6_ = this.skills.indexOf(_loc3_);
            _loc2_.push(this.skillIds[_loc6_]);
         }
         _loc4_ = new Vector.<KeyInfo>(5,true);
         _loc5_ = 0;
         while(_loc5_ < 5)
         {
            _loc7_ = new KeyInfo();
            if(_loc5_ == 0)
            {
               _loc7_.dataID = _loc2_[0];
               _loc7_.type = KeyCodeType.SKILL;
               _loc7_.funcID = 41;
               _loc7_.lv = 1;
               _loc7_.isVisual = true;
            }
            if(_loc5_ == 1)
            {
               _loc7_.dataID = _loc2_[1];
               _loc7_.type = KeyCodeType.SKILL;
               _loc7_.funcID = 42;
               _loc7_.lv = 1;
               _loc7_.isVisual = true;
            }
            if(_loc5_ == 2)
            {
               _loc7_.dataID = _loc2_[2];
               _loc7_.type = KeyCodeType.SKILL;
               _loc7_.funcID = 43;
               _loc7_.lv = 1;
               _loc7_.isVisual = true;
            }
            _loc4_[_loc5_] = _loc7_;
            _loc5_++;
         }
         KeyManager.upDateItemQuickKeys(_loc4_,true);
         KeyManager.setItemQuickAutoAddable(false);
         this.bossID = param1;
         this.initBossFlag();
      }
      
      private function initBossFlag() : void
      {
         var _loc1_:UserModel = null;
         if(this.bossID != 0)
         {
            _loc1_ = UserManager.getModel(this.bossID);
            if(_loc1_)
            {
               if(this.bossID == MainManager.actorInfo.userID)
               {
                  TextAlert.show("你成为了魔王，新增3个技能，快捷键为1,2,3。");
               }
               else
               {
                  TextAlert.show("玩家" + _loc1_.info.nick + "成为魔王，快和你的小伙伴齐心合力打败他吧！");
               }
               if(!this.bossUI)
               {
                  this.bossUI = UIManager.getMovieClip("Head_ThreeHeroFight");
               }
               this.bossUI.x = -15;
               this.bossUI.y = -170;
               _loc1_.addChild(this.bossUI);
            }
         }
      }
   }
}

