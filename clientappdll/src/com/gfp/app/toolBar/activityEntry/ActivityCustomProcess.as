package com.gfp.app.toolBar.activityEntry
{
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.app.toolBar.DynamicActivityEntry;
   import com.gfp.app.ui.activity.BaseActivitySprite;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.ActivityExchangeAwardInfo;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UserManager;
   import org.taomee.ds.HashMap;
   
   public class ActivityCustomProcess
   {
      
      private static var _entryHash:HashMap = new HashMap();
      
      public function ActivityCustomProcess()
      {
         super();
      }
      
      public static function initEntry(param1:ActivityNodeInfo, param2:BaseActivitySprite) : void
      {
         _entryHash.add(param1.id,param2);
         switch(param1.id)
         {
            case 1:
            case 3:
               if(MainManager.actorInfo.isTurnBack)
               {
                  param2.visible = false;
                  break;
               }
               UserManager.addEventListener(UserEvent.TURN_BACK,onTurnBack);
               break;
            case 7:
               if(ActivityExchangeTimesManager.getTimes(2042) > 0)
               {
                  param2.visible = false;
               }
               else
               {
                  ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,onExchangeComplete);
               }
         }
      }
      
      private static function onTurnBack(param1:UserEvent) : void
      {
         UserManager.removeEventListener(UserEvent.TURN_BACK,onTurnBack);
         DynamicActivityEntry.instance.updateAlign();
      }
      
      private static function onExchangeComplete(param1:ExchangeEvent) : void
      {
         var _loc3_:BaseActivitySprite = null;
         var _loc2_:ActivityExchangeAwardInfo = param1.info;
         if(_loc2_.id == 2042)
         {
            ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,onExchangeComplete);
            _loc3_ = _entryHash.getValue(6);
            _loc3_.visible = false;
         }
      }
   }
}

