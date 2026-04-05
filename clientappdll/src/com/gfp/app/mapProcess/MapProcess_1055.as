package com.gfp.app.mapProcess
{
   import com.gfp.app.toolBar.TimeCountDown;
   import com.gfp.core.events.DataEvent;
   import com.gfp.core.events.UserItemEvent;
   import com.gfp.core.info.dailyActivity.SwapTimesInfo;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.utils.TimeUtil;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class MapProcess_1055 extends BaseMapProcess
   {
      
      private const TIME_SWAPID:int = 2708;
      
      public function MapProcess_1055()
      {
         super();
      }
      
      override protected function init() : void
      {
      }
      
      protected function onMouseClick(param1:MouseEvent) : void
      {
         ModuleManager.turnAppModule("SummonFishPanel");
      }
      
      private function addEvent() : void
      {
         ItemManager.addListener(UserItemEvent.FISH_PAENL_END,this.onEnd);
         ItemManager.addListener(UserItemEvent.FISH_PANEL_BEGIN,this.onBegin);
         this.getBuffTime();
      }
      
      private function getBuffTime() : void
      {
         ActivityExchangeTimesManager.addEventListener(this.TIME_SWAPID,this.onGetBuffTime);
         ActivityExchangeTimesManager.getActiviteTimeInfo(this.TIME_SWAPID);
      }
      
      private function onGetBuffTime(param1:DataEvent) : void
      {
         ActivityExchangeTimesManager.removeEventListener(this.TIME_SWAPID,this.onGetBuffTime);
         var _loc2_:SwapTimesInfo = param1.data as SwapTimesInfo;
         var _loc3_:Date = new Date();
         _loc3_.setTime(_loc2_.senconds * 1000);
         var _loc4_:Date = TimeUtil.getSeverDateObject();
         var _loc5_:int = (_loc3_.time - _loc4_.time) * 0.001 + 900;
         if(_loc5_ > 0)
         {
            TimeCountDown.instance.show("持续增加经验剩余时间");
            TimeCountDown.instance.start(_loc5_);
         }
      }
      
      private function onBegin(param1:Event) : void
      {
      }
      
      private function onEnd(param1:Event) : void
      {
      }
      
      private function removeEvent() : void
      {
         ItemManager.removeListener(UserItemEvent.FISH_PAENL_END,this.onEnd);
         ItemManager.removeListener(UserItemEvent.FISH_PANEL_BEGIN,this.onBegin);
         if(TimeCountDown.instance.isRunning)
         {
            TimeCountDown.instance.destroy();
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
   }
}

