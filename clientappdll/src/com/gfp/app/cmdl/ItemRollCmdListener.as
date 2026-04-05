package com.gfp.app.cmdl
{
   import com.gfp.app.fight.RollItemPanel;
   import com.gfp.core.CommandID;
   import com.gfp.core.info.RollInfo;
   import com.gfp.core.net.SocketConnection;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   
   public class ItemRollCmdListener extends BaseBean
   {
      
      public function ItemRollCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.TEAM_HAVE_ROLL_ITEM,this.onHaveRollItem);
         finish();
      }
      
      private function onHaveRollItem(param1:SocketEvent) : void
      {
         var _loc2_:RollInfo = param1.data as RollInfo;
         RollItemPanel.instance.addRoll(_loc2_);
      }
   }
}

