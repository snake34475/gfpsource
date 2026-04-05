package com.gfp.app.toolBar
{
   import com.gfp.app.manager.FightGroupManager;
   import com.gfp.core.cache.SwfCache;
   import com.gfp.core.cache.SwfInfo;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.GroupUserInfo;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.language.ModuleLanguageDefine;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.manager.UserInfoManager;
   import com.gfp.core.utils.TextFormatUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import org.taomee.manager.ToolTipManager;
   
   public class GroupHeadInfoItem extends Sprite
   {
      
      private var _info:GroupUserInfo;
      
      private var _mainUI:MovieClip;
      
      private var _lvTxt:TextField;
      
      private var _nameTxt:TextField;
      
      private var _hpTxt:TextField;
      
      private var _hpBar:Sprite;
      
      private var _mpTxt:TextField;
      
      private var _mpBar:Sprite;
      
      private var _headIcoMc:Sprite;
      
      private var hpRectWidth:Number;
      
      private var hpRect:Rectangle;
      
      private var mpRectWidth:Number;
      
      private var mpRect:Rectangle;
      
      public function GroupHeadInfoItem(param1:GroupUserInfo)
      {
         super();
         this._info = param1;
         this._mainUI = UIManager.getMovieClip("Head_GroupInfoItemPanel");
         this._lvTxt = this._mainUI.lvTxt;
         this._nameTxt = this._mainUI.nameTxt;
         this._hpTxt = this._mainUI.hpTxt;
         this._hpBar = this._mainUI.hpProcess_mc;
         this._mpTxt = this._mainUI.mpTxt;
         this._mpBar = this._mainUI.mp_mc;
         this.hpRectWidth = this._hpBar.width;
         this.hpRect = new Rectangle(0,0,this.hpRectWidth,this._hpBar.height);
         this.mpRectWidth = this._mpBar.width;
         this.mpRect = new Rectangle(0,0,this.mpRectWidth,this._mpBar.height);
         this._headIcoMc = this._mainUI.headIcoMc;
         this._headIcoMc.buttonMode = true;
         addChild(this._mainUI);
         if(param1.type == 0)
         {
            this._mainUI.fightGroupIcoMc.gotoAndStop(2);
            this._mainUI.fightGroupIcoMc.visible = false;
         }
         else
         {
            this._mainUI.fightGroupIcoMc.gotoAndStop(1);
            ToolTipManager.add(this._mainUI.fightGroupIcoMc,"队长");
         }
         UserInfoManager.getSimpleInfo(param1.userInfo.userID,param1.userInfo.createTime,this.getUserInfoBack,true);
         this.addEvent();
      }
      
      public function refreshUserInfo() : void
      {
         UserInfoManager.getSimpleInfo(this._info.userInfo.userID,this._info.userInfo.createTime,this.getUserInfoBack,true);
      }
      
      private function addEvent() : void
      {
         this._headIcoMc.addEventListener(MouseEvent.CLICK,this.clickHeadIcoHandler);
         UserInfoManager.ed.addEventListener(UserEvent.HP_CHANGE,this.userHpChangeHandler);
         UserInfoManager.ed.addEventListener(UserEvent.MP_CHANGE,this.userMpChangeHandler);
         UserInfoManager.ed.addEventListener(UserEvent.GROW_CHANGE,this.userGrowChangeHandler);
      }
      
      private function removeEvent() : void
      {
         this._headIcoMc.removeEventListener(MouseEvent.CLICK,this.clickHeadIcoHandler);
         UserInfoManager.ed.removeEventListener(UserEvent.HP_CHANGE,this.userHpChangeHandler);
         UserInfoManager.ed.removeEventListener(UserEvent.MP_CHANGE,this.userMpChangeHandler);
         UserInfoManager.ed.removeEventListener(UserEvent.GROW_CHANGE,this.userGrowChangeHandler);
      }
      
      private function userHpChangeHandler(param1:UserEvent) : void
      {
         var _loc2_:UserInfo = param1.data as UserInfo;
         if(_loc2_.userID == this._info.userInfo.userID)
         {
            this._hpTxt.text = _loc2_.hp + "/" + _loc2_.maxHp;
            this.hpRect.width = _loc2_.hp / _loc2_.maxHp * this.hpRectWidth;
            this._hpBar.scrollRect = this.hpRect;
         }
      }
      
      private function userMpChangeHandler(param1:UserEvent) : void
      {
         var _loc2_:UserInfo = param1.data as UserInfo;
         if(_loc2_.userID == this._info.userInfo.userID)
         {
            this._mpTxt.text = _loc2_.mp + "/" + _loc2_.maxMp;
            this.mpRect.width = _loc2_.mp / _loc2_.maxMp * this.mpRectWidth;
            this._mpBar.scrollRect = this.mpRect;
         }
      }
      
      private function userGrowChangeHandler(param1:UserEvent) : void
      {
         var _loc2_:UserInfo = param1.data as UserInfo;
         if(_loc2_.userID == this._info.userInfo.userID)
         {
            this._lvTxt.text = String(_loc2_.lv);
         }
      }
      
      private function clickLeaveBtnHandler(param1:MouseEvent) : void
      {
         AlertManager.showSimpleAnswer(TextFormatUtil.substitute(ModuleLanguageDefine.FIGHT_GROUP_MSG[8],this._info.userInfo.nick),this.leaveGroup);
      }
      
      private function leaveGroup() : void
      {
         FightGroupManager.instance.leaveGroup(this._info.userInfo.userID,this._info.userInfo.createTime);
      }
      
      private function clickHeadIcoHandler(param1:MouseEvent) : void
      {
         var _loc2_:Point = new Point(0,this.height - 13);
         GroupHeadNavigatePanel.instance.showNavigate(this._info,localToGlobal(_loc2_));
         param1.stopImmediatePropagation();
      }
      
      private function getUserInfoBack(param1:UserInfo) : void
      {
         if(this._info == null)
         {
            return;
         }
         this._info.userInfo.hp = param1.hp;
         this._info.userInfo.mp = param1.mp;
         this._info.userInfo.nick = param1.nick;
         this._info.userInfo.roleType = param1.roleType;
         this._lvTxt.text = String(this._info.userInfo.lv);
         this._nameTxt.text = this._info.userInfo.nick;
         this._hpTxt.text = String(this._info.userInfo.hp);
         this.hpRect.width = this.hpRectWidth;
         this._hpBar.scrollRect = this.hpRect;
         this._mpTxt.text = String(this._info.userInfo.mp);
         this.mpRect.width = this.mpRectWidth;
         this._mpBar.scrollRect = this.mpRect;
         SwfCache.getSwfInfo(ClientConfig.getRoleIcon(this._info.userInfo.roleType),this.onLoadCompleteHandler);
      }
      
      private function onLoadCompleteHandler(param1:SwfInfo) : void
      {
         var _loc2_:Sprite = param1.content as Sprite;
         _loc2_.y = 5;
         _loc2_.x = 4;
         _loc2_.scaleX = _loc2_.scaleY = 0.4;
         this._headIcoMc.addChild(_loc2_);
      }
      
      public function setItemState() : void
      {
      }
      
      public function destory() : void
      {
         ToolTipManager.remove(this._mainUI.fightGroupIcoMc);
         this.removeEvent();
         this._info = null;
      }
   }
}

