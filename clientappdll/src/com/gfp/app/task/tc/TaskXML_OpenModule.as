package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.ui.events.UIEvent;
   import com.gfp.core.utils.Logger;
   
   public class TaskXML_OpenModule extends TaskXML_Base
   {
      
      private var moduleName:String;
      
      private var data:String;
      
      public function TaskXML_OpenModule()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:Array = param3.split(",");
         if(_loc5_.length == 2)
         {
            this.moduleName = _loc5_[0];
            this.data = _loc5_[1];
         }
         else
         {
            this.moduleName = param3;
         }
         var _loc6_:String = Logger.createLogMsgByArr("TaskXML_OpenModule setup:",_params,param1,param2);
         Logger.info(this,_loc6_);
      }
      
      override protected function addListener() : void
      {
         ModuleManager.event.addEventListener(UIEvent.CLOSE_MODULE,this.onCloseModule);
      }
      
      override public function init(param1:Boolean) : void
      {
         super.init(param1);
         if(this.data)
         {
            ModuleManager.turnAppModule(this.moduleName,"正在加载...",this.data);
         }
         else
         {
            ModuleManager.turnAppModule(this.moduleName);
         }
      }
      
      private function onCloseModule(param1:UIEvent) : void
      {
         if(_taskID == 1158)
         {
            return;
         }
         if(String(param1.data).indexOf(this.moduleName) != -1)
         {
            TasksManager.taskProComplete(_taskID,_proID);
            TextAlert.show(this.getTaskProcName(_taskID,_proID) + " (完成)");
            uninit();
         }
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

