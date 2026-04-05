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
   
   public class TaskXML_TowerPassed extends TaskXML_Base
   {
      
      private const TOWER_MAPS:Array = [1080101,1080102,1080103,1080104,1080105,1080106,1080107,1080108,1080109,1080110,1080111];
      
      private var _towerFloor:uint;
      
      public function TaskXML_TowerPassed()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:String = Logger.createLogMsgByArr(_params,param1,param2);
         Logger.info(this,_loc5_);
         this._towerFloor = int(param3);
      }
      
      override protected function addListener() : void
      {
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
      }
      
      private function onMapSwitchComplete(param1:MapEvent) : void
      {
         var _loc2_:MapModel = param1.mapModel;
         var _loc3_:uint = uint(_loc2_.info.id);
         var _loc4_:int = this.TOWER_MAPS.indexOf(_loc3_);
         if(_loc4_ != -1)
         {
            if(_loc4_ + 1 >= this._towerFloor)
            {
               TasksManager.taskProComplete(_taskID,_proID);
               this.uninit();
               TextAlert.show(this.getTaskProcName(_taskID,_proID) + " (完成)");
            }
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
      
      private function getTaskProcName(param1:uint, param2:uint) : String
      {
         return TasksXMLInfo.getProDoc(param1,param2);
      }
   }
}

