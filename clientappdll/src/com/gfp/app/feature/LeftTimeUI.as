package com.gfp.app.feature
{
   import com.gfp.core.cache.SwfCache;
   import com.gfp.core.cache.SwfInfo;
   import com.gfp.core.config.ClientConfig;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.utils.getTimer;
   import org.taomee.utils.DisplayUtil;
   
   public class LeftTimeUI extends Sprite
   {
      
      private var _totalTime:int;
      
      private var _id:String;
      
      private var _callBack:Function;
      
      private var _ui:Sprite;
      
      private var _feather:LeftTimeMovFeather;
      
      private var _isHour:Boolean;
      
      private var _startLoadTime:uint;
      
      public function LeftTimeUI(param1:int, param2:Function = null, param3:String = "left_time", param4:Boolean = false)
      {
         super();
         this._startLoadTime = getTimer();
         this._totalTime = param1;
         this._id = param3;
         this._callBack = param2;
         this._isHour = param4;
         this.loadUI();
      }
      
      private function loadUI() : void
      {
         SwfCache.getSwfInfo(ClientConfig.getSubUI(this._id),this.onIconLoaded);
      }
      
      public function destory() : void
      {
         if(this._feather)
         {
            this._feather.destroy();
            this._feather = null;
         }
         SwfCache.cancel(ClientConfig.getSubUI(this._id),this.onIconLoaded);
         DisplayUtil.removeForParent(this);
      }
      
      private function onIconLoaded(param1:SwfInfo) : void
      {
         var _loc2_:int = getTimer() - this._startLoadTime;
         this._totalTime -= _loc2_;
         if(this._totalTime <= 0)
         {
            this.destory();
            return;
         }
         if(this._ui == null)
         {
            this._ui = param1.content as MovieClip;
            addChild(this._ui);
         }
         this._feather = new LeftTimeMovFeather(this._totalTime,this._ui as MovieClip,this.timeComeCallBack,1,this._isHour);
         this._feather.start();
      }
      
      private function timeComeCallBack() : void
      {
         if(this._callBack != null)
         {
            this._callBack();
            this.destory();
         }
      }
   }
}

