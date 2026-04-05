package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.utils.Logger;
   
   public class TaskXML_CompleteTask extends TaskXML_Base
   {
      
      private var nextAcceptID:int = 0;
      
      private var nextCompleteID:int = 0;
      
      public function TaskXML_CompleteTask()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:String = Logger.createLogMsgByArr("TaskXML_CompleteTask setup:",_params,param1,param2);
         Logger.info(this,_loc5_);
      }
      
      override public function uninit() : void
      {
         super.uninit();
      }
      
      override public function init(param1:Boolean) : void
      {
         super.init(param1);
         TasksManager.taskComplete(_taskID);
         if(_params)
         {
            CityMap.instance.tranChangeMapByStr(_params);
         }
      }
      
      override public function get isComplete() : Boolean
      {
         return true;
      }
   }
}

