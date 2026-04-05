package com.gfp.app.manager
{
   import com.gfp.app.feature.PvpSideGodGrilComeFeater;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.utils.TimeUtil;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class PvpSideGodManager
   {
      
      private static var _airGodFeather:PvpSideGodGrilComeFeater;
      
      private static var _moGodFeather:PvpSideGodGrilComeFeater;
      
      public static var effectMaps:Array = [7,1060,1061,101,1059,1061];
      
      private static var _effectPath:Array = [[new Point(404,618),new Point(395,788),new Point(511,931),new Point(751,996),new Point(1052,1021),new Point(1339,853),new Point(1582,908)],[new Point(2038,478),new Point(1465,806),new Point(1144,706),new Point(907,461),new Point(610,399),new Point(472,523),new Point(664,891),new Point(1126,1111),new Point(1903,1389),new Point(1306,1521),new Point(786,1367),new Point(329,1117)],[new Point(2618,867),new Point(2344,952),new Point(2325,1192),new Point(2250,1409),new Point(1977,1486),new Point(1602,1510),new Point(1145,1470),new Point(199,1392)],[new Point(749,427),new Point(323,561),new Point(315,804),new Point(588,989),new Point(942,955),new Point(1202,794),new Point(1565,648)],[new Point(574,398),new Point(1014,725),new Point(1373,812),new Point(1664,561),new Point(2096,374),new Point(2285,688),new Point(1826,1011),new Point(1157,1169),new Point(758,1256),new Point(1417,1507),new Point(1932,1343),new Point(2288,1122)],[new Point(224,624),new Point(612
      ,905),new Point(874,1106),new Point(1141,1031),new Point(1400,830),new Point(1745,878),new Point(2005,766),new Point(1982,544)]];
      
      private static const _effectTimes:Array = [[13,0,0],[13,0,30],[13,1,0],[13,0,0],[13,0,30],[13,1,0]];
      
      private static const _effectBoxPostions:Array = [[new Point(404,618),new Point(395,788),new Point(511,931),new Point(751,996),new Point(1052,1021),new Point(1339,853),new Point(1582,908)],[new Point(2038,478),new Point(1465,806),new Point(1144,706),new Point(907,461),new Point(610,399),new Point(472,523),new Point(664,891),new Point(1126,1111),new Point(1903,1389),new Point(1306,1521),new Point(786,1367),new Point(329,1117)],[new Point(2618,867),new Point(2344,952),new Point(2325,1192),new Point(2250,1409),new Point(1977,1486),new Point(1602,1510),new Point(1145,1470),new Point(199,1392)],[new Point(749,427),new Point(323,561),new Point(315,804),new Point(588,989),new Point(942,955),new Point(1202,794),new Point(1565,648)],[new Point(574,398),new Point(1014,725),new Point(1373,812),new Point(1664,561),new Point(2096,374),new Point(2285,688),new Point(1826,1011),new Point(1157,1169),new Point(758,1256),new Point(1417,1507),new Point(1932,1343),new Point(2288,1122)],[new Point(224,624),new Point(612
      ,905),new Point(874,1106),new Point(1141,1031),new Point(1400,830),new Point(1745,878),new Point(2005,766),new Point(1982,544)]];
      
      public function PvpSideGodManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         addEvent();
      }
      
      private static function addEvent() : void
      {
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,onMapSwtichComplete);
      }
      
      private static function onMapSwtichComplete(param1:MapEvent) : void
      {
         initGod(param1.mapModel.info.id);
      }
      
      private static function initGod(param1:int) : void
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:Date = null;
         var _loc6_:Date = null;
         var _loc7_:Date = null;
         var _loc8_:Date = null;
         if(_airGodFeather)
         {
            _airGodFeather.removeEventListener(PvpSideGodGrilComeFeater.TIME_OUT_EVENT,onGodTimeOut);
            _airGodFeather.destory();
         }
         if(_moGodFeather)
         {
            _moGodFeather.removeEventListener(PvpSideGodGrilComeFeater.TIME_OUT_EVENT,onGodTimeOut);
            _moGodFeather.destory();
         }
         var _loc2_:int = effectMaps.indexOf(param1);
         if(_loc2_ != -1)
         {
            if(_loc2_ < _effectPath.length)
            {
               _loc3_ = _effectPath[_loc2_] as Array;
               _loc4_ = _effectTimes[_loc2_];
               _loc5_ = TimeUtil.getSeverDateObject();
               _loc6_ = getLastTime(_loc4_);
               if(_loc6_)
               {
                  _loc7_ = new Date();
                  _loc7_.time = _loc6_.time + 30 * 1000;
                  _loc8_ = new Date();
                  _loc8_.time = _loc6_.time + 90 * 1000;
                  if(_loc2_ == 2)
                  {
                     _airGodFeather = new PvpSideGodGrilComeFeater(_loc3_,_effectBoxPostions[_loc2_],_loc6_,_loc7_,_loc8_,1);
                     _airGodFeather.addEventListener(PvpSideGodGrilComeFeater.TIME_OUT_EVENT,onGodTimeOut);
                     _moGodFeather = new PvpSideGodGrilComeFeater(_loc3_,_effectBoxPostions[_loc2_],_loc6_,_loc7_,_loc8_,2);
                  }
                  else if(_loc2_ < 3)
                  {
                     _airGodFeather = new PvpSideGodGrilComeFeater(_loc3_,_effectBoxPostions[_loc2_],_loc6_,_loc7_,_loc8_,1);
                     _airGodFeather.addEventListener(PvpSideGodGrilComeFeater.TIME_OUT_EVENT,onGodTimeOut);
                  }
                  else
                  {
                     _moGodFeather = new PvpSideGodGrilComeFeater(_loc3_,_effectBoxPostions[_loc2_],_loc6_,_loc7_,_loc8_,2);
                     _moGodFeather.addEventListener(PvpSideGodGrilComeFeater.TIME_OUT_EVENT,onGodTimeOut);
                  }
               }
            }
         }
      }
      
      private static function onGodTimeOut(param1:Event) : void
      {
         initGod(MapManager.currentMap.info.id);
      }
      
      public static function getLastTime(param1:Array, param2:int = 90000) : Date
      {
         var _loc3_:Date = TimeUtil.getSeverDateObject();
         var _loc4_:Date = new Date();
         _loc4_.time = _loc3_.time;
         _loc4_.hours = param1[0];
         _loc4_.minutes = param1[1];
         _loc4_.seconds = param1[2];
         _loc4_.milliseconds = 0;
         var _loc5_:Number = _loc4_.time;
         var _loc6_:int = 0;
         while(_loc6_ < 4)
         {
            _loc4_.time = _loc5_ + 15 * 60 * 1000 * _loc6_;
            if(_loc4_.time > _loc3_.time - param2)
            {
               return _loc4_;
            }
            _loc6_++;
         }
         return null;
      }
   }
}

