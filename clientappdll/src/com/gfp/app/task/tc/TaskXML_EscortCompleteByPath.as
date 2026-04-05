package com.gfp.app.task.tc
{
   import com.gfp.app.manager.EscortManager;
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.events.DataEvent;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.Logger;
   
   public class TaskXML_EscortCompleteByPath extends TaskXML_Base
   {
      
      public var _pathIds:Array;
      
      public function TaskXML_EscortCompleteByPath()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         this._pathIds = param3.split(",");
         var _loc5_:String = Logger.createLogMsgByArr(_params,param1,param2);
         Logger.info(this,_loc5_);
      }
      
      override protected function addListener() : void
      {
         EscortManager.instance.addEventListener(EscortManager.ESCORT_COMPLETE,this.onEscortComplete);
      }
      
      public function onEscortComplete(param1:DataEvent) : void
      {
         var _loc2_:int = int(param1.data);
         if(this._pathIds.indexOf(_loc2_) != -1)
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

