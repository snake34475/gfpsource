package com.gfp.app.feature
{
   import com.gfp.app.manager.EscortManager;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.model.PeopleModel;
   import com.gfp.core.utils.PvpTypeConstantUtil;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class YaBiaoPkFeather extends PKBaseFeather
   {
      
      private const LEFT_SWAP_ID:int = 10259;
      
      public function YaBiaoPkFeather()
      {
         super();
      }
      
      public function checkLeftTimes() : void
      {
         ActivityExchangeTimesManager.addEventListener(this.LEFT_SWAP_ID,this.getLeftSwapBack);
         ActivityExchangeTimesManager.getActiviteTimeInfo(this.LEFT_SWAP_ID);
      }
      
      private function getLeftSwapBack(param1:Event) : void
      {
         ActivityExchangeTimesManager.removeEventListener(this.LEFT_SWAP_ID,this.getLeftSwapBack);
      }
      
      override protected function onModelClick(param1:MouseEvent) : void
      {
         if(ActivityExchangeTimesManager.getTimes(this.LEFT_SWAP_ID) >= 8)
         {
            AlertManager.showSimpleAlarm("小侠士，你的劫镖次数已用完,每日最多劫镖8次");
            return;
         }
         if(EscortManager.instance.escortPathId != 0)
         {
            AlertManager.showSimpleAlarm("小侠士，押镖中不能劫镖！");
            return;
         }
         super.onModelClick(param1);
      }
      
      override protected function isModelNeedToAdd(param1:PeopleModel) : Boolean
      {
         if(Boolean(param1) && Boolean(param1.info))
         {
            if(param1.info.monsterID == 10403)
            {
               return true;
            }
         }
         return false;
      }
      
      override protected function getAlertMessage(param1:PeopleModel) : String
      {
         return "该玩家押镖中，是否确认进行劫镖？";
      }
      
      override protected function getPvpId() : int
      {
         return PvpTypeConstantUtil.PVP_JIE_BIAO;
      }
      
      override protected function getSelectInfoClearMessage() : String
      {
         return "该玩家已经退出押镖状态，无法进行劫镖。";
      }
      
      override protected function addEvent() : void
      {
         super.addEvent();
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
      }
      
      override protected function addModelEvent(param1:PeopleModel) : void
      {
         super.addModelEvent(param1);
         param1.addEventListener(UserEvent.ROLE_VIEW_CHANGE,this.onRoleViewChanged);
      }
      
      override protected function removeModelEvent(param1:PeopleModel) : void
      {
         super.removeModelEvent(param1);
         param1.removeEventListener(UserEvent.ROLE_VIEW_CHANGE,this.onRoleViewChanged);
      }
      
      private function onRoleViewChanged(param1:MouseEvent) : void
      {
         var _loc2_:PeopleModel = param1.currentTarget as PeopleModel;
         if(_loc2_.info.monsterID != 10403)
         {
            removeModel(_loc2_);
         }
      }
   }
}

