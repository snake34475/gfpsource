package com.gfp.app.toolBar.chat
{
   import com.gfp.core.Constant;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.ChatEvent;
   import com.gfp.core.events.DataEvent;
   import com.gfp.core.info.ChatInfo;
   import com.gfp.core.manager.KeyManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.MessageManager;
   import com.gfp.core.utils.TextUtil;
   import com.greensock.TweenLite;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class MultiChatPanel extends Sprite
   {
      
      private static var _instance:MultiChatPanel;
      
      public static var POSITION_CHANGE:String = "postion_change";
      
      private var _mainUI:Sprite;
      
      private var _chatSendPanel:ChatSendPanel;
      
      private var _chatInfoPanel:ChatInfoPanel;
      
      private var _isShowChatPanel:Boolean;
      
      private var _noLayout:Boolean;
      
      public function MultiChatPanel()
      {
         super();
         this._mainUI = new Sprite();
         this._chatInfoPanel = new ChatInfoPanel();
         this._chatSendPanel = new ChatSendPanel();
         new RandomSystemInfo();
         addChild(this._mainUI);
         this._mainUI.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         this._mainUI.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         this._chatInfoPanel.addEventListener(Event.CHANGE,this.onChatNumChange);
         KeyManager.addEventListener(KeyManager.ENTER_PRESS,this.onCtrlEnterPress);
         this._isShowChatPanel = false;
         if(MainManager.actorInfo.lv < 80)
         {
            this._isShowChatPanel = true;
         }
         this.toggle();
         this.onMouseOut(null);
      }
      
      public static function get instance() : MultiChatPanel
      {
         if(_instance == null)
         {
            _instance = new MultiChatPanel();
         }
         return _instance;
      }
      
      public static function addLink(param1:int) : void
      {
         instance.addLink(param1);
      }
      
      private function onCtrlEnterPress(param1:Event) : void
      {
         if(this._isShowChatPanel == false)
         {
            this.toggle();
         }
         else
         {
            this._chatSendPanel.ctrlEnterPress();
         }
      }
      
      private function onChatNumChange(param1:Event) : void
      {
         if(this._isShowChatPanel)
         {
            return;
         }
         this._chatSendPanel.updateNum(this._chatInfoPanel.num);
      }
      
      public function toggle() : void
      {
         this._isShowChatPanel = !this._isShowChatPanel;
         if(!this._chatInfoPanel.parent)
         {
            this._mainUI.addChild(this._chatInfoPanel);
            this._chatInfoPanel.y = -388;
         }
         this._chatInfoPanel.addChild(this._chatSendPanel);
         if(this._isShowChatPanel)
         {
            TweenLite.to(this._chatInfoPanel,1,{
               "x":4.75,
               "y":-388,
               "onUpdate":this.updatePosition,
               "onComplete":function():void
               {
                  _chatInfoPanel.closeBtnShow();
               }
            });
            this._chatSendPanel.updateNum(0);
         }
         else
         {
            TweenLite.to(this._chatInfoPanel,1,{
               "x":4.75 - 239.15,
               "onUpdate":this.updatePosition,
               "onComplete":function():void
               {
                  _chatSendPanel.updateNum(_chatInfoPanel.num);
               }
            });
         }
         this._chatSendPanel.setIsChatOpen(this._isShowChatPanel);
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function updatePosition() : void
      {
         dispatchEvent(new DataEvent(POSITION_CHANGE,this._chatInfoPanel.x));
      }
      
      public function get isChatShow() : Boolean
      {
         return this._isShowChatPanel;
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         this._chatInfoPanel.hideBg();
         if(this._chatSendPanel.canHide() && this._isShowChatPanel)
         {
            TweenLite.to(this._chatSendPanel,1,{"alpha":0});
         }
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         this._chatInfoPanel.showBg();
         TweenLite.to(this._chatSendPanel,1,{"alpha":1});
      }
      
      private function layout() : void
      {
         this._mainUI.x = 0;
         this._mainUI.y = LayerManager.stageHeight - 40.55 - 10;
         this.updatePosition();
      }
      
      public function get view() : DisplayObject
      {
         return this._mainUI;
      }
      
      public function setSendChannel(param1:uint) : void
      {
         this._chatSendPanel.setChannel(param1);
      }
      
      public function destroy() : void
      {
         this._chatInfoPanel.destroy();
      }
      
      public function showSystemNotice(param1:String, param2:Boolean = true) : void
      {
         var _loc3_:ChatInfo = new ChatInfo(null);
         _loc3_.type = Constant.CHAT_TYPE_SYSTEM;
         _loc3_.msg = param2 ? TextUtil.decode(param1) : param1;
         MessageManager.dispatchEvent(new ChatEvent(ChatEvent.CHAT_COM,_loc3_));
      }
      
      private function addLink(param1:int) : void
      {
         this._chatSendPanel.addLink(param1);
      }
      
      public function get noLayout() : Boolean
      {
         return this._noLayout;
      }
      
      public function set noLayout(param1:Boolean) : void
      {
         this._noLayout = param1;
         if(this._noLayout)
         {
            StageResizeController.instance.unregister(this.layout);
         }
         else
         {
            StageResizeController.instance.register(this.layout);
            this.layout();
         }
      }
   }
}

