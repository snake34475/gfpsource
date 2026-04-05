package com.gfp.app.mapProcess
{
   import com.gfp.core.CommandID;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.strength.SwfLoaderHelper;
   import com.greensock.TweenLite;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class MapProcess_1110001 extends BaseMapProcess
   {
      
      private var _biaomc:MovieClip;
      
      private var _fullmc:MovieClip;
      
      private var _firemc:MovieClip;
      
      private var _dou:Vector.<MovieClip> = new Vector.<MovieClip>();
      
      private var _mask:Vector.<MovieClip> = new Vector.<MovieClip>();
      
      private var _angre:int = 0;
      
      private var dindex:int = 0;
      
      private var lastd:int = 0;
      
      private var maskpos:Number = 0;
      
      private var _maskfire:MovieClip;
      
      public function MapProcess_1110001()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         var _loc1_:int = 0;
         var _loc2_:SwfLoaderHelper = new SwfLoaderHelper();
         _loc2_.loadFile(ClientConfig.getCartoon("YU_HENG"),this.movieCallBack);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         LayerManager.stage.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         LayerManager.topLevel.removeChild(this._biaomc);
         LayerManager.topLevel.removeChild(this._fullmc);
         var _loc1_:int = 0;
         while(_loc1_ < 10)
         {
            this._dou[_loc1_] = null;
            this._mask[_loc1_] = null;
            _loc1_++;
         }
         this._biaomc = null;
         this._fullmc = null;
         this._firemc = null;
         SocketConnection.removeCmdListener(CommandID.FIGHT_COMMON_NOTIFY,this.onFireFly);
      }
      
      private function movieCallBack(param1:Loader) : void
      {
         this._biaomc = param1.content["biao"];
         this._fullmc = param1.content["full"];
         this._firemc = param1.content["fire"];
         var _loc2_:int = 0;
         while(_loc2_ < 10)
         {
            this._dou.push(this._biaomc["dou" + _loc2_]);
            this._mask.push(this._dou[_loc2_]["mask"]);
            this._mask[_loc2_].y = 18;
            _loc2_++;
         }
         if(LayerManager.stageHeight == 660)
         {
            this._biaomc.x = 1000;
            this._biaomc.y = 95;
         }
         else
         {
            this._biaomc.x = 850;
            this._biaomc.y = 50;
         }
         this._maskfire = this._firemc["maskfire"];
         this._maskfire.y = 330;
         this._fullmc.x = this._biaomc.x + 35;
         LayerManager.topLevel.addChild(this._biaomc);
         LayerManager.topLevel.addChild(this._fullmc);
         LayerManager.topLevel.addChild(this._firemc);
         this._fullmc.visible = false;
         this._fullmc.stop();
         SocketConnection.addCmdListener(CommandID.FIGHT_COMMON_NOTIFY,this.onFireFly);
         LayerManager.stage.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.dindex)
         {
            this._mask[_loc2_].y = 0;
            _loc2_++;
         }
         _loc2_ = this.dindex + 1;
         while(_loc2_ < 10)
         {
            this._mask[_loc2_].y = 18;
            _loc2_++;
         }
      }
      
      private function onFireFly(param1:SocketEvent) : void
      {
         var _loc3_:int = 0;
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         this._angre = _loc2_.readUnsignedInt();
         this._angre = _loc2_.readUnsignedInt();
         if(this._angre < 100 && this._angre > 0)
         {
            this.maskpos = 18 - this.ge(this._angre) * 1.8;
            this.dindex = this.shi(this._angre);
            TweenLite.to(this._mask[this.dindex],0.5,{"y":this.maskpos});
            _loc3_ = 0;
            while(_loc3_ < this.dindex)
            {
               this._mask[_loc3_].y = 0;
               this._fullmc.y = this._biaomc.y + 285 - 25 * (this.dindex - 1);
               _loc3_++;
            }
            if(this.dindex > this.lastd)
            {
               _loc3_ = 0;
               while(_loc3_ < this.dindex)
               {
                  this._mask[_loc3_].y = 0;
                  this._fullmc.y = this._biaomc.y + 285 - 25 * (this.dindex - 1);
                  this._fullmc.visible = true;
                  this._fullmc.play();
                  _loc3_++;
               }
            }
         }
         else
         {
            _loc3_ = 0;
            while(_loc3_ < 10)
            {
               TweenLite.to(this._mask[_loc3_],0.5,{"y":18});
               _loc3_++;
            }
            this._firemc.visible = true;
            this._firemc.x = this._biaomc.x;
            this._firemc.y = this._biaomc.y - 30;
            TweenLite.to(this._maskfire,2,{
               "y":0,
               "onComplete":this.hideFire
            });
            this._angre -= 100;
         }
         this.lastd = this.dindex;
      }
      
      private function hideFire() : void
      {
         this._maskfire.y = 330;
      }
      
      private function shi(param1:int = 0) : int
      {
         return int(param1 / 10);
      }
      
      private function ge(param1:int = 0) : int
      {
         return int(param1 % 10);
      }
   }
}

