package com.gfp.app.cmdl
{
   import com.gfp.app.systems.WallowRemindChild;
   import com.gfp.app.toolBar.Battery;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.ClientType;
   import flash.utils.ByteArray;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   
   public class PreventAddictedListener extends BaseBean
   {
      
      public function PreventAddictedListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.PREVENT_ADDICTED,this.onPreventAddicted);
         finish();
      }
      
      private function onPreventAddicted(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         MainManager.olToday = _loc3_;
         Battery.instance.onTimeUpdate(true);
         if(MainManager.olToday == MainManager.battleTimeLimit && ClientConfig.clientType != ClientType.KAIXIN)
         {
            WallowRemindChild.instance.showFullTime();
         }
      }
   }
}

