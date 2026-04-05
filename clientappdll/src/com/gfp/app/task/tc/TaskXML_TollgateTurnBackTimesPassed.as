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
   import com.gfp.core.utils.StringConstants;
   import com.gfp.core.utils.TextFormatUtil;
   import flash.utils.ByteArray;
   
   public class TaskXML_TollgateTurnBackTimesPassed extends TaskXML_Base
   {
      
      private var _tollgateId:int;
      
      private var _tollgateCount:int;
      
      public function TaskXML_TollgateTurnBackTimesPassed()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:String = Logger.createLogMsgByArr("TaskXML_TollgateTurnBackTimesPassed setup:",_params,param1,param2);
         Logger.info(this,_loc5_);
         var _loc6_:Array = _params.split(StringConstants.TASK_PARAM_SIGN);
         this._tollgateId = uint(_loc6_[0]);
         this._tollgateCount = uint(_loc6_[2]);
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
               this.completeStageTaskAdd();
            }
            else if(_loc2_.stageType == 5)
            {
               this.completeStageTaskAdd();
            }
         }
      }
      
      private function completeStageTaskAdd() : void
      {
         var _loc2_:uint = 0;
         var _loc3_:String = null;
         var _loc1_:ByteArray = TasksManager.getTaskProBytes(_taskID,_proID);
         if(_loc1_)
         {
            _loc1_.position = 1;
            _loc2_ = _loc1_.readUnsignedByte();
            if(_loc2_ < this._tollgateCount)
            {
               _loc2_++;
               _loc1_.position = 1;
               _loc1_.writeByte(_loc2_);
               if(_loc2_ < this._tollgateCount)
               {
                  TasksManager.setTaskProBytes(_taskID,_proID,_loc1_);
                  TextAlert.show(this.getTaskProcName(_taskID,_proID) + " " + TextFormatUtil.getRedText(_loc2_.toString() + "/" + this._tollgateCount.toString()));
               }
               else
               {
                  TasksManager.setTaskProBytes(_taskID,_proID,_loc1_,false);
                  TasksManager.taskProComplete(_taskID,_proID);
                  this.uninit();
                  TextAlert.show(this.getTaskProcName(_taskID,_proID) + " " + TextFormatUtil.getRedText(_loc2_.toString() + "/" + this._tollgateCount.toString()) + "(完成)");
               }
            }
            else
            {
               _loc3_ = Logger.createLogMsgByArr("数据异常强制完成：",_taskID,_proID,_loc2_,this._tollgateCount);
               Logger.info(this,_loc3_);
               TasksManager.taskProComplete(_taskID,_proID);
               this.uninit();
            }
         }
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

