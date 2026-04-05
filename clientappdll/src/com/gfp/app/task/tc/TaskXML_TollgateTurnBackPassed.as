package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.config.xml.TollgateXMLInfo;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.info.fight.FightAwardInfo;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.Logger;
   
   public class TaskXML_TollgateTurnBackPassed extends TaskXML_Base
   {
      
      private var _tollgateId:int;
      
      public function TaskXML_TollgateTurnBackPassed()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:String = Logger.createLogMsgByArr("TaskXML_TollgateTurnBackPassed setup:",_params,param1,param2);
         Logger.info(this,_loc5_);
         this._tollgateId = parseInt(param3);
      }
      
      override protected function addListener() : void
      {
         super.addListener();
         TasksManager.addActionListener(TaskActionEvent.TASK_TOLLGATE_DETAIL_INFO,null,this.onTollgatePassed);
      }
      
      override public function uninit() : void
      {
         super.uninit();
         TasksManager.removeActionListener(TaskActionEvent.TASK_TOLLGATE_DETAIL_INFO,null,this.onTollgatePassed);
      }
      
      private function onTollgatePassed(param1:TaskActionEvent) : void
      {
         var _loc2_:FightAwardInfo = param1.param as FightAwardInfo;
         if(this._tollgateId == 0 || this._tollgateId == _loc2_.stageId)
         {
            if(TollgateXMLInfo.isTurnBackTollgate(_loc2_.stageId))
            {
               this.completeTask();
            }
            else if(_loc2_.stageType == 5)
            {
               this.completeTask();
            }
         }
      }
      
      private function completeTask() : void
      {
         TasksManager.taskProComplete(_taskID,_proID);
         TextAlert.show(this.getTaskProcName(_taskID,_proID) + " (完成)");
         this.uninit();
      }
      
      protected function getTaskProcName(param1:uint, param2:uint) : String
      {
         return TasksXMLInfo.getProDoc(param1,param2);
      }
      
      override public function get isComplete() : Boolean
      {
         return TasksManager.getTaskProStatus(_taskID,_proID) == TasksManager.STEP_COMPLETE;
      }
   }
}

