package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.utils.Logger;
   
   public class TaskXML_HuntAwardPay extends TaskXML_Base
   {
      
      private var _huntAwardNum:uint;
      
      public function TaskXML_HuntAwardPay()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:String = Logger.createLogMsgByArr("TaskXML_HuntAwardPay setup:",_params,param1,param2);
         Logger.info(this,_loc5_);
         this._huntAwardNum = uint(_params);
      }
      
      override public function taskComplete() : void
      {
         uninit();
      }
      
      override public function get isComplete() : Boolean
      {
         return MainManager.actorInfo.huntAward >= this._huntAwardNum;
      }
   }
}

