package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.manager.MasterManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.utils.Logger;
   import com.gfp.core.utils.StringConstants;
   import flash.events.Event;
   
   public class TaskXML_GetApprentice extends TaskXML_Base
   {
      
      public function TaskXML_GetApprentice()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:String = Logger.createLogMsgByArr(_params,param1,param2);
         Logger.info(this,_loc5_);
         var _loc6_:Array = _params.split(StringConstants.TASK_PARAM_SIGN);
         _taskID = param1;
         _proID = param2;
         MasterManager.instance.addEventListener(MasterManager.MASTER_ADD_APPRENTICE_SUCCESS,this.onAddApprenticeSuccess);
      }
      
      private function onAddApprenticeSuccess(param1:Event) : void
      {
         TasksManager.taskProComplete(_taskID,_proID);
         this.uninit();
      }
      
      override public function uninit() : void
      {
         MasterManager.instance.removeEventListener(MasterManager.MASTER_ADD_APPRENTICE_SUCCESS,this.onAddApprenticeSuccess);
      }
      
      override public function get isComplete() : Boolean
      {
         return TasksManager.getTaskProStatus(_taskID,_proID) == TasksManager.STEP_COMPLETE;
      }
   }
}

