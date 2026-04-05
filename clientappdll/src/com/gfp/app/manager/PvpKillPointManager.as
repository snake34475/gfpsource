package com.gfp.app.manager
{
   import com.gfp.app.feature.AutoFightInPvpMap;
   import com.gfp.app.feature.KillPointFeather;
   import com.gfp.app.feature.PKBaseFeather;
   import com.gfp.app.systems.ClientTempState;
   import com.gfp.core.CommandID;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.info.RankInfo;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.RankType;
   import flash.events.Event;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class PvpKillPointManager
   {
      
      private static var _feather:PKBaseFeather;
      
      private static var _autoFightFeather:AutoFightInPvpMap;
      
      private static var _top10Users:Vector.<RankInfo>;
      
      public static var effectMaps:Array = [34,56,103,104];
      
      public static var effectPathIds:Array = [68,69,70,71,72,73];
      
      public function PvpKillPointManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         addEvent();
      }
      
      private static function requestTop10() : void
      {
         SocketConnection.send(CommandID.SINGLE_ACTIVITY_RANK,RankType.TYPE_TOP_KILL_POINT,0,9);
      }
      
      public static function isUserInTop10Bad(param1:int) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(_top10Users)
         {
            _loc2_ = int(_top10Users.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               if(_top10Users[_loc3_].userID == param1)
               {
                  return true;
               }
               _loc3_++;
            }
         }
         return false;
      }
      
      private static function onActivityRank(param1:SocketEvent) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:uint = 0;
         var _loc7_:int = 0;
         var _loc8_:RankInfo = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         _top10Users = new Vector.<RankInfo>();
         var _loc3_:int = _loc2_.readInt();
         if(_loc3_ == RankType.TYPE_TOP_KILL_POINT)
         {
            _loc4_ = _loc2_.readInt();
            _loc5_ = _loc2_.readInt();
            _loc6_ = _loc2_.readUnsignedInt();
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               _loc8_ = new RankInfo(_loc2_);
               _loc8_.rankIndex = _loc7_ + 1;
               _top10Users.push(_loc8_);
               _loc7_++;
            }
         }
      }
      
      private static function addEvent() : void
      {
         SocketConnection.addCmdListener(CommandID.SINGLE_ACTIVITY_RANK,onActivityRank);
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,onMapSwtichComplete);
         MapManager.addEventListener(MapEvent.MAP_DESTROY,onMapDestory);
         EscortManager.instance.addEventListener(EscortManager.ESCORT_START,onEsStart);
         EscortManager.instance.addEventListener(EscortManager.ESCORT_PROGRESS,onEsStart);
         EscortManager.instance.addEventListener(EscortManager.ESCORT_COMPLETE,onEsEnd);
         EscortManager.instance.addEventListener(EscortManager.ESCORT_OVER,onEsEnd);
      }
      
      private static function onEsStart(param1:Event) : void
      {
      }
      
      private static function onEsEnd(param1:Event) : void
      {
         ClientTempState.yaBiaoStatus = [0,0,0];
      }
      
      private static function onMapDestory(param1:MapEvent) : void
      {
         if(_feather)
         {
            _feather.destroy();
         }
      }
      
      private static function onMapSwtichComplete(param1:MapEvent) : void
      {
         if(param1.mapModel.info.mapType == MapType.STAND)
         {
            _feather = new KillPointFeather();
         }
      }
   }
}

