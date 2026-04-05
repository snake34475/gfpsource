package com.gfp.app.im.talk
{
   import com.gfp.app.chat.constant.ChatConstants;
   import com.gfp.app.chat.text.TextMixArea;
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.user.MoreUserInfoController;
   import com.gfp.app.user.UserHeadShow;
   import com.gfp.app.user.UserInfoController;
   import com.gfp.core.behavior.ChatBehavior;
   import com.gfp.core.config.xml.NpcXMLInfo;
   import com.gfp.core.events.ChatEvent;
   import com.gfp.core.events.CutBmpEvent;
   import com.gfp.core.events.DataEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.ChatInfo;
   import com.gfp.core.info.OnLineInfo;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.FocusManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.MessageManager;
   import com.gfp.core.manager.RecentFriendManager;
   import com.gfp.core.manager.UserInfoManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.ui.ExtenalUIPanel;
   import com.gfp.core.ui.VipIcon;
   import com.gfp.core.uic.UIPanel;
   import com.gfp.core.utils.ColorConstantUtil;
   import com.gfp.core.utils.TextUtil;
   import com.gfp.core.utils.WebURLUtil;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.filter.ColorFilter;
   import org.taomee.manager.EventManager;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class TalkPanel extends UIPanel
   {
      
      private static const EXP_MAX_TIME:int = 2000;
      
      public static const IMG_LINK:String = "http://114.80.98.83:80/";
      
      private var _info:UserInfo;
      
      private var _userID:uint;
      
      private var _isOnLine:Boolean;
      
      private var _titleTxt:TextField;
      
      private var _sendBtn:SimpleButton;
      
      private var _inputTxt:TextField;
      
      private var _wordTxt:TextMixArea;
      
      private var _emotionBtn:SimpleButton;
      
      private var _showYou:UserHeadShow;
      
      private var _showMe:UserHeadShow;
      
      private var _meBtn:SimpleButton;
      
      private var _youBtn:SimpleButton;
      
      private var _cutBmpBtn:SimpleButton;
      
      private var _nonoYou:Sprite;
      
      private var _nonoMe:Sprite;
      
      private var _emotionPanel:TEmotionPanel;
      
      private var _expMe:MovieClip;
      
      private var _expYou:MovieClip;
      
      private var _outTimeMe:uint;
      
      private var _outTimeYou:uint;
      
      private var _logoMe:VipIcon;
      
      private var _logoYou:VipIcon;
      
      private var wanTongTongMc:ExtenalUIPanel;
      
      private var _isSend:Boolean = false;
      
      public function TalkPanel()
      {
         super(new Talk_MainPanel());
         this._sendBtn = _mainUI["sendBtn"];
         this._inputTxt = _mainUI["writeTxt"];
         this._titleTxt = _mainUI["titleTxt"];
         this._wordTxt = new TextMixArea(_mainUI,238.15,169.55);
         this._wordTxt.direction = TextMixArea.RIGHT;
         this._wordTxt.x = 38.8;
         this._wordTxt.y = 58.45;
         this._wordTxt.maxParagraph = ChatConstants.BOX_VIEW_LINE;
         _mainUI.addChild(this._wordTxt);
         this._emotionBtn = _mainUI["emotionBtn"];
         this._meBtn = _mainUI["meBtn"];
         this._youBtn = _mainUI["youBtn"];
         this._cutBmpBtn = _mainUI["cutBmpBtn"];
         addChild(_mainUI);
         this._cutBmpBtn.visible = false;
         this._inputTxt.maxChars = 130;
         this._showYou = new UserHeadShow();
         this._showMe = new UserHeadShow();
         this._showYou.mouseEnabled = false;
         this._showYou.mouseChildren = false;
         this._showMe.mouseEnabled = false;
         this._showMe.mouseChildren = false;
         this._showYou.x = 371;
         this._showYou.y = 139;
         this._showYou.scaleX = 1.25;
         this._showYou.scaleY = 1.25;
         this._showMe.x = 371;
         this._showMe.y = 300;
         this._showMe.scaleX = 1.25;
         this._showMe.scaleY = 1.25;
         addChild(this._showYou);
         addChild(this._showMe);
      }
      
      override public function show(param1:DisplayObjectContainer = null) : void
      {
         super.show(param1);
         DisplayUtil.align(this,null,AlignType.MIDDLE_CENTER);
         this.x -= 50;
         this._inputTxt.text = "";
         FocusManager.setFocus(this._inputTxt);
      }
      
      public function init(param1:uint, param2:uint) : void
      {
         var _loc3_:ChatInfo = null;
         this._userID = param1;
         this._showMe.setInfo(MainManager.actorInfo);
         if(MainManager.actorInfo.isVip)
         {
            this._logoMe = new VipIcon(MainManager.actorInfo);
            this._logoMe.scaleX = this._logoMe.scaleY = 20 / this._logoMe.height;
            this._logoMe.x = 397;
            this._logoMe.y = 235;
            addChild(this._logoMe);
         }
         this.removeEvent();
         this._emotionBtn.visible = true;
         if(this._userID != NpcXMLInfo.GF_HELPER_ID)
         {
            UserInfoManager.getSimpleInfo(this._userID,param2,this.onInfo,true);
         }
         else
         {
            this._emotionBtn.visible = false;
            this._info = new UserInfo();
            this._info.userID = this._userID;
            this._info.nick = "万通通";
            this._titleTxt.htmlText = "与" + this._info.nick + "通话中";
            this._showYou.setInfo(this._info);
            this.addEvent();
            this.addTalkEventListener();
            this.initMsg();
            _loc3_ = new ChatInfo(null);
            _loc3_.senderNickName = this._info.nick;
            _loc3_.msg = "<font color=\'#" + ColorConstantUtil.TALK_TEXT_COLOR + "\'>小侠士你好，请问你有什么问题吗？</font>";
            this._wordTxt.appendText(TextUtil.getSecretlyHtml(_loc3_));
            this.wanTongTongMc = new ExtenalUIPanel("wan_tong_tong");
            addChild(this.wanTongTongMc);
            swapChildren(this.wanTongTongMc,this._showYou);
            this._showYou.visible = false;
            this.wanTongTongMc.x = 338;
            this.wanTongTongMc.y = 103;
            _mainUI["youName_txt"].text = "万通通";
            this._wordTxt.addEventListener(TextEvent.LINK,this.linkTextHandler);
         }
      }
      
      private function linkTextHandler(param1:TextEvent) : void
      {
         if(param1.text == "helpFromGfp")
         {
            WebURLUtil.intance.navigateService();
         }
      }
      
      override public function hide() : void
      {
         super.hide();
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(this.wanTongTongMc)
         {
            this.wanTongTongMc.destory();
         }
         this.removeExpMe();
         this.removeExpYou();
         this._showYou.destroy();
         if(this._logoYou)
         {
            this._logoYou.destroy();
         }
         this._showMe.destroy();
         if(this._logoMe)
         {
            this._logoMe.destroy();
         }
         this._wordTxt.removeEventListener(TextEvent.LINK,this.linkTextHandler);
         this._wordTxt.dispose();
         this._info = null;
         this._sendBtn = null;
         this._inputTxt = null;
         this._titleTxt = null;
         this._wordTxt = null;
         this._showMe = null;
         this._showYou = null;
         this._cutBmpBtn = null;
         this._nonoYou = null;
         this._nonoMe = null;
      }
      
      private function onInfo(param1:UserInfo) : void
      {
         this._info = param1;
         UserInfoManager.seeOnLine([this._userID],this.onInitOnLine);
         this._showYou.setInfo(this._info);
         if(this._info.isVip)
         {
            this._logoYou = new VipIcon(this._info);
            this._logoYou.scaleX = this._logoYou.scaleY = 20 / this._logoYou.height;
            this._logoYou.x = 395;
            this._logoYou.y = 73;
            addChild(this._logoYou);
         }
         this.addEvent();
         this.addTalkEventListener();
         this.initMsg();
      }
      
      private function onInitOnLine(param1:Array) : void
      {
         var _loc2_:OnLineInfo = null;
         if(param1.length > 0)
         {
            _loc2_ = param1[0];
            this._info.serverID = _loc2_.serverID;
            if(this._info.serverID == MainManager.actorInfo.serverID)
            {
               this._isOnLine = true;
            }
            this._showYou.filters = [];
         }
         else
         {
            this._isOnLine = true;
            this._showYou.filters = [ColorFilter.setGrayscale(),ColorFilter.setBrightness(50)];
         }
         this.setTitleTxt(this._info);
      }
      
      private function setTitleTxt(param1:UserInfo) : void
      {
         if(this._isOnLine)
         {
            this._titleTxt.htmlText = "<a href=\'event:\'>与好友" + param1.nick + "(" + param1.userID + ")通话中</a>";
         }
         else
         {
            this._titleTxt.htmlText = "<a href=\'event:\'>与" + param1.serverID + ".服务器的" + param1.nick + "(" + param1.userID + ")通话中</a>";
         }
      }
      
      private function initMsg() : void
      {
         var _loc2_:ChatInfo = null;
         var _loc1_:Array = MessageManager.getChatInfo(this._userID);
         if(_loc1_ != null)
         {
            this._wordTxt.text = "";
            for each(_loc2_ in _loc1_)
            {
               this.wordChange(_loc2_);
            }
         }
      }
      
      override protected function addEvent() : void
      {
         super.addEvent();
         this._sendBtn.addEventListener(MouseEvent.CLICK,this.onSendMsg);
         this._inputTxt.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         this._inputTxt.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         this._emotionBtn.addEventListener(MouseEvent.CLICK,this.onEmotion);
         this._meBtn.addEventListener(MouseEvent.CLICK,this.onMeShow);
         this._youBtn.addEventListener(MouseEvent.CLICK,this.onYouShow);
         this._titleTxt.addEventListener(TextEvent.LINK,this.onYouShow);
         this._cutBmpBtn.addEventListener(MouseEvent.CLICK,this.onCutMap);
         ToolTipManager.add(this._emotionBtn,"发送表情");
         ToolTipManager.add(this._cutBmpBtn,"截图");
      }
      
      private function addTalkEventListener() : void
      {
         UserManager.addUserListener(UserEvent.NICK_CHANGE,this._userID,this.onNickChange);
         MessageManager.addEventListener(ChatEvent.TALK + this._userID.toString(),this.onData);
      }
      
      private function removeTalkEventListener() : void
      {
         UserManager.removeUserListener(UserEvent.NICK_CHANGE,this._userID,this.onNickChange);
         MessageManager.removeEventListener(ChatEvent.TALK + this._userID.toString(),this.onData);
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         this._sendBtn.removeEventListener(MouseEvent.CLICK,this.onSendMsg);
         this._inputTxt.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         this._inputTxt.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         this._emotionBtn.removeEventListener(MouseEvent.CLICK,this.onEmotion);
         this._meBtn.removeEventListener(MouseEvent.CLICK,this.onMeShow);
         this._youBtn.removeEventListener(MouseEvent.CLICK,this.onYouShow);
         this._titleTxt.removeEventListener(TextEvent.LINK,this.onYouShow);
         this._cutBmpBtn.removeEventListener(MouseEvent.CLICK,this.onCutMap);
         ToolTipManager.remove(this._emotionBtn);
         ToolTipManager.remove(this._cutBmpBtn);
         this.removeTalkEventListener();
         EventManager.removeEventListener(CutBmpEvent.CUT_BMP_COMPLETE,this.onCutBmpHandler);
      }
      
      private function onNickChange(param1:UserEvent) : void
      {
         var _loc2_:UserInfo = param1.data;
         this._info.nick = _loc2_.nick;
         this.setTitleTxt(this._info);
      }
      
      private function wordChange(param1:ChatInfo) : void
      {
         if(param1.senderID == MainManager.actorID)
         {
            param1.senderNickName = MainManager.actorInfo.nick;
         }
         else
         {
            param1.senderNickName = this._info.nick;
         }
         if(param1.senderID == NpcXMLInfo.GF_HELPER_ID)
         {
            if(param1.msg == "no answer")
            {
               param1.msg = "<font size=\'14\' color=\'#D47400\'>小侠士，万通通不知道这个问题如何回答，你可以尽量缩短问题的字数或修改错别字后再次提问。如果仍然无法回答，你可以求助于</font><u><font color=\'#FF0000\'><a href=\'event:helpFromGfp\'>功夫派的客服</a></font></u><br/>";
            }
         }
         this._wordTxt.appendText(TextUtil.getSecretlyHtml(param1));
         param1.isRead = true;
      }
      
      private function addExpMe(param1:MovieClip) : void
      {
         var mc:MovieClip = param1;
         this._showMe.visible = false;
         this._expMe = mc;
         if(this._expMe)
         {
            this._expMe.x = 306;
            this._expMe.y = 255;
            this._expMe.scaleX = this._expMe.scaleY = 2.6;
            addChild(this._expMe);
            this._outTimeMe = setTimeout(function():void
            {
               _showMe.visible = true;
               DisplayUtil.removeForParent(_expMe);
               _expMe = null;
            },EXP_MAX_TIME);
         }
      }
      
      private function removeExpMe() : void
      {
         clearTimeout(this._outTimeMe);
         if(this._expMe)
         {
            this._showMe.visible = true;
            DisplayUtil.removeForParent(this._expMe);
            this._expMe = null;
         }
      }
      
      private function addExpYou(param1:MovieClip) : void
      {
         var mc:MovieClip = param1;
         this._showYou.visible = false;
         this._expYou = mc;
         if(this._expYou)
         {
            this._expYou.x = 306;
            this._expYou.y = 80;
            this._expYou.scaleX = this._expYou.scaleY = 3;
            addChild(this._expYou);
            this._outTimeYou = setTimeout(function():void
            {
               _showYou.visible = true;
               DisplayUtil.removeForParent(_expYou);
               _expYou = null;
            },EXP_MAX_TIME);
         }
      }
      
      private function removeExpYou() : void
      {
         clearTimeout(this._outTimeYou);
         if(this._expYou)
         {
            this._showYou.visible = true;
            DisplayUtil.removeForParent(this._expYou);
            this._expYou = null;
         }
      }
      
      private function onMeShow(param1:MouseEvent) : void
      {
         MoreUserInfoController.show(MainManager.actorInfo,LayerManager.uiLevel);
      }
      
      private function onYouShow(param1:Event) : void
      {
         if(this._info.userID == NpcXMLInfo.GF_HELPER_ID)
         {
            return;
         }
         UserInfoController.showForInfo(this._info);
      }
      
      private function onSendMsg(param1:Event) : void
      {
         if(this._inputTxt.text == "")
         {
            return;
         }
         MainManager.actorModel.execBehavior(new ChatBehavior(0,TextUtil.htmlEncode(this._inputTxt.text),this._userID));
         RecentFriendManager.addRecentFriend(this._userID);
         this._inputTxt.text = "";
         FocusManager.setFocus(this._inputTxt);
      }
      
      override protected function onClose(param1:MouseEvent) : void
      {
         TalkManager.closeTalkPanel(this._userID);
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            this._isSend = true;
            this._inputTxt.multiline = false;
            this._inputTxt.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         }
      }
      
      private function onKeyUp(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            this._inputTxt.multiline = true;
            this._inputTxt.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
            if(!this._isSend)
            {
               return;
            }
            this._isSend = false;
            if(this._inputTxt.text != "")
            {
               this.onSendMsg(null);
            }
         }
      }
      
      private function onData(param1:ChatEvent) : void
      {
         this.wordChange(param1.info);
      }
      
      private function onEmotion(param1:MouseEvent) : void
      {
         if(this._emotionPanel == null)
         {
            this._emotionPanel = new TEmotionPanel(this._info.userID);
            this._emotionPanel.addEventListener(DataEvent.DATA_UPDATE,this.onEmotionData);
         }
         if(DisplayUtil.hasParent(this._emotionPanel))
         {
            this._emotionPanel.hide();
         }
         else
         {
            this._emotionPanel.show(this._emotionBtn);
         }
      }
      
      private function onEmotionData(param1:DataEvent) : void
      {
         var _loc2_:uint = uint(param1.data);
         this._inputTxt.appendText("<e>" + _loc2_ + "</e> ");
      }
      
      private function onFight(param1:MouseEvent) : void
      {
         FightManager.instance.fightWithPlayer(this._info);
      }
      
      private function onCutMap(param1:MouseEvent) : void
      {
      }
      
      private function onCutBmpHandler(param1:CutBmpEvent) : void
      {
         EventManager.removeEventListener(CutBmpEvent.CUT_BMP_COMPLETE,this.onCutBmpHandler);
      }
   }
}

