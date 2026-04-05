package com.gfp.app.feature
{
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.FunctionManager;
   import com.gfp.core.manager.MainManager;
   import flash.events.Event;
   
   public class PVPGetInfomationFeather
   {
      
      public function PVPGetInfomationFeather()
      {
         super();
      }
      
      public function start() : void
      {
         this.addEvent();
         MainManager.setOperateDisable(true);
      }
      
      public function destory() : void
      {
         this.removeEvent();
         MainManager.setOperateDisable(false);
      }
      
      private function addEvent() : void
      {
         FunctionManager.evtDispatch.addEventListener(FunctionManager.FUNCTION_DISABLED,this.functionDisabledHandler);
      }
      
      private function removeEvent() : void
      {
         FunctionManager.evtDispatch.removeEventListener(FunctionManager.FUNCTION_DISABLED,this.functionDisabledHandler);
      }
      
      private function functionDisabledHandler(param1:Event) : void
      {
         AlertManager.showSimpleAlarm("小侠士，你正在刺探军情，不能进行该操作。");
      }
   }
}

