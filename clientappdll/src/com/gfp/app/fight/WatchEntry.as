package com.gfp.app.fight
{
   import com.gfp.app.manager.WatchFightManager;
   import com.gfp.app.manager.WatchFightTimerManager;
   import com.gfp.app.toolBar.FightToolBar;
   import com.gfp.app.toolBar.HeadSelfPanel;
   import com.gfp.core.CommandID;
   import com.gfp.core.buff.ActorOperateBuffManager;
   import com.gfp.core.controller.KeyController;
   import com.gfp.core.events.CommEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.info.fight.FightReadyInfo;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import org.taomee.manager.TaomeeManager;
   import org.taomee.net.SocketEvent;
   
   public class WatchEntry extends FightEntry
   {
      
      private static var _instance:WatchEntry;
      
      private var isEnterMap:Boolean;
      
      private var smallWindow:WatchFightSmallWindow;
      
      public function WatchEntry()
      {
         super();
      }
      
      public static function get instance() : WatchEntry
      {
         if(!_instance)
         {
            _instance = new WatchEntry();
         }
         return _instance;
      }
      
      public static function destroy() : void
      {
         if(_instance)
         {
            ActorOperateBuffManager.instance.operaterDisable = false;
            UserManager.filterActor = true;
            _instance.destroy();
            _instance = null;
         }
      }
      
      override public function setup(param1:FightReadyInfo) : void
      {
         _mapType = MapType.WATCH;
         super.setup(param1);
         _resLoader.loadPvP(_readyInfo.roles,_readyInfo.ogres);
         SocketConnection.addCmdListener(CommandID.PVP_AWARD,this.onPvpAward);
         SocketConnection.addCmdListener(CommandID.FIGHT_COUNT_DOWN,this.onCountDown);
         SocketConnection.addCmdListener(CommandID.WATCH_FIGHT_BEGIN,this.watchFightBeginHandler);
         SocketConnection.addCmdListener(CommandID.WATCH_FIGHT_END,this.watchFightEndHandler);
         WatchFightManager.ed.addEventListener(WatchFightManager.WATCH_FIGHT_LEAVE_EVENT,this.leaveHandler);
         WatchFightManager.instance.hidePanel();
      }
      
      override protected function onMapComplete(param1:MapEvent) : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_OPEN,this.onMapComplete);
         WatchFightTimerManager.instance.nextPackage();
      }
      
      private function onPvpAward(param1:SocketEvent) : void
      {
      }
      
      override protected function onBegin(param1:SocketEvent) : void
      {
         super.onBegin(param1);
         if(!this.isEnterMap)
         {
            this.enterWatchMap();
         }
         FightToolBar.instance.enabledSkillQuickKeys();
         KeyController.instance.clear();
      }
      
      override protected function fightInit() : void
      {
         super.fightInit();
         FightToolBar.instance.hide();
         MainManager.actorModel.hide();
         UserManager.filterActor = false;
         HeadSelfPanel.instance.hide();
         KeyController.instance.clear();
         ActorOperateBuffManager.instance.operaterDisable = true;
         this.smallWindow = new WatchFightSmallWindow();
         this.smallWindow.x = TaomeeManager.stageWidth - this.smallWindow.width;
         LayerManager.topLevel.addChild(this.smallWindow);
      }
      
      private function onCountDown(param1:SocketEvent) : void
      {
         this.isEnterMap = true;
         FightCountDown.play();
         this.enterWatchMap();
      }
      
      private function enterWatchMap() : void
      {
         resLoader.destroyPvpTransition();
         this.fightInit();
      }
      
      private function watchFightBeginHandler(param1:SocketEvent) : void
      {
         if(!this.isEnterMap)
         {
            TextAlert.show(AppLanguageDefine.WATCH_FIGHT_MSG[0]);
            this.leaveHandler();
         }
      }
      
      private function watchFightEndHandler(param1:SocketEvent) : void
      {
         TextAlert.show(AppLanguageDefine.WATCH_FIGHT_MSG[1]);
         this.leaveHandler();
      }
      
      private function leaveHandler(param1:CommEvent = null) : void
      {
         FightManager.pvpLevel = 0;
         FightGo.destroy();
         ActorOperateBuffManager.instance.clear();
         FightManager.destroy();
         SummonManager.updateActorSummonVisible();
         SummonManager.clearFightInfo();
         WatchFightManager.instance.saveFightData();
      }
      
      override public function destroy() : void
      {
         if(this.smallWindow)
         {
            this.smallWindow.destroy();
            LayerManager.topLevel.removeChild(this.smallWindow);
         }
         SocketConnection.removeCmdListener(CommandID.PVP_AWARD,this.onPvpAward);
         SocketConnection.removeCmdListener(CommandID.FIGHT_COUNT_DOWN,this.onCountDown);
         SocketConnection.removeCmdListener(CommandID.WATCH_FIGHT_BEGIN,this.watchFightBeginHandler);
         SocketConnection.removeCmdListener(CommandID.WATCH_FIGHT_END,this.watchFightEndHandler);
         WatchFightManager.ed.removeEventListener(WatchFightManager.WATCH_FIGHT_LEAVE_EVENT,this.leaveHandler);
         super.destroy();
         SinglePkManager.instance.destroy();
         KeyController.instance.init();
      }
   }
}

