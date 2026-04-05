package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.Logger;
   import org.taomee.net.SocketEvent;
   
   public class TaskXML_CommandReceive extends TaskXML_Base
   {
      
      private var _commandId:uint;
      
      public function TaskXML_CommandReceive()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:String = Logger.createLogMsgByArr("TaskXML_CommandReceive setup:",_params,param1,param2);
         Logger.info(this,_loc5_);
         this._commandId = uint(_params);
      }
      
      override protected function addListener() : void
      {
         SocketConnection.addCmdListener(this._commandId,this.onBackResultHandler);
      }
      
      override public function uninit() : void
      {
         SocketConnection.removeCmdListener(this._commandId,this.onBackResultHandler);
      }
      
      private function onBackResultHandler(param1:SocketEvent) : void
      {
         TasksManager.taskProComplete(_taskID,_proID);
         TextAlert.show(this.getTaskProcName(_taskID,_proID) + " (完成)");
         this.uninit();
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

