package com.gfp.app.manager
{
   import com.gfp.core.manager.TasksManager;
   
   public class SumGuidTaskManager
   {
      
      private static var _instance:SumGuidTaskManager;
      
      private var _sumTaskList:Array = [2252,2253,2254,2255,2256,2257,2258,2259];
      
      public function SumGuidTaskManager()
      {
         super();
      }
      
      public static function getInstance() : SumGuidTaskManager
      {
         if(!_instance)
         {
            _instance = new SumGuidTaskManager();
         }
         return _instance;
      }
      
      public function checkIsAutoAcceptTask() : void
      {
         var _loc1_:int = 0;
         for each(_loc1_ in this._sumTaskList)
         {
            if(TasksManager.isAcceptable(_loc1_))
            {
               TasksManager.accept(_loc1_,true);
            }
         }
      }
   }
}

