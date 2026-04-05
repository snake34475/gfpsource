package com.gfp.app.mapProcess
{
   import com.gfp.app.manager.FightPluginManager;
   import com.gfp.app.manager.fightPlugin.AutoFightManager;
   import com.gfp.app.manager.fightPlugin.AutoRecoverManager;
   import com.gfp.app.manager.fightPlugin.AutoTollgateTransManager;
   import com.gfp.app.toolBar.FightPluginEntry;
   import com.gfp.core.map.BaseMapProcess;
   
   public class LingXiaoAutoFightMapProcess extends BaseMapProcess
   {
      
      public function LingXiaoAutoFightMapProcess()
      {
         super();
      }
      
      override protected function init() : void
      {
         if(FightPluginEntry.instance.opentCloseBtn.currentFrame == 1)
         {
            return;
         }
         FightPluginManager.instance.isPluginRunning = true;
         AutoFightManager.instance.setup();
         AutoTollgateTransManager.instance.setup(false);
         AutoRecoverManager.instance.setup();
      }
      
      override public function destroy() : void
      {
         FightPluginManager.instance.isPluginRunning = false;
         FightPluginManager.instance.stop();
      }
   }
}

