package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.controller.KeyController;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.net.SocketConnection;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import org.taomee.net.SocketEvent;
   
   public class MapProcess_1051101 extends BaseMapProcess
   {
      
      private static var _monsterNum:int = 0;
      
      private var timeTotal:int = 60;
      
      private var _mainUI:Sprite;
      
      private var _timeTxt:TextField;
      
      private var _autoInvTimeID:int = 5;
      
      private var _mainUIMonsterSprite:Sprite;
      
      private var _monsterNumText:TextField;
      
      private var _tollgateID:int = 511;
      
      public function MapProcess_1051101(param1:int = 0, param2:int = 0)
      {
         super();
         if(param1 != 0)
         {
            this.timeTotal = param1;
         }
         if(param2 != 0)
         {
            this._tollgateID = param2;
         }
         this._mainUI = UIManager.getSprite("ToolBar_TopTime");
         this._timeTxt = this._mainUI["timeTxt"];
         this.starComputeTime();
         LayerManager.topLevel.addChild(this._mainUI);
         this._mainUI.x = 555;
         this._timeTxt.text = String(this.timeTotal) + "s";
         this._mainUIMonsterSprite = UIManager.getSprite("ToolBar_MonsterNum");
         this._monsterNumText = this._mainUIMonsterSprite["timeTxt"];
         LayerManager.topLevel.addChild(this._mainUIMonsterSprite);
         this._mainUIMonsterSprite.x = 280;
         this._monsterNumText.text = "0/100";
         TasksManager.addActionListener(TaskActionEvent.TASK_MONSTERWANTED,String(11662),this.onInnocentKill);
         TasksManager.addActionListener(TaskActionEvent.TASK_MONSTERWANTED,String(11663),this.onInnocentKill);
         TasksManager.addActionListener(TaskActionEvent.TASK_MONSTERWANTED,String(11665),this.onInnocentKill);
         MainManager.actorModel.addEventListener(UserEvent.DIE,this.onActorDie);
         SocketConnection.addCmdListener(CommandID.FIGHT_END,this.onEnd);
         SocketConnection.addCmdListener(CommandID.STAGE_MONSTER_PRO_CHANGE,this.onStageProChange);
         FightManager.isAutoReasonEnd = false;
      }
      
      private function onEnd(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         if(_loc4_ == 7)
         {
            AlertManager.showSimpleAlert("师叔的傀儡大阵岂是这么好破的，换个难度再试试吧！");
         }
         KeyController.instance.init();
      }
      
      private function onActorDie(param1:UserEvent) : void
      {
         ModuleManager.turnModule(ClientConfig.getAppModule("FightRevivePanel"),AppLanguageDefine.LOAD_MATTER_COLLECTION[1]);
      }
      
      private function onStageProChange(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         if(_loc3_ == this._tollgateID)
         {
            this.timeTotal = _loc5_;
         }
      }
      
      private function onInnocentKill(param1:TaskActionEvent) : void
      {
         ++_monsterNum;
         this._monsterNumText.text = String(_monsterNum) + "/100";
      }
      
      private function starComputeTime() : void
      {
         if(this.timeTotal > 0)
         {
            clearInterval(this._autoInvTimeID);
            this._autoInvTimeID = setInterval(this.changeTime,1000);
         }
      }
      
      private function changeTime() : void
      {
         --this.timeTotal;
         if(this.timeTotal < 0)
         {
            clearInterval(this._autoInvTimeID);
            this._timeTxt.text = "0s";
         }
         else
         {
            this._timeTxt.text = String(this.timeTotal) + "s";
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         LayerManager.topLevel.removeChild(this._mainUI);
         LayerManager.topLevel.removeChild(this._mainUIMonsterSprite);
         TasksManager.removeActionListener(TaskActionEvent.TASK_MONSTERWANTED,String(11662),this.onInnocentKill);
         TasksManager.removeActionListener(TaskActionEvent.TASK_MONSTERWANTED,String(11663),this.onInnocentKill);
         TasksManager.removeActionListener(TaskActionEvent.TASK_MONSTERWANTED,String(11665),this.onInnocentKill);
         SocketConnection.removeCmdListener(CommandID.STAGE_MONSTER_PRO_CHANGE,this.onStageProChange);
         MainManager.actorModel.removeEventListener(UserEvent.DIE,this.onActorDie);
         SocketConnection.removeCmdListener(CommandID.FIGHT_END,this.onEnd);
         clearInterval(this._autoInvTimeID);
         _monsterNum = 0;
         this.timeTotal = 0;
         this._mainUI = null;
         this._timeTxt = null;
         this._autoInvTimeID = 0;
         this._mainUIMonsterSprite = null;
         this._monsterNumText = null;
         this._tollgateID = 0;
      }
   }
}

