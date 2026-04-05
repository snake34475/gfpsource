package com.gfp.app.manager
{
   import com.gfp.app.fight.FightGo;
   import com.gfp.app.fight.FightOgreManager;
   import com.gfp.app.toolBar.DynamicActivityEntry;
   import com.gfp.app.toolBar.HeadSummonPanel;
   import com.gfp.core.config.xml.SummonXMLInfo;
   import com.gfp.core.events.CommEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.ScenceItemAddEvent;
   import com.gfp.core.info.SummonInfo;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.UserInfoManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.PeopleModel;
   import com.gfp.core.model.SpriteModel;
   import com.gfp.core.model.SummonModel;
   import com.gfp.core.utils.SpriteType;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   
   public class UserAddManager
   {
      
      private static var _usersData:ByteArray;
      
      private static var _userLen:uint;
      
      private static var _userRemoveList:Array;
      
      private static var _isLoadUser:Boolean;
      
      private static var _needToAdds:Array = [13797,10452,1086,13660,10519,1216,13768,13797,11918,11919,11920,11921,13876,13877,11990,11991];
      
      private static var _monsterList:Array = new Array();
      
      private static var _monsterRemoveList:Array = new Array();
      
      private static var _isLoadMonster:Boolean = false;
      
      public function UserAddManager()
      {
         super();
      }
      
      public static function addUserListForCity(param1:ByteArray) : void
      {
         _userRemoveList = new Array();
         _usersData = param1;
         _userLen = param1.readUnsignedInt();
         if(_userLen > 20)
         {
            UserManager.setAllPeopleNoAnimat();
            SightManager.setAllModelNoAnimat();
         }
         LayerManager.stage.addEventListener(Event.ENTER_FRAME,onCityFrameEnter);
      }
      
      public static function removeUserID(param1:uint) : void
      {
         if(_isLoadUser)
         {
            _userRemoveList.push(param1);
         }
      }
      
      private static function onCityFrameEnter(param1:Event) : void
      {
         var _loc2_:UserInfo = null;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:Point = null;
         var _loc7_:uint = 0;
         if(_userLen > 0)
         {
            --_userLen;
            _loc2_ = UserInfoManager.creatInfo();
            UserInfo.setForPeoleInfo(_loc2_,_usersData);
            _loc2_.serverID = MainManager.serverID;
            if(_loc2_.userID != MainManager.actorInfo.userID)
            {
               if(_userRemoveList.indexOf(_loc2_.userID) == -1)
               {
                  if(!UserManager.contains(_loc2_.userID))
                  {
                     MapManager.currentMap.addUser(_loc2_.userID,new PeopleModel(_loc2_));
                  }
                  else if(UserManager.getModel(_loc2_.userID).parent == null)
                  {
                     MapManager.currentMap.addUser(_loc2_.userID,UserManager.getModel(_loc2_.userID));
                  }
               }
            }
            else
            {
               MainManager.actorModel.changeHeroSoul();
               DynamicActivityEntry.instance.updateAlign();
            }
         }
         else
         {
            LayerManager.stage.removeEventListener(Event.ENTER_FRAME,onCityFrameEnter);
            _loc3_ = _usersData.readUnsignedInt();
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc5_ = _usersData.readUnsignedInt();
               _loc6_ = new Point();
               _loc6_.x = _usersData.readUnsignedInt();
               _loc6_.y = _usersData.readUnsignedInt();
               _loc7_ = _usersData.readUnsignedInt();
               if(_loc5_ == 10412)
               {
                  ExpAutoUpManager.instance.evtDispatch.dispatchEvent(new ScenceItemAddEvent(ScenceItemAddEvent.FLOWER_APPEARED,_loc6_));
               }
               else if(_loc5_ == 10415)
               {
                  MapManager.dispatchEvent(new CommEvent("OneWayWestStatus",_loc7_));
               }
               else if(_needToAdds.indexOf(_loc5_) != -1)
               {
                  ChallengeSummonManager.instance.dispatchEvent(new ScenceItemAddEvent(ScenceItemAddEvent.SUMMON_NPC_APPEARED,_loc6_,_loc5_));
               }
               else if(Boolean(SummonXMLInfo.isSummonType(_loc5_)) || _loc5_ == 10452)
               {
                  ChallengeSummonManager.instance.dispatchEvent(new ScenceItemAddEvent(ScenceItemAddEvent.SUMMON_NPC_APPEARED,_loc6_,_loc5_ + 5));
               }
               else if(SpriteModel.getSpriteType(_loc5_) == SpriteType.TREASURE_BOX)
               {
                  TeamTaskManager.instance.dispatchEvent(new ScenceItemAddEvent(ScenceItemAddEvent.TRASURE_BOX_APPEARED,_loc6_,_loc5_ + 5));
               }
               else
               {
                  ChallengeSummonManager.instance.dispatchEvent(new ScenceItemAddEvent(ScenceItemAddEvent.ITEM_STATUS_INFO,_loc6_,_loc5_,_loc7_));
               }
               _loc4_++;
            }
            _isLoadUser = false;
            _usersData = null;
            _userRemoveList.length = 0;
            MapManager.dispatchEvent(new MapEvent(MapEvent.USER_LIST_COMPLETE,MapManager.currentMap));
         }
      }
      
      public static function addMonsterForBtl(param1:ByteArray) : void
      {
         _monsterList.push(param1);
         if(!_isLoadMonster)
         {
            _isLoadMonster = true;
            LayerManager.stage.addEventListener(Event.ENTER_FRAME,onBtlFrameEnter);
         }
      }
      
      public static function removeMonster(param1:uint) : void
      {
         if(_isLoadMonster)
         {
            _monsterRemoveList.push(param1);
         }
      }
      
      private static function onBtlFrameEnter(param1:Event) : void
      {
         var _loc5_:SummonInfo = null;
         var _loc6_:SummonModel = null;
         var _loc2_:ByteArray = _monsterList.pop();
         if(_monsterList.length <= 0)
         {
            _isLoadMonster = false;
            _monsterList.length = 0;
            _monsterRemoveList.length = 0;
            LayerManager.stage.removeEventListener(Event.ENTER_FRAME,onBtlFrameEnter);
         }
         var _loc3_:UserInfo = UserInfoManager.creatInfo();
         UserInfo.setForStageInfo(_loc3_,_loc2_,false);
         _loc3_.serverID = MainManager.serverID;
         if(_monsterRemoveList.indexOf(_loc3_.userID) != -1)
         {
            return;
         }
         if(SpriteModel.getSpriteType(_loc3_.roleType) == SpriteType.SUMMON)
         {
            _loc5_ = new SummonInfo();
            _loc5_.masterID = _loc3_.masterID;
            _loc5_.uniqueID = _loc3_.createTime;
            _loc5_.roleID = _loc3_.roleType;
            _loc5_.stageID = _loc3_.userID;
            _loc5_.quality = _loc3_.quality;
            _loc5_.lv = _loc3_.lv;
            _loc5_.nick = _loc3_.nick;
            _loc5_.exp = _loc3_.exp;
            _loc5_.troop = _loc3_.troop;
            _loc5_.pos = _loc3_.pos;
            _loc5_.hp = _loc3_.hp;
            _loc5_.hpMax = _loc3_.maxHp;
            _loc5_.mp = _loc3_.mp;
            _loc5_.serverSpeed = _loc3_.serverSpeed;
            _loc6_ = new SummonModel(_loc5_,null);
            if(MainManager.actorModel.fightSummonModel == null)
            {
               MainManager.actorModel.fightSummonModel = _loc6_;
               HeadSummonPanel.instance.clearCutDown();
               HeadSummonPanel.instance.init(_loc6_);
               HeadSummonPanel.instance.show();
            }
            MapManager.currentMap.addUser(_loc3_.userID,_loc6_);
         }
         var _loc4_:uint = _loc2_.readUnsignedShort();
         FightOgreManager.addUser(_loc3_,checkBornEffect(_loc3_.roleType));
         FightOgreManager.init();
         FightGo.destroy();
      }
      
      private static function checkBornEffect(param1:uint) : Boolean
      {
         var _loc2_:uint = uint(SpriteModel.getSpriteType(param1));
         switch(_loc2_)
         {
            case SpriteType.PEOPLE:
            case SpriteType.Z_HIDDEN_STOP:
            case SpriteType.Z_HIDDEN_ANIMAT:
            case SpriteType.HIDDEN_STOP:
            case SpriteType.HIDDEN_ANIMAT:
            case SpriteType.TREASURE_BOX:
            case SpriteType.CARRIER:
               return false;
            default:
               return true;
         }
      }
      
      public static function clear() : void
      {
         LayerManager.stage.removeEventListener(Event.ENTER_FRAME,onCityFrameEnter);
         _isLoadUser = false;
         _usersData = null;
         _userRemoveList = null;
         LayerManager.stage.removeEventListener(Event.ENTER_FRAME,onBtlFrameEnter);
         _monsterList.length = 0;
         _monsterRemoveList.length = 0;
         _isLoadMonster = false;
      }
   }
}

