package com.gfp.app.info
{
   import com.gfp.app.info.summonRace.RaceInfo;
   import org.taomee.ds.HashMap;
   
   public class SummonRaceInfo
   {
      
      private var _raceID:uint;
      
      private var _mapID:uint;
      
      private var _duration:uint;
      
      private var _channelNum:uint;
      
      private var _winSummons:Array;
      
      private var _totalCoins:Number;
      
      private var _awards:Array;
      
      private var _summonList:Array;
      
      private var _summonHash:HashMap;
      
      public function SummonRaceInfo(param1:XML)
      {
         var _loc3_:XML = null;
         var _loc4_:uint = 0;
         super();
         this._raceID = uint(param1.@id);
         this._mapID = uint(param1.@mapID);
         this._duration = uint(param1.@duration);
         this._channelNum = uint(param1.@channelNum);
         this._winSummons = String(param1.@winners).split(",");
         this._totalCoins = uint(param1.@totalCoins) / 100;
         this._awards = String(param1.@awards).split(",");
         this._summonList = new Array();
         this._summonHash = new HashMap();
         var _loc2_:XMLList = param1.elements("summon");
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = uint(_loc3_.@id);
            this._summonList.push(_loc4_);
            this._summonHash.add(_loc4_,new RaceInfo(_loc3_));
         }
      }
      
      public function get summonList() : Array
      {
         return this._summonList;
      }
      
      public function get mapID() : uint
      {
         return this._mapID;
      }
      
      public function get duration() : uint
      {
         return this._duration;
      }
      
      public function get channelNum() : uint
      {
         return this._channelNum;
      }
      
      public function get winSummons() : Array
      {
         return this._winSummons;
      }
      
      public function get totalCoins() : Number
      {
         return this._totalCoins;
      }
      
      public function get awards() : Array
      {
         return this._awards;
      }
      
      public function getRaceInfo(param1:uint) : RaceInfo
      {
         return this._summonHash.getValue(param1);
      }
   }
}

