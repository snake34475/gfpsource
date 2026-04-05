package com.gfp.app.mapProcess
{
   import com.gfp.core.events.MoveEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.MapManager;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class MapProcess_1101703 extends BaseMapProcess
   {
      
      private var mMovieClip:Vector.<MovieClip>;
      
      public function MapProcess_1101703()
      {
         super();
      }
      
      override protected function init() : void
      {
         var _loc3_:DisplayObject = null;
         super.init();
         MainManager.actorModel.addEventListener(MoveEvent.MOVE,this.onMove);
         this.mMovieClip = new Vector.<MovieClip>();
         var _loc1_:int = int(MapManager.currentMap.downLevel.numChildren);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = MapManager.currentMap.downLevel.getChildAt(_loc2_);
            if(_loc3_ is MovieClip)
            {
               this.mMovieClip.push(_loc3_);
            }
            _loc2_++;
         }
         this.onMove(null);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         MainManager.actorModel.removeEventListener(MoveEvent.MOVE,this.onMove);
      }
      
      protected function onMove(param1:MoveEvent) : void
      {
         var _loc3_:MovieClip = null;
         var _loc2_:Point = MapManager.currentMap.camera.totalToView(MainManager.actorModel.pos);
         for each(_loc3_ in this.mMovieClip)
         {
            if(_loc3_.hitTestPoint(_loc2_.x,_loc2_.y,true))
            {
               _loc3_.play();
            }
            else
            {
               _loc3_.stop();
            }
         }
      }
   }
}

