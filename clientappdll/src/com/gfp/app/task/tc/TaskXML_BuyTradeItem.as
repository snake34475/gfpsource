package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.events.TradeEvent;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.manager.TradeManager;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.Logger;
   
   public class TaskXML_BuyTradeItem extends TaskXML_Base
   {
      
      public function TaskXML_BuyTradeItem()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:String = Logger.createLogMsgByArr("TaskXML_BuyTradeItem setup:",_params,param1,param2);
         Logger.info(this,_loc5_);
      }
      
      override protected function addListener() : void
      {
         TradeManager.addListener(TradeEvent.BUY_ITEM,this.buyItemComplete);
      }
      
      private function buyItemComplete(param1:TradeEvent) : void
      {
         TasksManager.taskProComplete(_taskID,_proID);
         TextAlert.show(this.getTaskProcName(_taskID,_proID) + " (完成)");
         this.uninit();
      }
      
      override public function uninit() : void
      {
         TradeManager.removeListener(TradeEvent.BUY_ITEM,this.buyItemComplete);
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

