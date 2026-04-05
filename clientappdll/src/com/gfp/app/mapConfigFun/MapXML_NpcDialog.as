package com.gfp.app.mapConfigFun
{
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.map.IMapConfigFun;
   import com.gfp.core.model.sensemodels.SightModel;
   
   public class MapXML_NpcDialog implements IMapConfigFun
   {
      
      public function MapXML_NpcDialog()
      {
         super();
      }
      
      public function exec(param1:SightModel, param2:XML, param3:XMLList) : void
      {
         NpcDialogController.showForNpc(uint(param2));
      }
   }
}

