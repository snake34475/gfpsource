package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.LeftTimeFeather;
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.manager.PanelGValueManager;
   import com.gfp.core.events.DataEvent;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.map.BaseMapProcess;
   
   public class MapProcess_1102201 extends BaseMapProcess
   {
      
      private var _feather:LeftTimeFeather;
      
      public function MapProcess_1102201()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._feather = new LeftTimeFeather(60 * 3 * 1000,"能量值");
         PanelGValueManager.instance().addEventListener(DataEvent.DATA_UPDATE,this.onPowerChanged);
         FightManager.instance.addEventListener(FightEvent.QUITE,this.quitFight);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(this._feather)
         {
            this._feather.destroy();
            this._feather = null;
         }
         PanelGValueManager.instance().removeEventListener(DataEvent.DATA_UPDATE,this.onPowerChanged);
         FightManager.instance.removeEventListener(FightEvent.QUITE,this.quitFight);
      }
      
      private function onPowerChanged(param1:DataEvent) : void
      {
         if(this._feather)
         {
            this._feather.vue = int(param1.data);
         }
      }
      
      private function quitFight(param1:FightEvent) : void
      {
         AlertManager.showSimpleAlarm("小侠士经过这次挑战，获得了" + this._feather.vue.toString() + "点能量值。");
      }
   }
}

