package com.gfp.app.feature
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.CommandID;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.info.fight.FightAwardInfo;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.TextFormatUtil;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class NanBuGongFangZhanFeather
   {
      
      public static var getExp:int = 0;
      
      public var awardInfo:FightAwardInfo;
      
      public function NanBuGongFangZhanFeather()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         getExp = 0;
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         FightManager.instance.addEventListener(FightEvent.WINNER,this.onWinner);
         SocketConnection.addCmdListener(CommandID.STAGE_MONSTER_PRO_CHANGE,this.onStageProChange);
      }
      
      private function removeEvent() : void
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
         var _loc6_:uint = _loc2_.readUnsignedInt();
         TextAlert.show("第 " + TextFormatUtil.getRedText(_loc5_ + 1) + " 波怪物已经出现");
      }
      
      public function destroy() : void
      {
         this.removeEvent();
         this.awardInfo = null;
      }
      
      private function onWinner(param1:FightEvent) : void
      {
         this.awardInfo = param1.data as FightAwardInfo;
         getExp = 1;
      }
   }
}

