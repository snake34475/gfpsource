package com.gfp.app.im.ui
{
   import com.gfp.app.im.talk.TalkManager;
   import com.gfp.app.user.UserInfoController;
   import com.gfp.core.config.xml.NpcXMLInfo;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.RecentFriendManager;
   import com.gfp.core.manager.RelationManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.ui.VipIcon;
   import com.gfp.core.utils.FilterUtil;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import org.taomee.filter.ColorFilter;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.DisplayUtil;
   
   public class IMListItem extends Sprite
   {
      
      protected var _info:UserInfo;
      
      private var _mainUI:Sprite;
      
      protected var _txt:TextField;
      
      protected var _faceMc:MovieClip;
      
      protected var _nonoMc:Sprite;
      
      protected var _clickBtn:SimpleButton;
      
      protected var _talkMc:SimpleButton;
      
      protected var _blackMc:SimpleButton;
      
      protected var _delMc:SimpleButton;
      
      protected var _bgMc:Sprite;
      
      private var _vipLogo:VipIcon;
      
      public function IMListItem()
      {
         super();
         buttonMode = true;
         this._mainUI = this.getMainUI();
         this._txt = this._mainUI["txt"];
         this._faceMc = this._mainUI["faceMc"];
         this._talkMc = this._mainUI["talkMc"];
         this._clickBtn = this._mainUI["clickBtn"];
         this._bgMc = this._mainUI["bgMc"];
         this._nonoMc = this._mainUI["nonoMc"];
         this._blackMc = this._mainUI["blackMc"];
         this._delMc = this._mainUI["delMc"];
         this._mainUI.mouseEnabled = false;
         this._txt.mouseEnabled = false;
         this._nonoMc.visible = false;
         this._talkMc.visible = false;
         this._faceMc.mouseEnabled = false;
         this._faceMc.visible = false;
         this._bgMc.mouseEnabled = false;
         this._bgMc.visible = false;
         this._blackMc.visible = false;
         this._delMc.visible = false;
         addChild(this._mainUI);
      }
      
      protected function getMainUI() : Sprite
      {
         return UIManager.getSprite("IM_ListItem");
      }
      
      private function clickTeacherIcon(param1:MouseEvent) : void
      {
         if(MainManager.actorInfo.teacherID != 0)
         {
            AlertManager.showSimpleAlarm(AppLanguageDefine.IM_CHARACTER_COLLECTION[4]);
         }
      }
      
      private function clickStudentIcon(param1:MouseEvent) : void
      {
         if(MainManager.actorInfo.studentID != 0)
         {
            AlertManager.showSimpleAlarm(AppLanguageDefine.IM_CHARACTER_COLLECTION[5]);
         }
      }
      
      public function set info(param1:UserInfo) : void
      {
         this._info = param1;
         name = this._info.userID.toString();
         if(this._info.isVip)
         {
            this._nonoMc.visible = true;
         }
         else
         {
            this._nonoMc.visible = false;
         }
         if(this._info.serverID)
         {
            this._txt.textColor = 16777188;
            this._txt.filters = [FilterUtil.FILTER_SHADOW_TEXT];
            this._faceMc.filters = [];
            this._nonoMc.filters = [];
         }
         else
         {
            this._txt.textColor = 10066329;
            this._txt.filters = [];
            this._faceMc.filters = [ColorFilter.setGrayscale()];
            this._nonoMc.filters = [ColorFilter.setGrayscale()];
         }
         if(Boolean(RelationManager.isFriend(this._info.userID)) || this._info.userID == NpcXMLInfo.GF_HELPER_ID)
         {
            this._talkMc.visible = true;
            this._blackMc.visible = true;
            this._delMc.visible = true;
            ToolTipManager.add(this._talkMc,"聊天");
            ToolTipManager.add(this._blackMc,"加入黑名单");
            ToolTipManager.add(this._delMc,"删除好友");
            this._talkMc.addEventListener(MouseEvent.CLICK,this.onTalk);
            this._blackMc.addEventListener(MouseEvent.CLICK,this.onBlack);
            this._delMc.addEventListener(MouseEvent.CLICK,this.onDel);
         }
         else if(!RelationManager.isBlack(this._info.userID) && (Boolean(UserManager.contains(this._info.userID)) || Boolean(RecentFriendManager.isRecentFriend(this._info.userID))))
         {
            this._talkMc.visible = true;
            this._blackMc.visible = true;
            ToolTipManager.add(this._talkMc,"聊天");
            ToolTipManager.add(this._blackMc,"加入黑名单");
            this._blackMc.addEventListener(MouseEvent.CLICK,this.onBlack);
            this._talkMc.addEventListener(MouseEvent.CLICK,this.onTalk);
         }
         else if(RelationManager.isBlack(this._info.userID))
         {
            this._talkMc.visible = false;
            this._blackMc.visible = false;
            this._delMc.visible = true;
            ToolTipManager.add(this._delMc,"从黑名单中移除");
            this._delMc.addEventListener(MouseEvent.CLICK,this.onDelFromBlackHandler);
         }
         this._faceMc.visible = true;
         this._faceMc.gotoAndStop(this.info.roleType);
         if(this._info.userID == NpcXMLInfo.GF_HELPER_ID)
         {
            this._faceMc.gotoAndStop(9);
            this._txt.textColor = 16777188;
            this._txt.filters = [FilterUtil.FILTER_SHADOW_TEXT];
            this._blackMc.visible = false;
            this._delMc.visible = false;
         }
         if(this._info.userID != NpcXMLInfo.GF_HELPER_ID)
         {
            this._clickBtn.addEventListener(MouseEvent.CLICK,this.onClick);
         }
         if(!this._info.hasSimpleInfo)
         {
            this._txt.text = this._info.userID.toString();
            return;
         }
         if(this.info.isVip)
         {
            this._txt.htmlText = "<font color=\"#FF0000\">" + this._info.nick + "</font>";
         }
         else
         {
            this._txt.text = this._info.nick;
         }
      }
      
      public function get info() : UserInfo
      {
         return this._info;
      }
      
      public function get hitMouseArea() : SimpleButton
      {
         return this._clickBtn;
      }
      
      public function get online() : Boolean
      {
         return this._info.serverID != 0;
      }
      
      public function clear() : void
      {
         this._info = null;
         this._txt.text = "";
         this._talkMc.visible = false;
         this._faceMc.visible = false;
         this._nonoMc.visible = false;
         this._blackMc.visible = false;
         this._delMc.visible = false;
         ToolTipManager.remove(this._talkMc);
         ToolTipManager.remove(this._blackMc);
         ToolTipManager.remove(this._delMc);
         if(this._vipLogo)
         {
            DisplayUtil.removeForParent(this._vipLogo);
            this._vipLogo = null;
         }
         this._clickBtn.removeEventListener(MouseEvent.CLICK,this.onClick);
         this._talkMc.removeEventListener(MouseEvent.CLICK,this.onTalk);
         this._blackMc.removeEventListener(MouseEvent.CLICK,this.onBlack);
         this._delMc.removeEventListener(MouseEvent.CLICK,this.onDel);
         this._delMc.removeEventListener(MouseEvent.CLICK,this.onDelFromBlackHandler);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         UserInfoController.showForInfo(this._info);
      }
      
      protected function onTalk(param1:MouseEvent) : void
      {
         TalkManager.showTalkPanel(this._info.userID,this._info.createTime,true);
      }
      
      protected function onBlack(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         AlertManager.showSimpleAlert(AppLanguageDefine.USERINFO_CHARACTER_COLLECTION[10] + this._info.nick + "(" + this._info.userID + AppLanguageDefine.USERINFO_CHARACTER_COLLECTION[11],function():void
         {
            RelationManager.addBlack(_info.userID);
         });
      }
      
      protected function onDel(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         AlertManager.showSimpleAlert(AppLanguageDefine.USERINFO_CHARACTER_COLLECTION[12] + this._info.nick + "(" + this._info.userID + AppLanguageDefine.USERINFO_CHARACTER_COLLECTION[13],function():void
         {
            RelationManager.removeFriend(_info.userID);
         });
      }
      
      protected function onDelFromBlackHandler(param1:MouseEvent) : void
      {
         var event:MouseEvent = param1;
         AlertManager.showSimpleAlert("确定要把" + this._info.nick + "(" + this._info.userID + ")从黑名单中移除吗？",function():void
         {
            RelationManager.removeBlack(_info.userID);
         });
      }
   }
}

