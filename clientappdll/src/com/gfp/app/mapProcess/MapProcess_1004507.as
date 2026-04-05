package com.gfp.app.mapProcess
{
   import com.gfp.core.CommandID;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.sensemodels.SightModel;
   import com.gfp.core.net.SocketConnection;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class MapProcess_1004507 extends BaseMapProcess
   {
      
      private var _waterModel:SightModel;
      
      private var _dryModel:SightModel;
      
      public function MapProcess_1004507()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.initSightModel();
         this.addEventLister();
      }
      
      private function initSightModel() : void
      {
         this._waterModel = SightManager.getSightModel(19128);
         this._dryModel = SightManager.getSightModel(19129);
         this._dryModel.hide();
      }
      
      private function addEventLister() : void
      {
         SocketConnection.addCmdListener(CommandID.STAGE_MONSTER_PRO_CHANGE,this.onWaterPipeChange);
      }
      
      private function removeEventListener() : void
      {
         SocketConnection.removeCmdListener(CommandID.STAGE_MONSTER_PRO_CHANGE,this.onWaterPipeChange);
      }
      
      private function onWaterPipeChange(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         if(_loc3_ == 45 && _loc4_ == 1004507)
         {
            if(_loc5_ == 1)
            {
               this._waterModel.hide();
               this._dryModel.show();
            }
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.removeEventListener();
      }
   }
}

