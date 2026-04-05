package com.gfp.app.feature
{
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.utils.strength.SwfLoaderHelper;
   import com.greensock.TweenLite;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.utils.DisplayUtil;
   
   public class ShowCartoonFeather
   {
      
      private var _name:String;
      
      private var _time:int;
      
      private var _timer:uint;
      
      private var _mov:MovieClip;
      
      public function ShowCartoonFeather(param1:String, param2:int = 3000)
      {
         super();
         this._name = param1;
         this._time = param2;
         var _loc3_:SwfLoaderHelper = new SwfLoaderHelper();
         _loc3_.loadFile(ClientConfig.getCartoon(param1),this.movieCallBack);
      }
      
      private function movieCallBack(param1:Loader) : void
      {
         this._mov = param1.content["mc"];
         this._timer = setTimeout(this.hideMov,this._time);
         this._mov.x = LayerManager.stageWidth - this._mov.width >> 1;
         this._mov.y = (LayerManager.stageHeight - this._mov.height >> 1) - 150;
         LayerManager.topLevel.addChild(this._mov);
      }
      
      private function hideMov() : void
      {
         clearTimeout(this._timer);
         TweenLite.to(this._mov,1,{
            "alpha":0,
            "onComplete":this.tweenComplete
         });
      }
      
      private function tweenComplete() : void
      {
         DisplayUtil.removeForParent(this._mov);
      }
      
      public function destroy() : void
      {
         clearTimeout(this._timer);
         this.tweenComplete();
      }
   }
}

