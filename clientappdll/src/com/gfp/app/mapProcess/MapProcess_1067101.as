package com.gfp.app.mapProcess
{
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.ui.alert.TextAlert;
   
   public class MapProcess_1067101 extends BaseMapProcess
   {
      
      public function MapProcess_1067101()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.addEvent();
      }
      
      private function onBuffHandler(param1:UserEvent) : void
      {
         if(int(param1.data) == 1411)
         {
            TextAlert.show("小侠士，我彻底愤怒了。",16776960,16711680);
         }
      }
      
      private function addEvent() : void
      {
         UserManager.addEventListener(UserEvent.BUFF,this.onBuffHandler);
      }
      
      private function removeEvent() : void
      {
         UserManager.removeEventListener(UserEvent.BUFF,this.onBuffHandler);
      }
      
      override public function destroy() : void
      {
         this.removeEvent();
         super.destroy();
      }
   }
}

