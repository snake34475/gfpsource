package com.gfp.app.mapProcess
{
   import com.gfp.core.config.xml.RoleXMLInfo;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.ui.alert.TextAlert;
   import flash.display.MovieClip;
   import org.taomee.utils.DisplayUtil;
   import org.taomee.utils.Tick;
   
   public class MapProcess_1070103 extends BaseMapProcess
   {
      
      private var darkMC:MovieClip;
      
      public function MapProcess_1070103()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.darkMC = _mapModel.upLevel["darkMC"];
         this.addMapEvent();
      }
      
      private function addMapEvent() : void
      {
         UserManager.addEventListener(UserEvent.DIE,this.onUserDied);
         UserManager.addEventListener(UserEvent.BORN,this.onUserBorn);
      }
      
      private function removeMapEvent() : void
      {
         UserManager.removeEventListener(UserEvent.DIE,this.onUserDied);
         UserManager.removeEventListener(UserEvent.BORN,this.onUserBorn);
      }
      
      private function onUserBorn(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         if(_loc2_.info.roleType == 13142 || _loc2_.info.roleType == 13143)
         {
            TextAlert.show(RoleXMLInfo.getName(_loc2_.info.roleType) + "出现了！");
         }
      }
      
      private function onUserDied(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         if(_loc2_.info.roleType == 19165)
         {
            Tick.instance.addCallback(this.onTick);
         }
      }
      
      private function onTick(param1:uint) : void
      {
         if(this.darkMC.alpha <= 0)
         {
            Tick.instance.removeCallback(this.onTick);
            DisplayUtil.removeForParent(this.darkMC);
            this.darkMC = null;
            return;
         }
         this.darkMC.alpha -= param1 / 500;
      }
      
      override public function destroy() : void
      {
         this.removeMapEvent();
         super.destroy();
      }
   }
}

