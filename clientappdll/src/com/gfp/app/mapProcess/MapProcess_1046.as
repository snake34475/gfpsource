package com.gfp.app.mapProcess
{
   import com.gfp.app.manager.TeamTaskManager;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.manager.TasksManager;
   
   public class MapProcess_1046 extends MapProcess_1045
   {
      
      public function MapProcess_1046()
      {
         super();
      }
      
      override protected function init() : void
      {
         var _loc2_:uint = 0;
         var _loc1_:uint = TeamTaskManager.instance.taskID;
         if(TasksManager.isReady(_loc1_))
         {
            if(_loc1_ < 1989)
            {
               _loc2_ = 10505;
            }
            else
            {
               _loc2_ = 10506;
            }
            addSignFlag(_loc2_);
         }
         initTaskEvent();
      }
      
      override protected function onTaskProComplete(param1:TaskEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc2_:uint = uint(param1.taskID);
         if(TasksXMLInfo.getType(_loc2_) == 13 && Boolean(TasksManager.isReady(_loc2_)))
         {
            if(_loc2_ < 1989)
            {
               _loc3_ = 10505;
            }
            else
            {
               _loc3_ = 10506;
            }
            addSignFlag(_loc3_);
         }
      }
   }
}

