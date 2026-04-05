package com.gfp.app.plugins
{
   import com.gfp.app.skillBook.SkillBookData;
   import com.gfp.core.CommandID;
   import com.gfp.core.Constant;
   import com.gfp.core.config.xml.SkillXMLInfo;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.ResEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.events.UserItemEvent;
   import com.gfp.core.info.fight.SkillInfo;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SkillManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.manager.UserInfoManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   import com.gfp.core.net.SocketConnection;
   import flash.events.Event;
   import flash.utils.getTimer;
   import org.taomee.net.SocketEvent;
   
   public class AutoUpgradeSkillPlugin extends BasePlugin
   {
      
      private var _config:Array = [[100706,100701,100702,100703,100704,100705],[200706,200701,200702,200703,200704,200705],[300706,300701,300702,300703,300704,300705],[400706,400701,400702,400703,400704,400705],[500706,500701,500702,500703,500704,500705],[600706,600701,600702,600703,600704,600705],[700706,700701,700702,700703,700704,700705],[800701,800702,800703,800704,800705,800706,800707,800708,800709]];
      
      private var _skills:Array;
      
      private var _prevUpgradeTime:int;
      
      private var canUpgradeSkills:Array = [];
      
      public function AutoUpgradeSkillPlugin()
      {
         super();
      }
      
      override public function install() : void
      {
         if(MainManager.actorInfo.isTurnBack)
         {
            PluginManager.instance.uninstallPlugin("AutoUpgradeSkillPlugin");
         }
         else
         {
            super.install();
            this._skills = SkillBookData.skillArray[MainManager.roleType - 1];
            UserInfoManager.ed.addEventListener(UserEvent.LVL_CHANGE,this.onLevelChange);
            ItemManager.addListener(UserItemEvent.ITEM_ADD,this.onLevelChange);
            SkillManager.addEventListener(SkillManager.UPGRADE,this.responseUpgrade);
            SkillManager.addEventListener(SkillManager.LEARN,this.responseUpgrade);
            ItemManager.addListener(ResEvent.USE_SKILLBOOK,this.onLevelChange);
            ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.exchangeCompleteHandle);
            MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onSwitchComplete);
         }
      }
      
      private function onSwitchComplete(param1:MapEvent) : void
      {
         var _loc2_:Array = null;
         if(param1.mapModel.info.mapType == MapType.STAND)
         {
            this.reset();
         }
      }
      
      private function exchangeCompleteHandle(param1:ExchangeEvent) : void
      {
         if(param1.info.id == 10167)
         {
            this.reset();
         }
      }
      
      private function responseUpgrade(param1:Event) : void
      {
         this.reset();
      }
      
      private function reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:SkillInfo = null;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         if(getTimer() - this._prevUpgradeTime < 1500)
         {
            return;
         }
         if(TasksManager.isCompleted(522) == false && MainManager.actorInfo.lv < 80)
         {
            return;
         }
         if(MapManager.mapInfo == null || MapManager.mapInfo.mapType != MapType.STAND)
         {
            return;
         }
         if(MainManager.actorInfo.isTurnBack)
         {
            PluginManager.instance.uninstallPlugin("AutoUpgradeSkillPlugin");
            return;
         }
         if(ActivityExchangeTimesManager.getTimes(10167) % 2 == 1)
         {
            return;
         }
         for each(_loc1_ in this._skills)
         {
            _loc2_ = SkillManager.getSkillInfo(_loc1_);
            if(_loc2_ == null || _loc2_.lv == 0)
            {
               _loc3_ = int(SkillXMLInfo.getLearnItemID(_loc1_));
               _loc4_ = SkillXMLInfo.getLevelInfo(_loc1_,1).needItem;
               _loc5_ = true;
               if(Boolean(_loc4_) && _loc4_.length > 1)
               {
                  _loc6_ = 0;
                  while(_loc6_ < _loc4_.length)
                  {
                     if(ItemManager.getItemCount(int(_loc4_[_loc6_])) < int(_loc4_[_loc6_ + 1]))
                     {
                        _loc5_ = false;
                        break;
                     }
                     _loc6_++;
                     _loc6_++;
                  }
               }
               if(_loc5_ && (_loc3_ == 0 || ItemManager.getItemCount(_loc3_) > 0) && Boolean(SkillXMLInfo.canLearnSkill(_loc1_)) && MainManager.actorInfo.skillPoint > 0)
               {
                  this.canUpgradeSkills.push(_loc1_);
               }
            }
            else if(_loc2_.lv < 20)
            {
               _loc4_ = SkillXMLInfo.getLevelInfo(_loc1_,1).needItem;
               _loc5_ = true;
               if(Boolean(_loc4_) && _loc4_.length > 1)
               {
                  _loc6_ = 0;
                  while(_loc6_ < _loc4_.length)
                  {
                     if(ItemManager.getItemCount(int(_loc4_[_loc6_])) < int(_loc4_[_loc6_ + 1]))
                     {
                        _loc5_ = false;
                        break;
                     }
                     _loc6_++;
                     _loc6_++;
                  }
               }
               if(_loc5_ && MainManager.actorInfo.skillPoint > 0)
               {
                  this.canUpgradeSkills.push(_loc1_);
               }
            }
         }
         if(this.canUpgradeSkills.length > 0)
         {
            SocketConnection.addCmdListener(CommandID.SKILL_LIST,this.onSkillList);
            SkillManager.getData();
         }
      }
      
      private function onSkillList(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.SKILL_LIST,this.onSkillList);
         this.canUpgradeSkills.sort(this.sortHandle);
         var _loc2_:SkillInfo = SkillManager.getSkillInfo(this.canUpgradeSkills[0]);
         var _loc3_:int = _loc2_ ? int(_loc2_.lv) : 0;
         if(_loc3_ <= 0)
         {
            SocketConnection.send(CommandID.LEARN_SKILL,this.canUpgradeSkills[0]);
         }
         this._prevUpgradeTime = getTimer();
      }
      
      protected function onLevelChange(param1:Event) : void
      {
         this.reset();
      }
      
      private function sortHandle(param1:int, param2:int) : int
      {
         if(param1 % 10 == 6)
         {
            return -1;
         }
         if(param2 % 10 == 6)
         {
            return 1;
         }
         if(MainManager.roleType == Constant.ROLE_TYPE_WOLF)
         {
            if(param1 % 10 == 5)
            {
               return -1;
            }
            if(param2 % 10 == 5)
            {
               return 1;
            }
            if(param1 % 10 == 8)
            {
               return -1;
            }
            if(param2 % 10 == 8)
            {
               return 1;
            }
         }
         var _loc3_:SkillInfo = SkillManager.getSkillInfo(param1);
         var _loc4_:SkillInfo = SkillManager.getSkillInfo(param2);
         var _loc5_:int = _loc3_ ? int(_loc3_.lv) : 0;
         var _loc6_:int = _loc4_ ? int(_loc4_.lv) : 0;
         return _loc5_ > _loc6_ ? 1 : -1;
      }
      
      override public function uninstall() : void
      {
         super.uninstall();
         UserInfoManager.ed.removeEventListener(UserEvent.LVL_CHANGE,this.onLevelChange);
         ItemManager.removeListener(UserItemEvent.ITEM_ADD,this.onLevelChange);
         SkillManager.removeEventListener(SkillManager.UPGRADE,this.responseUpgrade);
         SkillManager.removeEventListener(SkillManager.LEARN,this.responseUpgrade);
         ItemManager.removeListener(ResEvent.USE_SKILLBOOK,this.onLevelChange);
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.exchangeCompleteHandle);
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onSwitchComplete);
      }
   }
}

