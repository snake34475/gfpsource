package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.Logger;
   import com.gfp.core.utils.StringConstants;
   import com.gfp.core.utils.TextFormatUtil;
   import flash.utils.ByteArray;
   
   public class TaskXML_AllTollgateDifficulty extends TaskXML_Base
   {
      
      private var _tollgateDifficulty:int;
      
      private var _tollgateCount:int;
      
      public function TaskXML_AllTollgateDifficulty()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:String = Logger.createLogMsgByArr(_params,param1,param2);
         Logger.info(this,_loc5_);
         var _loc6_:Array = _params.split(StringConstants.TASK_PARAM_SIGN);
         this._tollgateDifficulty = uint(_loc6_[0]);
         this._tollgateCount = uint(_loc6_[1]);
      }
      
      override protected function addListener() : void
      {
         TasksManager.addActionListener(TaskActionEvent.TASK_ALL_TOLLGATE_DIFFICLTY,String(this._tollgateDifficulty),this.onTollgateWin);
      }
      
      private function onTollgateWin(param1:TaskActionEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:String = null;
         var _loc2_:ByteArray = TasksManager.getTaskProBytes(_taskID,_proID);
         if(_loc2_)
         {
            _loc2_.position = 1;
            _loc3_ = _loc2_.readUnsignedByte();
            if(_loc3_ < this._tollgateCount)
            {
               _loc3_++;
               _loc2_.position = 1;
               _loc2_.writeByte(_loc3_);
               if(_loc3_ < this._tollgateCount)
               {
                  TasksManager.setTaskProBytes(_taskID,_proID,_loc2_);
                  TextAlert.show(this.getDifficultyText() + " " + TextFormatUtil.getRedText(_loc3_.toString() + "/" + this._tollgateCount.toString()));
               }
               else
               {
                  TasksManager.setTaskProBytes(_taskID,_proID,_loc2_,false);
                  TasksManager.taskProComplete(_taskID,_proID);
                  this.uninit();
                  TextAlert.show(this.getDifficultyText() + " " + TextFormatUtil.getRedText(_loc3_.toString() + "/" + this._tollgateCount.toString()) + "(完成)");
               }
            }
            else
            {
               _loc4_ = Logger.createLogMsgByArr("数据异常强制完成：",_taskID,_proID,_loc3_,this._tollgateCount);
               Logger.info(this,_loc4_);
               TasksManager.taskProComplete(_taskID,_proID);
               this.uninit();
            }
         }
      }
      
      override public function uninit() : void
      {
         TasksManager.removeActionListener(TaskActionEvent.TASK_ALL_TOLLGATE_DIFFICLTY,String(this._tollgateDifficulty),this.onTollgateWin);
      }
      
      override public function get isComplete() : Boolean
      {
         return TasksManager.getTaskProStatus(_taskID,_proID) == TasksManager.STEP_COMPLETE;
      }
      
      override public function get procString() : String
      {
         if(TasksManager.isOutModedFinish(_taskID))
         {
            return this._tollgateCount + "/" + this._tollgateCount;
         }
         var _loc1_:ByteArray = TasksManager.getTaskProBytes(_taskID,_proID);
         _loc1_.position = 1;
         var _loc2_:uint = _loc1_.readUnsignedByte();
         return _loc2_.toString() + "/" + this._tollgateCount.toString();
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

