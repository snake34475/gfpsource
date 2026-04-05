package com.gfp.app.manager
{
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.utils.TickManager;
   
   public class NoahsWeightReductionPlanManager
   {
      
      private static var _instance:NoahsWeightReductionPlanManager;
      
      public static const TASK_IDs:Array = [5024,5025,5026];
      
      public static const SUB_TASKS:Array = [6471,6472,6473,6474,6475,6476,6477,6478,6479,6480];
      
      private var _curTask:int;
      
      public function NoahsWeightReductionPlanManager()
      {
         super();
      }
      
      public static function get instance() : NoahsWeightReductionPlanManager
      {
         if(_instance == null)
         {
            _instance = new NoahsWeightReductionPlanManager();
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
         TasksManager.addListener(TaskEvent.PRO_COMPLETE,this._taskCompleteHandler);
      }
      
      private function _taskCompleteHandler(param1:TaskEvent) : void
      {
         var _loc2_:uint = uint(param1.taskID);
         var _loc3_:uint = uint(param1.proID);
         var _loc4_:int = SUB_TASKS.indexOf(_loc2_);
         if(_loc4_ != -1)
         {
            if(TasksManager.getTaskStatus(_loc2_) != TasksManager.COMPLETE && Boolean(TasksManager.isReady(_loc2_)))
            {
               TasksManager.taskComplete(_loc2_);
               if(_loc4_ >= 0 && _loc4_ <= 2)
               {
                  this._curTask = 1;
               }
               else if(_loc4_ >= 3 && _loc4_ <= 6)
               {
                  this._curTask = 2;
               }
               if(_loc4_ >= 7 && _loc4_ <= 9)
               {
                  this._curTask = 3;
               }
               TickManager.instance.addTimeout(2000,this.openModule);
            }
         }
      }
      
      private function openModule() : void
      {
         ModuleManager.turnAppModule("NoahsWeightReductionPlan" + this._curTask.toString() + "Panel");
         TickManager.instance.removeTimeout(this.openModule);
      }
      
      public function check() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < 10)
         {
            _loc2_ = uint(SUB_TASKS[_loc1_]);
            if(_loc2_ == 6478 || _loc2_ == 6479 || _loc2_ == 6480)
            {
               if(TasksManager.getTaskStatus(_loc2_) != TasksManager.COMPLETE)
               {
                  _loc3_ = uint(ActivityExchangeTimesManager.getTimes(6211 + _loc2_ - 6478));
                  if(_loc3_ > 0)
                  {
                     TasksManager.taskComplete(_loc2_);
                  }
               }
            }
            else if(TasksManager.getTaskStatus(_loc2_) != TasksManager.COMPLETE && Boolean(TasksManager.isReady(_loc2_)))
            {
               TasksManager.taskComplete(_loc2_);
            }
            _loc1_++;
         }
      }
      
      public function destroy() : void
      {
         TasksManager.removeListener(TaskEvent.PRO_COMPLETE,this._taskCompleteHandler);
      }
   }
}

