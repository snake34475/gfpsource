package com.gfp.app.mapProcess
{
   import com.gfp.core.events.SkillEvent;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.ui.alert.TextAlert;
   
   public class MapProcess_1006007 extends BaseMapProcess
   {
      
      public function MapProcess_1006007()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.addEvent();
      }
      
      private function _onBossDownHandler(param1:SkillEvent) : void
      {
         if(param1.skillID == 4120312)
         {
            TextAlert.show("硕硕小强潜入地下，迅速清理小怪，注意脚下！",16776960,16711680);
         }
      }
      
      private function addEvent() : void
      {
         UserManager.addEventListener(SkillEvent.SKILL_ACTION,this._onBossDownHandler);
      }
      
      private function removeEvent() : void
      {
         UserManager.removeEventListener(SkillEvent.SKILL_ACTION,this._onBossDownHandler);
      }
      
      override public function destroy() : void
      {
         this.removeEvent();
         super.destroy();
      }
   }
}

