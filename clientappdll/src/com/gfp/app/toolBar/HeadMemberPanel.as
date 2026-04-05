package com.gfp.app.toolBar
{
   import com.gfp.core.cache.SwfCache;
   import com.gfp.core.cache.SwfInfo;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.model.UserModel;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import org.taomee.utils.DisplayUtil;
   
   public class HeadMemberPanel
   {
      
      private static var _instance:HeadMemberPanel;
      
      private var _mainUI:Sprite;
      
      private var _lvTxt:TextField;
      
      private var _nameTxt:TextField;
      
      private var _hpTxt:TextField;
      
      private var _mpTxt:TextField;
      
      private var _hpBar:Sprite;
      
      private var _mpBar:Sprite;
      
      private var _hpRect:Rectangle;
      
      private var _mpRect:Rectangle;
      
      private var _hpWidth:Number;
      
      private var _mpWidth:Number;
      
      private var _headIcon:Sprite;
      
      private var _userInfo:UserInfo;
      
      private var _userModel:UserModel;
      
      private var _addhpTimeID:uint;
      
      private var _addmpTimeID:uint;
      
      private var _buffBar:BuffIconBar;
      
      private var _teamLeader:Sprite;
      
      public function HeadMemberPanel()
      {
         super();
         this._mainUI = new Head_MemberInfoPanel();
         this._lvTxt = this._mainUI["lvTxt"];
         this._nameTxt = this._mainUI["nameTxt"];
         this._hpTxt = this._mainUI["hpTxt"];
         this._hpBar = this._mainUI["teammateHp_mc"];
         this._buffBar = new BuffIconBar();
         this._buffBar.x = 68;
         this._buffBar.y = 68;
         this._mainUI.addChild(this._buffBar);
         this._hpWidth = this._hpBar.width;
         this._hpRect = new Rectangle(0,0,0,this._hpBar.height);
         this._hpBar.scrollRect = this._hpRect;
      }
      
      public static function get instance() : HeadMemberPanel
      {
         if(_instance == null)
         {
            _instance = new HeadMemberPanel();
         }
         return _instance;
      }
      
      public static function destroy() : void
      {
         if(_instance)
         {
            _instance.destroy();
            _instance = null;
         }
      }
      
      public function init(param1:UserInfo) : void
      {
         this._userInfo = param1;
         this._userModel = UserManager.getModel(this._userInfo.userID);
         this._lvTxt.text = "" + this._userInfo.lv;
         this._nameTxt.text = this._userInfo.nick;
         this.setExpBar(this._userInfo);
      }
      
      public function show() : void
      {
         LayerManager.toolsLevel.addChild(this._mainUI);
         this.clearHeadIcon();
         SwfCache.getSwfInfo(ClientConfig.getRoleIcon(this._userInfo.roleType),this.onLoad);
      }
      
      public function hide() : void
      {
         DisplayUtil.removeForParent(this._mainUI,false);
      }
      
      public function destroy() : void
      {
         SwfCache.cancel(ClientConfig.getRoleIcon(this._userInfo.roleType),this.onLoad);
         this.hide();
         this.clearHeadIcon();
         this.clearAddIcon();
         if(this._teamLeader)
         {
            DisplayUtil.removeForParent(this._teamLeader);
            this._teamLeader = null;
         }
         this._hpRect = null;
         this._lvTxt = null;
         this._nameTxt = null;
         this._hpTxt = null;
         this._hpBar = null;
         this._mainUI = null;
      }
      
      private function clearHeadIcon() : void
      {
         if(this._headIcon)
         {
            this._headIcon.cacheAsBitmap = false;
            DisplayUtil.removeForParent(this._headIcon);
            this._headIcon = null;
         }
      }
      
      private function clearAddIcon() : void
      {
         this._buffBar.clear();
      }
      
      public function get sprite() : Sprite
      {
         return this._mainUI;
      }
      
      private function setExpBar(param1:UserInfo) : void
      {
         this._lvTxt.text = "" + param1.lv;
         var _loc2_:int = int(this._userInfo.hp);
         var _loc3_:int = int(this._userInfo.maxHp);
         this._hpRect.width = _loc2_ / _loc3_ * this._hpWidth;
         this._hpBar.scrollRect = this._hpRect;
         this._hpTxt.text = _loc2_.toString() + "/" + _loc3_.toString();
      }
      
      private function onInfoChange(param1:UserEvent) : void
      {
         var _loc2_:UserInfo = param1.data;
         if(_loc2_)
         {
            this.setExpBar(_loc2_);
         }
      }
      
      private function onLoad(param1:SwfInfo) : void
      {
         this._headIcon = param1.content as Sprite;
         this._headIcon.mouseChildren = false;
         this._headIcon.mouseEnabled = false;
         this._headIcon.cacheAsBitmap = true;
         this._headIcon.y = 5;
         this._headIcon.x = 4;
         this._headIcon.scaleX = 0.65;
         this._headIcon.scaleY = 0.65;
         this._mainUI["roleIcon"].addChild(this._headIcon);
         if(MainManager.leaderID == this._userInfo.userID)
         {
            if(this._teamLeader == null)
            {
               this._teamLeader = new Fight_Team_Leader();
            }
            this._teamLeader.scaleX = 0.5;
            this._teamLeader.scaleY = 0.5;
            this._teamLeader.x = 5;
            this._teamLeader.y = 22;
            this._mainUI.addChild(this._teamLeader);
         }
      }
      
      public function onHP(param1:int) : void
      {
         var _loc2_:int = int(this._userModel.getTotalHP());
         this._hpRect.width = param1 / _loc2_ * this._hpWidth;
         this._hpBar.scrollRect = this._hpRect;
         this._hpTxt.text = param1.toString() + "/" + _loc2_.toString();
      }
      
      public function onMP(param1:int) : void
      {
      }
      
      public function onLv(param1:int) : void
      {
         this._lvTxt.text = param1.toString();
      }
   }
}

