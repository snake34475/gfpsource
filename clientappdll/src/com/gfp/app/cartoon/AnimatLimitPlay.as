package com.gfp.app.cartoon
{
   import com.gfp.app.cartoon.event.AnimatEvent;
   import com.gfp.core.player.SpngPlayer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   import org.taomee.ds.HashMap;
   import org.taomee.utils.Delegate;
   import org.taomee.utils.DisplayUtil;
   
   public class AnimatLimitPlay
   {
      
      private static var _ed:EventDispatcher;
      
      private static var funcMap:HashMap = new HashMap();
      
      public function AnimatLimitPlay()
      {
         super();
      }
      
      public static function playForDuration(param1:MovieClip, param2:uint = 0) : void
      {
         var _loc3_:Function = Delegate.create(onDurantionFrame,param1,getTimer(),param2);
         funcMap.add(param1.name,_loc3_);
         param1.addEventListener(Event.ENTER_FRAME,_loc3_);
      }
      
      public static function spngPlayForDuration(param1:SpngPlayer, param2:uint = 0) : void
      {
         param1.duration = param2;
         setTimeout(Delegate.create(spngDestroy,param1),param2);
      }
      
      public static function playForRepeat(param1:MovieClip, param2:uint = 1) : void
      {
         var _loc3_:Function = Delegate.create(onRepeatFrame,param1,{"i":0},param2);
         funcMap.add(param1.name,_loc3_);
         param1.addEventListener(Event.ENTER_FRAME,_loc3_);
      }
      
      private static function onDurantionFrame(param1:Event, param2:MovieClip, param3:uint, param4:uint) : void
      {
         var array:Array = null;
         var e:Event = param1;
         var target:MovieClip = param2;
         var timeTick:uint = param3;
         var duration:uint = param4;
         if(getTimer() - timeTick >= duration)
         {
            array = [];
            array.push(target);
            funcMap.forEach(function(param1:String, param2:Function):void
            {
               var _loc3_:MovieClip = array[0];
               if(_loc3_.name == param1)
               {
                  if(_loc3_.hasEventListener(Event.ENTER_FRAME))
                  {
                     _loc3_.removeEventListener(Event.ENTER_FRAME,funcMap.remove(param1));
                     dispatchEvent(new AnimatEvent(AnimatEvent.ANIMAT_END,_loc3_));
                     DisplayUtil.removeForParent(_loc3_);
                     _loc3_ = null;
                  }
               }
            });
         }
      }
      
      private static function spngDestroy(param1:SpngPlayer) : void
      {
         dispatchEvent(new AnimatEvent(AnimatEvent.ANIMAT_END,param1));
         param1.destroy();
         DisplayUtil.removeForParent(param1);
         param1 = null;
      }
      
      private static function onRepeatFrame(param1:Event, param2:MovieClip, param3:Object, param4:uint) : void
      {
         var array:Array = null;
         var e:Event = param1;
         var target:MovieClip = param2;
         var repeatI:Object = param3;
         var repeat:uint = param4;
         if(repeat == 0)
         {
            return;
         }
         array = [];
         array.push(target);
         if(target.currentFrame == target.totalFrames)
         {
            ++repeatI["i"];
            if(repeatI["i"] == repeat)
            {
               funcMap.forEach(function(param1:String, param2:Function):void
               {
                  var _loc3_:MovieClip = array[0];
                  if(_loc3_.name == param1)
                  {
                     if(_loc3_.hasEventListener(Event.ENTER_FRAME))
                     {
                        _loc3_.removeEventListener(Event.ENTER_FRAME,funcMap.remove(param1));
                        dispatchEvent(new AnimatEvent(AnimatEvent.ANIMAT_END,_loc3_));
                        DisplayUtil.removeForParent(_loc3_);
                        _loc3_ = null;
                     }
                  }
               });
            }
         }
      }
      
      private static function getED() : EventDispatcher
      {
         if(_ed == null)
         {
            _ed = new EventDispatcher();
         }
         return _ed;
      }
      
      public static function dispatchEvent(param1:Event) : void
      {
         getED().dispatchEvent(param1);
      }
      
      public static function addEventListener(param1:String, param2:Function) : void
      {
         getED().addEventListener(param1,param2);
      }
      
      public static function removeEventListener(param1:String, param2:Function) : void
      {
         if(getED().hasEventListener(param1))
         {
            getED().removeEventListener(param1,param2);
         }
      }
   }
}

