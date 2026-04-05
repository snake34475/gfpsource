package com.gfp.app.feature
{
   import com.gfp.core.manager.LayerManager;
   import flash.events.Event;
   
   public class FrameFunctionHelper
   {
      
      public var source:Array;
      
      public var eachFunction:Function;
      
      public var completeFunction:Function;
      
      public function FrameFunctionHelper(param1:Array, param2:Function, param3:Function = null)
      {
         super();
         this.source = param1;
         this.eachFunction = param2;
         this.completeFunction = param3;
      }
      
      public function start() : void
      {
         if(this.source.length > 0)
         {
            LayerManager.stage.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc2_:int = int(this.source.length);
         var _loc3_:* = this.source.shift();
         this.eachFunction(_loc3_,_loc2_);
         if(this.source.length == 0)
         {
            LayerManager.stage.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            if(this.completeFunction != null)
            {
               this.completeFunction();
            }
         }
      }
   }
}

