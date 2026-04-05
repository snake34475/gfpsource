package com.gfp.app.manager
{
   import com.gfp.app.config.xml.SummonRaceXMLInfo;
   import com.gfp.core.events.DataEvent;
   import com.gfp.core.manager.LayerManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class SummonRaceForecastMananger
   {
      
      private static var _instance:SummonRaceForecastMananger;
      
      public static const ADD_SUMMON_FORECAST:String = "ADD_SUMMON_FORECAST";
      
      public static const REMOVE_SUMMON_FORECAST:String = "REMOVE_SUMMON_FORECAST";
      
      public static const ADD_SUMMON_TICKET:String = "ADD_SUMMON_TICKET";
      
      public static const SUMMON_RACE_BEGIN:String = "Summon_race_begin";
      
      public static const SUMMON_RACE_END:String = "Summon_race_end";
      
      private var _chosenList:Array;
      
      private var _ed:EventDispatcher;
      
      public function SummonRaceForecastMananger()
      {
         super();
         this._chosenList = new Array();
      }
      
      public static function get instance() : SummonRaceForecastMananger
      {
         if(_instance == null)
         {
            _instance = new SummonRaceForecastMananger();
         }
         return _instance;
      }
      
      public static function addEventListener(param1:String, param2:Function) : void
      {
         instance.addEventListener(param1,param2);
      }
      
      public static function removeEventListener(param1:String, param2:Function) : void
      {
         instance.removeEventListener(param1,param2);
      }
      
      public static function dispatchEvent(param1:Event) : void
      {
         instance.dispatchEvent(param1);
      }
      
      public static function destroy() : void
      {
         if(_instance)
         {
            _instance.destroy();
         }
         _instance = null;
      }
      
      public function getRacingSummons(param1:uint = 0) : Array
      {
         return SummonRaceXMLInfo.getInfos(param1).summonList;
      }
      
      public function addSummon(param1:uint) : void
      {
         this._chosenList.push(param1);
         this.dispatchEvent(new DataEvent(ADD_SUMMON_FORECAST,param1));
      }
      
      public function removeSummon(param1:uint) : void
      {
         var summonID:uint = param1;
         this._chosenList.some(function(param1:uint, param2:int, param3:Array):Boolean
         {
            if(param1 == summonID)
            {
               _chosenList.splice(param2,1);
               dispatchEvent(new DataEvent(REMOVE_SUMMON_FORECAST,summonID));
               return true;
            }
            return false;
         });
      }
      
      public function getPosX(param1:uint) : Number
      {
         if(param1 == 0 || param1 > 25)
         {
            return 0;
         }
         return (26 - param1) * LayerManager.stageWidth / 26;
      }
      
      public function clearList() : void
      {
         this._chosenList.length = 0;
      }
      
      public function addEventListener(param1:String, param2:Function) : void
      {
         this.ed.addEventListener(param1,param2);
      }
      
      public function removeEventListener(param1:String, param2:Function) : void
      {
         this.ed.removeEventListener(param1,param2);
      }
      
      public function dispatchEvent(param1:Event) : void
      {
         this.ed.dispatchEvent(param1);
      }
      
      private function get ed() : EventDispatcher
      {
         if(this._ed == null)
         {
            this._ed = new EventDispatcher();
         }
         return this._ed;
      }
      
      public function get chosenList() : Array
      {
         return this._chosenList;
      }
      
      public function destroy() : void
      {
         this._chosenList = null;
      }
   }
}

