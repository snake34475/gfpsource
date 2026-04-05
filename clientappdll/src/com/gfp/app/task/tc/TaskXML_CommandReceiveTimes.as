package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.Logger;
   import com.gfp.core.utils.TextFormatUtil;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class TaskXML_CommandReceiveTimes extends TaskXML_Base
   {
      
      private var _commandId:uint;
      
      private var _times:uint;
      
      public function TaskXML_CommandReceiveTimes()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:String = Logger.createLogMsgByArr("TaskXML_CommandReceiveTimes setup:",_params,param1,param2);
         Logger.info(this,_loc5_);
         var _loc6_:Array = param3.split(",");
         if(_loc6_.length >= 2)
         {
            this._commandId = uint(_loc6_[0]);
            this._times = uint(_loc6_[1]);
         }
      }
      
      override protected function addListener() : void
      {
         SocketConnection.addCmdListener(this._commandId,this.onBackResultHandler);
      }
      
      override public function uninit() : void
      {
         SocketConnection.removeCmdListener(this._commandId,this.onBackResultHandler);
      }
      
      private function onBackResultHandler(param1:SocketEvent) : void
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
               }
               else
               {
                  TasksManager.setTaskProBytes(_taskID,_proID,_loc2_,false);
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
      
      override public function get procString() : String
      {
         if(TasksManager.isOutModedFinish(_taskID))
         {
            return this._times + "/" + this._times;
         }
         var _loc1_:ByteArray = TasksManager.getTaskProBytes(_taskID,_proID);
         _loc1_.position = 1;
         var _loc2_:uint = _loc1_.readUnsignedByte();
         return _loc2_.toString() + "/" + this._times.toString();
      }
   }
}

