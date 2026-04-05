package com.gfp.app.task.tc
{
   import com.gfp.app.fight.PveEntry;
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.utils.Logger;
   import com.gfp.core.utils.StringConstants;
   
   public class TaskXML_TollgateDifficultyAndTimeLimit extends TaskXML_Base
   {
      
      private var _tollgateId:int;
      
      private var _tollgateDifficulty:int;
      
      private var _tollgateTime:int;
      
      public function TaskXML_TollgateDifficultyAndTimeLimit()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:String = Logger.createLogMsgByArr(_params,param1,param2);
         Logger.info(this,_loc5_);
         var _loc6_:Array = _params.split(StringConstants.TASK_PARAM_SIGN);
         this._tollgateId = uint(_loc6_[0]);
         this._tollgateDifficulty = uint(_loc6_[1]);
         this._tollgateTime = uint(_loc6_[2]);
         TasksManager.addActionListener(TaskActionEvent.TASK_TOLLGATE_DIFFICLTY,this._tollgateId + StringConstants.SIGN + this._tollgateDifficulty,this.onTollgateWin);
      }
      
      override public function uninit() : void
      {
         TasksManager.removeActionListener(TaskActionEvent.TASK_TOLLGATE_DIFFICLTY,this._tollgateId + StringConstants.SIGN + this._tollgateDifficulty,this.onTollgateWin);
      }
      
      override public function get isComplete() : Boolean
      {
         return TasksManager.getTaskProStatus(_taskID,_proID) == TasksManager.STEP_COMPLETE;
      }
      
      private function onTollgateWin(param1:TaskActionEvent) : void
      {
         if(PveEntry.instance._awardInfo.passTime < 241)
         {
            TasksManager.taskProComplete(_taskID,_proID);
            this.uninit();
         }
      }
      
      private function getTaskProcName(param1:uint, param2:uint) : String
      {
         return TasksXMLInfo.getProDoc(param1,param2);
      }
      
      private function getDifficultyText() : String
      {
         switch(this._tollgateDifficulty)
         {
            case 1:
               return AppLanguageDefine.SIMPLE;
            case 2:
               return AppLanguageDefine.GENERAL;
            case 3:
               return AppLanguageDefine.DIFFICULT;
            case 4:
               return AppLanguageDefine.ELITE;
            case 5:
               return AppLanguageDefine.HERO;
            case 6:
               return AppLanguageDefine.EPIC;
            default:
               return "";
         }
      }
   }
}

