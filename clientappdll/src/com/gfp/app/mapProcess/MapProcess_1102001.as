package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.LeftTimeFeather;
   import com.gfp.core.CommandID;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.net.SocketConnection;
   import org.taomee.net.SocketEvent;
   
   public class MapProcess_1102001 extends BaseMapProcess
   {
      
      private var _feather:LeftTimeFeather;
      
      public function MapProcess_1102001()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._feather = new LeftTimeFeather(60 * 2 * 1000);
         SocketConnection.addCmdListener(CommandID.PVP_AWARD,this.onPvpAward);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(this._feather)
         {
            this._feather.destroy();
            this._feather = null;
         }
         SocketConnection.removeCmdListener(CommandID.PVP_AWARD,this.onPvpAward);
      }
      
      private function onPvpAward(param1:SocketEvent) : void
      {
         if(this._feather)
         {
            this._feather.destroy();
            this._feather = null;
         }
      }
   }
}

