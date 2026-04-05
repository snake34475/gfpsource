package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.app.toolBar.DynamicActivityEntry;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.UserInfoManager;
   import com.gfp.core.manager.UserManager;
   import flash.events.Event;
   
   public class ChengXianButton extends BaseActivitySprite
   {
      
      public function ChengXianButton(param1:ActivityNodeInfo)
      {
         super(param1);
         UserManager.addEventListener(UserEvent.SECOND_TURN_BACK,this.updateHandle);
         UserInfoManager.ed.addEventListener(UserEvent.LVL_CHANGE,this.updateHandle);
      }
      
      private function updateHandle(param1:Event) : void
      {
         if((MainManager.actorInfo.secondTurnBackType == 0 && MainManager.actorInfo.lv == 115) != visible)
         {
            DynamicActivityEntry.instance.updateAlign();
         }
      }
      
      override protected function doAction() : void
      {
         var _loc1_:int = int(ActivityExchangeTimesManager.getTimes(12180));
         if(_loc1_ == 2 || _loc1_ == 3)
         {
            ModuleManager.turnAppModule("SecondTurnbackPanel");
         }
         else
         {
            ModuleManager.turnAppModule("SecondTurnbackSelectRolePanel");
         }
      }
      
      override public function executeShow() : Boolean
      {
         return Boolean(super.executeShow()) && MainManager.actorInfo.secondTurnBackType == 0 && MainManager.actorInfo.lv == 115;
      }
   }
}

