package com.gfp.app.task.tc
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.Constant;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.Logger;
   
   public class TaskXML_TollgatePassed extends TaskXML_Base
   {
      
      protected var _tollgateID:int;
      
      protected var _isTeam:Boolean;
      
      protected var _isEpic:Boolean;
      
      public function TaskXML_TollgatePassed()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         var _loc6_:Array = null;
         super.setup(param1,param2,param3,param4);
         var _loc5_:String = Logger.createLogMsgByArr("TaskXML_TollgatePassed setup:",_params,param1,param2);
         Logger.info(this,_loc5_);
         _loc6_ = param3.split(",");
         if(_loc6_.length >= 2)
         {
            this._tollgateID = uint(_loc6_[0]);
            this._isTeam = _loc6_[1] == "1";
         }
         else
         {
            this._tollgateID = uint(_params);
         }
         if(_loc6_.length == 3)
         {
            this._isEpic = this._isEpic[2] == 1;
         }
         else if(_loc6_.length == Constant.MAX_ROLE_TYPE)
         {
            this._tollgateID = _loc6_[MainManager.roleType - 1];
         }
      }
      
      override protected function addListener() : void
      {
         if(this._tollgateID != 0)
         {
            TasksManager.addActionListener(TaskActionEvent.TASK_TOLLGATE_PASSED,String(this._tollgateID),this.onTollgatePassed);
         }
         else
         {
            TasksManager.addActionListener(TaskActionEvent.TASK_TOLLGATE_PASSED,null,this.onTollgatePassed);
         }
      }
      
      protected function onTollgatePassed(param1:TaskActionEvent) : void
      {
         if(this._isTeam)
         {
            if(!FightManager.isTeamFight)
            {
               return;
            }
         }
         TasksManager.taskProComplete(_taskID,_proID);
         TextAlert.show(this.getTaskProcName(_taskID,_proID) + " (完成)");
         this.uninit();
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
      
      protected function getTaskProcName(param1:uint, param2:uint) : String
      {
         return TasksXMLInfo.getProDoc(param1,param2);
      }
   }
}

