package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.app.toolBar.DynamicActivityEntry;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.MainManager;
   
   public class BestGodRecommendButton extends BaseActivitySprite
   {
      
      public function BestGodRecommendButton(param1:ActivityNodeInfo)
      {
         super(param1);
         if(MainManager.actorInfo.lv < 30)
         {
            MainManager.actorModel.addEventListener(UserEvent.LVL_CHANGE,this.onLvlChange);
         }
      }
      
      private function onLvlChange(param1:UserEvent) : void
      {
         if(MainManager.actorInfo.lv >= 30)
         {
            MainManager.actorModel.removeEventListener(UserEvent.LVL_CHANGE,this.onLvlChange);
            DynamicActivityEntry.instance.updateAlign();
         }
      }
      
      override public function executeShow() : Boolean
      {
         var _loc1_:Boolean = super.executeShow();
         if(MainManager.actorInfo.lv >= 30)
         {
            return true;
         }
         return false;
      }
   }
}

