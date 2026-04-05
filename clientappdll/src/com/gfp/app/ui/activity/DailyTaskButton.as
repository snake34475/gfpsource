package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.SOManager;
   import flash.events.Event;
   import flash.net.SharedObject;
   
   public class DailyTaskButton extends BaseActivitySprite
   {
      
      private var _swapID:Array = [13070,13071,13072,13073,13074,13075,13076,13077,13078,13079,13080,13081];
      
      private var _recieveID:Array = [13082,13083,13084,13085,13086];
      
      public function DailyTaskButton(param1:ActivityNodeInfo)
      {
         super(param1);
         var _loc2_:int = 0;
         while(_loc2_ < this._recieveID.length)
         {
            ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.exchangeHandle);
            _loc2_++;
         }
         this.update();
      }
      
      private function exchangeHandle(param1:ExchangeEvent) : void
      {
         if(this._recieveID.indexOf(param1.info.id) != -1 || this._swapID.indexOf(param1.info.id) != -1)
         {
            this.update();
         }
      }
      
      private function update(param1:Event = null) : void
      {
         resetPromptEffect();
      }
      
      override public function hasProptEffect() : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc1_:SharedObject = SOManager.getActorSO("gf_dynamic_entry/" + info.oneShotKey + "/" + info.params);
         if(_loc1_.data.shot == true)
         {
            _loc2_ = 0;
            _loc3_ = 0;
            while(_loc3_ < this._swapID.length)
            {
               if(ActivityExchangeTimesManager.getTimes(this._swapID[_loc3_]) > 0)
               {
                  _loc2_++;
               }
               _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < this._recieveID.length)
            {
               if(_loc2_ >= 2 * (_loc3_ + 1) && ActivityExchangeTimesManager.getTimes(this._recieveID[_loc3_]) == 0)
               {
                  return true;
               }
               _loc3_++;
            }
            return false;
         }
         return true;
      }
      
      override protected function destroyAllEffect() : void
      {
         hideProptEffect();
      }
   }
}

