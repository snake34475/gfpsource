package com.gfp.app.mapProcess
{
   import com.gfp.core.CommandID;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.DisplayObjectFlashUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   import org.taomee.player.data.FrameInfo;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1129102 extends BaseMapProcess
   {
      
      private var _container:Sprite;
      
      private var _frameInfo:Vector.<FrameInfo>;
      
      private var _lights:Vector.<MY_PLAYER>;
      
      private var _introduce:Sprite;
      
      public function MapProcess_1129102()
      {
         super();
      }
      
      override protected function init() : void
      {
         SocketConnection.addCmdListener(CommandID.FIGHT_COMMON_NOTIFY,this.onBossHitCount);
         this._container = new Sprite();
         MainManager.actorModel.addHeadContainerChild(this._container);
         this._lights = new Vector.<MY_PLAYER>();
         this._introduce = _mapModel.libManager.getSprite("Introduce");
         LayerManager.topLevel.addChild(this._introduce);
         this._introduce.x = 20;
         this._introduce.y = 135;
      }
      
      private function get frameInfo() : Vector.<FrameInfo>
      {
         if(this._frameInfo)
         {
            return this._frameInfo;
         }
         this._frameInfo = DisplayObjectFlashUtil.generalFrameInfo(_mapModel.libManager.getSprite("UserHeadLight") as MovieClip);
         return this._frameInfo;
      }
      
      private function onBossHitCount(param1:SocketEvent) : void
      {
         var _loc4_:int = 0;
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         if(_loc3_ == 1291)
         {
            _loc4_ = int(_loc2_.readUnsignedInt());
            _loc4_ = int(_loc4_ / 10);
            this.updateHeadLight(_loc4_);
         }
      }
      
      private function updateHeadLight(param1:int) : void
      {
         var _loc3_:MY_PLAYER = null;
         var _loc2_:int = 0;
         while(_loc2_ < 5)
         {
            _loc3_ = this._lights.length > _loc2_ ? this._lights[_loc2_] : null;
            if(_loc2_ < param1)
            {
               if(_loc3_ == null)
               {
                  _loc3_ = new MY_PLAYER(this.frameInfo);
                  this._lights.push(_loc3_);
               }
               _loc3_.play();
               this._container.addChild(_loc3_);
               _loc3_.x = 35 * _loc2_;
            }
            else if(_loc3_)
            {
               DisplayUtil.removeForParent(_loc3_,false);
            }
            _loc2_++;
         }
         this._container.x = -35 * param1 * 0.5;
         MainManager.actorModel.showNick();
      }
      
      override public function destroy() : void
      {
         SocketConnection.removeCmdListener(CommandID.FIGHT_COMMON_NOTIFY,this.onBossHitCount);
         DisplayUtil.removeForParent(this._container);
         DisplayUtil.removeForParent(this._introduce);
         while(this._lights.length)
         {
            this._lights.pop().destory();
         }
         super.destroy();
      }
   }
}

import com.gfp.core.player.MovieClipPlayerEx;

class MY_PLAYER extends MovieClipPlayerEx
{
   
   public function MY_PLAYER(param1:Object)
   {
      super(param1);
   }
   
   override public function get height() : Number
   {
      return 50;
   }
}
