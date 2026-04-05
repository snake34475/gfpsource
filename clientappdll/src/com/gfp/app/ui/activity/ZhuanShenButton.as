package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.CustomEventMananger;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.UserManager;
   import flash.events.Event;
   
   public class ZhuanShenButton extends BaseActivitySprite
   {
      
      private var _levelLimit:Array = [1,1,1];
      
      private var _swapIds:Array = [[10027,10028],[10029,10030,10031],[10032,10033,10034]];
      
      public function ZhuanShenButton(param1:ActivityNodeInfo)
      {
         super(param1);
         if(!MainManager.actorInfo.isTurnBack)
         {
            this.visible = false;
            UserManager.addEventListener(UserEvent.TURN_BACK,this.onUserTurnBack);
         }
         MainManager.actorModel.addEventListener(UserEvent.LVL_CHANGE,this.onLvlChange);
         CustomEventMananger.addEventLisnter(CustomEventMananger.TURN_BACK_AWARDS_PANEL_CLOSE,this.onPanelClosed);
         this.checkAwards();
      }
      
      override public function executeShow() : Boolean
      {
         return Boolean(super.executeShow()) && this.isCanGetAward();
      }
      
      override public function hasProptEffect() : Boolean
      {
         return this.executeShow();
      }
      
      private function onPanelClosed(param1:Event) : void
      {
         this.checkAwards();
      }
      
      private function onLvlChange(param1:UserEvent) : void
      {
         this.checkAwards();
      }
      
      private function checkAwards() : void
      {
         if(this.isCanGetAward())
         {
            this.visible = true;
         }
         else
         {
            this.visible = false;
         }
      }
      
      private function isCanGetAward() : Boolean
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc1_:int = int(MainManager.actorInfo.lv);
         var _loc2_:int = 0;
         while(_loc2_ < this._swapIds.length)
         {
            _loc3_ = this._swapIds[_loc2_];
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc5_ = int(_loc3_[_loc4_]);
               if(ActivityExchangeTimesManager.getTimes(_loc5_) == 0)
               {
                  return true;
               }
               _loc4_++;
            }
            _loc2_++;
         }
         return false;
      }
      
      private function onUserTurnBack(param1:Event) : void
      {
         this.visible = true;
      }
      
      override protected function doAction() : void
      {
         ModuleManager.turnAppModule("TurnBackAwardPanel");
      }
   }
}

