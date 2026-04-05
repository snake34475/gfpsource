package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.Logger;
   
   public class TaskXML_TalkToNPC extends TaskXML_Base
   {
      
      private var _hasCompleteAlertStep:int = 0;
      
      public function TaskXML_TalkToNPC()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:String = Logger.createLogMsgByArr(_params,param1,param2);
         Logger.info(this,_loc5_);
      }
      
      private function onTalkToTaskNPC(param1:TaskActionEvent) : void
      {
         TasksManager.taskProComplete(_taskID,_proID);
         if(this._hasCompleteAlertStep == 1)
         {
            this._hasCompleteAlertStep = 2;
            TextAlert.show(this.getTaskProcName(_taskID,_proID) + " (完成)");
            CityMap.instance.tranChangeMapByStr(_params);
            ModuleManager.hideModule("TaskBookPanel");
         }
         this.uninit();
      }
      
      override public function autoExec() : void
      {
         if(MapManager.currentMap == null || MapManager.currentMap.info == null || MapManager.currentMap.info.mapType == MapType.PVE)
         {
            MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onSwitchComplete);
         }
         else
         {
            super.autoExec();
         }
      }
      
      private function onSwitchComplete(param1:MapEvent) : void
      {
         if(param1.mapModel.info.mapType == MapType.STAND)
         {
            MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onSwitchComplete);
            this.autoExec();
         }
      }
      
      override protected function addListener() : void
      {
         if(this._hasCompleteAlertStep == 0)
         {
            this._hasCompleteAlertStep = 1;
         }
         TasksManager.addActionListener(TaskActionEvent.TASK_TALKTO,_params,this.onTalkToTaskNPC);
      }
      
      override public function uninit() : void
      {
         TasksManager.removeActionListener(TaskActionEvent.TASK_TALKTO,_params,this.onTalkToTaskNPC);
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onSwitchComplete);
      }
      
      override public function get isComplete() : Boolean
      {
         if(TasksManager.getTaskProStatus(_taskID,_proID) == TasksManager.STEP_COMPLETE)
         {
            if(this._hasCompleteAlertStep == 1)
            {
               this._hasCompleteAlertStep = 2;
               this.taskProComplete();
               this.transferToSomePlace();
            }
            return true;
         }
         return false;
      }
      
      protected function taskProComplete() : void
      {
         TasksManager.taskProComplete(_taskID,_proID);
         TextAlert.show(this.getTaskProcName(_taskID,_proID) + " (完成)");
         ModuleManager.hideModule(ClientConfig.getAppModule("TaskBookPanel"));
      }
      
      protected function transferToSomePlace() : void
      {
         if(this._params)
         {
            CityMap.instance.tranChangeMapByStr(this._params);
         }
      }
      
      private function getTaskProcName(param1:uint, param2:uint) : String
      {
         return TasksXMLInfo.getProDoc(param1,param2);
      }
   }
}

