package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.events.SummonEvent;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.Logger;
   
   public class TaskXML_SummonExpAdd extends TaskXML_Base
   {
      
      public function TaskXML_SummonExpAdd()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:String = Logger.createLogMsgByArr("TaskXML_SummonExpAdd setup:",_params,param1,param2);
         Logger.info(this,_loc5_);
      }
      
      override protected function addListener() : void
      {
         super.addListener();
         SummonManager.addEventListener(SummonEvent.SUMMON_UPDATE,this.onSummonExpUpdate);
      }
      
      override public function uninit() : void
      {
         super.uninit();
         SummonManager.removeEventListener(SummonEvent.SUMMON_UPDATE,this.onSummonExpUpdate);
      }
      
      private function onSummonExpUpdate(param1:SummonEvent) : void
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

