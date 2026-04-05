package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.events.TaskCommonEvent;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.Logger;
   import com.gfp.core.utils.StringConstants;
   
   public class TaskXML_FightPvpPerfectWin extends TaskXML_Base
   {
      
      private var _pvpTypes:Array;
      
      public function TaskXML_FightPvpPerfectWin()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:String = Logger.createLogMsgByArr("TaskXML_FightPvpPerfectWin setup:",_params,param1,param2);
         Logger.info(this,_loc5_);
         this._pvpTypes = _params.split(StringConstants.TASK_PARAM_SIGN);
      }
      
      override protected function addListener() : void
      {
         TasksManager.addCommonListener(TaskCommonEvent.TASK_FIGHTPVP_PERFECT_WIN,this.onFightPvpPerfectWin);
      }
      
      private function onFightPvpPerfectWin(param1:TaskCommonEvent) : void
      {
         var _loc2_:uint = uint(param1.data);
         if(this._pvpTypes.indexOf(String(_loc2_)) != -1)
         {
            TasksManager.taskProComplete(_taskID,_proID);
            TextAlert.show(this.getTaskProcName(_taskID,_proID) + " (完成)");
            this.uninit();
         }
      }
      
      override public function uninit() : void
      {
         TasksManager.removeCommonListener(TaskCommonEvent.TASK_FIGHTPVP_PERFECT_WIN,this.onFightPvpPerfectWin);
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

