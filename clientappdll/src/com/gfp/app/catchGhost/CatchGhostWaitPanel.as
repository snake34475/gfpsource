package com.gfp.app.catchGhost
{
   import com.gfp.app.manager.CatchBigGhostManager;
   import com.gfp.app.manager.FightGroupManager;
   import com.gfp.core.cache.SwfCache;
   import com.gfp.core.cache.SwfInfo;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.CommEvent;
   import com.gfp.core.info.GroupUserInfo;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.ui.alert.TextAlert;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class CatchGhostWaitPanel
   {
      
      private static var _instance:CatchGhostWaitPanel;
      
      private var _mainUI:Sprite;
      
      private var _joinBtn:SimpleButton;
      
      private var _closeBtn:SimpleButton;
      
      private var _getItemBtn:SimpleButton;
      
      private var _changeMapBtn:SimpleButton;
      
      private var _memList:Vector.<CatchGhostWaitItem>;
      
      private var _isMyself:Boolean;
      
      public function CatchGhostWaitPanel()
      {
         super();
         this._mainUI = new UI_CatchGhostWaitPanel();
         this._joinBtn = this._mainUI["joinBtn"];
         this._closeBtn = this._mainUI["closeBtn"];
         this._getItemBtn = this._mainUI["getItemBtn"];
         this._changeMapBtn = this._mainUI["changeMapBtn"];
         this._getItemBtn.visible = false;
         this._changeMapBtn.visible = false;
         this._isMyself = FightGroupManager.instance.senderID == MainManager.actorID;
         var _loc1_:GroupUserInfo = FightGroupManager.instance.getGroupUserInfo(FightGroupManager.instance.senderID,FightGroupManager.instance.senderRoleID);
         if(this._isMyself)
         {
            this._joinBtn.visible = false;
         }
         this._mainUI["nameTxt"].text = _loc1_.userInfo.nick;
         this._mainUI["lvTxt"].text = "Lv:" + String(_loc1_.userInfo.lv);
         SwfCache.getSwfInfo(ClientConfig.getRoleIcon(_loc1_.userInfo.roleType),this.onLoadCompleteHandler);
         this.initMemberList();
         this.addEvent();
      }
      
      public static function get instance() : CatchGhostWaitPanel
      {
         if(_instance == null)
         {
            _instance = new CatchGhostWaitPanel();
         }
         return _instance;
      }
      
      public static function destroy() : void
      {
         if(_instance)
         {
            _instance.destroy();
         }
         _instance = null;
      }
      
      private function addEvent() : void
      {
         this._joinBtn.addEventListener(MouseEvent.CLICK,this.onJoinIn);
         this._closeBtn.addEventListener(MouseEvent.CLICK,this.onClose);
         this._changeMapBtn.addEventListener(MouseEvent.CLICK,this.onChangeMap);
         FightGroupManager.instance.ed.addEventListener(FightGroupManager.FIGHT_GROUP_WAIT_UPDATE,this.groupWaitUpdateHandler);
         FightGroupManager.instance.ed.addEventListener(FightGroupManager.FIGHT_GROUP_WAIT_DESTORY,this.destoryPanelHandler);
      }
      
      private function removeEvent() : void
      {
         this._joinBtn.removeEventListener(MouseEvent.CLICK,this.onJoinIn);
         this._closeBtn.removeEventListener(MouseEvent.CLICK,this.onClose);
         this._getItemBtn.removeEventListener(MouseEvent.CLICK,this.onGetItem);
         this._changeMapBtn.removeEventListener(MouseEvent.CLICK,this.onChangeMap);
         FightGroupManager.instance.ed.removeEventListener(FightGroupManager.FIGHT_GROUP_WAIT_UPDATE,this.groupWaitUpdateHandler);
         FightGroupManager.instance.ed.removeEventListener(FightGroupManager.FIGHT_GROUP_WAIT_DESTORY,this.destoryPanelHandler);
      }
      
      public function show() : void
      {
         LayerManager.topLevel.addChild(this._mainUI);
         DisplayUtil.align(this._mainUI,null,AlignType.MIDDLE_CENTER);
      }
      
      private function onLoadCompleteHandler(param1:SwfInfo) : void
      {
         var _loc2_:Sprite = null;
         _loc2_ = param1.content as Sprite;
         _loc2_.x = 70;
         _loc2_.y = 132;
         this._mainUI.addChild(_loc2_);
      }
      
      private function initMemberList() : void
      {
         var _loc2_:GroupUserInfo = null;
         var _loc3_:CatchGhostWaitItem = null;
         this._memList = new Vector.<CatchGhostWaitItem>();
         var _loc1_:int = 0;
         for each(_loc2_ in FightGroupManager.instance.groupUserList)
         {
            if(_loc2_.userInfo.userID != FightGroupManager.instance.senderID)
            {
               _loc3_ = new CatchGhostWaitItem(_loc2_);
               _loc3_.x = 248.7;
               _loc3_.y = 127.4;
               _loc1_++;
               this._mainUI.addChild(_loc3_);
               this._memList.push(_loc3_);
            }
         }
      }
      
      private function destoryPanelHandler(param1:CommEvent) : void
      {
         CatchGhostWaitPanel.destroy();
      }
      
      private function groupChangeHandler(param1:CommEvent) : void
      {
         this.clearMemberList();
         this.initMemberList();
      }
      
      private function clearMemberList() : void
      {
         var _loc1_:CatchGhostWaitItem = null;
         for each(_loc1_ in this._memList)
         {
            _loc1_.destory();
         }
      }
      
      private function onJoinIn(param1:MouseEvent) : void
      {
         if(!CatchBigGhostManager.instance.isRightMap())
         {
            TextAlert.show("小侠士需前往特定场景才能开启驱魔斩妖术！");
            this._changeMapBtn.visible = true;
            return;
         }
         FightGroupManager.instance.groupFightWaitResoponse(FightGroupManager.instance.groupId,1);
      }
      
      private function playCallBack() : void
      {
         FightGroupManager.instance.groupFightWaitResoponse(FightGroupManager.instance.groupId,1);
      }
      
      private function onClose(param1:MouseEvent = null) : void
      {
         CatchGhostWaitPanel.destroy();
         FightGroupManager.instance.groupFightWaitResoponse(FightGroupManager.instance.groupId,0);
      }
      
      private function onGetItem(param1:MouseEvent) : void
      {
         this._getItemBtn.visible = false;
         CityMap.instance.tranToNpc(10451);
      }
      
      private function onChangeMap(param1:MouseEvent) : void
      {
         this._changeMapBtn.visible = false;
         var _loc2_:uint = CatchBigGhostManager.instance.getRandomMap();
         CityMap.instance.changeMap(_loc2_);
      }
      
      private function groupWaitUpdateHandler(param1:CommEvent) : void
      {
         var _loc2_:CatchGhostWaitItem = null;
         var _loc3_:GroupUserInfo = null;
         for each(_loc2_ in this._memList)
         {
            _loc2_.updateState();
         }
         for each(_loc3_ in FightGroupManager.instance.groupUserList)
         {
            if(_loc3_.userInfo.userID != FightGroupManager.instance.senderID)
            {
               if(_loc3_.isReady)
               {
                  CatchBigGhostManager.instance.catchBegin();
               }
               else
               {
                  this.onClose();
                  TextAlert.show("对方拒绝了你大战黑暗魔将的邀请！");
               }
            }
         }
      }
      
      public function destroy() : void
      {
         this.removeEvent();
         DisplayUtil.removeForParent(this._mainUI);
         this._mainUI = null;
      }
   }
}

