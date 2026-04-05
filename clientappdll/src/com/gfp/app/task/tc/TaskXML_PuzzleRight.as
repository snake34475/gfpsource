package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.Logger;
   import com.gfp.core.utils.TextFormatUtil;
   import flash.utils.ByteArray;
   
   public class TaskXML_PuzzleRight extends TaskXML_Base
   {
      
      private var _conditionNum:uint;
      
      public function TaskXML_PuzzleRight()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:String = Logger.createLogMsgByArr("TaskXML_PuzzleRight setup:",_params,param1,param2);
         Logger.info(this,_loc5_);
         this._conditionNum = uint(_params);
      }
      
      override protected function addListener() : void
      {
         TasksManager.addActionListener(TaskActionEvent.TASK_PUZZLE_RIGHT,"",this.onPuzzleRight);
      }
      
      private function onPuzzleRight(param1:TaskActionEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:String = null;
         var _loc2_:ByteArray = TasksManager.getTaskProBytes(_taskID,_proID);
         if(_loc2_)
         {
            _loc2_.position = 1;
            _loc3_ = _loc2_.readUnsignedByte();
            if(_loc3_ < this._conditionNum)
            {
               _loc3_++;
               _loc2_.position = 1;
               _loc2_.writeByte(_loc3_);
               if(_loc3_ < this._conditionNum)
               {
                  TasksManager.setTaskProBytes(_taskID,_proID,_loc2_,false);
                  TextAlert.show(this.getTaskProcName(_taskID,_proID) + " " + TextFormatUtil.getRedText(_loc3_.toString() + "/" + this._conditionNum.toString()));
               }
               else
               {
                  TasksManager.setTaskProBytes(_taskID,_proID,_loc2_,false);
                  TasksManager.taskProComplete(_taskID,_proID);
                  this.uninit();
                  TextAlert.show(this.getTaskProcName(_taskID,_proID) + " " + TextFormatUtil.getRedText(_loc3_.toString() + "/" + this._conditionNum.toString()) + "(完成)");
               }
            }
            else
            {
               _loc4_ = Logger.createLogMsgByArr("数据异常强制完成：",_taskID,_proID,_loc3_,this._conditionNum);
               Logger.info(this,_loc4_);
               TasksManager.taskProComplete(_taskID,_proID);
               this.uninit();
            }
         }
      }
      
      override public function uninit() : void
      {
         TasksManager.removeActionListener(TaskActionEvent.TASK_PUZZLE_RIGHT,"",this.onPuzzleRight);
      }
      
      override public function get isComplete() : Boolean
      {
         return TasksManager.getTaskProStatus(_taskID,_proID) == TasksManager.STEP_COMPLETE;
      }
      
      override public function get procString() : String
      {
         if(TasksManager.isOutModedFinish(_taskID))
         {
            return this._conditionNum + "/" + this._conditionNum;
         }
         var _loc1_:ByteArray = TasksManager.getTaskProBytes(_taskID,_proID);
         _loc1_.position = 1;
         var _loc2_:uint = _loc1_.readUnsignedByte();
         return _loc2_.toString() + "/" + this._conditionNum.toString();
      }
      
      private function getTaskProcName(param1:uint, param2:uint) : String
      {
         return TasksXMLInfo.getProDoc(param1,param2);
      }
   }
}

