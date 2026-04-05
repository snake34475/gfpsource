package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.LeftTimeFeather;
   import com.gfp.core.CommandID;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import org.taomee.net.SocketEvent;
   
   public class MapProcess_1104701 extends BaseMapProcess
   {
      
      private var _totalTime:int = 300000;
      
      private var _mapTimer:LeftTimeFeather;
      
      private var _maxHp:int;
      
      private var _hasDamaged:Boolean = false;
      
      public function MapProcess_1104701()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._mapTimer = new LeftTimeFeather(this._totalTime);
         this._maxHp = MainManager.actorInfo.hp;
         TextAlert.show("小侠士需要在5分钟内打败敌人!");
         SocketConnection.addCmdListener(CommandID.INFORM_USER_HPMP,this.onRevive);
      }
      
      private function onRevive(param1:SocketEvent) : void
      {
         if(MainManager.actorInfo.hp < this._maxHp && !this._hasDamaged)
         {
            this._hasDamaged = true;
         }
         if(MainManager.actorInfo.hp == this._maxHp && this._hasDamaged)
         {
            SocketConnection.removeCmdListener(CommandID.INFORM_USER_HPMP,this.onRevive);
            TextAlert.show("武圣爷爷为超灵侠士提供一次复活机会！");
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(this._mapTimer)
         {
            this._mapTimer.destroy();
         }
         SocketConnection.removeCmdListener(CommandID.INFORM_USER_HPMP,this.onRevive);
      }
   }
}

