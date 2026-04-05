package com.gfp.app.mapConfigFun.single
{
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.model.sensemodels.SightModel;
   
   public class MapXML_TaskGoto_908 extends MapXML_TaskGotoBase
   {
      
      public function MapXML_TaskGoto_908()
      {
         super();
      }
      
      override public function exec(param1:SightModel, param2:XML, param3:XMLList) : void
      {
         PveEntry.enterTollgate(908);
      }
   }
}

