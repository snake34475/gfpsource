package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.Logger;
   
   public class TaskXML_TollgatesPassed extends TaskXML_Base
   {
      
      protected var _tollgateIDs:Array;
      
      public function TaskXML_TollgatesPassed()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:String = Logger.createLogMsgByArr("TaskXML_TollgatePassed setup:",_params,param1,param2);
         Logger.info(this,_loc5_);
         this._tollgateIDs = [];
         var _loc6_:Array = param3.split(",");
         var _loc7_:int = int(_loc6_.length);
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_)
         {
            this._tollgateIDs.push(int(_loc6_[_loc8_]));
            _loc8_++;
         }
      }
      
      override protected function addListener() : void
      {
         TasksManager.addActionListener(TaskActionEvent.TASK_TOLLGATE_PASSED,null,this.onTollgatePassed);
      }
      
      protected function onTollgatePassed(param1:TaskActionEvent) : void
      {
         var _loc2_:int = int(param1.param);
         if(this._tollgateIDs.indexOf(_loc2_) != -1)
         {
            TasksManager.taskProComplete(_taskID,_proID);
            TextAlert.show(this.getTaskProcName(_taskID,_proID) + " (完成)");
            this.uninit();
         }
      }
      
      override public function uninit() : void
      {
         TasksManager.removeActionListener(TaskActionEvent.TASK_TOLLGATE_PASSED,null,this.onTollgatePassed);
      }
      
      override public function get isComplete() : Boolean
      {
         return TasksManager.getTaskProStatus(_taskID,_proID) == TasksManager.STEP_COMPLETE;
      }
      
      protected function getTaskProcName(param1:uint, param2:uint) : String
      {
         return TasksXMLInfo.getProDoc(param1,param2);
      }
   }
}

