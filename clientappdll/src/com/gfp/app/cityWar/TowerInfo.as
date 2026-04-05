package com.gfp.app.cityWar
{
   import com.gfp.core.info.UserInfo;
   import org.taomee.ds.HashMap;
   
   public class TowerInfo
   {
      
      public static const DEFAULT_HP:uint = 6;
      
      private const MAX_HP:uint = 10;
      
      private var _towerID:uint;
      
      private var _team:uint;
      
      private var _mapID:uint;
      
      private var _defUserHash:HashMap;
      
      private var _atkUserHash:HashMap;
      
      private var _towerHp:int;
      
      public function TowerInfo(param1:uint, param2:uint, param3:uint)
      {
         super();
         this._towerID = param1;
         this._team = param2;
         this._mapID = param3;
         this._defUserHash = new HashMap();
         this._atkUserHash = new HashMap();
         this._towerHp = DEFAULT_HP;
      }
      
      public function addDefUser(param1:UserInfo) : void
      {
         this._defUserHash.add(param1.userID,param1);
      }
      
      public function removeDefUser(param1:uint) : void
      {
         this._defUserHash.remove(param1);
      }
      
      public function clearDefUserList() : void
      {
         this._defUserHash.clear();
      }
      
      public function addAtkUser(param1:UserInfo) : void
      {
         this._atkUserHash.add(param1.userID,param1);
      }
      
      public function removeAtkUser(param1:UserInfo) : void
      {
         this._atkUserHash.remove(param1.userID);
      }
      
      public function clearAtkUserList() : void
      {
         this._atkUserHash.clear();
      }
      
      public function get towerID() : uint
      {
         return this._towerID;
      }
      
      public function get team() : uint
      {
         return this._team;
      }
      
      public function get hp() : int
      {
         return this._towerHp;
      }
      
      public function set hp(param1:int) : void
      {
         param1 = param1 > 0 ? param1 : 0;
         param1 = param1 < this.MAX_HP ? param1 : int(this.MAX_HP);
         this._towerHp = param1;
      }
      
      public function get mapID() : uint
      {
         return this._mapID;
      }
      
      public function getDefUserList() : Array
      {
         return this._defUserHash.getKeys();
      }
      
      public function getDefUserInfoList() : Array
      {
         return this._defUserHash.getValues();
      }
      
      public function getAtkUserList() : Array
      {
         return this._atkUserHash.getKeys();
      }
      
      public function getAtkUserInfoList() : Array
      {
         return this._atkUserHash.getValues();
      }
      
      public function get defNum() : uint
      {
         return this._defUserHash.length;
      }
      
      public function isContainUser(param1:uint) : Boolean
      {
         return this._defUserHash.containsKey(param1);
      }
   }
}

