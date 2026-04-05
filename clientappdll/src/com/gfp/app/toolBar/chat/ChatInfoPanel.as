package com.gfp.app.toolBar.chat
{
   import com.gfp.app.chat.constant.ChatConstants;
   import com.gfp.app.chat.text.TextMixArea;
   import com.gfp.app.config.xml.DynamicActivityXMLInfo;
   import com.gfp.app.glory.HonorAchievePopPanel;
   import com.gfp.app.manager.ChatManager;
   import com.gfp.core.Constant;
   import com.gfp.core.action.TimeQueue;
   import com.gfp.core.action.mouse.MouseProcess;
   import com.gfp.core.events.ChatEvent;
   import com.gfp.core.events.GloryEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.ChatInfo;
   import com.gfp.core.info.HonorInfo;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.MessageManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.utils.ChatUtil;
   import com.gfp.core.utils.FilterUtil;
   import com.gfp.core.utils.PopUpUIManager;
   import com.gfp.core.utils.TextUtil;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.motion.Tween;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   import org.taomee.utils.MovieClipUtil;
   
   public class ChatInfoPanel extends Sprite
   {
      
      private static const CHAT_BUTTON_NAME:String = "chatType";
      
      private static const CLOSE_STATE:String = "close";
      
      private static const OPEN_STATE:String = "open";
      
      private static const HEIGHT_MIN:int = 60;
      
      private static const HEIGHT_STEP:int = 20;
      
      private static const HEIGHT_MAX:int = 350;
      
      private var _mainUI:UI_Multi_Chat_Info_Panel;
      
      private var _chatInfoText:TextMixArea;
      
      private var _tmf:TextFormat = new TextFormat();
      
      private var _selectChatChannelBtn:MovieClip;
      
      private var _currentDisplayType:int = 999;
      
      private var _tween:Tween;
      
      private var _currentState:String = "open";
      
      private var _isLockScorll:Boolean = false;
      
      private var _hasLinked:Boolean;
      
      private var _timeOutID_1:int;
      
      private var _lastPos:Point;
      
      private var _nowPos:Point;
      
      private var _timer:Timer;
      
      private var _bigSpeakerQueue:TimeQueue;
      
      private var _numMcs:Object;
      
      private var _chatNum:Object;
      
      private var _bigMc:MovieClip;
      
      private var _textField:TextField;
      
      private var defaultTextX:Number = 208;
      
      private var _num:int;
      
      private var noDispatch:Boolean = false;
      
      private var barMc:MovieClip;
      
      public function ChatInfoPanel()
      {
         super();
         this._chatNum = new Object();
         this._mainUI = new UI_Multi_Chat_Info_Panel();
         addChild(this._mainUI);
         this.initView();
         this.initEvent();
         this.initChannelBtn();
         this._hasLinked = false;
         this._lastPos = new Point();
         this._nowPos = new Point();
         this._bigSpeakerQueue = new TimeQueue(10000,this.handleBigSpeakerData,this.bigSpeakerComplete);
         this._bigMc = this._mainUI["bigMc"];
         this._bigMc.visible = false;
         this._timer = new Timer(15000);
         this._timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this._textField = this._mainUI["textField"];
         addEventListener(Event.ADDED_TO_STAGE,this.onAddToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveStage);
         this.updateNum();
      }
      
      protected function onTimer(param1:TimerEvent) : void
      {
         this._bigMc.visible = false;
         this._mainUI["maskMc"].x = 16;
         this._mainUI["maskMc"].width = 188;
         this._textField.htmlText = this.getRandomText();
         this._textField.x = this.defaultTextX;
         this._textField.autoSize = TextFieldAutoSize.LEFT;
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      protected function onEnterFrame(param1:Event) : void
      {
         --this._textField.x;
      }
      
      private function getRandomText() : String
      {
         return DynamicActivityXMLInfo.announcement[int(Math.random() * DynamicActivityXMLInfo.announcement.length)];
      }
      
      protected function onRemoveStage(param1:Event) : void
      {
         this._timer.stop();
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      protected function onAddToStage(param1:Event) : void
      {
         this._timer.start();
         this.onTimer(null);
      }
      
      private function handleBigSpeakerData(param1:ChatInfo) : void
      {
         if(stage)
         {
            this._timer.reset();
            this._timer.start();
            this.onTimer(null);
            this._textField.htmlText = param1.senderNickName + ":" + param1.msg;
            this._bigMc.visible = true;
            this._mainUI["maskMc"].x = 33;
            this._mainUI["maskMc"].width = 171;
         }
      }
      
      private function bigSpeakerComplete() : void
      {
         this._bigMc.visible = false;
      }
      
      private function initView() : void
      {
         this._chatInfoText = new TextMixArea(this._mainUI["scrollMc"],202,240);
         this._chatInfoText.mouseEnabled = false;
         this._chatInfoText.direction = TextMixArea.RIGHT;
         this._chatInfoText.x = 8;
         this._chatInfoText.y = 25;
         this._chatInfoText.maxParagraph = ChatConstants.BOX_VIEW_LINE;
         addChild(this._chatInfoText);
         this._mainUI.scrollMc.y -= 3;
      }
      
      private function initEvent() : void
      {
         MessageManager.addEventListener(ChatEvent.CHAT_COM,this.onChat);
         MessageManager.addEventListener(GloryEvent.HONOR_SHOW,this.onShowGlory);
         this._chatInfoText.addEventListener(TextEvent.LINK,this.onLink);
         this._mainUI.addEventListener(MouseEvent.MOUSE_UP,this.onStageDown);
         this._mainUI.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         this._chatInfoText.doubleClickEnabled = true;
         this._chatInfoText.addEventListener(MouseEvent.DOUBLE_CLICK,this.onStageDown);
         this._mainUI["closeBtn"].addEventListener(MouseEvent.CLICK,this.onCloseClick);
      }
      
      private function onCloseClick(param1:MouseEvent) : void
      {
         MultiChatPanel.instance.toggle();
         this._mainUI["closeBtn"].visible = false;
      }
      
      public function closeBtnShow() : void
      {
         this._mainUI["closeBtn"].visible = true;
      }
      
      protected function onMouseDown(param1:MouseEvent) : void
      {
         this._lastPos.x = param1.localX;
         this._lastPos.y = param1.localY;
      }
      
      private function onStageDown(param1:MouseEvent) : void
      {
         var _loc4_:* = undefined;
         if(!(param1.target is TextField))
         {
            return;
         }
         if(this._hasLinked)
         {
            return;
         }
         this._nowPos.x = param1.localX;
         this._nowPos.y = param1.localY;
         if(Point.distance(this._nowPos,this._lastPos) > 5)
         {
            return;
         }
         if(MapManager.currentMap.info.id == 1092001)
         {
            return;
         }
         if(!MapManager.currentMap.groundLevel.hasEventListener(MouseEvent.MOUSE_DOWN))
         {
            return;
         }
         var _loc2_:Number = Number(MapManager.currentMap.groundLevel.mouseX);
         var _loc3_:Number = Number(MapManager.currentMap.groundLevel.mouseY);
         if(param1)
         {
            _loc4_ = param1.target;
            if(_loc4_)
            {
               if(_loc4_["parent"] is UI_Multi_Chat_Info_Panel || _loc4_["name"] == "ChatSystemInfoText")
               {
                  this.forceGo(param1,_loc2_,_loc3_);
               }
            }
         }
      }
      
      private function forceGo(param1:MouseEvent, param2:Number, param3:Number) : void
      {
         var _loc4_:Point = new Point(param2,param3);
         if(MapManager.currentMap.isBlock(_loc4_))
         {
            return;
         }
         if(param1.type == MouseEvent.MOUSE_UP)
         {
            MouseProcess.execWalk(MainManager.actorModel,_loc4_);
         }
         else if(param1.type == MouseEvent.DOUBLE_CLICK)
         {
            MouseProcess.execRun(MainManager.actorModel,_loc4_);
         }
         var _loc5_:MovieClip = UIManager.getMovieClip("Effect_MouseDown");
         _loc5_.mouseEnabled = false;
         _loc5_.mouseChildren = false;
         MovieClipUtil.playEndAndRemove(_loc5_);
         _loc5_.x = _loc4_.x;
         _loc5_.y = _loc4_.y;
         MapManager.currentMap.root.addChild(_loc5_);
         MapManager.dispatchEvent(new MapEvent(MapEvent.MAP_MOUSE_DOWN,MapManager.currentMap));
      }
      
      private function onShow() : void
      {
         this._currentState = OPEN_STATE;
         this._mainUI.addChild(this._mainUI.scrollMc);
         this._mainUI.addChild(this._chatInfoText);
      }
      
      private function onClose() : void
      {
         this._currentState = CLOSE_STATE;
         DisplayUtil.removeForParent(this._mainUI.scrollMc);
         DisplayUtil.removeForParent(this._chatInfoText);
      }
      
      public function showBg() : void
      {
         TweenLite.to(this._mainUI["barMc"],1,{"alpha":1});
         TweenLite.to(this._mainUI["closeBtn"],1,{"alpha":1});
         TweenLite.to(this._mainUI["bgMc"],1,{"alpha":0.5});
         TweenLite.to(this._mainUI["scrollMc"],1,{"alpha":1});
         TweenLite.to(this._mainUI["wbBgMc"],1,{"alpha":1});
      }
      
      public function hideBg() : void
      {
         TweenLite.to(this._mainUI["barMc"],1,{"alpha":0});
         TweenLite.to(this._mainUI["closeBtn"],1,{"alpha":0});
         TweenLite.to(this._mainUI["scrollMc"],1,{"alpha":0});
         TweenLite.to(this._mainUI["bgMc"],1,{"alpha":0.25});
         TweenLite.to(this._mainUI["wbBgMc"],1,{"alpha":0.25});
      }
      
      private function initChannelBtn() : void
      {
         var _loc3_:MovieClip = null;
         this.barMc = this._mainUI["barMc"];
         var _loc1_:int = this.barMc.numChildren;
         this._numMcs = new Object();
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.barMc.getChildAt(_loc2_) as MovieClip;
            _loc3_.addEventListener(MouseEvent.CLICK,this.onChatChannelClick);
            _loc3_.gotoAndStop(1);
            if(_loc3_["numMc"])
            {
               this._numMcs[_loc3_.name.split("_").pop()] = _loc3_["numMc"];
            }
            _loc2_++;
         }
         this._selectChatChannelBtn = this.barMc.getChildByName(CHAT_BUTTON_NAME + "_" + 999) as MovieClip;
         this._selectChatChannelBtn.gotoAndStop(2);
         UserManager.addEventListener(UserEvent.CHANGCHANNEL,this.onChangeChannel);
      }
      
      private function onChangeChannel(param1:UserEvent) : void
      {
         if(param1.data.isInfoDispatch == true)
         {
            return;
         }
         var _loc2_:int = int(param1.data.type);
         var _loc3_:MovieClip = this.barMc.getChildByName("chatType_" + (_loc2_ - 10)) as MovieClip;
         if(_loc3_ != null)
         {
            _loc3_.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            this.noDispatch = true;
         }
      }
      
      private function onLockBtnClick(param1:MouseEvent) : void
      {
         this._isLockScorll = !this._isLockScorll;
         var _loc2_:int = this._isLockScorll ? 2 : 1;
         this._mainUI.lockBtn.gotoAndStop(_loc2_);
         this._chatInfoText.lockScroll = this._isLockScorll;
         if(this._isLockScorll)
         {
            this._mainUI.lockBtn.filters = FilterUtil.GRAY_FILTER;
         }
         else
         {
            this._mainUI.lockBtn.filters = null;
         }
      }
      
      private function onClearBtnClick(param1:MouseEvent) : void
      {
         this._chatInfoText.text = "";
         ChatManager.clearBox(this._currentDisplayType);
      }
      
      private function onSubBtnClick(param1:MouseEvent) : void
      {
         if(this._chatInfoText.height > HEIGHT_MIN)
         {
            this.subChatInfoTextHeight(HEIGHT_STEP);
         }
         else
         {
            this.onClose();
         }
      }
      
      private function subChatInfoTextHeight(param1:int) : void
      {
         this._chatInfoText.height -= param1;
         this._chatInfoText.y += param1;
         this._mainUI.scrollMc.y += param1;
      }
      
      public function setChatInfoTextToMin() : void
      {
      }
      
      private function onChatChannelClick(param1:MouseEvent) : void
      {
         var _loc5_:int = 0;
         var _loc6_:Vector.<ChatInfo> = null;
         var _loc2_:String = param1.currentTarget.name;
         var _loc3_:int = _loc2_.indexOf(CHAT_BUTTON_NAME);
         var _loc4_:int = parseInt(_loc2_.split("_")[1]);
         if(this.noDispatch == false)
         {
            if([0,7,2].indexOf(_loc4_) != -1)
            {
               UserManager.dispatchEvent(new UserEvent(UserEvent.CHANGCHANNEL,{
                  "type":_loc4_,
                  "isChannelDispatch":false,
                  "isInfoDispatch":true
               }));
            }
         }
         this.noDispatch = false;
         if(_loc3_ != -1)
         {
            this._selectChatChannelBtn.gotoAndStop(1);
            this._selectChatChannelBtn = param1.currentTarget as MovieClip;
            this._selectChatChannelBtn.gotoAndStop(2);
            _loc5_ = int(_loc2_.split("_")[1]);
            this._chatNum[_loc5_] = 0;
            this.updateNum();
            this._currentDisplayType = _loc5_;
            _loc6_ = ChatManager.getBoxs(this._currentDisplayType);
            if(_loc6_ == null || _loc6_.length == 0)
            {
               this._chatInfoText.clearText();
               return;
            }
            this._chatInfoText.text = TextUtil.getBoxHtmlMore(_loc6_);
         }
      }
      
      private function updateNum() : void
      {
         var _loc1_:Object = null;
         this._num = 0;
         for(_loc1_ in this._numMcs)
         {
            if(int(this._chatNum[_loc1_]) == 0)
            {
               this._numMcs[_loc1_].visible = false;
            }
            else
            {
               this._numMcs[_loc1_].visible = true;
               this._numMcs[_loc1_]["numTxt"].text = int(this._chatNum[_loc1_]).toString();
               this._num += this._chatNum[_loc1_];
            }
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function onLink(param1:TextEvent) : void
      {
         var event:TextEvent = param1;
         ChatUtil.charProcess(event.text);
         this._hasLinked = true;
         this._timeOutID_1 = setTimeout(function():void
         {
            _hasLinked = false;
         },1000);
      }
      
      private function onShowGlory(param1:GloryEvent) : void
      {
         var _loc2_:HonorInfo = new HonorInfo();
         _loc2_.id = param1.id;
         _loc2_.creatTime = param1.creatTime;
         var _loc3_:HonorAchievePopPanel = new HonorAchievePopPanel(_loc2_);
         PopUpUIManager.showFor(_loc3_,null,AlignType.BOTTOM_CENTER,0,-85);
      }
      
      private function onChat(param1:ChatEvent) : void
      {
         var _loc2_:ChatInfo = param1.info;
         var _loc3_:String = _loc2_.msg;
         ChatManager.addBox(_loc2_);
         this.onSay(_loc2_);
      }
      
      private function onSay(param1:ChatInfo) : void
      {
         if(!param1)
         {
            return;
         }
         if(param1.senderID == MainManager.actorInfo.userID)
         {
            MainManager.actorModel.showBox(param1.msg);
         }
         var _loc2_:String = TextUtil.decodeChatMsg(param1) + "<br/>";
         if(param1.type != Constant.CHAT_TYPE_SYSTEM)
         {
            if(param1.type == Constant.CHAT_TYPE_SUPER_TRADE)
            {
               this._bigSpeakerQueue.addQueue(param1);
            }
            else if(param1.type == this._currentDisplayType || this._currentDisplayType == Constant.CHAT_TYPE_ALL)
            {
               this.addChatInfoDisplay(_loc2_);
            }
         }
         if(Boolean(this.stage) && this._currentDisplayType == param1.type)
         {
            return;
         }
         if(param1.senderID == MainManager.actorInfo.userID)
         {
            return;
         }
         this._chatNum[param1.type] = int(this._chatNum[param1.type]) + 1;
         this.updateNum();
      }
      
      private function addChatInfoDisplay(param1:String) : void
      {
         this._chatInfoText.appendText(param1);
      }
      
      public function destroy() : void
      {
         this._mainUI.removeEventListener(MouseEvent.MOUSE_UP,this.onStageDown);
         this._chatInfoText.removeEventListener(MouseEvent.DOUBLE_CLICK,this.onStageDown);
         this._chatInfoText.removeEventListener(TextEvent.LINK,this.onLink);
         this._chatInfoText.dispose();
         this._chatInfoText = null;
         MessageManager.removeEventListener(ChatEvent.CHAT_COM,this.onChat);
         MessageManager.removeEventListener(GloryEvent.HONOR_SHOW,this.onShowGlory);
         this._mainUI["closeBtn"].removeEventListener(MouseEvent.CLICK,this.onCloseClick);
         clearTimeout(this._timeOutID_1);
      }
      
      public function get num() : int
      {
         return this._num;
      }
   }
}

