package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.manager.GodGuardManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.ui.alert.TextAlert;
   import flash.events.Event;
   
   public class TaskXML_GodGuard extends TaskXML_Base
   {
      
      public function TaskXML_GodGuard()
      {
         super();
      }
      
      override protected function addListener() : void
      {
         GodGuardManager.instance.ed.addEventListener(GodGuardManager.GOD_GUARD_TIP_RESET,this.onGodGuardUpgrad);
      }
      
      protected function onGodGuardUpgrad(param1:Event) : void
      {
         this.setComplete();
      }
      
      private function setComplete() : void
      {
         TasksManager.taskProComplete(_taskID,_proID);
         TextAlert.show(this.getTaskProcName(_taskID,_proID) + " (完成)");
         this.uninit();
      }
      
      private function getTaskProcName(param1:uint, param2:uint) : String
      {
         return TasksXMLInfo.getProDoc(param1,param2);
      }
      
      override public function uninit() : void
      {
         GodGuardManager.instance.ed.removeEventListener(GodGuardManager.GOD_GUARD_TIP_RESET,this.onGodGuardUpgrad);
      }
      
      override public function get isComplete() : Boolean
      {
         return TasksManager.getTaskProStatus(_taskID,_proID) == TasksManager.STEP_COMPLETE;
      }
   }
}

