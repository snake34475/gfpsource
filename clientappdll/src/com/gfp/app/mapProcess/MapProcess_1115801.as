package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.toolBar.FightToolBar;
   import com.gfp.core.buff.ActorOperateBuffManager;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.map.BaseMapProcess;
   
   public class MapProcess_1115801 extends BaseMapProcess
   {
      
      private var isQuite:Boolean = false;
      
      public function MapProcess_1115801()
      {
         super();
         MainManager.actorModel.visible = false;
         ActorOperateBuffManager.instance.operaterDisable = true;
         FightToolBar.instance.disabledSkillQuickKeys();
         FightManager.instance.addEventListener(FightEvent.QUITE,this.ifQuit);
      }
      
      override public function destroy() : void
      {
         if(!this.isQuite)
         {
            AlertManager.showSimpleAlarm("小侠士你获得了大！便！");
         }
         super.destroy();
         MainManager.actorModel.visible = true;
         FightToolBar.instance.enabledSkillQuickKeys();
         ActorOperateBuffManager.instance.operaterDisable = false;
         FightManager.instance.removeEventListener(FightEvent.QUITE,this.ifQuit);
      }
      
      private function ifQuit(param1:FightEvent) : void
      {
         this.isQuite = true;
      }
   }
}

