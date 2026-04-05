package com.gfp.app.mapProcess
{
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.ui.alert.TextAlert;
   
   public class MapProcess_1072101 extends BaseMapProcess
   {
      
      public function MapProcess_1072101()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         UserManager.addEventListener(UserEvent.DIE,this.onDieEvent);
      }
      
      private function removeEvent() : void
      {
         if(UserManager.hasEventListener(UserEvent.DIE))
         {
            UserManager.removeEventListener(UserEvent.DIE,this.onDieEvent);
         }
      }
      
      private function onDieEvent(param1:UserEvent) : void
      {
         var _loc2_:UserInfo = param1.data.info as UserInfo;
         if(_loc2_)
         {
            if(_loc2_.roleType == 11540)
            {
               if(UserManager.hasEventListener(UserEvent.DIE))
               {
                  UserManager.removeEventListener(UserEvent.DIE,this.onDieEvent);
               }
            }
            TextAlert.show("下一位高手3秒后出场！");
         }
      }
      
      override public function destroy() : void
      {
         this.removeEvent();
      }
   }
}

