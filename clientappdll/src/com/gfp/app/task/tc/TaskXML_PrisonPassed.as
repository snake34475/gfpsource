package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.MapModel;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.Logger;
   
   public class TaskXML_PrisonPassed extends TaskXML_Base
   {
      
      private const BASE_MAP:uint = 1080601;
      
      private var _prisonFloor:int;
      
      public function TaskXML_PrisonPassed()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:String = Logger.createLogMsgByArr(_params,param1,param2);
         Logger.info(this,_loc5_);
         this._prisonFloor = int(param3);
      }
      
      override protected function addListener() : void
      {
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
      }
      
      private function onMapSwitchComplete(param1:MapEvent) : void
      {
         var _loc2_:MapModel = param1.mapModel;
         var _loc3_:uint = uint(_loc2_.info.id);
         var _loc4_:int = _loc3_ - this.BASE_MAP + 1;
         if(_loc4_ > this._prisonFloor && _loc4_ <= 7)
         {
            TasksManager.taskProComplete(_taskID,_proID);
            this.uninit();
            TextAlert.show(TasksXMLInfo.getProDoc(_taskID,_proID) + " (完成)");
         }
      }
      
      override public function uninit() : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
      }
      
      override public function get isComplete() : Boolean
      {
         return TasksManager.getTaskProStatus(_taskID,_proID) == TasksManager.STEP_COMPLETE;
      }
   }
}

