package com.gfp.app.fight
{
   import com.gfp.app.cartoon.OgreBronAnimat;
   import com.gfp.app.fight.pvai.PvaiEntry;
   import com.gfp.app.manager.FightGroupManager;
   import com.gfp.app.miniMap.BlockContainer;
   import com.gfp.app.toolBar.HeadHeroSoulPanel;
   import com.gfp.app.toolBar.HeadOgrePanel;
   import com.gfp.core.action.data.EffectInfo;
   import com.gfp.core.buff.BuffInfo;
   import com.gfp.core.buff.movie.MovieBuff;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.PlayerOrgeXMLInfo;
   import com.gfp.core.config.xml.RoleXMLInfo;
   import com.gfp.core.config.xml.TollgateXMLInfo;
   import com.gfp.core.config.xml.TreasureMapXMLInfo;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.DeffEquiptManager;
   import com.gfp.core.manager.FireTestManager;
   import com.gfp.core.manager.GodManager;
   import com.gfp.core.manager.HiddenManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   import com.gfp.core.model.GodModel;
   import com.gfp.core.model.HiddenModel;
   import com.gfp.core.model.OgreModel;
   import com.gfp.core.model.PeopleModel;
   import com.gfp.core.model.SolidModel;
   import com.gfp.core.model.SpriteModel;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.player.EffectPlayer;
   import com.gfp.core.ui.FightBloodBar;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.BornType;
   import com.gfp.core.utils.FightMode;
   import com.gfp.core.utils.HiddenState;
   import com.gfp.core.utils.SpriteType;
   import com.gfp.core.utils.TextFormatUtil;
   import com.gfp.core.utils.TroopType;
   import flash.display.MovieClip;
   import flash.utils.setTimeout;
   import org.taomee.ds.HashMap;
   
   public class FightOgreManager
   {
      
      public static var ogreNum:int;
      
      private static const colors:Array = [16777215,16763904,16737792,13382400,12668094,7583957];
      
      private static var nameColor:uint = 16777215;
      
      public static var teamMemberMap:HashMap = new HashMap();
      
      private static var _bossBarFilterList:Array = [14625,14626,14627,14628,14629,14630,14631,14617,13054];
      
      public function FightOgreManager()
      {
         super();
      }
      
      public static function setDifficulty(param1:uint = 1) : void
      {
         if(param1 > colors.length)
         {
            nameColor = 16777215;
         }
         else
         {
            nameColor = colors[param1 - 1];
         }
      }
      
      public static function addOgreDieListener() : void
      {
         UserManager.addEventListener(UserEvent.DIE,onUserDied);
         UserManager.addEventListener(UserEvent.RECYCLE,onUserRecycle);
         UserManager.addEventListener(UserEvent.BORN,onUserBorn);
         UserManager.addEventListener(UserEvent.EXPLODED,onExploded);
      }
      
      public static function removeOgreDieListner() : void
      {
         UserManager.removeEventListener(UserEvent.DIE,onUserDied);
         UserManager.removeEventListener(UserEvent.RECYCLE,onUserRecycle);
         UserManager.removeEventListener(UserEvent.BORN,onUserBorn);
         UserManager.removeEventListener(UserEvent.EXPLODED,onExploded);
      }
      
      private static function onUserDied(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data;
         onUserdestory(_loc2_);
      }
      
      private static function onExploded(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data;
         onUserdestory(_loc2_);
      }
      
      private static function onUserdestory(param1:UserModel) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         if(param1 == null || param1.info == null)
         {
            return;
         }
         if(RoleXMLInfo.getFlag(param1.info.roleType) == 1)
         {
            HeadOgrePanel.instance.destroyBoss(param1.info.roleType);
         }
         if(param1.spriteType == SpriteType.OGRE && !isPlayerTroop(param1.info.troop))
         {
            ogreNum = ogreNum - 1;
            if(ogreNum <= 0)
            {
               FireTestManager.instance.setShow();
               setTimeout(showTeleporter,1000);
               if(TollgateXMLInfo.getTollgateInfoById(MainManager.pveTollgateId).disabledGo)
               {
                  FightGo.instance.enabledShow = false;
               }
               else
               {
                  FightGo.instance.enabledShow = true;
               }
               _loc2_ = 0;
               while(_loc2_ < BlockContainer.mapBlockArray.length)
               {
                  _loc3_ = UIManager.getMovieClip("strengthenFullAnimat_12");
                  _loc3_.width = BlockContainer.mapBlockArray[_loc2_].width;
                  _loc3_.height = BlockContainer.mapBlockArray[_loc2_].height;
                  BlockContainer.mapBlockArray[_loc2_].addChildAt(_loc3_,1);
                  _loc2_++;
               }
               FightManager.instance.dispatchEvent(new FightEvent(FightEvent.OGRE_CLEAR));
            }
            updatePathArr(param1);
         }
      }
      
      private static function updatePathArr(param1:UserModel) : void
      {
         if(!RoleXMLInfo.isObstacle(param1.info.roleType))
         {
         }
      }
      
      private static function onUserRecycle(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data;
         if(_loc2_.spriteType == SpriteType.OGRE)
         {
            if(Boolean(_loc2_.info) && !isPlayerTroop(_loc2_.info.troop))
            {
               ogreNum = ogreNum - 1;
               if(ogreNum <= 0)
               {
                  setTimeout(showTeleporter,1000);
               }
            }
         }
      }
      
      private static function showTeleporter() : void
      {
         SightManager.show(SpriteType.TELEPORTER);
         FightMonsterClear.instance.show();
         FightGo.instance.showLater();
      }
      
      private static function onUserBorn(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data;
         if(_loc2_.spriteType == SpriteType.OGRE && Boolean(_loc2_.info))
         {
            if(_loc2_.info.roleType == 12228)
            {
               _loc2_.alpha = 0.5;
            }
            if(_loc2_.info.roleType == 13042)
            {
               OgreBronAnimat.instance.playBronAnimat(13042);
            }
            else if(_loc2_.info.roleType == 13602)
            {
               OgreBronAnimat.instance.playBronAnimat(13602,300,150);
            }
         }
      }
      
      public static function init() : void
      {
         if(ogreNum > 0)
         {
            HeadOgrePanel.instance.changeMapHideUI(true);
            SightManager.hide(SpriteType.TELEPORTER);
         }
         else
         {
            SightManager.show(SpriteType.TELEPORTER);
         }
      }
      
      public static function resetCount() : void
      {
         ogreNum = 0;
      }
      
      public static function clearOgre() : void
      {
         UserManager.eachModel(function(param1:UserModel):void
         {
            if(param1.spriteType == SpriteType.OGRE)
            {
               UserManager.remove(param1.info.userID);
               param1.destroy();
            }
         });
      }
      
      public static function addUser(param1:UserInfo, param2:Boolean = false) : void
      {
         var _loc5_:UserModel = null;
         var _loc6_:uint = 0;
         var _loc7_:int = 0;
         var _loc8_:UserInfo = null;
         var _loc9_:uint = 0;
         var _loc10_:int = 0;
         var _loc11_:UserInfo = null;
         var _loc12_:UserModel = null;
         var _loc13_:BuffInfo = null;
         var _loc14_:HiddenModel = null;
         var _loc15_:EffectInfo = null;
         var _loc3_:uint = uint(param1.roleType);
         var _loc4_:uint = uint(SpriteModel.getSpriteType(_loc3_));
         if(MapManager.currentMap == null)
         {
            return;
         }
         if(!UserManager.contains(param1.userID))
         {
            HeadOgrePanel.instance.changeMapHideUI(false);
            switch(_loc4_)
            {
               case SpriteType.OGRE:
               case SpriteType.NPC:
               case SpriteType.SOUL:
                  _loc5_ = new OgreModel(param1);
                  _loc5_.setNicStyle(nameColor);
                  OgreModel(_loc5_).setOgreNicStyle();
                  if(RoleXMLInfo.getType(param1.roleType) == 1)
                  {
                     _loc5_.showRing(ClientConfig.getBuff("boss_ring"));
                     HeadOgrePanel.instance.bossSetup(_loc5_);
                  }
                  if(!isPlayerTroop(param1.troop))
                  {
                     ogreNum += 1;
                  }
                  break;
               case SpriteType.PLAYER_OGRE:
                  if(FightManager.fightMode == FightMode.PVAI)
                  {
                     _loc8_ = PvaiEntry.instance.fightReadyInfo.getPlayerInfo(param1.roleType);
                     param1.roleType = uint(PlayerOrgeXMLInfo.getRoleIDByOgreID(param1.roleType)) || uint(param1.roleType);
                     param1.nick = _loc8_.nick;
                     param1.isAdvanced = _loc8_.isAdvanced;
                     param1.isSuperAdvc = _loc8_.isSuperAdvc;
                     param1.isTurnBack = _loc8_.isTurnBack;
                     param1.troop = _loc8_.troop;
                     _loc5_ = new PeopleModel(param1);
                     break;
                  }
                  param1.isSuperAdvc = true;
                  _loc9_ = uint(RoleXMLInfo.getResID(param1.roleType));
                  _loc10_ = int(param1.roleType);
                  _loc11_ = PlayerOrgeXMLInfo.getPlayerOrgeInfo(_loc9_);
                  param1.isTurnBack = _loc11_.quality >= 3;
                  _loc5_ = new PeopleModel(param1);
                  _loc5_.spriteType = SpriteType.OGRE;
                  _loc5_.showRing(ClientConfig.getBuff("boss_ring"));
                  if(!isPlayerTroop(param1.troop))
                  {
                     HeadOgrePanel.instance.bossSetup(_loc5_);
                     ogreNum += 1;
                  }
                  break;
               case SpriteType.PEOPLE:
                  _loc5_ = new PeopleModel(param1);
                  if(DeffEquiptManager.isDisplayDeffEquipt)
                  {
                     PeopleModel(_loc5_).displayDeffEquipt();
                  }
                  break;
               case SpriteType.SOLID:
                  _loc5_ = new SolidModel(param1);
                  break;
               case SpriteType.Z_HIDDEN_STOP:
               case SpriteType.Z_HIDDEN_ANIMAT:
               case SpriteType.HIDDEN_STOP:
               case SpriteType.HIDDEN_ANIMAT:
               case SpriteType.CARRIER:
                  _loc5_ = new HiddenModel(param1,_loc4_);
                  HiddenManager.add(param1.userID,HiddenModel(_loc5_));
                  break;
               case SpriteType.TREASURE_BOX:
                  _loc5_ = new HiddenModel(param1,_loc4_);
                  HiddenManager.add(param1.userID,HiddenModel(_loc5_));
                  _loc6_ = uint(TreasureMapXMLInfo.getIDByBoxId(_loc5_.info.roleType));
                  if(_loc6_ != 0 && ItemManager.getItemCount(_loc6_) <= 0)
                  {
                     HiddenModel(_loc5_).ableFlag = false;
                  }
                  break;
               case SpriteType.GOD:
                  _loc7_ = int(param1.masterID);
                  if(_loc7_ == MainManager.actorInfo.userID)
                  {
                     _loc5_ = new GodModel(param1,MainManager.actorModel);
                     GodManager.fightGodStageID = param1.userID;
                  }
                  else
                  {
                     _loc12_ = UserManager.getModel(_loc7_);
                     if(_loc12_)
                     {
                        _loc5_ = new GodModel(param1,_loc12_);
                     }
                  }
                  if(_loc5_)
                  {
                     _loc5_.setNickText(_loc5_.info.nick,false);
                  }
            }
            if(_loc5_)
            {
               if(isPlayerTroop(param1.troop))
               {
                  if(MapManager.mapInfo != null && MapManager.mapInfo.mapType == MapType.PVP && param1.troop == 1)
                  {
                     _loc5_.setBloodBar(new FightBloodBar());
                  }
                  else
                  {
                     _loc5_.setBloodBar(new FightBloodBar(FightBloodBar.COLOR_SELF));
                  }
               }
               else if(param1.roleType == 11211)
               {
                  _loc5_.setBloodBar(new FightBloodBar(FightBloodBar.COLOR_SELF));
               }
               else
               {
                  _loc5_.setBloodBar(new FightBloodBar());
               }
               if(FightGroupManager.instance.getGroupUserInfo(param1.userID,param1.createTime))
               {
                  _loc5_.setBloodBar(new FightBloodBar(FightBloodBar.COLOR_SELF));
               }
               _loc5_.initHP(param1.maxHp);
               _loc5_.setHP(param1.hp);
               _loc5_.initMP(param1.maxMp);
               _loc5_.setMP(param1.mp);
               _loc5_.setTroop(param1.troop);
               MapManager.currentMap.addUser(param1.userID,_loc5_);
               if(param2 && isNomalBorn(_loc5_))
               {
                  _loc13_ = new BuffInfo();
                  _loc13_.id = 9007;
                  _loc13_.duration = 600;
                  _loc13_.layer = 999;
                  _loc5_.execBuff(new MovieBuff(_loc13_,false));
               }
               if(param1.maxHp != param1.hp)
               {
                  _loc5_.showBloodBar();
               }
               if(_loc5_ is HiddenModel)
               {
                  if(param1.mp != HiddenState.STATE_HIDDEN)
                  {
                     _loc14_ = _loc5_ as HiddenModel;
                     _loc14_.state = param1.mp;
                  }
               }
               if(_loc4_ == SpriteType.SOUL)
               {
                  _loc15_ = new EffectInfo();
                  _loc15_.id = "call_soul_" + param1.roleType;
                  _loc15_.repeat = 1;
                  _loc15_.scaleX = 1;
                  _loc15_.scaleY = 1;
                  EffectPlayer.play(_loc5_,_loc15_);
                  if(param1.masterID == MainManager.actorID)
                  {
                     HeadHeroSoulPanel.instance.init(param1);
                  }
               }
            }
         }
      }
      
      private static function isNomalBorn(param1:UserModel) : Boolean
      {
         return RoleXMLInfo.getBorn(param1.info.roleType) <= BornType.GROUND;
      }
      
      private static function isPlayerTroop(param1:uint) : Boolean
      {
         return param1 == TroopType.PLAYER || param1 == TroopType.NEUTRAL_PLAYER;
      }
      
      public static function addMemberInfo(param1:UserInfo) : void
      {
         teamMemberMap.add(param1.userID,param1);
      }
      
      public static function getMemberInfo(param1:int) : UserInfo
      {
         return teamMemberMap.getValue(param1);
      }
      
      public static function removeMember(param1:int) : void
      {
         teamMemberMap.remove(param1);
         if(teamMemberMap.length < 2)
         {
            if(FightManager.isTeamFight)
            {
               TextAlert.show(TextFormatUtil.getRedText("队友离开队伍已解散！"));
               FightManager.isTeamFight = false;
            }
         }
      }
      
      public static function clearMember() : void
      {
         teamMemberMap = new HashMap();
      }
   }
}

