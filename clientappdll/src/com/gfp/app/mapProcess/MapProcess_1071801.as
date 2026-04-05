package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.CommandID;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class MapProcess_1071801 extends BaseMapProcess
   {
      
      public function MapProcess_1071801()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.addMapListener();
      }
      
      private function onWinner(param1:FightEvent) : void
      {
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onWinner);
      }
      
      private function addMapListener() : void
      {
         FightManager.instance.addEventListener(FightEvent.WINNER,this.onWinner);
         SocketConnection.addCmdListener(CommandID.STAGE_MONSTER_PRO_CHANGE,this.onStageProChange);
      }
      
      private function removeMapListener() : void
      {
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onWinner);
         SocketConnection.removeCmdListener(CommandID.STAGE_MONSTER_PRO_CHANGE,this.onStageProChange);
      }
      
      private function onStageProChange(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         if(_loc3_ == 718)
         {
            TextAlert.show("第" + (_loc5_ + 1) + "波怪物5秒后来袭，请保护神灯");
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.removeMapListener();
      }
   }
}

