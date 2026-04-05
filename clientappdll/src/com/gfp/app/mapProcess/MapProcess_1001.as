package com.gfp.app.mapProcess
{
   import com.gfp.app.cartoon.AnimatHeadString;
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.systems.ClientTempState;
   import com.gfp.core.CommandID;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.sensemodels.SightModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.ActivityType;
   import flash.display.MovieClip;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class MapProcess_1001 extends BaseMapProcess
   {
      
      private var _chainList:Array = [];
      
      public function MapProcess_1001()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.addMapEvent();
         this.requestMapInfo();
         this.initSightModel(1);
         this.playAnimat();
      }
      
      private function playAnimat() : void
      {
         if(!ClientTempState.isNineChainAnimatPlayed)
         {
            AnimatPlay.startAnimat(AnimatHeadString.SCENCE,60);
            ClientTempState.isNineChainAnimatPlayed = true;
         }
      }
      
      private function initSightModel(param1:uint = 0) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:SightModel = null;
         var _loc2_:uint = 1;
         while(_loc2_ <= 9)
         {
            _loc3_ = _mapModel.downLevel["chainMC_" + _loc2_];
            _loc4_ = SightManager.getSightModel(_loc2_);
            if(_loc4_)
            {
               if(_loc2_ <= param1)
               {
                  _loc3_.gotoAndStop(_loc3_.totalFrames - 1);
                  if(_loc2_ == param1)
                  {
                     _loc4_.show();
                  }
                  else
                  {
                     _loc4_.hide();
                  }
               }
               else
               {
                  _loc3_.gotoAndStop(1);
                  _loc4_.hide();
               }
            }
            _loc2_++;
         }
      }
      
      private function addMapEvent() : void
      {
         SocketConnection.addCmdListener(CommandID.ACTIVITY_INFO,this.onGetActivityInfo);
      }
      
      private function removeMapEvent() : void
      {
         SocketConnection.removeCmdListener(CommandID.ACTIVITY_INFO,this.onGetActivityInfo);
      }
      
      private function onGetActivityInfo(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         this.initSightModel(_loc4_ + 1);
      }
      
      private function requestMapInfo() : void
      {
         SocketConnection.send(CommandID.ACTIVITY_INFO,ActivityType.NINE_CHAINS);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.removeMapEvent();
      }
   }
}

