package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.Logger;
   
   public class TaskXML_HitCount extends TaskXML_Base
   {
      
      private var _tollgateId:int;
      
      private var _hit:int;
      
      public function TaskXML_HitCount()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:String = Logger.createLogMsgByArr("TaskXML_HitCount setup:",_params,param1,param2);
         Logger.info(this,_loc5_);
         var _loc6_:Array = param3.split("|");
         if(_loc6_.length >= 2)
         {
            this._tollgateId = uint(_loc6_[0]);
            this._hit = uint(_loc6_[1]);
         }
      }
      
      override protected function addListener() : void
      {
         super.addListener();
         TasksManager.addActionListener(TaskActionEvent.TASK_HIT_HAPPENED,null,this.onHitChanged);
      }
      
      override public function uninit() : void
      {
         super.uninit();
         TasksManager.removeActionListener(TaskActionEvent.TASK_HIT_HAPPENED,null,this.onHitChanged);
      }
      
      private function onHitChanged(param1:TaskActionEvent) : void
      {
         var _loc2_:Object = param1.param;
         if((this._tollgateId == 0 || this._tollgateId == _loc2_.stageId) && _loc2_.hit == this._hit)
         {
            TasksManager.taskProComplete(_taskID,_proID);
            TextAlert.show(this.getTaskProcName(_taskID,_proID) + " (完成)");
            this.uninit();
         }
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

