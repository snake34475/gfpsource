package com.gfp.app.mapProcess
{
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.strength.SwfLoaderHelper;
   import com.greensock.TweenLite;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.utils.ByteArray;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1111001 extends BaseMapProcess
   {
      
      private const Tan_COM:int = 2740;
      
      private var _timer1:uint;
      
      private var _time1:int = 3000;
      
      private var _timer2:uint;
      
      private var _time2:int = 3000;
      
      private var _timer3:uint;
      
      private var _time3:int = 3000;
      
      private var _mc1:MovieClip;
      
      private var _mc2:MovieClip;
      
      private var _mc3:MovieClip;
      
      private var helper1:SwfLoaderHelper = new SwfLoaderHelper();
      
      private var helper2:SwfLoaderHelper = new SwfLoaderHelper();
      
      private var helper3:SwfLoaderHelper = new SwfLoaderHelper();
      
      private var index:int = 0;
      
      public function MapProcess_1111001()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         SocketConnection.addCmdListener(this.Tan_COM,this.onTan);
      }
      
      private function onTan(param1:SocketEvent) : void
      {
         if(this._mc3)
         {
            DisplayUtil.removeForParent(this._mc3);
         }
         if(this._mc2)
         {
            DisplayUtil.removeForParent(this._mc2);
         }
         if(this._mc1)
         {
            DisplayUtil.removeForParent(this._mc1);
         }
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         this.index = _loc2_.readUnsignedInt();
         this.index = _loc2_.readUnsignedInt();
         this.index = _loc2_.readUnsignedInt();
         --this.index;
         clearTimeout(this._timer1);
         clearTimeout(this._timer2);
         clearTimeout(this._timer3);
         this.helper1.loadFile(ClientConfig.getCartoon("Mi_Bao_Tip"),this.movieCallBack1);
         if(this.index >= 7 && this.index < 13)
         {
            this.helper2.loadFile(ClientConfig.getCartoon("Mi_Bao_Tip"),this.movieCallBack2);
         }
         if(this.index == 14)
         {
            this.helper3.loadFile(ClientConfig.getCartoon("Mi_Bao_Tip"),this.movieCallBack3);
         }
      }
      
      private function movieCallBack1(param1:Loader) : void
      {
         var _loc2_:int = 0;
         this._mc1 = param1.content["mc1"];
         var _loc3_:MovieClip = this._mc1["mc0"];
         _loc2_ = (15 - this.index) % 10 + 1;
         _loc3_.gotoAndStop(_loc2_);
         var _loc4_:MovieClip = this._mc1["mc1"];
         _loc2_ = (15 - this.index) / 10 + 1;
         _loc4_.gotoAndStop(_loc2_);
         this._timer1 = setTimeout(this.hideMov1,this._time1);
         this._mc1.x = LayerManager.stageWidth - this._mc1.width >> 1;
         this._mc1.y = (LayerManager.stageHeight - this._mc1.height >> 1) - 150;
         LayerManager.topLevel.addChild(this._mc1);
      }
      
      private function hideMov1() : void
      {
         clearTimeout(this._timer1);
         TweenLite.to(this._mc1,1,{
            "alpha":0,
            "onComplete":this.tweenComplete1
         });
      }
      
      private function tweenComplete1() : void
      {
         DisplayUtil.removeForParent(this._mc1);
      }
      
      private function movieCallBack2(param1:Loader) : void
      {
         this._mc2 = param1.content["mc2"];
         this._timer2 = setTimeout(this.hideMov2,this._time2);
         this._mc2.x = LayerManager.stageWidth - this._mc2.width >> 1;
         this._mc2.y = (LayerManager.stageHeight - this._mc2.height >> 1) - 50;
         LayerManager.topLevel.addChild(this._mc2);
      }
      
      private function hideMov2() : void
      {
         clearTimeout(this._timer2);
         TweenLite.to(this._mc2,1,{
            "alpha":0,
            "x":LayerManager.stageWidth - this._mc2.width >> 1,
            "y":(LayerManager.stageHeight - this._mc2.height >> 1) - 150,
            "onComplete":this.tweenComplete2
         });
      }
      
      private function tweenComplete2() : void
      {
         DisplayUtil.removeForParent(this._mc2);
      }
      
      private function movieCallBack3(param1:Loader) : void
      {
         this._mc3 = param1.content["mc3"];
         this._timer3 = setTimeout(this.hideMov3,this._time3);
         this._mc3.x = LayerManager.stageWidth - this._mc3.width >> 1;
         this._mc3.y = LayerManager.stageHeight - this._mc3.height >> 1;
         LayerManager.topLevel.addChild(this._mc3);
      }
      
      private function hideMov3() : void
      {
         clearTimeout(this._timer3);
         TweenLite.to(this._mc3,1,{
            "alpha":0,
            "x":LayerManager.stageWidth - this._mc2.width >> 1,
            "y":(LayerManager.stageHeight - this._mc2.height >> 1) - 150,
            "onComplete":this.tweenComplete3
         });
      }
      
      private function tweenComplete3() : void
      {
         DisplayUtil.removeForParent(this._mc3);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(this._mc3)
         {
            DisplayUtil.removeForParent(this._mc3);
         }
         if(this._mc2)
         {
            DisplayUtil.removeForParent(this._mc2);
         }
         if(this._mc1)
         {
            DisplayUtil.removeForParent(this._mc1);
         }
         clearTimeout(this._timer1);
         clearTimeout(this._timer2);
         clearTimeout(this._timer3);
         SocketConnection.removeCmdListener(this.Tan_COM,this.onTan);
      }
   }
}

