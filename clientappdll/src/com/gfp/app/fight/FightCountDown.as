package com.gfp.app.fight
{
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.utils.FightMode;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class FightCountDown
   {
      
      private static var _movie:MovieClip;
      
      private static var _ed:EventDispatcher;
      
      public static const COUNT_DOWN_COMPLETE:String = "Count_Down_complete";
      
      public function FightCountDown()
      {
         super();
      }
      
      public static function destroy() : void
      {
         if(_movie)
         {
            DisplayUtil.removeForParent(_movie);
            _movie.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
            _movie = null;
         }
      }
      
      public static function play() : void
      {
         if(_movie == null)
         {
            if(FightManager.fightMode == FightMode.PVE)
            {
               _movie = UIManager.getMovieClip("Fight_CountDown_pve");
            }
            else
            {
               _movie = UIManager.getMovieClip("Fight_CountDown_pvp");
            }
            _movie.mouseChildren = false;
            _movie.mouseEnabled = false;
            _movie.stop();
         }
         LayerManager.topLevel.addChild(_movie);
         DisplayUtil.align(_movie,null,AlignType.MIDDLE_CENTER,new Point(0,-100));
         _movie.addEventListener(Event.ENTER_FRAME,onEnterFrame);
         _movie.gotoAndPlay(1);
      }
      
      private static function onEnterFrame(param1:Event) : void
      {
         if(_movie.currentFrame == _movie.totalFrames)
         {
            destroy();
            ed.dispatchEvent(new Event(COUNT_DOWN_COMPLETE));
         }
      }
      
      public static function get ed() : EventDispatcher
      {
         if(_ed == null)
         {
            _ed = new EventDispatcher();
         }
         return _ed;
      }
   }
}

