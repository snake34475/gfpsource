package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.events.TaskCommonEvent;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.Logger;
   import com.gfp.core.utils.StringConstants;
   import flash.utils.ByteArray;
   
   public class TaskXML_PvpStatus extends TaskXML_Base
   {
      
      private var _status:uint;
      
      private var _pvpTypeArr:Array;
      
      public function TaskXML_PvpStatus()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:String = Logger.createLogMsgByArr(_params,param1,param2);
         Logger.info(this,_loc5_);
         var _loc6_:Array = _params.split(StringConstants.TASK_PARAM_SIGN);
         this._status = uint(_loc6_.shift());
         this._pvpTypeArr = _loc6_;
      }
      
      override protected function addListener() : void
      {
         TasksManager.addCommonListener(TaskCommonEvent.TASK_PVP_STATUS,this.onPvpStatus);
      }
      
      private function onPvpStatus(param1:TaskCommonEvent) : void
      {
         var _loc2_:ByteArray = ByteArray(param1.data);
         _loc2_.position = 0;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         if((this._status == 0 || _loc3_ == this._status) && this._pvpTypeArr.indexOf(String(_loc4_)) != -1)
         {
            TasksManager.taskProComplete(_taskID,_proID);
            TextAlert.show(this.getTaskProcName(_taskID,_proID) + " (完成)");
            this.uninit();
         }
      }
      
      override public function uninit() : void
      {
         TasksManager.removeCommonListener(TaskCommonEvent.TASK_PVP_STATUS,this.onPvpStatus);
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

