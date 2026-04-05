package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.events.TaskCommonEvent;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.Logger;
   import com.gfp.core.utils.StringConstants;
   
   public class TaskXML_BruiseLessLimit extends TaskXML_Base
   {
      
      private var _tollgateID:uint;
      
      private var _bruiseLessLimit:uint;
      
      public function TaskXML_BruiseLessLimit()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:String = Logger.createLogMsgByArr("TaskXML_BruiseLessLimit setup:",_params,param1,param2);
         Logger.info(this,_loc5_);
         var _loc6_:Array = _params.split(StringConstants.TASK_PARAM_SIGN);
         this._tollgateID = uint(_loc6_[0]);
         this._bruiseLessLimit = uint(_loc6_[1]);
      }
      
      override protected function addListener() : void
      {
         TasksManager.addCommonListener(TaskCommonEvent.TASK_BRUISE_LESSLIMIT,this.onBruiseLessLimit);
      }
      
      private function onBruiseLessLimit(param1:TaskCommonEvent) : void
      {
         var _loc2_:String = String(param1.data);
         var _loc3_:Array = _loc2_.split(StringConstants.SIGN);
         var _loc4_:uint = uint(_loc3_[0]);
         var _loc5_:uint = uint(_loc3_[1]);
         if(_loc4_ == this._tollgateID && _loc5_ <= this._bruiseLessLimit)
         {
            TasksManager.taskProComplete(_taskID,_proID);
            TextAlert.show(this.getTaskProcName(_taskID,_proID) + " (完成)");
            this.uninit();
         }
      }
      
      override public function uninit() : void
      {
         TasksManager.removeCommonListener(TaskCommonEvent.TASK_BRUISE_LESSLIMIT,this.onBruiseLessLimit);
      }
      
      override public function get isComplete() : Boolean
      {
         return TasksManager.getTaskProStatus(_taskID,_proID) == TasksManager.STEP_COMPLETE;
      }
      
      private function getTaskProcName(param1:uint, param2:uint) : String
      {
         return TasksXMLInfo.getProDoc(param1,param2);
      }
   }
}

