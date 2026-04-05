package com.gfp.app.task.tc
{
   import com.gfp.app.manager.EscortManager;
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.config.xml.EscortXMLInfo;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.events.DataEvent;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.Logger;
   
   public class TaskXML_EscortComplete extends TaskXML_Base
   {
      
      private var _yaBiaoIds:Array = [[65,66,67],[68,69,70],[71,72,73]];
      
      public var _taskType:int;
      
      public function TaskXML_EscortComplete()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         this._taskType = int(param3);
         var _loc5_:String = Logger.createLogMsgByArr(_params,param1,param2);
         Logger.info(this,_loc5_);
      }
      
      override protected function addListener() : void
      {
         EscortManager.instance.addEventListener(EscortManager.ESCORT_COMPLETE,this.onEscortComplete);
      }
      
      public function onEscortComplete(param1:DataEvent) : void
      {
         var _loc4_:Array = null;
         var _loc2_:int = int(param1.data);
         var _loc3_:int = int(EscortXMLInfo.getEscortType(_loc2_));
         if(this._taskType == 0)
         {
            TasksManager.taskProComplete(_taskID,_proID);
            TextAlert.show(this.getTaskProcName(_taskID,_proID) + " (完成)");
            this.uninit();
            return;
         }
         if(this._taskType >= 1 && this._taskType <= 3)
         {
            _loc4_ = this._yaBiaoIds[this._taskType - 1];
            if(_loc4_.indexOf(_loc2_) != -1)
            {
               TasksManager.taskProComplete(_taskID,_proID);
               TextAlert.show(this.getTaskProcName(_taskID,_proID) + " (完成)");
               this.uninit();
               return;
            }
         }
         if(_loc3_ == this._taskType)
         {
            TasksManager.taskProComplete(_taskID,_proID);
            TextAlert.show(this.getTaskProcName(_taskID,_proID) + " (完成)");
            this.uninit();
         }
      }
      
      protected function getTaskProcName(param1:uint, param2:uint) : String
      {
         return TasksXMLInfo.getProDoc(param1,param2);
      }
      
      override public function uninit() : void
      {
         EscortManager.instance.removeEventListener(EscortManager.ESCORT_COMPLETE,this.onEscortComplete);
      }
      
      override public function get isComplete() : Boolean
      {
         return TasksManager.getTaskProStatus(_taskID,_proID) == TasksManager.STEP_COMPLETE;
      }
   }
}

