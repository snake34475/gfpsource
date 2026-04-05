package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.app.toolBar.DynamicActivityEntry;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.ModuleManager;
   
   public class SavingPotButton extends BaseActivitySprite
   {
      
      private static const NEW_COUNT_SWAPS:Array = [13047,13049,13051];
      
      private static const COUNT_SWAPS:Array = [12054,12060];
      
      private static const SAVE_SWAPS:Array = [12055,12061,13046,13048,13050];
      
      private static const CLAIM_PRIZE_SWAPS:Array = [[12056,12057,12058,12059],[12062,12063,12064,12065]];
      
      private static const NEW_CLAIM_PRIZE_SWAPS:Array = [[13052,13053,13054,13055],[13056,13057,13058,13059],[13060,13061,13062,13063]];
      
      private var _saved:Boolean;
      
      private var _willOpenNewPot:Boolean;
      
      public function SavingPotButton(param1:ActivityNodeInfo)
      {
         super(param1);
      }
      
      override public function addEvent() : void
      {
         super.addEvent();
         ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.exchangeHandle);
      }
      
      override public function removeEvent() : void
      {
         super.removeEvent();
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.exchangeHandle);
      }
      
      private function exchangeHandle(param1:ExchangeEvent) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc2_:int = int(param1.info.id);
         if(SAVE_SWAPS.indexOf(_loc2_) != -1)
         {
            this._saved = true;
            DynamicActivityEntry.instance.updateAlign();
         }
         else if(CLAIM_PRIZE_SWAPS[0].indexOf(_loc2_) != -1)
         {
            _loc3_ = true;
            _loc4_ = 0;
            while(_loc4_ < 4)
            {
               if(ActivityExchangeTimesManager.getTimes(CLAIM_PRIZE_SWAPS[0][_loc4_]) == 0)
               {
                  _loc3_ = false;
                  break;
               }
               _loc4_++;
            }
            if(_loc3_)
            {
               DynamicActivityEntry.instance.updateAlign();
            }
         }
         else if(CLAIM_PRIZE_SWAPS[1].indexOf(_loc2_) != -1)
         {
            _loc3_ = true;
            _loc4_ = 0;
            while(_loc4_ < 4)
            {
               if(ActivityExchangeTimesManager.getTimes(CLAIM_PRIZE_SWAPS[1][_loc4_]) == 0)
               {
                  _loc3_ = false;
                  break;
               }
               _loc4_++;
            }
            if(_loc3_)
            {
               DynamicActivityEntry.instance.updateAlign();
            }
         }
         else
         {
            _loc4_ = 0;
            while(_loc4_ < 3)
            {
               _loc5_ = int(NEW_CLAIM_PRIZE_SWAPS[_loc4_].indexOf(_loc2_));
               if(_loc5_ != -1)
               {
                  _loc6_ = 0;
                  _loc7_ = 0;
                  while(_loc7_ < 4)
                  {
                     if(ActivityExchangeTimesManager.getTimes(NEW_CLAIM_PRIZE_SWAPS[_loc4_][_loc7_]) > 0)
                     {
                        _loc6_++;
                     }
                     _loc7_++;
                  }
                  if(_loc6_ >= 4)
                  {
                     DynamicActivityEntry.instance.updateAlign();
                     return;
                  }
               }
               _loc4_++;
            }
         }
      }
      
      override protected function doAction() : void
      {
         if(this._willOpenNewPot)
         {
            ModuleManager.turnAppModule("SavingPot1604Panel");
         }
         else
         {
            ModuleManager.turnAppModule("SavingPot1601Panel");
         }
      }
      
      private function getNewPlayerSaved() : Boolean
      {
         var _loc1_:int = 0;
         while(_loc1_ < NEW_COUNT_SWAPS.length)
         {
            if(ActivityExchangeTimesManager.getTimes(NEW_COUNT_SWAPS[_loc1_]) > 0)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      override public function executeShow() : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(super.executeShow() == false)
         {
            return false;
         }
         var _loc1_:Boolean = true;
         _loc3_ = 0;
         if(_loc3_ < SAVE_SWAPS.length)
         {
            if(ActivityExchangeTimesManager.getTimes(SAVE_SWAPS[_loc3_]) != 0)
            {
               this._saved = true;
            }
         }
         if(this._saved == false && ActivityExchangeTimesManager.getTimes(COUNT_SWAPS[0]) == 0 && ActivityExchangeTimesManager.getTimes(COUNT_SWAPS[1]) == 0)
         {
            _loc2_ = this.getNewPlayerSaved();
            if(_loc2_ == false)
            {
               return false;
            }
            this._willOpenNewPot = true;
            _loc3_ = 0;
            while(_loc3_ < 3)
            {
               _loc4_ = 0;
               _loc5_ = 0;
               while(_loc5_ < 4)
               {
                  if(ActivityExchangeTimesManager.getTimes(NEW_CLAIM_PRIZE_SWAPS[_loc3_][_loc5_]) > 0)
                  {
                     _loc4_++;
                  }
                  _loc5_++;
               }
               if(_loc4_ < 4)
               {
                  return true;
               }
               _loc3_++;
            }
            return false;
         }
         this._willOpenNewPot = false;
         _loc1_ = true;
         _loc3_ = 0;
         while(_loc3_ < 4)
         {
            if(ActivityExchangeTimesManager.getTimes(CLAIM_PRIZE_SWAPS[0][_loc3_]) == 0)
            {
               _loc1_ = false;
               break;
            }
            _loc3_++;
         }
         if(_loc1_ == false)
         {
            _loc1_ = true;
            _loc3_ = 0;
            while(_loc3_ < 4)
            {
               if(ActivityExchangeTimesManager.getTimes(CLAIM_PRIZE_SWAPS[1][_loc3_]) == 0)
               {
                  _loc1_ = false;
                  break;
               }
               _loc3_++;
            }
         }
         return _loc1_ == false;
      }
   }
}

