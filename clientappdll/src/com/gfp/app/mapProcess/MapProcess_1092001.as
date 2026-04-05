package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.utils.TimeUtil;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class MapProcess_1092001 extends BaseMapProcess
   {
      
      private var _timer:int;
      
      public function MapProcess_1092001()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this.checkIs4();
      }
      
      override public function destroy() : void
      {
         super.destroy();
         clearTimeout(this._timer);
      }
      
      private function checkIs4() : void
      {
         var _loc2_:Date = null;
         var _loc3_:Number = NaN;
         var _loc1_:Date = TimeUtil.getSeverDateObject();
         if(_loc1_.day == 4)
         {
            _loc2_ = new Date(_loc1_.fullYear,_loc1_.month,_loc1_.date,22,0,0);
            _loc3_ = _loc2_.time - _loc1_.time;
            if(_loc3_ > 0)
            {
               this._timer = setTimeout(this.onTimeCome,_loc3_);
            }
         }
      }
      
      private function onTimeCome() : void
      {
         clearTimeout(this._timer);
         FightManager.quit();
      }
   }
}

