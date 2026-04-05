package com.gfp.app.feature
{
   import com.gfp.core.CommandID;
   import com.gfp.core.net.SocketConnection;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class SimpleEnterStageFeather
   {
      
      private var _stageId:int;
      
      private var _diff:int;
      
      public function SimpleEnterStageFeather()
      {
         super();
      }
      
      public function enter(param1:int, param2:int = 1) : void
      {
         this._stageId = param1;
         this._diff = param2;
         SocketConnection.addCmdListener(CommandID.STAGE_ENTRY,this.onEntryStage);
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeUnsignedInt(this._stageId);
         _loc3_.writeByte(this._diff);
         _loc3_.writeUnsignedInt(0);
         _loc3_.writeUnsignedInt(0);
         _loc3_.writeUnsignedInt(0);
         _loc3_.writeUnsignedInt(0);
         SocketConnection.send(CommandID.STAGE_ENTRY,_loc3_);
      }
      
      public function destory() : void
      {
         SocketConnection.removeCmdListener(CommandID.STAGE_ENTRY,this.onEntryStage);
      }
      
      private function onEntryStage(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.STAGE_ENTRY,this.onEntryStage);
         SocketConnection.send(CommandID.FIGHT_READY_COMPLETE);
      }
   }
}

