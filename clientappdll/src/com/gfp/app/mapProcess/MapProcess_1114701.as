package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.CommandID;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.MagicChangeManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   
   public class MapProcess_1114701 extends BaseMapProcess
   {
      
      private var _rankType:Vector.<int> = new <int>[142,143,144,145,146,147,148,192];
      
      public function MapProcess_1114701()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         MagicChangeManager.instance.installBlockFilter(this.magicFilter);
         this.addEvent();
      }
      
      private function magicFilter() : Boolean
      {
         TextAlert.show("当前关卡不允许变身哦！",16711680);
         return true;
      }
      
      private function addEvent() : void
      {
         FightManager.instance.addEventListener(FightEvent.WINNER,this.onFightWinner);
      }
      
      private function removeEvent() : void
      {
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onFightWinner);
      }
      
      private function onFightWinner(param1:FightEvent) : void
      {
         SocketConnection.send(CommandID.SINGLE_ACTIVITY_RANK,this._rankType[MainManager.actorInfo.roleType - 1],0,1);
         AlertManager.showSimpleAlarm("恭喜小侠士赢得了此次比赛，获胜次数 + 1。");
      }
      
      private function onFightFail(param1:FightEvent) : void
      {
      }
      
      override public function destroy() : void
      {
         MagicChangeManager.instance.uninstallBlockFilter(this.magicFilter);
         this.removeEvent();
         super.destroy();
      }
   }
}

