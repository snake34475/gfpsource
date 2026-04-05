package com.gfp.app.mapProcess
{
   import com.gfp.core.CommandID;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.MonsterHpAlertManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.ByteArrayUtil;
   import com.gfp.core.utils.TextFormatUtil;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class MapProcess_1091601 extends BaseMapProcess
   {
      
      private var _monsterID:uint = 11213;
      
      public function MapProcess_1091601()
      {
         super();
      }
      
      override protected function init() : void
      {
         MonsterHpAlertManager.instance.addMonster(this._monsterID,20);
         TasksManager.addActionListener(TaskActionEvent.TASK_MONSTERWANTED,this._monsterID.toString(),this.onKillMonsters);
         SocketConnection.addCmdListener(CommandID.ACTION_SKILL,this.onAction);
      }
      
      private function onAction(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:ByteArray = ByteArrayUtil.clone(_loc2_);
         var _loc4_:uint = _loc3_.readUnsignedInt();
         var _loc5_:uint = _loc3_.readUnsignedInt();
         var _loc6_:uint = _loc3_.readUnsignedInt();
         if(_loc6_ == 4120041)
         {
            TextAlert.show(TextFormatUtil.getRedText(AppLanguageDefine.NPC_DIALOG_MAP1091601[0]));
         }
      }
      
      private function onKillMonsters(param1:TaskActionEvent) : void
      {
         TextAlert.show(TextFormatUtil.getRedText(AppLanguageDefine.NPC_DIALOG_MAP1091601[1]));
      }
      
      override public function destroy() : void
      {
         MonsterHpAlertManager.instance.removeMonster(this._monsterID);
         TasksManager.removeActionListener(TaskActionEvent.TASK_MONSTERWANTED,this._monsterID.toString(),this.onKillMonsters);
         SocketConnection.removeCmdListener(CommandID.ACTION_SKILL,this.onAction);
         super.destroy();
      }
   }
}

