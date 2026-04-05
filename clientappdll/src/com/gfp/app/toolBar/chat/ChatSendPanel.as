package com.gfp.app.toolBar.chat
{
   import com.gfp.app.InputCommand;
   import com.gfp.app.emotion.EmotionPanel;
   import com.gfp.app.quickWord.QuickWord;
   import com.gfp.app.systems.ClientTempState;
   import com.gfp.core.CommandID;
   import com.gfp.core.Constant;
   import com.gfp.core.behavior.ChatBehavior;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.events.ChatEvent;
   import com.gfp.core.events.DataEvent;
   import com.gfp.core.events.ItemLinkEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.info.ChatInfo;
   import com.gfp.core.language.ModuleLanguageDefine;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.BuyMallItemManager;
   import com.gfp.core.manager.FocusManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.MessageManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.TextUtil;
   import com.gfp.core.utils.TimeUtil;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   import flash.utils.clearInterval;
   import flash.utils.clearTimeout;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.net.SocketEvent;
   
   public class ChatSendPanel extends Sprite
   {
      
      private var _mainUI:UI_Multi_Chat_Send_Panel;
      
      private var _sendText:TextField;
      
      private var _sendBtn:SimpleButton;
      
      private var _quickWordBtn:SimpleButton;
      
      private var _emotionBtn:SimpleButton;
      
      private var _isSend:Boolean = true;
      
      private var _chatChageChannelPanel:ChatChageChannelPanel;
      
      private var _toggleBtn:SimpleButton;
      
      private var _numMc:MovieClip;
      
      private var _numTxt:TextField;
      
      private var _index:int = -1;
      
      private var timer:uint;
      
      private var isFlaping:Boolean = true;
      
      private var keyDownNum:int = 0;
      
      private var timer2:int;
      
      private var _prevChatTime:Number;
      
      public function ChatSendPanel()
      {
         super();
         this._mainUI = new UI_Multi_Chat_Send_Panel();
         addChild(this._mainUI);
         this.initView();
      }
      
      private function initView() : void
      {
         this._sendBtn = this._mainUI.inputBtn;
         this._quickWordBtn = this._mainUI.quickWordBtn;
         this._emotionBtn = this._mainUI.emotionBtn;
         this._toggleBtn = this._mainUI.toggleBtn;
         this._numMc = this._mainUI["numMc"];
         this._numTxt = this._numMc["numTxt"];
         ToolTipManager.add(this._emotionBtn,"表情");
         ToolTipManager.add(this._quickWordBtn,"快捷语言");
         ToolTipManager.add(this._sendBtn,"发送",300);
         this._sendText = this._mainUI.inputTxt;
         this._sendText.maxChars = 50;
         this._chatChageChannelPanel = new ChatChageChannelPanel();
         this._chatChageChannelPanel.x = 6;
         this._chatChageChannelPanel.y = 297;
         addChild(this._chatChageChannelPanel);
         this.initEvent();
      }
      
      public function updateNum(param1:int) : void
      {
         this._numTxt.text = param1.toString();
         if(param1 == 0)
         {
            this._numMc.visible = false;
         }
         else
         {
            this._numMc.visible = true;
         }
      }
      
      public function setChannel(param1:int) : void
      {
         this._chatChageChannelPanel.currentType = param1;
         FocusManager.setFocus(this._sendText);
      }
      
      private function initEvent() : void
      {
         this._sendText.addEventListener(FocusEvent.FOCUS_OUT,this.onFChange);
         this._quickWordBtn.addEventListener(MouseEvent.CLICK,this.onQuickWordBtnClick);
         this._emotionBtn.addEventListener(MouseEvent.CLICK,this.onEmotionBtnClick);
         this._sendBtn.addEventListener(MouseEvent.CLICK,this.onSendBtnClick);
         this._toggleBtn.addEventListener(MouseEvent.CLICK,this.onToggleClick);
         ItemManager.addListener(ItemLinkEvent.ITEM_LINK,this.onLink);
         this.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         EmotionPanel.addEventListener(DataEvent.DATA_UPDATE,this.onEmotionData);
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitch);
      }
      
      private function onMapSwitch(param1:MapEvent) : void
      {
         this._chatChageChannelPanel.updateTurnnelNum();
      }
      
      protected function onFChange(param1:Event) : void
      {
         this._index = -1;
      }
      
      private function onKeyUp(param1:KeyboardEvent) : void
      {
         if(param1.keyCode != 38 && param1.keyCode != 40)
         {
            return;
         }
         clearTimeout(this.timer);
         clearInterval(this.timer2);
         this.isFlaping = false;
         --this.keyDownNum;
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode != 38 && param1.keyCode != 40 || this.keyDownNum > 0)
         {
            return;
         }
         this.isFlaping = true;
         ++this.keyDownNum;
         if(param1.keyCode == 38)
         {
            this.timer = setTimeout(this.onFlaping,1000,"up");
            ++this.index;
         }
         if(param1.keyCode == 40)
         {
            this.timer = setTimeout(this.onFlaping,1000,"down");
            --this.index;
         }
         this.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
      }
      
      private function onFlaping(param1:String) : void
      {
         clearTimeout(this.timer);
         if(this.isFlaping)
         {
            this.timer2 = setInterval(this.Flaping,333,param1);
            if(param1 == "up")
            {
               ++this.index;
            }
            if(param1 == "down")
            {
               --this.index;
            }
         }
      }
      
      private function Flaping(param1:String) : void
      {
         if(this.isFlaping)
         {
            if(param1 == "up")
            {
               ++this.index;
            }
            if(param1 == "down")
            {
               --this.index;
            }
         }
      }
      
      protected function onToggleClick(param1:MouseEvent) : void
      {
         MultiChatPanel.instance.toggle();
      }
      
      public function setIsChatOpen(param1:Boolean) : void
      {
         this._toggleBtn.visible = !param1;
      }
      
      public function ctrlEnterPress() : void
      {
         if(FocusManager.getFocus() == this._sendText)
         {
            this.onSendBtnClick(null);
         }
         else if(!(FocusManager.getFocus() is TextField))
         {
            FocusManager.setFocus(this._sendText);
            this.alpha = 1;
         }
      }
      
      private function onLink(param1:ItemLinkEvent) : void
      {
         this.addLink(param1.itemId);
      }
      
      public function canHide() : Boolean
      {
         if(FocusManager.getFocus() == this._sendText)
         {
            return false;
         }
         return true;
      }
      
      private function onSendBtnClick(param1:MouseEvent = null) : void
      {
         var _loc6_:String = null;
         var _loc7_:ChatInfo = null;
         FocusManager.setDefaultFocus();
         if(!this._isSend)
         {
            MultiChatPanel.instance.showSystemNotice("小侠士，累了吗？坐下休息会儿吧");
            return;
         }
         if(this._sendText.text == "")
         {
            MultiChatPanel.instance.showSystemNotice("小侠士，说点什么吧，不能发送空消息哦");
            return;
         }
         if(InputCommand.parse(this._sendText.text))
         {
            this._sendText.text = "";
            return;
         }
         if(!this.isCanSend())
         {
            return;
         }
         var _loc2_:Number = Number(TimeUtil.getSeverDateObject().time);
         if(this._chatChageChannelPanel.currentType == 0 && _loc2_ - this._prevChatTime < 3000)
         {
            _loc6_ = "<font color=\'" + Constant.MSG_PEOPLE_NICK_COLOR + "\'>小侠士，你说话太快了，请稍后试试</font>";
            _loc7_ = new ChatInfo(null);
            _loc7_.senderID = 0;
            _loc7_.msg = _loc6_;
            _loc7_.type = this._chatChageChannelPanel.currentType;
            _loc7_.toID = 0;
            MessageManager.dispatchEvent(new ChatEvent(ChatEvent.CHAT_COM,_loc7_));
            return;
         }
         this._prevChatTime = _loc2_;
         this._isSend = false;
         var _loc3_:String = this._sendText.htmlText;
         var _loc4_:String = this._sendText.text;
         var _loc5_:String = "";
         if(_loc4_ != "")
         {
            if(_loc3_.indexOf("TEXTFORMAT") == -1)
            {
               _loc3_ = "<TEXTFORMAT LEADING=\"2\">" + _loc3_ + "</TEXTFORMAT>";
            }
            _loc5_ = TextUtil.encodeChatMsg(_loc3_);
            _loc5_ = this.filterMsg(_loc5_);
            MainManager.actorModel.execBehavior(new ChatBehavior(this._chatChageChannelPanel.currentType,_loc5_));
            ClientTempState.LastWorld.unshift(_loc5_);
            this._sendText.text = "";
            this._sendText.htmlText = "";
            this._sendText.textColor = 16777215;
            setTimeout(this.setSendEbable,1000);
         }
         FocusManager.setDefaultFocus();
      }
      
      private function filterMsg(param1:String) : String
      {
         var _loc3_:int = 0;
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeUTFBytes(param1);
         if(_loc2_.length > 500)
         {
            param1 = param1.substr(0,100);
            _loc3_ = param1.lastIndexOf("[@");
            if(_loc3_ > 0)
            {
               param1 = param1.substr(0,_loc3_);
            }
         }
         return param1;
      }
      
      private function isCanSend() : Boolean
      {
         var _loc1_:String = null;
         if(this._chatChageChannelPanel.currentType == Constant.CHAT_TYPE_TRADE)
         {
            if(ItemManager.getItemCount(ItemXMLInfo.HAOJIAO_NOR) <= 0 && ItemManager.getItemCount(ItemXMLInfo.HAOJIAO_SHOP) <= 0)
            {
               AlertManager.showSimpleAlert(ModuleLanguageDefine.EXPRO_MESSS_ARR[1],this.alertBuyFun);
               return false;
            }
            return true;
         }
         if(this._chatChageChannelPanel.currentType == Constant.CHAT_TYPE_LABA)
         {
            if(ItemManager.getItemCount(1303031) <= 0 && ItemManager.getItemCount(1301212) <= 0)
            {
               _loc1_ = ModuleLanguageDefine.WORLD_MESSS_ARR[1];
               AlertManager.showSimpleAlert(_loc1_,this.alertBuyLaBaFun);
               return false;
            }
            return true;
         }
         return true;
      }
      
      private function alertBuyLaBaFun() : void
      {
         SocketConnection.addCmdListener(CommandID.BUY_MALL_ITEMS,this.onBuyItemSuccess);
         BuyMallItemManager.instance.buyItem(321934,1,1,1303031);
      }
      
      private function alertBuyFun() : void
      {
         SocketConnection.addCmdListener(CommandID.BUY_MALL_ITEMS,this.onBuyItemSuccess);
         BuyMallItemManager.instance.buyItem(320806,1,1,ItemXMLInfo.HAOJIAO_NOR);
      }
      
      private function onBuyItemSuccess(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.BUY_MALL_ITEMS,this.onBuyItemSuccess);
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         var _loc6_:uint = _loc2_.readUnsignedInt();
         var _loc7_:uint = _loc2_.readUnsignedInt();
         ItemManager.addItem(_loc6_,_loc7_);
         if(_loc6_ == 1303031)
         {
            AlertManager.showSimpleAlert(ModuleLanguageDefine.WORLD_MESSS_ARR[3],this.onSendBtnClick);
         }
         else
         {
            AlertManager.showSimpleAlert(ModuleLanguageDefine.EXPRO_MESSS_ARR[3],this.onSendBtnClick);
         }
      }
      
      private function setSendEbable() : void
      {
         this._isSend = true;
      }
      
      private function onEmotionBtnClick(param1:MouseEvent) : void
      {
         EmotionPanel.turn(param1.currentTarget as DisplayObject);
      }
      
      private function onEmotionData(param1:DataEvent) : void
      {
         var _loc2_:uint = uint(param1.data);
         this._sendText.appendText("<e>" + _loc2_ + "</e> ");
      }
      
      private function onQuickWordBtnClick(param1:MouseEvent) : void
      {
         QuickWord.instance.show(param1.currentTarget as DisplayObject);
      }
      
      public function addLink(param1:int) : void
      {
         var _loc2_:String = TextUtil.getCodeByItemId(param1);
         this._sendText.htmlText += TextUtil.decode(_loc2_);
         this._sendText.htmlText += "<font> </font>";
      }
      
      private function set index(param1:int) : void
      {
         if(param1 < ClientTempState.LastWorld.length && param1 >= 0)
         {
            this._index = param1;
            this._sendText.text = ClientTempState.LastWorld[this.index];
         }
      }
      
      private function get index() : int
      {
         return this._index;
      }
   }
}

