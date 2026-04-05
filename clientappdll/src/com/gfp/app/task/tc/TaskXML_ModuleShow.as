package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.ui.events.UIEvent;
   
   public class TaskXML_ModuleShow extends TaskXML_Base
   {
      
      private var mNames:Array;
      
      public function TaskXML_ModuleShow()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         this.mNames = param3.split("|");
      }
      
      override protected function addListener() : void
      {
         ModuleManager.event.addEventListener(UIEvent.OPEN_MODULE,this.onOpenModule);
      }
      
      protected function onOpenModule(param1:UIEvent) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.mNames.length)
         {
            if(String(param1.data).indexOf(this.mNames[_loc2_]) != -1)
            {
               this.setComplete();
               break;
            }
            _loc2_++;
         }
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
         ModuleManager.event.removeEventListener(UIEvent.OPEN_MODULE,this.onOpenModule);
      }
      
      override public function get isComplete() : Boolean
      {
         return TasksManager.getTaskProStatus(_taskID,_proID) == TasksManager.STEP_COMPLETE;
      }
   }
}

