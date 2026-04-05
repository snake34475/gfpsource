package com.gfp.app.mapProcess
{
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.utils.Direction;
   
   public class MapProcess_1069401 extends BaseMapProcess
   {
      
      private var flag:Boolean = false;
      
      public function MapProcess_1069401()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.addMapEvent();
      }
      
      private function addMapEvent() : void
      {
         UserManager.addEventListener(UserEvent.BUFF,this.buffStartHandler);
      }
      
      private function buffStartHandler(param1:UserEvent) : void
      {
         if(param1.data == 2113)
         {
            this.flag = !this.flag;
            Direction.isReverse = this.flag;
         }
      }
      
      private function removeMapEvent() : void
      {
         UserManager.removeEventListener(UserEvent.BUFF,this.buffStartHandler);
      }
      
      override public function destroy() : void
      {
         Direction.isReverse = false;
         this.removeMapEvent();
         super.destroy();
      }
   }
}

