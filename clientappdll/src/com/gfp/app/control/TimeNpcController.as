package com.gfp.app.control
{
   import com.gfp.app.config.xml.TimeNpcXMLInfo;
   import com.gfp.app.info.TimeNpcInfo;
   import com.gfp.core.config.xml.NpcXMLInfo;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.TimeEvent;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.map.MapConfigUtil;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.sensemodels.InSightModel;
   import com.gfp.core.model.sensemodels.MoveSightModel;
   import com.gfp.core.model.sensemodels.SightModel;
   import com.gfp.core.utils.TimerManager;
   import org.taomee.utils.DisplayUtil;
   
   public class TimeNpcController
   {
      
      private static var timeNpcCount:int;
      
      private static var inTimeNpcs:Array;
      
      private static var unInTimeNpcs:Array;
      
      public function TimeNpcController()
      {
         super();
      }
      
      public static function setup() : void
      {
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,whenMapSwitchCompleteHandler);
      }
      
      public static function whenMapSwitchCompleteHandler(param1:MapEvent) : void
      {
         destroy();
         if(!MapManager.isFightMap)
         {
            inital();
         }
      }
      
      public static function inital() : void
      {
         var _loc2_:TimeNpcInfo = null;
         inTimeNpcs = [];
         unInTimeNpcs = [];
         var _loc1_:Array = TimeNpcXMLInfo.getNpcTimeByMapId(MapManager.mapInfo.id);
         if(_loc1_.length > 0)
         {
            for each(_loc2_ in _loc1_)
            {
               if(checkNpcState(_loc2_))
               {
                  inTimeNpcs.push(_loc2_);
               }
               else
               {
                  unInTimeNpcs.push(_loc2_);
               }
            }
         }
         checkAddTimeListener();
      }
      
      private static function checkAddTimeListener() : void
      {
         removeEvent();
         TimerManager.ed.addEventListener(TimeEvent.TIMER_EVERY_MINUTE,checkNpcStateHandler);
      }
      
      private static function checkNpcStateHandler(param1:TimeEvent) : void
      {
         var _loc3_:TimeNpcInfo = null;
         checkNpcCanShowHandler(param1);
         var _loc2_:* = 0;
         while(_loc2_ < inTimeNpcs.length)
         {
            _loc3_ = inTimeNpcs[_loc2_];
            if(!checkNpcState(_loc3_))
            {
               inTimeNpcs.splice(_loc2_,1);
               _loc2_--;
            }
            _loc2_++;
         }
         checkAddTimeListener();
      }
      
      private static function checkNpcCanShowHandler(param1:TimeEvent) : void
      {
         var _loc3_:TimeNpcInfo = null;
         var _loc2_:* = 0;
         while(_loc2_ < unInTimeNpcs.length)
         {
            _loc3_ = unInTimeNpcs[_loc2_];
            if(checkNpcState(_loc3_))
            {
               inTimeNpcs.push(_loc3_);
               unInTimeNpcs.splice(_loc2_,1);
               _loc2_--;
            }
            _loc2_++;
         }
         checkAddTimeListener();
      }
      
      private static function checkNpcState(param1:TimeNpcInfo) : Boolean
      {
         var _loc2_:SightModel = SightManager.getSightModel(param1.npcId);
         if(param1.checkTime())
         {
            if(param1.visible && !_loc2_)
            {
               addNpcToMap(param1.npcId);
            }
            else if(!param1.visible && Boolean(_loc2_))
            {
               removeNpcFromMap(_loc2_);
            }
            return true;
         }
         if(!param1.visible && !_loc2_)
         {
            addNpcToMap(param1.npcId);
         }
         else if(param1.visible && Boolean(_loc2_))
         {
            removeNpcFromMap(_loc2_);
         }
         return false;
      }
      
      private static function removeEvent() : void
      {
         TimerManager.ed.removeEventListener(TimeEvent.TIMER_EVERY_MINUTE,checkNpcStateHandler);
         TimerManager.ed.removeEventListener(TimeEvent.TIMER_EVERY_FULL_HOUR,checkNpcCanShowHandler);
         TimerManager.ed.removeEventListener(TimeEvent.TIMER_EVERY_THIRTY_MINUTE,checkNpcCanShowHandler);
      }
      
      public static function destroy() : void
      {
         removeEvent();
      }
      
      private static function addNpcToMap(param1:uint) : void
      {
         var _loc3_:SightModel = null;
         var _loc2_:XML = NpcXMLInfo.getNpcInstanceById(int(param1)).xml;
         if(MapConfigUtil.S_MOVEINFO in _loc2_)
         {
            _loc3_ = new MoveSightModel(_loc2_);
         }
         else if(MapConfigUtil.S_MOUSEEVENT in _loc2_ || "@tip" in _loc2_)
         {
            _loc3_ = new InSightModel(_loc2_);
         }
         else
         {
            _loc3_ = new SightModel(_loc2_);
         }
         _loc3_.initView();
         var _loc4_:String = String(_loc2_.attribute(MapConfigUtil.A_LEVEL));
         addToMap(_loc3_,_loc4_);
         SightManager.add(_loc3_);
      }
      
      private static function removeNpcFromMap(param1:SightModel) : void
      {
         if(param1)
         {
            DisplayUtil.removeForParent(param1);
            SightManager.remove(param1);
         }
      }
      
      private static function addToMap(param1:SightModel, param2:String = "content") : void
      {
         if(param2 == "up")
         {
            param1.depthEnabled = false;
            MapManager.currentMap.upLevel.addChild(param1);
         }
         else if(param2 == "down")
         {
            param1.depthEnabled = false;
            MapManager.currentMap.downLevel.addChild(param1);
         }
         else
         {
            MapManager.currentMap.contentLevel.addChild(param1);
         }
      }
   }
}

