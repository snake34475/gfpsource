package com.gfp.app.mapConfigFun
{
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.IMapConfigFun;
   import com.gfp.core.model.sensemodels.SightModel;
   
   public class MapXML_MapCollection implements IMapConfigFun
   {
      
      public function MapXML_MapCollection()
      {
         super();
      }
      
      public function exec(param1:SightModel, param2:XML, param3:XMLList) : void
      {
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_MAPCOLLECT,param2.toString());
      }
   }
}

