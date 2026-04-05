package com.gfp.app.mapProcess
{
   import com.gfp.core.CommandID;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.MonsterHpAlertManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.TextFormatUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.net.SocketEvent;
   
   public class MapProcess_1091801 extends BaseMapProcess
   {
      
      private const _monsterNotKill:uint = 13054;
      
      private const _timeDownAlertTxt:String = AppLanguageDefine.NPC_DIALOG_MAP1091801[0];
      
      private var _alertTxtList:Array;
      
      private var _timeArray:Array;
      
      private var _monsterArray:Array;
      
      private var _currentStage:uint;
      
      private var _fightFlag:Boolean;
      
      private var _protected:Boolean;
      
      private var _donkeyMC:MovieClip;
      
      private var _warnTxt:Sprite;
      
      private var _timeOutID:uint;
      
      public function MapProcess_1091801()
      {
         super();
      }
      
      override protected function init() : void
      {
         MonsterHpAlertManager.instance.addMonster(this._monsterNotKill,20);
         this.initAlertArray();
         this._currentStage = 0;
         this._fightFlag = false;
         this._protected = true;
         TasksManager.addActionListener(TaskActionEvent.TASK_MONSTERWANTED,this._monsterNotKill.toString(),this.onBookKill);
         this.initEventListener();
         this._donkeyMC = MapManager.currentMap.contentLevel["donkeyMC"];
         this._warnTxt = MapManager.currentMap.contentLevel["warnTxt"];
         this._warnTxt.visible = false;
         this.showTxt();
      }
      
      private function initAlertArray() : void
      {
         this._alertTxtList = new Array();
         this._alertTxtList.push(AppLanguageDefine.NPC_DIALOG_MAP1091801[1],AppLanguageDefine.NPC_DIALOG_MAP1091801[2],AppLanguageDefine.NPC_DIALOG_MAP1091801[1],AppLanguageDefine.NPC_DIALOG_MAP1091801[2],AppLanguageDefine.NPC_DIALOG_MAP1091801[1],AppLanguageDefine.NPC_DIALOG_MAP1091801[2]);
         this._alertTxtList.push(AppLanguageDefine.NPC_DIALOG_MAP1091801[3],AppLanguageDefine.NPC_DIALOG_MAP1091801[1],AppLanguageDefine.NPC_DIALOG_MAP1091801[2],AppLanguageDefine.NPC_DIALOG_MAP1091801[1],AppLanguageDefine.NPC_DIALOG_MAP1091801[2],AppLanguageDefine.NPC_DIALOG_MAP1091801[3]);
         this._alertTxtList.push(AppLanguageDefine.NPC_DIALOG_MAP1091801[4]);
         this._timeArray = [10,10,10,10,10,10,10,10,10,10,10,10,10];
         this._monsterArray = [11240,11242,11240,11242,11240,11242,11241,11240,11242,11240,11242,11241,13055];
         TasksManager.addListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
      }
      
      private function initEventListener() : void
      {
         SocketConnection.addCmdListener(CommandID.FIGHT_MONSTER_BORN,this.onMonsterBorn);
      }
      
      private function onMonsterBorn(param1:SocketEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(!this._fightFlag)
         {
            this._fightFlag = true;
            this.showTxt();
            _loc2_ = uint(this._monsterArray[this._currentStage]);
            if(this._currentStage != 0)
            {
               _loc3_ = uint(this._monsterArray[this._currentStage - 1]);
               TasksManager.removeActionListener(TaskActionEvent.TASK_MONSTERWANTED,_loc2_.toString(),this.onMonsterKill);
            }
            TasksManager.addActionListener(TaskActionEvent.TASK_MONSTERWANTED,_loc2_.toString(),this.onMonsterKill);
         }
      }
      
      private function onMonsterKill(param1:TaskActionEvent) : void
      {
         this.checkMapEmpty();
      }
      
      private function checkMapEmpty() : void
      {
         var _loc1_:Array = UserManager.getModels();
         var _loc2_:uint = _loc1_.length;
         if(_loc2_ == 2 && this._protected || _loc2_ == 1 && !this._protected)
         {
            this._fightFlag = false;
            ++this._currentStage;
            this.showTxt();
         }
      }
      
      private function showTxt() : void
      {
         var _loc1_:String = null;
         var _loc3_:uint = 0;
         if(this._fightFlag)
         {
            _loc1_ = this._alertTxtList[this._currentStage];
         }
         else
         {
            _loc1_ = this._timeDownAlertTxt + 10 + AppLanguageDefine.SPECIAL_CHARACTER[2];
         }
         TextAlert.show(TextFormatUtil.getRedText(_loc1_));
         var _loc2_:uint = Math.round(Math.random()) + 2;
         this._donkeyMC.gotoAndStop(_loc2_);
         this._warnTxt["warnTxt"].text = _loc1_;
         this._warnTxt.visible = true;
         clearTimeout(this._timeOutID);
         this._timeOutID = setTimeout(this.hideTxt,3000);
         if(this._fightFlag)
         {
            _loc3_ = 12 - this._currentStage;
            if(_loc3_ != 0)
            {
               _loc1_ = AppLanguageDefine.NPC_DIALOG_MAP1091801[5] + _loc3_ + AppLanguageDefine.SPECIAL_CHARACTER[3];
            }
            TextAlert.show(TextFormatUtil.getRedText(_loc1_));
         }
      }
      
      private function hideTxt() : void
      {
         if(this._warnTxt)
         {
            this._warnTxt.visible = false;
         }
      }
      
      private function onTaskProComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 1311 && param1.proID == 0)
         {
            TextAlert.show(TextFormatUtil.getRedText(AppLanguageDefine.NPC_DIALOG_MAP1091801[6]) + AppLanguageDefine.NPC_DIALOG_MAP1091801[7]);
         }
      }
      
      private function onBookKill(param1:TaskActionEvent) : void
      {
         if(TasksManager.isProcess(1311,1))
         {
            TextAlert.show(TextFormatUtil.getRedText(AppLanguageDefine.NPC_DIALOG_MAP1091801[8]));
         }
         this._protected = false;
         var _loc2_:uint = Math.round(Math.random()) + 2;
         this._donkeyMC.gotoAndStop(_loc2_);
         this._warnTxt["warnTxt"].text = AppLanguageDefine.NPC_DIALOG_MAP1091801[8];
         this._warnTxt.visible = true;
         clearTimeout(this._timeOutID);
         this._timeOutID = setTimeout(this.hideTxt,3000);
      }
      
      override public function destroy() : void
      {
         SocketConnection.removeCmdListener(CommandID.FIGHT_MONSTER_BORN,this.onMonsterBorn);
         TasksManager.removeActionListener(TaskActionEvent.TASK_MONSTERWANTED,this._monsterNotKill.toString(),this.onBookKill);
         var _loc1_:uint = 11240;
         TasksManager.removeActionListener(TaskActionEvent.TASK_MONSTERWANTED,_loc1_.toString(),this.onMonsterKill);
         _loc1_ = 11242;
         TasksManager.removeActionListener(TaskActionEvent.TASK_MONSTERWANTED,_loc1_.toString(),this.onMonsterKill);
         _loc1_ = 11241;
         TasksManager.removeActionListener(TaskActionEvent.TASK_MONSTERWANTED,_loc1_.toString(),this.onMonsterKill);
         _loc1_ = 13055;
         TasksManager.removeActionListener(TaskActionEvent.TASK_MONSTERWANTED,_loc1_.toString(),this.onMonsterKill);
         TasksManager.removeListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
         this._donkeyMC = null;
         this._warnTxt = null;
         clearTimeout(this._timeOutID);
         MonsterHpAlertManager.instance.removeMonster(this._monsterNotKill);
         super.destroy();
      }
   }
}

