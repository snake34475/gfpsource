package com.gfp.app.cmdl
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.fight.CustomEvent;
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.app.fight.PvpEntry;
   import com.gfp.app.fight.SPCircleTurnBack;
   import com.gfp.app.manager.ExpAutoUpManager;
   import com.gfp.app.manager.PanelGValueManager;
   import com.gfp.app.toolBar.ActivitySuggestionEntry;
   import com.gfp.app.toolBar.HeadSelfPanel;
   import com.gfp.app.toolBar.HeadSummonPanel;
   import com.gfp.app.toolBar.TootalExpBar;
   import com.gfp.core.CommandID;
   import com.gfp.core.behavior.GrowBehavior;
   import com.gfp.core.behavior.HpMpBehavior;
   import com.gfp.core.buff.BuffInfo;
   import com.gfp.core.buff.movie.MovieBuff;
   import com.gfp.core.cache.SoundCache;
   import com.gfp.core.cache.SoundInfo;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.ActivitySuggestionXMLInfo;
   import com.gfp.core.events.DataEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.GrowInfo;
   import com.gfp.core.info.HpMpInfo;
   import com.gfp.core.info.UserSummonInfos;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.CustomEventMananger;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.NumberManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.manager.UserInfoManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   import com.gfp.core.model.MapModel;
   import com.gfp.core.model.SummonModel;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.sound.SoundManager;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import org.taomee.bean.BaseBean;
   import org.taomee.ds.HashMap;
   import org.taomee.net.SocketEvent;
   
   public class GrowCmdListener extends BaseBean
   {
      
      private static var levelExtendBag:HashMap = new HashMap();
      
      levelExtendBag.add(5,1700009);
      levelExtendBag.add(10,1700010);
      levelExtendBag.add(15,1700011);
      levelExtendBag.add(20,1700012);
      levelExtendBag.add(25,1700013);
      levelExtendBag.add(30,1700014);
      levelExtendBag.add(35,1700015);
      levelExtendBag.add(40,1700016);
      
      public function GrowCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.INFORM_USER_EXP,this.onExp);
         SocketConnection.addCmdListener(CommandID.INFORM_USER_HPMP,this.onHpMp);
         SocketConnection.addCmdListener(CommandID.INFORM_USER_LV,this.onLv);
         SocketConnection.addCmdListener(CommandID.INFORM_SUMMON,this.onSummon);
         SocketConnection.addCmdListener(CommandID.CHANGE_STATE,this.onChangeState);
         SocketConnection.addCmdListener(CommandID.FIGHT_POWER_INFO,this.onFightPower);
         UserInfoManager.ed.addEventListener(UserEvent.COINS_OVERFLOW,this.coinsOverflowHandle);
         if(MainManager.actorInfo.coins >= 1000000000)
         {
            this.coinsOverflowHandle(null);
         }
         SocketConnection.send(CommandID.FIGHT_POWER_INFO);
         finish();
      }
      
      private function onExp(param1:SocketEvent) : void
      {
         var _loc4_:MapModel = null;
         var _loc5_:Point = null;
         var _loc2_:GrowInfo = param1.data as GrowInfo;
         if(ExpAutoUpManager.canExpUp)
         {
            NumberManager.showExp(MainManager.actorModel,_loc2_.exp - MainManager.actorInfo.exp);
         }
         if(_loc2_.lv - MainManager.actorInfo.lv > 0)
         {
            this.userUpgrade();
         }
         var _loc3_:int = _loc2_.skillPoint - MainManager.actorInfo.skillPoint;
         if(_loc3_ > 0 && Boolean(MainManager.actorInfo.isTurnBack))
         {
            _loc4_ = MapManager.currentMap;
            if((Boolean(_loc4_)) && _loc4_.info.mapType == MapType.PVE)
            {
               _loc5_ = _loc4_.camera.totalToView(MainManager.actorModel.pos);
               _loc5_.y -= MainManager.actorModel.height;
               new SPCircleTurnBack(0,_loc5_);
            }
         }
         PanelGValueManager.instance().dispatchEvent(new DataEvent(DataEvent.DATA_UPDATE,_loc2_.bzdValue));
         UserManager.execBehavior(param1.headInfo.userID,new GrowBehavior(_loc2_,false),true);
         TootalExpBar.refreshExpBar();
      }
      
      private function coinsOverflowHandle(param1:UserEvent) : void
      {
         var event:UserEvent = param1;
         var mapType:uint = MapManager.currentMap ? uint(MapManager.currentMap.info.mapType) : 0;
         if(mapType != MapType.PVE && mapType != MapType.PVP)
         {
            AlertManager.showSimpleAlarm("小侠士，你的功夫豆数量已经到达10亿啦！要赶快兑换成银票哦！否则一旦下线，超出部分将自动消失",function():void
            {
               CityMap.instance.tranToNpc(10020);
            });
         }
         else
         {
            MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onSwitchMap);
         }
      }
      
      private function onSwitchMap(param1:MapEvent) : void
      {
         var event:MapEvent = param1;
         var mapType:uint = uint(MapManager.currentMap.info.mapType);
         if(mapType != MapType.PVE && mapType != MapType.PVP)
         {
            MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onSwitchMap);
            AlertManager.showSimpleAlarm("小侠士，你的功夫豆数量已经到达10亿啦！要赶快兑换成银票哦！否则一旦下线，超出部分将自动消失",function():void
            {
               CityMap.instance.tranToNpc(10020);
            });
         }
      }
      
      private function onHpMp(param1:SocketEvent) : void
      {
         var _loc2_:HpMpInfo = param1.data as HpMpInfo;
         this.summonRevive(param1.headInfo.userID,_loc2_);
         if(param1.headInfo.userID == MainManager.actorID)
         {
            if(MainManager.actorInfo.hp <= 0 && _loc2_.hp > 0)
            {
               PvpEntry.onActorRevive();
               MainManager.actorModel.dispatchEvent(new UserEvent(UserEvent.RE_BORN));
            }
         }
         UserManager.execBehavior(param1.headInfo.userID,new HpMpBehavior(_loc2_,false,!PveEntry.instance.isInTowerStage()),true);
         if(param1.headInfo.userID != MainManager.actorID)
         {
            PveEntry.instance.setMemberAttribute(param1.headInfo.userID,_loc2_.hp,_loc2_.mp);
         }
      }
      
      private function summonRevive(param1:int, param2:HpMpInfo) : void
      {
         var _loc4_:SummonModel = null;
         var _loc3_:SummonModel = SummonManager.getSummonModelByStageId(param1);
         if(_loc3_)
         {
            if(_loc3_.getHP() <= 0 && param2.hp != 0)
            {
               _loc4_ = MainManager.actorModel.fightSummonModel;
               if((Boolean(_loc4_)) && _loc4_.summonInfo.stageID == param1)
               {
                  HeadSummonPanel.instance.revive(param2);
                  _loc4_.show();
               }
               PveEntry.instance.onSummonRevive(param1);
               _loc3_.dispatchEvent(new UserEvent(UserEvent.SUMMONE_REVIVE));
               CustomEventMananger.dispatchEvent(new CustomEvent(UserEvent.SUMMONE_REVIVE,false,false,_loc3_));
            }
         }
      }
      
      private function onLv(param1:SocketEvent) : void
      {
         var _loc8_:uint = 0;
         var _loc9_:BuffInfo = null;
         var _loc10_:int = 0;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:UserModel = UserManager.getModel(param1.headInfo.userID);
         var _loc4_:int = int(_loc2_.readUnsignedInt());
         var _loc5_:uint = _loc2_.readUnsignedInt();
         var _loc6_:int = int(_loc2_.readUnsignedInt());
         var _loc7_:int = int(_loc2_.readUnsignedInt());
         if(_loc3_)
         {
            if(param1.headInfo.userID == MainManager.actorID && _loc4_ - MainManager.actorInfo.lv > 0)
            {
               this.userUpgrade();
            }
            _loc8_ = uint(_loc3_.info.lv);
            _loc3_.info.maxHp = _loc6_;
            _loc3_.info.maxMp = _loc7_;
            _loc3_.info.hp = _loc6_;
            _loc3_.info.mp = _loc7_;
            _loc3_.initHP(_loc6_);
            _loc3_.initMP(_loc7_);
            _loc3_.info.lv = _loc4_;
            _loc3_.upDateNickText();
            if(_loc3_.info.userID == MainManager.actorInfo.userID && _loc3_.info.createTime == MainManager.actorInfo.createTime)
            {
               HeadSelfPanel.instance.refreshUserInfo();
            }
            if(_loc3_.info.titleID == 0)
            {
               _loc3_.info.updateTitleByLv(_loc4_);
               _loc3_.updateTitle();
            }
            _loc9_ = new BuffInfo();
            _loc9_.id = 9005;
            _loc9_.duration = 1600;
            _loc9_.layer = 999;
            _loc3_.execBuff(new MovieBuff(_loc9_,false));
            if(_loc3_.info.userID == MainManager.actorID)
            {
               _loc10_ = _loc4_ - _loc8_;
               MainManager.actorModel.dispatchEvent(new UserEvent(UserEvent.LVL_CHANGE,_loc10_));
               UserInfoManager.ed.dispatchEvent(new UserEvent(UserEvent.LVL_CHANGE,_loc10_));
               if(ActivitySuggestionXMLInfo.getActivityVecByLvl(0,_loc4_ + 5).length > 0 && ActivitySuggestionXMLInfo.getActivityVecByLvl(0,_loc8_ + 5).length <= 0)
               {
                  ActivitySuggestionEntry.instance.show();
                  if(MapManager.isFightMap)
                  {
                     ActivitySuggestionEntry.instance.activityShowOrHide(false);
                  }
               }
               if(ActivitySuggestionXMLInfo.getActivityVecByLvl(_loc8_ + 1,_loc4_).length > 0)
               {
                  ActivitySuggestionEntry.instance.prepareEffect();
               }
            }
            if(Boolean(MapManager.mapInfo) && Boolean(MapManager.mapInfo.mapType == MapType.PVE) && param1.headInfo.userID != MainManager.actorID)
            {
               if(FightManager.isTeamFight)
               {
                  PveEntry.instance.setMemberLv(param1.headInfo.userID,_loc4_);
                  PveEntry.instance.setMemberAttribute(param1.headInfo.userID,_loc3_.info.hp,_loc3_.info.mp);
               }
            }
            if(MapManager.currentMap)
            {
               MapManager.currentMap.mapInfoConfig.changeTollgateModel();
            }
            _loc3_.execStandAction();
         }
      }
      
      private function onSummon(param1:SocketEvent) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:Number = NaN;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:Number = NaN;
         var _loc10_:UserSummonInfos = null;
         var _loc11_:BuffInfo = null;
         var _loc12_:uint = 0;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:SummonModel = SummonManager.getSummonModelByStageId(_loc3_);
         if((Boolean(_loc4_)) && Boolean(_loc4_.info))
         {
            _loc5_ = _loc2_.readUnsignedShort();
            if(_loc5_ > _loc4_.info.lv)
            {
               _loc11_ = new BuffInfo();
               _loc11_.id = 9005;
               _loc11_.duration = 1600;
               _loc11_.layer = 999;
               _loc4_.execBuff(new MovieBuff(_loc11_,false));
               _loc4_.info.lv = _loc5_;
               _loc4_.upDateNickText();
            }
            _loc6_ = Number(_loc4_.info.exp);
            _loc7_ = _loc2_.readUnsignedInt();
            _loc8_ = _loc2_.readUnsignedInt();
            _loc9_ = _loc2_.readUnsignedInt() / 10;
            _loc4_.info.exp = (_loc7_ << 32) + _loc8_;
            _loc4_.info.mp = _loc2_.readUnsignedShort();
            _loc4_.infoChanged();
            if(_loc4_.info.exp - _loc6_ > 0)
            {
               NumberManager.showExp(_loc4_,uint(_loc4_.info.exp - _loc6_),_loc9_);
            }
            _loc10_ = SummonManager.getUserSummonInfo(param1.headInfo.userID);
            if((Boolean(_loc10_)) && Boolean(_loc10_.fightSummonInfo))
            {
               _loc10_.fightSummonInfo.lv = _loc4_.info.lv;
               _loc12_ = _loc4_.info.exp - _loc10_.fightSummonInfo.exp;
               _loc10_.fightSummonInfo.exp = _loc4_.info.exp;
               _loc10_.fightSummonInfo.mp = _loc4_.info.mp;
            }
         }
      }
      
      private function onChangeState(param1:SocketEvent) : void
      {
      }
      
      private function onFightPower(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         MainManager.actorInfo.lvPower = _loc2_.readUnsignedInt();
         MainManager.actorInfo.equipPower = _loc2_.readUnsignedInt();
         MainManager.actorInfo.fashionPower = _loc2_.readUnsignedInt();
         MainManager.actorInfo.summonPower = _loc2_.readUnsignedInt();
         MainManager.actorInfo.guardPower = _loc2_.readUnsignedInt();
         MainManager.actorInfo.mohunPower = _loc2_.readUnsignedInt();
         MainManager.actorInfo.magicPower = _loc2_.readUnsignedInt();
         MainManager.actorInfo.otherPower = _loc2_.readUnsignedInt();
         MainManager.actorInfo.soulPower = _loc2_.readUnsignedInt();
         MainManager.actorInfo.godPower = _loc2_.readUnsignedInt();
         MainManager.actorInfo.fightPower = _loc2_.readUnsignedInt();
         UserInfoManager.ed.dispatchEvent(new UserEvent(UserEvent.FIGHT_POWER_CHANGED));
      }
      
      private function userUpgrade() : void
      {
         if(!AnimatPlay.instance.isPlaying)
         {
            AnimatPlay.startAnimat("user_level_upgrde",-1,false,0,0,false,false,false,0,false,false);
         }
         SoundCache.load(ClientConfig.getSoundOther("user_upgrade.mp3"),this.onSoundComplete,null);
      }
      
      private function onSoundComplete(param1:SoundInfo) : void
      {
         SoundManager.playSound(param1.url,0,false,0.6);
      }
   }
}

