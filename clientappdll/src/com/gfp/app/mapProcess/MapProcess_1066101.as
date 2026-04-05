package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import flash.utils.setTimeout;
   import org.taomee.net.SocketEvent;
   
   public class MapProcess_1066101 extends BaseMapProcess
   {
      
      private static const NUM_STRING:Array = ["一","二","三","四","五","六","七","八","九","十"];
      
      private var isWinner:Boolean = false;
      
      private var monster_num:int = 0;
      
      private const _monsterNotKill:uint = 11624;
      
      public function MapProcess_1066101()
      {
         super();
         MainManager.actorModel.addEventListener(UserEvent.DIE,this.onActorDie);
         FightManager.instance.addEventListener(FightEvent.WINNER,this.onWinner);
         SocketConnection.addCmdListener(CommandID.STAGE_MONSTER_PRO_CHANGE,this.onStageProChange);
         TasksManager.addActionListener(TaskActionEvent.TASK_MONSTERWANTED,this._monsterNotKill.toString(),this.onInnocentKill);
      }
      
      override protected function init() : void
      {
         this.checkTaskStatus();
      }
      
      private function checkTaskStatus() : void
      {
         FightManager.isAutoWinnerEnd = false;
         FightManager.isAutoReasonEnd = false;
         FightManager.outToMapID = 7;
      }
      
      private function onInnocentKill(param1:TaskActionEvent) : void
      {
         ++this.monster_num;
         if(this.monster_num == 12)
         {
            this.isWinner = true;
         }
      }
      
      private function onActorDie(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         if(!this.isWinner)
         {
            if(_loc2_.info.userID == MainManager.actorID)
            {
               ModuleManager.turnModule(ClientConfig.getAppModule("FightRevivePanel"),AppLanguageDefine.LOAD_MATTER_COLLECTION[1]);
            }
         }
      }
      
      private function onWinner(param1:FightEvent) : void
      {
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onWinner);
         FightManager.outToMapID = 7;
         if(this.isWinner)
         {
            setTimeout(this.quit,3000);
         }
      }
      
      private function quit() : void
      {
         FightManager.quit();
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_TOLLGATE_PASSED,String(661));
         CityMap.instance.changeMap(7,0,1,new Point(708,400));
      }
      
      private function onStageProChange(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         if(_loc3_ == 661)
         {
            TextAlert.show(NUM_STRING[_loc5_] + "面埋伏即将发动攻击");
         }
      }
      
      override public function destroy() : void
      {
         SocketConnection.removeCmdListener(CommandID.STAGE_MONSTER_PRO_CHANGE,this.onStageProChange);
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onWinner);
         TasksManager.removeActionListener(TaskActionEvent.TASK_MONSTERWANTED,this._monsterNotKill.toString(),this.onInnocentKill);
         MainManager.actorModel.removeEventListener(UserEvent.DIE,this.onActorDie);
      }
   }
}

