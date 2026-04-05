package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.utils.Logger;
   
   public class TaskXML_AutoComplete extends TaskXML_Base
   {
      
      public function TaskXML_AutoComplete()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:String = Logger.createLogMsgByArr("TaskXML_AutoComplete setup:",_params,param1,param2);
         Logger.info(this,_loc5_);
      }
   }
}

