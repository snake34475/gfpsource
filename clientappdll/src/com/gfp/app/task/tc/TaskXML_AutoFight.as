package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.Logger;
   import com.gfp.core.utils.TextFormatUtil;
   import flash.utils.ByteArray;
   
   public class TaskXML_AutoFight extends TaskXML_Base
   {
      
      private var _times:int;
      
      public function TaskXML_AutoFight()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:String = Logger.createLogMsgByArr("TaskXML_AutoFight setup:",_params,param1,param2);
         Logger.info(this,_loc5_);
         this._times = int(param3);
      }
      
      override protected function addListener() : void
      {
         super.addListener();
         TasksManager.addActionListener(TaskActionEvent.TASK_AUTO_FIGHT_START,null,this.onAutoFightStart);
      }
      
      override public function uninit() : void
      {
         super.uninit();
         TasksManager.removeActionListener(TaskActionEvent.TASK_AUTO_FIGHT_START,null,this.onAutoFightStart);
      }
      
      override public function get procString() : String
      {
         var _loc2_:uint = 0;
         var _loc1_:ByteArray = TasksManager.getTaskProBytes(_taskID,_proID);
         if(_loc1_)
         {
            _loc1_.position = 1;
            _loc2_ = _loc1_.readUnsignedByte();
            return _loc2_ + "/" + this._times;
         }
         return super.procString;
      }
      
      private function onAutoFightStart(param1:TaskActionEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:String = null;
         var _loc2_:ByteArray = TasksManager.getTaskProBytes(_taskID,_proID);
         if(_loc2_)
         {
            _loc2_.position = 1;
            _loc3_ = _loc2_.readUnsignedByte();
            if(_loc3_ < this._times)
            {
               _loc3_++;
               _loc2_.position = 1;
               _loc2_.writeByte(_loc3_);
               if(_loc3_ < this._times)
               {
                  TasksManager.setTaskProBytes(_taskID,_proID,_loc2_);
                  TextAlert.show(this.getTaskProcName(_taskID,_proID) + TextFormatUtil.getRedText(_loc3_.toString() + "/" + this._times.toString()));
                  TasksManager.dispatchEvent(TaskEvent.PRO_CHANGE,_taskID,_proID);
               }
               else
               {
                  TasksManager.setTaskProBytes(_taskID,_proID,_loc2_,true);
                  TasksManager.taskProComplete(_taskID,_proID);
                  this.uninit();
                  TextAlert.show(this.getTaskProcName(_taskID,_proID) + " (完成)");
               }
            }
            else
            {
               _loc4_ = Logger.createLogMsgByArr("数据异常强制完成：",_taskID,_proID,_loc3_,this._times);
               Logger.info(this,_loc4_);
               TasksManager.taskProComplete(_taskID,_proID);
               this.uninit();
            }
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

