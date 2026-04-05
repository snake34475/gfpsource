package com.gfp.app.fight
{
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.map.MapManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import org.taomee.manager.TaomeeManager;
   
   public class WatchFightSmallWindow extends Sprite
   {
      
      private var mapBitmap:Bitmap;
      
      private var scrollMc:Sprite;
      
      private var scal:Number = 0.16;
      
      public function WatchFightSmallWindow()
      {
         super();
         this.mapBitmap = new Bitmap();
         var _loc1_:BitmapData = new BitmapData(MapManager.currentMap.width * this.scal,MapManager.currentMap.height * this.scal,true,16777215);
         var _loc2_:Number = 1;
         var _loc3_:Matrix = new Matrix(this.scal / _loc2_,0,0,this.scal / _loc2_);
         _loc1_.draw(MapManager.currentMap.groundLevel,_loc3_);
         this.mapBitmap.bitmapData = _loc1_;
         addChild(this.mapBitmap);
         this.scrollMc = new Sprite();
         this.scrollMc.graphics.lineStyle(1,13382519,0.8);
         this.scrollMc.graphics.beginFill(16777215,0.2);
         this.scrollMc.graphics.drawRect(0,0,TaomeeManager.stageWidth * this.scal,TaomeeManager.stageHeight * this.scal);
         this.scrollMc.graphics.endFill();
         addChild(this.scrollMc);
         var _loc4_:Point = MapManager.currentMap.camera.viewToTotal(new Point(0,0));
         this.scrollMc.x = (this.mapBitmap.width - this.scrollMc.width) / 2;
         this.scrollMc.y = (this.mapBitmap.height - this.scrollMc.height) / 2;
         this.scrollMc.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
         this.scrollMc.buttonMode = true;
         MapManager.addEventListener(MapEvent.STAGE_USER_LISET_COMPLETE,this.stageUserListCompleteHandler);
      }
      
      private function stageUserListCompleteHandler(param1:MapEvent) : void
      {
         MapManager.removeEventListener(MapEvent.STAGE_USER_LISET_COMPLETE,this.stageUserListCompleteHandler);
         this.scrollMc.x = (this.mapBitmap.width - this.scrollMc.width) / 2;
         this.scrollMc.y = (this.mapBitmap.height - this.scrollMc.height) / 2;
         MapManager.currentMap.camera.scroll(this.scrollMc.x / this.scal,this.scrollMc.y / this.scal);
      }
      
      private function mouseDownHandler(param1:MouseEvent) : void
      {
         this.scrollMc.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
         var _loc2_:Rectangle = new Rectangle(0,0,this.mapBitmap.width - this.scrollMc.width,this.mapBitmap.height - this.scrollMc.height);
         this.scrollMc.startDrag(false,_loc2_);
         TaomeeManager.stage.addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
         this.scrollMc.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
      }
      
      private function mouseMoveHandler(param1:MouseEvent) : void
      {
         MapManager.currentMap.camera.scroll(this.scrollMc.x / this.scal,this.scrollMc.y / this.scal);
      }
      
      private function mouseUpHandler(param1:MouseEvent) : void
      {
         this.scrollMc.stopDrag();
         this.scrollMc.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
         TaomeeManager.stage.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
         this.scrollMc.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
      }
      
      public function destroy() : void
      {
         MapManager.removeEventListener(MapEvent.STAGE_USER_LISET_COMPLETE,this.stageUserListCompleteHandler);
         removeChild(this.mapBitmap);
         this.mapBitmap = null;
      }
   }
}

