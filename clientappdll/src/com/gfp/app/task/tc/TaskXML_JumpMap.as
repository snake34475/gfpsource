package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.Logger;
   
   public class TaskXML_JumpMap extends TaskXML_Base
   {
      
      private var _mapId:uint;
      
      private var _tran:String;
      
      public function TaskXML_JumpMap()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:String = Logger.createLogMsgByArr("TaskXML_JumpMap setup:",_params,param1,param2);
         Logger.info(this,_loc5_);
         var _loc6_:Array = _params.split("|");
         if(_loc6_.length == 1)
         {
            this._mapId = uint(_params);
         }
         else if(_loc6_.length == 2)
         {
            this._mapId = uint(_loc6_[0]);
            this._tran = _loc6_[1];
         }
      }
      
      override protected function addListener() : void
      {
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapComplete);
      }
      
      override public function uninit() : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapComplete);
      }
      
      private function onMapComplete(param1:MapEvent) : void
      {
         if(param1.mapModel.info.id == this._mapId)
         {
            TasksManager.taskProComplete(_taskID,_proID);
            TextAlert.show(this.getTaskProcName(_taskID,_proID) + " (完成)");
            this.uninit();
            if(this._tran)
            {
               CityMap.instance.tranChangeMapByStr(this._tran);
            }
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

