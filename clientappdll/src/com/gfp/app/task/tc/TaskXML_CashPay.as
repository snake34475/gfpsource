package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.utils.Logger;
   
   public class TaskXML_CashPay extends TaskXML_Base
   {
      
      private var _cash:uint;
      
      public function TaskXML_CashPay()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:String = Logger.createLogMsgByArr("TaskXML_CashPay setup:",_params,param1,param2);
         Logger.info(this,_loc5_);
         this._cash = uint(_params);
      }
      
      override public function taskComplete() : void
      {
         uninit();
      }
      
      override public function init(param1:Boolean) : void
      {
         super.init(param1);
         var _loc2_:Boolean = MainManager.actorInfo.coins >= this._cash;
         if(_loc2_)
         {
            TasksManager.taskProComplete(_taskID,_proID);
         }
      }
      
      override public function get isComplete() : Boolean
      {
         var _loc1_:Boolean = MainManager.actorInfo.coins >= this._cash;
         if(_loc1_)
         {
            return true;
         }
         return false;
      }
   }
}

