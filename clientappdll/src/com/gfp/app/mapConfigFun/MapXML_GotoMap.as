package com.gfp.app.mapConfigFun
{
   import com.gfp.app.manager.CityWarManager;
   import com.gfp.app.manager.EscortManager;
   import com.gfp.app.manager.PvpKillPointManager;
   import com.gfp.app.systems.ClientTempState;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.MiniRoomManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.map.IMapConfigFun;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   import com.gfp.core.model.sensemodels.SightModel;
   
   public class MapXML_GotoMap implements IMapConfigFun
   {
      
      public function MapXML_GotoMap()
      {
         super();
      }
      
      public function exec(param1:SightModel, param2:XML, param3:XMLList) : void
      {
         var pathIndex:int;
         var arr:Array = null;
         var sm:SightModel = param1;
         var data:XML = param2;
         var dataList:XMLList = param3;
         arr = data.toString().split(",");
         if(MiniRoomManager.ownerID != 0)
         {
            CityMap.instance.leaveMiniRoom(0,0,0,0,0);
            return;
         }
         if(CityWarManager.isInCityWar() && arr[1] == MapType.STAND)
         {
            CityWarManager.instance.changeMap(arr[0]);
            return;
         }
         if(MapManager.currentMap.info.id == 101 && arr[0] == 1059 || MapManager.currentMap.info.id == 7 && arr[0] == 1060)
         {
            if(!ClientTempState.isPvpSideAlert)
            {
               AlertManager.showSimpleAlert("大陆边境凶险异常，点击敌方大陆的侠士可以直接进入pvp。是否确认进入？",function(param1:Boolean):void
               {
                  ClientTempState.isPvpSideAlert = param1;
                  CityMap.instance.changeMap(arr[0],arr[1]);
               },null,true);
               return;
            }
         }
         pathIndex = PvpKillPointManager.effectPathIds.indexOf(EscortManager.instance.escortPathId);
         if(pathIndex != -1)
         {
            if(PvpKillPointManager.effectMaps.indexOf(arr[0]) != -1)
            {
               AlertManager.showSimpleAlert("进入该地图有可能被其他玩家劫镖，是否确认？",function(param1:Boolean):void
               {
                  CityMap.instance.changeMap(arr[0],arr[1]);
               });
               return;
            }
         }
         CityMap.instance.changeMap(arr[0],arr[1]);
      }
   }
}

