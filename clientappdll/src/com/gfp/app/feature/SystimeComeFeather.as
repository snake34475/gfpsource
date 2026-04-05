package com.gfp.app.feature
{
   import com.gfp.app.time.SystimeEvent;
   import flash.events.EventDispatcher;
   
   public class SystimeComeFeather extends EventDispatcher
   {
      
      private var _systimeIds:Array;
      
      private var _helpers:Vector.<SystemTimeHelper>;
      
      public function SystimeComeFeather(param1:Array)
      {
         var _loc4_:SystemTimeHelper = null;
         this._helpers = new Vector.<SystemTimeHelper>();
         super();
         this._systimeIds = param1;
         var _loc2_:int = int(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = new SystemTimeHelper(this._systimeIds[_loc3_]);
            _loc4_.addEventListener(SystimeEvent.TIME_COME,this.onTimeCome);
            _loc4_.start();
            this._helpers.push(_loc4_);
            _loc3_++;
         }
      }
      
      private function onTimeCome(param1:SystimeEvent) : void
      {
         var _loc2_:SystimeEvent = new SystimeEvent(SystimeEvent.TIME_COME);
         _loc2_.isStart = param1.isStart;
         _loc2_.index = param1.index;
         _loc2_.systemID = param1.systemID;
         dispatchEvent(_loc2_);
      }
      
      public function destroy() : void
      {
         var _loc1_:SystemTimeHelper = null;
         for each(_loc1_ in this._helpers)
         {
            _loc1_.removeEventListener(SystimeEvent.TIME_COME,this.onTimeCome);
            _loc1_.destory();
         }
      }
   }
}

