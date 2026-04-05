package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.info.ActivityExchangeAwardInfo;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.Logger;
   import com.gfp.core.utils.TextFormatUtil;
   import flash.utils.ByteArray;
   
   public class TaskXML_ActivityExchangeTimes extends TaskXML_Base
   {
      
      private var _swapId:int;
      
      private var _times:int;
      
      public function TaskXML_ActivityExchangeTimes()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:String = Logger.createLogMsgByArr("TaskXML_ActivityExchange setup:",_params,param1,param2);
         Logger.info(this,_loc5_);
         var _loc6_:Array = param3.split(",");
         if(_loc6_.length >= 2)
         {
            this._swapId = int(_loc6_[0]);
            this._times = int(_loc6_[1]);
         }
      }
      
      override protected function addListener() : void
      {
         ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchangeComplete);
      }
      
      private function onExchangeComplete(param1:ExchangeEvent) : void
      {
         var _loc3_:ByteArray = null;
         var _loc4_:uint = 0;
         var _loc5_:String = null;
         var _loc2_:ActivityExchangeAwardInfo = param1.info;
         if(_loc2_.id == this._swapId)
         {
            _loc3_ = TasksManager.getTaskProBytes(_taskID,_proID);
            if(_loc3_)
            {
               _loc3_.position = 1;
               _loc4_ = _loc3_.readUnsignedByte();
               if(_loc4_ < this._times)
               {
                  _loc4_++;
                  _loc3_.position = 1;
                  _loc3_.writeByte(_loc4_);
                  if(_loc4_ < this._times)
                  {
                     TasksManager.setTaskProBytes(_taskID,_proID,_loc3_);
                     TextAlert.show(this.getTaskProcName(_taskID,_proID) + TextFormatUtil.getRedText(_loc4_.toString() + "/" + this._times.toString()));
                     TasksManager.dispatchEvent(TaskEvent.PRO_CHANGE,_taskID,_proID);
                  }
                  else
                  {
                     TasksManager.setTaskProBytes(_taskID,_proID,_loc3_,false);
                     TasksManager.taskProComplete(_taskID,_proID);
                     this.uninit();
                     TextAlert.show(this.getTaskProcName(_taskID,_proID) + " (完成)");
                  }
               }
               else
               {
                  _loc5_ = Logger.createLogMsgByArr("数据异常强制完成：",_taskID,_proID,_loc4_,this._times);
                  Logger.info(this,_loc5_);
                  TasksManager.taskProComplete(_taskID,_proID);
                  this.uninit();
               }
            }
         }
      }
      
      override public function uninit() : void
      {
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchangeComplete);
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

