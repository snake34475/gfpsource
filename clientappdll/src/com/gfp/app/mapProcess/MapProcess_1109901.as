package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.player.MovieClipPlayerEx;
   import com.gfp.core.utils.strength.SwfLoaderHelper;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class MapProcess_1109901 extends BaseMapProcess
   {
      
      private const SUI_COM:int = 2740;
      
      private var mc:Vector.<MovieClipPlayerEx> = new Vector.<MovieClipPlayerEx>();
      
      private var _pos:Vector.<Point> = new Vector.<Point>();
      
      private var index:int = 0;
      
      public function MapProcess_1109901()
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._pos.length)
         {
            this._pos.pop();
            _loc1_++;
         }
         this._pos.push(new Point(748,146));
         this._pos.push(new Point(1034,193));
         this._pos.push(new Point(1204,317));
         this._pos.push(new Point(1034,489));
         this._pos.push(new Point(433,469));
         this._pos.push(new Point(433,187));
         this._pos.push(new Point(748,558));
         this._pos.push(new Point(211,317));
         var _loc2_:SwfLoaderHelper = new SwfLoaderHelper();
         _loc2_.loadFile(ClientConfig.getCartoon("Tian_Quan"),this.movieCallBack);
         super();
      }
      
      override protected function init() : void
      {
      }
      
      override public function destroy() : void
      {
         super.destroy();
         LayerManager.stage.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         SocketConnection.removeCmdListener(this.SUI_COM,this.onSui);
         if(FightManager.isWinTheFight)
         {
            MainManager.stageRecordInfo.getPassedStageMap().add(1099,true);
         }
      }
      
      private function onSui(param1:SocketEvent) : void
      {
         LayerManager.stage.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         this.index = _loc2_.readUnsignedInt();
         this.index = _loc2_.readUnsignedInt();
         this.index = _loc2_.readUnsignedInt();
         --this.index;
         var _loc3_:int = 0;
         while(_loc3_ < 8)
         {
            this.mc[_loc3_].currentFrame = 1;
            _loc3_++;
         }
         this.mc[this.index].play();
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         if(this.mc[this.index].currentFrame == this.mc[this.index].totalFrames)
         {
            this.mc[this.index].visible = false;
            LayerManager.stage.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
      }
      
      private function movieCallBack(param1:Loader) : void
      {
         var _loc4_:int = 0;
         var _loc5_:MovieClipPlayerEx = null;
         var _loc2_:MovieClip = new MovieClip();
         _loc2_ = param1.content["item"];
         var _loc3_:MovieClipPlayerEx = new MovieClipPlayerEx(_loc2_);
         this.mc.push(_loc3_);
         _loc4_ = 0;
         while(_loc4_ < 7)
         {
            _loc5_ = new MovieClipPlayerEx(_loc3_.date,1,1,_loc3_.xx,_loc3_.yy);
            this.mc.push(_loc5_);
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < 8)
         {
            this.mc[_loc4_].x = this._pos[_loc4_].x;
            this.mc[_loc4_].y = this._pos[_loc4_].y - 100;
            MapManager.currentMap.contentLevel.addChild(this.mc[_loc4_]);
            this.mc[_loc4_].currentFrame = 1;
            _loc4_++;
         }
         SocketConnection.addCmdListener(this.SUI_COM,this.onSui);
      }
   }
}

