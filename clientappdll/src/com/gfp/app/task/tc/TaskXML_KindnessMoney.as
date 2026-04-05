package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.events.DonateGfCoin;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.utils.Logger;
   import flash.utils.ByteArray;
   
   public class TaskXML_KindnessMoney extends TaskXML_Base
   {
      
      private var coinNum:int = 0;
      
      public function TaskXML_KindnessMoney()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:String = Logger.createLogMsgByArr(_params,param1,param2);
         Logger.info(this,_loc5_);
         this.coinNum = int(param3);
      }
      
      override protected function addListener() : void
      {
         ItemManager.addListener(DonateGfCoin.DONATECOIN,this.onDonateCoin);
      }
      
      private function onDonateCoin(param1:DonateGfCoin) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:String = null;
         var _loc2_:int = int(param1.coinNum);
         var _loc3_:int = 256;
         var _loc4_:ByteArray = TasksManager.getTaskProBytes(_taskID,_proID);
         if(_loc4_)
         {
            _loc4_.position = 1;
            _loc5_ = _loc4_.readUnsignedShort();
            _loc6_ = _loc4_.readUnsignedByte();
            _loc5_ = _loc5_ * _loc3_ + _loc6_;
            if(_loc5_ < this.coinNum)
            {
               _loc5_ += _loc2_;
               _loc4_.position = 1;
               _loc4_.writeShort(_loc5_ / 256);
               _loc4_.writeByte(_loc5_ % 256);
               if(_loc5_ < this.coinNum)
               {
                  TasksManager.setTaskProBytes(_taskID,_proID,_loc4_,true);
               }
               else
               {
                  TasksManager.setTaskProBytes(_taskID,_proID,_loc4_,false);
                  TasksManager.taskProComplete(_taskID,_proID);
                  this.uninit();
               }
            }
            else
            {
               _loc7_ = Logger.createLogMsgByArr("数据异常强制完成：",_taskID,_proID,_loc5_,this.coinNum);
               Logger.info(this,_loc7_);
               TasksManager.taskProComplete(_taskID,_proID);
               this.uninit();
            }
         }
      }
      
      private function setComplete() : void
      {
         TasksManager.taskProComplete(_taskID,_proID);
         this.uninit();
      }
      
      private function getTaskProcName(param1:uint, param2:uint) : String
      {
         return TasksXMLInfo.getProDoc(param1,param2);
      }
      
      override public function uninit() : void
      {
         ItemManager.removeListener(DonateGfCoin.DONATECOIN,this.onDonateCoin);
      }
      
      override public function get isComplete() : Boolean
      {
         return TasksManager.getTaskProStatus(_taskID,_proID) == TasksManager.STEP_COMPLETE;
      }
   }
}

