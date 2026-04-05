package com.gfp.app.ui.activity
{
   import com.gfp.core.cache.SwfCache;
   import com.gfp.core.cache.SwfInfo;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.ui.TipsManager;
   import com.gfp.core.ui.tips.BaseTips;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import org.taomee.utils.DisplayUtil;
   
   public class ActivityIcon extends Sprite
   {
      
      private var _url:String;
      
      private var _obj:DisplayObject;
      
      public function ActivityIcon()
      {
         super();
      }
      
      public function setData(param1:uint, param2:BaseTips = null) : void
      {
         this._url = ClientConfig.getActivityIcon(param1);
         if(this._obj)
         {
            DisplayUtil.removeForParent(this._obj);
            this._obj = null;
         }
         SwfCache.getSwfInfo(this._url,this.onLoad);
         if(param2)
         {
            TipsManager.addTip(this,param2);
         }
      }
      
      private function onLoad(param1:SwfInfo) : void
      {
         this._obj = param1.content;
         addChild(this._obj);
      }
      
      public function destroy() : void
      {
         TipsManager.removeTip(this);
         if(Boolean(this._url) && this._url != "")
         {
            SwfCache.cancel(this._url,this.onLoad);
         }
         if(this._obj)
         {
            DisplayUtil.removeForParent(this._obj);
            this._obj = null;
         }
         DisplayUtil.removeForParent(this);
      }
   }
}

