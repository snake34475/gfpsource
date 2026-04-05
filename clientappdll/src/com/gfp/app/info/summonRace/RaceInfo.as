package com.gfp.app.info.summonRace
{
   import org.taomee.ds.HashMap;
   
   public class RaceInfo
   {
      
      private var _summonID:uint;
      
      private var _actionHash:HashMap;
      
      public function RaceInfo(param1:XML)
      {
         var _loc3_:XML = null;
         var _loc4_:uint = 0;
         super();
         this._actionHash = new HashMap();
         this._summonID = uint(param1.@id);
         var _loc2_:XMLList = param1.elements("action");
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = uint(_loc3_.@time);
            this._actionHash.add(_loc4_,{
               "nextChannel":uint(_loc3_.@channel),
               "duration":uint(_loc3_.@duration),
               "dialog":_loc3_.@dialog
            });
         }
      }
      
      public function getNextChannel(param1:uint) : int
      {
         var _loc2_:Object = null;
         if(this._actionHash.containsKey(param1))
         {
            _loc2_ = this._actionHash.getValue(param1);
            return _loc2_.nextChannel;
         }
         return -1;
      }
      
      public function getActionDuration(param1:uint) : int
      {
         var _loc2_:Object = null;
         if(this._actionHash.containsKey(param1))
         {
            _loc2_ = this._actionHash.getValue(param1);
            return _loc2_.duration;
         }
         return -1;
      }
      
      public function getDialog(param1:uint) : String
      {
         var _loc2_:Object = null;
         if(this._actionHash.containsKey(param1))
         {
            _loc2_ = this._actionHash.getValue(param1);
            return _loc2_.dialog;
         }
         return "";
      }
      
      public function get summonID() : uint
      {
         return this._summonID;
      }
   }
}

