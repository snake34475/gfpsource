package com.gfp.app.manager
{
   import com.gfp.app.manager.mapEvents.CommMapEventIds;
   import com.gfp.app.manager.mapEvents.CommMapFightEvent;
   import com.gfp.app.manager.mapEvents.ICommMapEvent;
   import org.taomee.ds.HashMap;
   
   public class CommMapEventManager
   {
      
      private static var _commEvtMap:HashMap = new HashMap();
      
      public function CommMapEventManager()
      {
         super();
      }
      
      private static function addCommEvent(param1:uint, param2:ICommMapEvent) : void
      {
         _commEvtMap.add(param1,param2);
      }
      
      public static function addTimerFightEvent() : void
      {
         var _loc1_:CommMapFightEvent = new CommMapFightEvent();
         _loc1_.init();
         addCommEvent(CommMapEventIds.TIME_FIGHT,_loc1_);
      }
      
      public static function getEventById(param1:uint) : ICommMapEvent
      {
         return _commEvtMap.getValue(param1);
      }
      
      public static function destroyEvtById(param1:uint) : void
      {
         var _loc2_:ICommMapEvent = getEventById(param1);
         if(_loc2_)
         {
            _loc2_.destroy();
         }
         _commEvtMap.remove(param1);
      }
   }
}

