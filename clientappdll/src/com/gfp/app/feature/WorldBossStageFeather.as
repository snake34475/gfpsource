package com.gfp.app.feature
{
   import com.gfp.app.manager.WorldBossMananer;
   import com.gfp.app.ui.activity.WorldBossScorePanel;
   import com.gfp.core.manager.LayerManager;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import org.taomee.utils.DisplayUtil;
   
   public class WorldBossStageFeather
   {
      
      private var _rankPanel:WorldBossScorePanel;
      
      private var _rankTimer:int;
      
      public function WorldBossStageFeather()
      {
         super();
         this.init();
         this.startUpdating();
      }
      
      private function init() : void
      {
         this._rankPanel = new WorldBossScorePanel();
         this._rankPanel.x = 10;
         this._rankPanel.y = 120;
         this._rankPanel.requestData(WorldBossMananer.isMorning);
         LayerManager.topLevel.addChild(this._rankPanel);
      }
      
      private function startUpdating() : void
      {
         this._rankTimer = setInterval(this.requestRankData,20 * 1000);
      }
      
      private function requestRankData() : void
      {
         if(this._rankPanel)
         {
            this._rankPanel.requestData(WorldBossMananer.isMorning);
         }
      }
      
      public function destory() : void
      {
         if(this._rankPanel)
         {
            DisplayUtil.removeForParent(this._rankPanel);
            this._rankPanel.destory();
            this._rankPanel = null;
         }
         if(this._rankTimer != 0)
         {
            clearInterval(this._rankTimer);
            this._rankTimer = 0;
         }
      }
   }
}

