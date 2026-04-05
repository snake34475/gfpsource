package com.gfp.app.feature
{
   import com.gfp.core.CommandID;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.TextFormatUtil;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class TakeHeroFeature
   {
      
      public function TakeHeroFeature()
      {
         super();
      }
      
      public function setup() : void
      {
         this.initModels();
         this.addEvent();
      }
      
      private function initModels() : void
      {
      }
      
      public function destory() : void
      {
         this.removeEvent();
      }
      
      public function addEvent() : void
      {
         SocketConnection.addCmdListener(CommandID.STAGE_MONSTER_PRO_CHANGE,this.onStageProChange);
      }
      
      public function removeEvent() : void
      {
         SocketConnection.removeCmdListener(CommandID.STAGE_MONSTER_PRO_CHANGE,this.onStageProChange);
      }
      
      private function onStageProChange(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         var _loc6_:uint = _loc2_.readUnsignedInt();
         TextAlert.show("第 " + TextFormatUtil.getRedText(_loc5_ + 1) + " 波怪物已经出现，请小侠士做好准备。");
      }
   }
}

