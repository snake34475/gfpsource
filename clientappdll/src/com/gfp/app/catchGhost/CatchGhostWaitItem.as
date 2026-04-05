package com.gfp.app.catchGhost
{
   import com.gfp.app.im.talk.TalkManager;
   import com.gfp.app.manager.CatchBigGhostManager;
   import com.gfp.app.manager.FightGroupManager;
   import com.gfp.core.cache.SwfCache;
   import com.gfp.core.cache.SwfInfo;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.info.GroupUserInfo;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class CatchGhostWaitItem extends Sprite
   {
      
      private var _mainUI:Sprite;
      
      private var _groupUserInfo:GroupUserInfo;
      
      private var _isReadyMc:MovieClip;
      
      private var _lvTxt:TextField;
      
      private var _nameTxt:TextField;
      
      private var _inviteFightBtn:SimpleButton;
      
      private var _chatBtn:SimpleButton;
      
      public function CatchGhostWaitItem(param1:GroupUserInfo)
      {
         super();
         this._mainUI = new UI_CatchGhostWaitItem();
         this._groupUserInfo = param1;
         this._lvTxt = this._mainUI["lvTxt"];
         this._lvTxt.text = "Lv:" + String(param1.userInfo.lv);
         this._nameTxt = this._mainUI["nameTxt"];
         this._nameTxt.text = param1.userInfo.nick;
         this._inviteFightBtn = this._mainUI["inviteFightBtn"];
         this._chatBtn = this._mainUI["chatBtn"];
         this._inviteFightBtn.visible = false;
         this._chatBtn.visible = false;
         if(FightGroupManager.instance.myIsTheSender && !this._groupUserInfo.isReady)
         {
            this._inviteFightBtn.visible = true;
            this._chatBtn.visible = true;
         }
         this._isReadyMc = this._mainUI["isReadyMc"];
         if(this._groupUserInfo.isReady)
         {
            this._isReadyMc.gotoAndStop(1);
         }
         else
         {
            this._isReadyMc.gotoAndStop(2);
         }
         addChild(this._mainUI);
         SwfCache.getSwfInfo(ClientConfig.getRoleIcon(this._groupUserInfo.userInfo.roleType),this.onLoadCompleteHandler);
         this._inviteFightBtn.addEventListener(MouseEvent.CLICK,this.clickSendWaitHandler);
         this._chatBtn.addEventListener(MouseEvent.CLICK,this.clickChatHandler);
      }
      
      private function onLoadCompleteHandler(param1:SwfInfo) : void
      {
         var _loc2_:Sprite = param1.content as Sprite;
         _loc2_.x = 12;
         _loc2_.y = 12;
         this._mainUI["bg"].addChild(_loc2_);
      }
      
      public function updateState() : void
      {
         this._isReadyMc.gotoAndStop(this._groupUserInfo.isReady ? 1 : 3);
         if(FightGroupManager.instance.myIsTheLeader)
         {
            this._inviteFightBtn.visible = !this._groupUserInfo.isReady;
            this._chatBtn.visible = !this._groupUserInfo.isReady;
         }
      }
      
      private function clickSendWaitHandler(param1:MouseEvent) : void
      {
         FightGroupManager.instance.sendFightGroupWait(this._groupUserInfo.userInfo.userID,this._groupUserInfo.userInfo.createTime,CatchBigGhostManager.instance.currentItem);
         this._isReadyMc.gotoAndStop(2);
      }
      
      private function clickChatHandler(param1:MouseEvent) : void
      {
         TalkManager.showTalkPanel(this._groupUserInfo.userInfo.userID,this._groupUserInfo.userInfo.createTime,true);
      }
      
      public function destory() : void
      {
         this._inviteFightBtn.removeEventListener(MouseEvent.CLICK,this.clickSendWaitHandler);
         this._chatBtn.removeEventListener(MouseEvent.CLICK,this.clickChatHandler);
         removeChild(this._mainUI);
         this._mainUI = null;
      }
   }
}

