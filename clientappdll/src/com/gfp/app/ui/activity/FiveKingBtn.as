package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.core.CommandID;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.net.SocketConnection;
   import org.taomee.net.SocketEvent;
   
   public class FiveKingBtn extends BaseActivitySprite
   {
      
      public function FiveKingBtn(param1:ActivityNodeInfo)
      {
         super(param1);
         SocketConnection.addCmdListener(CommandID.SUMMON_POWERUP,this.onBackResultHandler);
      }
      
      override public function executeShow() : Boolean
      {
         if(SummonManager.getActorSummonInfoPreID(3851).length > 0)
         {
            return false;
         }
         return super.executeShow();
      }
      
      private function onBackResultHandler(param1:SocketEvent) : void
      {
         this.executeShow();
      }
   }
}

