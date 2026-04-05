package com.gfp.app.cmdl
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.config.xml.ActivitySuggestionXMLInfo;
   import com.gfp.core.events.ActivitySuggestionEvents;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.info.activitySuggestion.ActivitySuggestionInfo;
   import com.gfp.core.manager.ActivitySuggestionSOManager;
   import com.gfp.core.manager.TasksManager;
   import org.taomee.bean.BaseBean;
   
   public class ActivitySuggestionCmdListener extends BaseBean
   {
      
      public function ActivitySuggestionCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         if(ActivitySuggestionSOManager.checkShouldReset())
         {
            ActivitySuggestionSOManager.resetSO();
         }
         ActivitySuggestionSOManager.checkNullArr();
         FightManager.instance.addEventListener(ActivitySuggestionEvents.MAP_COMPLETE,this.onMapComplete);
         TasksManager.addListener(TaskEvent.COMPLETE,this.onTaskComplete);
         finish();
      }
      
      private function onMapComplete(param1:ActivitySuggestionEvents) : void
      {
         var _loc5_:ActivitySuggestionInfo = null;
         var _loc2_:uint = uint(param1.data);
         var _loc3_:Vector.<ActivitySuggestionInfo> = ActivitySuggestionXMLInfo.getActivityVecByRestrictID(_loc2_);
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = _loc3_[_loc4_];
            if(_loc5_.type == 1 || _loc5_.type == 4)
            {
               ActivitySuggestionSOManager.updataTimesByID(_loc5_.id);
            }
            _loc4_++;
         }
      }
      
      private function onTaskComplete(param1:TaskEvent) : void
      {
         var _loc5_:ActivitySuggestionInfo = null;
         var _loc2_:uint = uint(param1.taskID);
         var _loc3_:Vector.<ActivitySuggestionInfo> = ActivitySuggestionXMLInfo.getActivityVecByRestrictID(_loc2_);
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = _loc3_[_loc4_];
            if(_loc5_.type == 2 || _loc5_.type == 3)
            {
               ActivitySuggestionSOManager.updataTimesByID(_loc5_.id);
            }
            _loc4_++;
         }
      }
   }
}

