package com.gfp.app.task.tc
{
   import com.gfp.core.utils.Logger;
   
   public class TaskXML_ItemPay extends TaskXML_ItemCollect
   {
      
      public function TaskXML_ItemPay()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:String = Logger.createLogMsgByArr(_params,param1,param2);
         Logger.info(this,_loc5_);
      }
   }
}

