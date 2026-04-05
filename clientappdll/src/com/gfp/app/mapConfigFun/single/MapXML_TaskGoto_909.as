package com.gfp.app.mapConfigFun.single
{
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.model.sensemodels.SightModel;
   
   public class MapXML_TaskGoto_909 extends MapXML_TaskGotoBase
   {
      
      public function MapXML_TaskGoto_909()
      {
         super();
      }
      
      override public function exec(param1:SightModel, param2:XML, param3:XMLList) : void
      {
         if(TasksManager.isCompleted(1255))
         {
            PveEntry.enterTollgate(909);
         }
      }
   }
}

