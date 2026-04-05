package com.gfp.app.mapProcess
{
   import com.gfp.app.control.SystemTimeController;
   import com.gfp.app.feature.LeftTimeUI;
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.map.BaseMapProcess;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1124801 extends BaseMapProcess
   {
      
      private static const QUARTER:int = 199;
      
      private static const QUARTER_REST:int = 200;
      
      private static const SEMI:int = 201;
      
      private static const SEMI_REST:int = 202;
      
      private static const FINAL:int = 203;
      
      private var _leftTimeUI:LeftTimeUI;
      
      public function MapProcess_1124801()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._leftTimeUI = new LeftTimeUI(180000);
         LayerManager.topLevel.addChild(this._leftTimeUI);
         this._leftTimeUI.x = LayerManager.stageWidth / 2;
         this._leftTimeUI.y = 150;
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         FightManager.instance.addEventListener(FightEvent.WINNER,this.onFightWinner);
         FightManager.instance.addEventListener(FightEvent.REASON,this.onFightFail);
      }
      
      private function removeEvent() : void
      {
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onFightWinner);
         FightManager.instance.removeEventListener(FightEvent.REASON,this.onFightFail);
      }
      
      private function onFightWinner(param1:FightEvent) : void
      {
         if(SystemTimeController.instance.checkSysTimeAchieve(QUARTER) || SystemTimeController.instance.checkSysTimeAchieve(QUARTER_REST))
         {
            AlertManager.showSimpleAlarm("恭喜你晋级半决赛，比赛将在13:45开启哦~");
            return;
         }
         if(SystemTimeController.instance.checkSysTimeAchieve(SEMI) || SystemTimeController.instance.checkSysTimeAchieve(SEMI_REST))
         {
            AlertManager.showSimpleAlarm("恭喜你晋级决赛，比赛将在14:00开启哦~");
            return;
         }
         AlertManager.showSimpleAlarm("恭喜你成为本次霸王赛冠军，获得丰厚冠军奖励。");
      }
      
      private function onFightFail(param1:FightEvent) : void
      {
         AlertManager.showSimpleAlarm("你遇到了一个高富帅，不幸落败，请再接再厉。");
      }
      
      override public function destroy() : void
      {
         this.removeEvent();
         if(this._leftTimeUI)
         {
            this._leftTimeUI.destory();
            DisplayUtil.removeForParent(this._leftTimeUI);
         }
         super.destroy();
      }
   }
}

