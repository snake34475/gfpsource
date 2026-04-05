package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.LeftTimeFeather;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.ui.alert.TextAlert;
   
   public class MapProcess_1106101 extends BaseMapProcess
   {
      
      private var _totalTime:int = 300000;
      
      private var _mapTimer:LeftTimeFeather;
      
      public function MapProcess_1106101()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._mapTimer = new LeftTimeFeather(this._totalTime);
         TextAlert.show("小侠士需要在5分钟内打败敌人!");
         TextAlert.show("暗黑之卵会在2分钟后重新孵化为暗黑凤凰!");
         TextAlert.show("小侠士站在中间回血法阵可获得HP恢复效果!");
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(this._mapTimer)
         {
            this._mapTimer.destroy();
         }
      }
   }
}

