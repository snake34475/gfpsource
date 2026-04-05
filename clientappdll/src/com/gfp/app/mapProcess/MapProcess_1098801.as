package com.gfp.app.mapProcess
{
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.ui.alert.TextAlert;
   
   public class MapProcess_1098801 extends BaseMapProcess
   {
      
      public function MapProcess_1098801()
      {
         super();
      }
      
      override protected function init() : void
      {
         UserManager.addEventListener(UserEvent.DIE,this.onYuanDanDie);
      }
      
      private function onYuanDanDie(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         if(_loc2_.info.roleType == 11503)
         {
            TextAlert.show("圆蛋完蛋啦，圣诞看上去很生气，生命值和攻击力提升了！");
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         UserManager.removeEventListener(UserEvent.DIE,this.onYuanDanDie);
      }
   }
}

