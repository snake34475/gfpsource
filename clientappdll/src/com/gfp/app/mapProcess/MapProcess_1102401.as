package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.LeftTimeFeather;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.MapManager;
   
   public class MapProcess_1102401 extends BaseMapProcess
   {
      
      private var _feather:LeftTimeFeather;
      
      public function MapProcess_1102401()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._feather = new LeftTimeFeather(60 * 0.5 * 1000);
         MapManager.addEventListener(MapEvent.USER_LEAVE_MAP,this.onPvpAward);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(this._feather)
         {
            this._feather.destroy();
            this._feather = null;
         }
         MapManager.removeEventListener(MapEvent.USER_LEAVE_MAP,this.onPvpAward);
      }
      
      private function onPvpAward(param1:MapEvent) : void
      {
         if(this._feather)
         {
            this._feather.destroy();
            this._feather = null;
         }
      }
   }
}

