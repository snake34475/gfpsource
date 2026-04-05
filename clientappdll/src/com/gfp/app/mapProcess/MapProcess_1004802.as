package com.gfp.app.mapProcess
{
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.ui.alert.TextAlert;
   
   public class MapProcess_1004802 extends BaseMapProcess
   {
      
      public function MapProcess_1004802()
      {
         super();
      }
      
      override protected function init() : void
      {
         UserManager.addEventListener(UserEvent.DIE,this.onStoneDie);
      }
      
      private function onStoneDie(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         if(_loc2_.info.roleType == 19137)
         {
            TextAlert.show("沉睡于岩石之中的海火终于苏醒，斗兽场中央的舞台点亮起来。");
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         UserManager.removeEventListener(UserEvent.DIE,this.onStoneDie);
      }
   }
}

