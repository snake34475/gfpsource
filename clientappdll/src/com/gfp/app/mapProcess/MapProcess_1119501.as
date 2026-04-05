package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.LeftTimeTxtFeater;
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.manager.FightPluginManager;
   import com.gfp.app.manager.fightPlugin.AutoFightManager;
   import com.gfp.app.manager.fightPlugin.AutoRecoverManager;
   import com.gfp.app.manager.fightPlugin.AutoTollgateTransManager;
   import com.gfp.core.CommandID;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1119501 extends BaseMapProcess
   {
      
      private var _killNum:int = 0;
      
      private var _txtInfoMc:MovieClip;
      
      private var _grassTotal:int = 0;
      
      private var _feather:LeftTimeTxtFeater;
      
      public function MapProcess_1119501()
      {
         super();
      }
      
      override protected function init() : void
      {
         FightPluginManager.instance.isPluginRunning = true;
         AutoFightManager.instance.setup();
         AutoTollgateTransManager.instance.setup(false);
         AutoRecoverManager.instance.setup();
         SocketConnection.addCmdListener(CommandID.FIGHT_END,this.onEnd);
         this._txtInfoMc = _mapModel.libManager.getMovieClip("UI_TxtInfo");
         this._feather = new LeftTimeTxtFeater(1 * 60 * 1000,this._txtInfoMc["timeTxt"] as TextField,null);
         this._feather.start();
         FightManager.instance.addEventListener(FightEvent.OGRE_DIE,this.onModelDied);
         StageResizeController.instance.register(this.resizePos);
         UserManager.addEventListener(UserEvent.BORN,this.onBossBorn);
         this.resizePos();
      }
      
      private function onBossBorn(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         if(_loc2_.info.roleType == 14562)
         {
            ++this._grassTotal;
         }
         this._txtInfoMc.sumBornTxt.text = this._grassTotal * 2;
         this._txtInfoMc.bornGrassTxt.text = this._grassTotal.toString();
      }
      
      private function resizePos() : void
      {
         this._txtInfoMc.x = LayerManager.stageWidth - this._txtInfoMc.width >> 1;
         this._txtInfoMc.y = 165;
         LayerManager.topLevel.addChild(this._txtInfoMc);
      }
      
      private function onModelDied(param1:FightEvent) : void
      {
         if(param1.data.roleType == 14562)
         {
            --this._grassTotal;
            this._txtInfoMc.bornGrassTxt.text = this._grassTotal.toString();
         }
         this._txtInfoMc.sumBornTxt.text = this._grassTotal * 2;
      }
      
      protected function onEnd(param1:SocketEvent) : void
      {
         FightPluginManager.instance.isPluginRunning = false;
         FightPluginManager.instance.stop();
         AlertManager.showSimpleAlarm("本次获得了" + (this._grassTotal * 2).toString() + "点仙兽成长！");
      }
      
      override public function destroy() : void
      {
         if(this._feather)
         {
            this._feather.destroy();
            this._feather = null;
         }
         UserManager.removeEventListener(UserEvent.BORN,this.onBossBorn);
         SocketConnection.removeCmdListener(CommandID.FIGHT_END,this.onEnd);
         FightPluginManager.instance.isPluginRunning = false;
         FightPluginManager.instance.stop();
         this._killNum = 0;
         DisplayUtil.removeForParent(this._txtInfoMc);
         this._txtInfoMc = null;
         FightManager.instance.removeEventListener(FightEvent.OGRE_DIE,this.onModelDied);
         StageResizeController.instance.unregister(this.resizePos);
         super.destroy();
      }
   }
}

