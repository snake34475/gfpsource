package com.gfp.app.manager
{
   import com.gfp.app.config.xml.ActivityPromptXmlInfo;
   import com.gfp.app.config.xml.SystemTimeXMLInfo;
   import com.gfp.app.control.SystemTimeController;
   import com.gfp.app.info.ActivityPromptInfo;
   import com.gfp.app.info.SystemTimeInfo;
   import com.gfp.core.events.TimeEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.utils.TimeUtil;
   import com.gfp.core.utils.TimerManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class ActivityPromptManager
   {
      
      private static var _instance:ActivityPromptManager;
      
      public static const ADD_PROMPT:String = "add_prompt";
      
      public static const REMOVE_PROMPT:String = "remove_prompt";
      
      private var _activityList:Array;
      
      private var _limitList:Array;
      
      private var _ed:EventDispatcher;
      
      public function ActivityPromptManager()
      {
         super();
      }
      
      public static function get instance() : ActivityPromptManager
      {
         if(_instance == null)
         {
            _instance = new ActivityPromptManager();
         }
         return _instance;
      }
      
      public static function destroy() : void
      {
         if(_instance)
         {
            _instance.destroy();
         }
         _instance = null;
      }
      
      public function setup() : void
      {
         this._activityList = new Array();
         this._limitList = new Array();
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         TimerManager.ed.addEventListener(TimeEvent.TIMER_EVERY_MINUTE,this.onEveryMinute);
      }
      
      private function onEveryMinute(param1:TimeEvent) : void
      {
         var _loc3_:ActivityPromptInfo = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:SystemTimeInfo = null;
         var _loc7_:Date = null;
         var _loc8_:Date = null;
         var _loc9_:Date = null;
         var _loc2_:Array = ActivityPromptXmlInfo.getActivityList();
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = this._activityList.indexOf(_loc3_.id);
            _loc5_ = this._limitList.indexOf(_loc3_.id);
            _loc6_ = SystemTimeXMLInfo.getSystemTimeInfoById(_loc3_.sysTime);
            if(!(_loc6_ == null || _loc3_.lv > MainManager.actorInfo.lv))
            {
               _loc7_ = TimeUtil.getSeverDateObject();
               _loc8_ = new Date(_loc7_.fullYear,_loc7_.month,_loc7_.date,_loc7_.hours,_loc7_.minutes - _loc3_.offset,_loc7_.seconds);
               _loc9_ = new Date(_loc8_.fullYear,_loc8_.month,_loc8_.date,_loc8_.hours,_loc8_.minutes - 6,_loc8_.seconds);
               if(SystemTimeController.instance.checkSpecificTimeAchieve(_loc3_.sysTime,_loc8_) && !SystemTimeController.instance.checkSpecificTimeAchieve(_loc3_.sysTime,_loc9_))
               {
                  if(_loc4_ == -1 && _loc5_ == -1)
                  {
                     this._activityList.push(_loc3_.id);
                  }
               }
               else
               {
                  if(_loc4_ != -1)
                  {
                     this._activityList.splice(_loc4_,1);
                  }
                  if(_loc5_ != -1)
                  {
                     this._limitList.slice(_loc5_,1);
                  }
               }
            }
         }
         if(this._activityList.length > 0)
         {
            this.dispatchEvent(new Event(ADD_PROMPT));
         }
         else
         {
            this.dispatchEvent(new Event(REMOVE_PROMPT));
         }
      }
      
      public function removeActivity(param1:uint) : void
      {
         var _loc2_:int = this._activityList.indexOf(param1);
         if(_loc2_ != -1)
         {
            this._activityList.splice(_loc2_,1);
            if(this._activityList.length <= 0)
            {
               this.dispatchEvent(new Event(REMOVE_PROMPT));
            }
         }
         this._limitList.push(param1);
      }
      
      public function addEventListener(param1:String, param2:Function) : void
      {
         this.ed.addEventListener(param1,param2);
      }
      
      public function removeEventListener(param1:String, param2:Function) : void
      {
         this.ed.removeEventListener(param1,param2);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this.ed.dispatchEvent(param1);
      }
      
      private function get ed() : EventDispatcher
      {
         if(this._ed == null)
         {
            this._ed = new EventDispatcher();
         }
         return this._ed;
      }
      
      public function get activityList() : Array
      {
         return this._activityList;
      }
      
      public function destroy() : void
      {
         TimerManager.ed.removeEventListener(TimeEvent.TIMER_EVERY_MINUTE,this.onEveryMinute);
         this._activityList = null;
      }
   }
}

