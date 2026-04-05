package com.gfp.app.cityWar
{
   import com.gfp.core.cache.SwfCache;
   import com.gfp.core.cache.SwfInfo;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.info.UserInfo;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class CityWarHeadPanel extends Sprite
   {
      
      private var _mainUI:Sprite;
      
      private var _headIconMc:Sprite;
      
      private var _selectPanel:MovieClip;
      
      private var _userInfo:UserInfo;
      
      public function CityWarHeadPanel()
      {
         super();
         this._mainUI = new UI_CityWarHeadPanel();
         addChild(this._mainUI);
         this._headIconMc = this._mainUI["headIcoMc"];
         this._headIconMc.buttonMode = true;
      }
      
      public function init(param1:UserInfo) : void
      {
         this._userInfo = param1;
         this._mainUI["lvTxt"].text = param1.lv.toString();
         this._mainUI["nameTxt"].text = param1.nick;
         SwfCache.getSwfInfo(ClientConfig.getRoleIcon(param1.roleType),this.onLoadCompleteHandler);
      }
      
      private function onLoadCompleteHandler(param1:SwfInfo) : void
      {
         var _loc2_:Sprite = param1.content as Sprite;
         _loc2_.y = 5;
         _loc2_.x = 4;
         _loc2_.scaleX = _loc2_.scaleY = 0.6;
         this._headIconMc.addChild(_loc2_);
      }
      
      public function get userID() : uint
      {
         return this._userInfo.userID;
      }
      
      public function destroy() : void
      {
         this._mainUI = null;
      }
   }
}

