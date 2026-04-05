package com.gfp.app.task.tc
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.Logger;
   
   public class TaskXML_TollgateConditionPassed extends TaskXML_Base
   {
      
      protected var _tollgateID:int;
      
      protected var _isTeam:Boolean;
      
      protected var _isEpic:uint;
      
      private var isPass:Boolean;
      
      private var dissIsPass:Boolean;
      
      private var iscompltet:Boolean;
      
      public function TaskXML_TollgateConditionPassed()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:String = Logger.createLogMsgByArr("TaskXML_TollgatePassed setup:",_params,param1,param2);
         Logger.info(this,_loc5_);
         this._tollgateID = uint(_params);
         var _loc6_:Array = param3.split("|");
         if(_loc6_.length >= 2)
         {
            this._isTeam = _loc6_[1] == "1";
         }
         if(_loc6_.length == 3)
         {
            this._isEpic = _loc6_[2];
         }
      }
      
      override protected function addListener() : void
      {
         TasksManager.addActionListener(TaskActionEvent.TASK_TOLLGATE_PASSED,null,this.onTollgatePassed);
         TasksManager.addActionListener(TaskActionEvent.TASK_TOLLGATE_DIFFICLTY,null,this.onTollgateWin);
      }
      
      private function onTollgateWin(param1:TaskActionEvent) : void
      {
         var _loc2_:String = param1.param as String;
         var _loc3_:uint = uint(_loc2_.split("_")[1]);
         if(_loc3_)
         {
            this.dissIsPass = _loc3_ == this._isEpic;
         }
         this.compltetProTask();
      }
      
      private function onTollgatePassed(param1:TaskActionEvent) : void
      {
         if(this._isTeam && !FightManager.isTeamFight)
         {
            return;
         }
         this.isPass = true;
         this.compltetProTask();
      }
      
      private function compltetProTask() : void
      {
         if(this.isPass && this.dissIsPass && !this.iscompltet)
         {
            TasksManager.taskProComplete(_taskID,_proID);
            TextAlert.show(this.getTaskProcName(_taskID,_proID) + " (完成)");
            this.iscompltet = true;
            this.uninit();
         }
      }
      
      override public function uninit() : void
      {
         if(this._tollgateID != 0)
         {
            TasksManager.removeActionListener(TaskActionEvent.TASK_TOLLGATE_PASSED,String(this._tollgateID),this.onTollgatePassed);
         }
         else
         {
            TasksManager.removeActionListener(TaskActionEvent.TASK_TOLLGATE_PASSED,null,this.onTollgatePassed);
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

