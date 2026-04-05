package com.gfp.app.im.ui
{
   import com.gfp.app.im.ui.tab.IIMTab;
   import com.gfp.app.im.ui.tab.TabBlack;
   import com.gfp.app.im.ui.tab.TabFriend;
   import com.gfp.app.im.ui.tab.TabOnline;
   import com.gfp.app.im.ui.tab.TabRecent;
   import com.gfp.app.popup.AddFriendPanel;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.xml.MapXMLInfo;
   import com.gfp.core.config.xml.NpcXMLInfo;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.language.CoreLanguageDefine;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.MasterManager;
   import com.gfp.core.manager.RelationManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.uic.UIPanel;
   import com.gfp.core.uic.UIScrollBar;
   import com.gfp.core.utils.PanelType;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.ds.HashMap;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class IMPanel extends UIPanel
   {
      
      private static const LIST_LENGTH:int = 8;
      
      private static const FORBID_ADD_FRIEND:uint = 1;
      
      private static const ALLOW_ADD_FRIEND:uint = 0;
      
      private var _titleMc:MovieClip;
      
      private var _txt:TextField;
      
      private var _addBtn:SimpleButton;
      
      private var _delBtn:SimpleButton;
      
      private var _teacherBtn:SimpleButton;
      
      private var _allowBtn:SimpleButton;
      
      private var _tabFriend:MovieClip;
      
      private var _tabBlack:MovieClip;
      
      private var _tabNewly:MovieClip;
      
      private var _tabOnline:MovieClip;
      
      private var _tabRecent:MovieClip;
      
      private var _tabDetail:MovieClip;
      
      private var _tabList:HashMap;
      
      private var _currentTab:IIMTab;
      
      private var _listCon:Sprite;
      
      private var _listData:Array;
      
      private var _scrollBar:UIScrollBar;
      
      private var _searchBtn:SimpleButton;
      
      private var _searchText:TextField;
      
      private var _currentIMItem:IMListItem;
      
      private var _showDetailTimeID:uint;
      
      public function IMPanel()
      {
         var _loc2_:IMListItem = null;
         this._listData = [];
         super(new IM_MainPanel());
         _type = PanelType.HIDE;
         this._txt = _mainUI["txt"];
         this._addBtn = _mainUI["addBtn"];
         this._delBtn = _mainUI["delBtn"];
         this._teacherBtn = _mainUI["teacherBtn"];
         this._allowBtn = _mainUI["allowBtn"];
         this._tabFriend = _mainUI["tabFriend"];
         this._tabOnline = _mainUI["tabOnline"];
         this._tabBlack = _mainUI["tabBlack"];
         this._tabRecent = _mainUI["tabRecent"];
         this._searchBtn = _mainUI["searchBtn"];
         this._searchText = _mainUI["searchTxt"];
         this._txt.mouseEnabled = false;
         if(MainManager.actorInfo.allowOrForbidAddFriend == 1)
         {
            this._allowBtn.visible = true;
            this._delBtn.visible = false;
         }
         else
         {
            this._allowBtn.visible = false;
            this._delBtn.visible = true;
         }
         this._scrollBar = new UIScrollBar(_mainUI);
         this._scrollBar.pageSize = LIST_LENGTH;
         this._scrollBar.wheelObject = this;
         this._listCon = new Sprite();
         this._listCon.x = 42;
         this._listCon.y = 126;
         _mainUI.addChild(this._listCon);
         var _loc1_:int = 0;
         while(_loc1_ < LIST_LENGTH)
         {
            _loc2_ = new IMListItem();
            _loc2_.y = 28.45 * _loc1_;
            this._listCon.addChild(_loc2_);
            _loc1_++;
         }
         this._tabList = new HashMap();
         this._tabList.add(this._tabFriend,new TabFriend(1,this._tabFriend,this._listCon,this.refreshItem));
         this._tabList.add(this._tabOnline,new TabOnline(3,this._tabOnline,this._listCon,this.refreshItem));
         this._tabList.add(this._tabBlack,new TabBlack(4,this._tabBlack,this._listCon,this.refreshItem));
         this._tabList.add(this._tabRecent,new TabRecent(5,this._tabRecent,this._listCon,this.refreshItem));
         this._currentTab = this._tabList.getValue(this._tabFriend);
      }
      
      override public function show(param1:DisplayObjectContainer = null) : void
      {
         super.show(LayerManager.topLevel);
         DisplayUtil.align(this,null,AlignType.MIDDLE_RIGHT,new Point(-10,0));
         this._currentTab.show();
         if(ActivityExchangeTimesManager.getTimes(6035) == 0)
         {
            ActivityExchangeCommander.exchange(6035);
         }
      }
      
      override public function hide() : void
      {
         super.hide();
         this._currentTab.hide();
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this._txt = null;
         this._addBtn = null;
         this._delBtn = null;
         this._allowBtn = null;
         this._listCon = null;
         this._listData = null;
         this._tabList = null;
         this._currentTab = null;
         this._scrollBar.destroy();
         this._scrollBar = null;
      }
      
      override protected function addEvent() : void
      {
         super.addEvent();
         this._addBtn.addEventListener(MouseEvent.CLICK,this.onAddFriend);
         this._delBtn.addEventListener(MouseEvent.CLICK,this.onDelFriend);
         this._allowBtn.addEventListener(MouseEvent.CLICK,this.onAllowFriend);
         this._teacherBtn.addEventListener(MouseEvent.CLICK,this.clickTeacherHandler);
         this._scrollBar.addEventListener(MouseEvent.MOUSE_MOVE,this.onScrollMove);
         this._tabFriend.addEventListener(MouseEvent.CLICK,this.onTabClick);
         this._tabBlack.addEventListener(MouseEvent.CLICK,this.onTabClick);
         this._tabOnline.addEventListener(MouseEvent.CLICK,this.onTabClick);
         this._tabRecent.addEventListener(MouseEvent.CLICK,this.onTabClick);
         this._searchText.addEventListener(Event.CHANGE,this.onSearchChange);
         this._searchBtn.addEventListener(MouseEvent.CLICK,this.onSearch);
         SocketConnection.addCmdListener(CommandID.FRIEND_SEARCH,this.onServerSearch);
         ToolTipManager.add(this._addBtn,"寻找好友");
         ToolTipManager.add(this._delBtn,"禁加好友");
         ToolTipManager.add(this._allowBtn,"允许加好友");
         ToolTipManager.add(this._tabFriend,"我的好友");
         ToolTipManager.add(this._tabBlack,"黑名单");
         ToolTipManager.add(this._tabOnline,"附近的在线玩家");
         ToolTipManager.add(this._tabRecent,"最近联系人");
         ToolTipManager.add(this._searchBtn,"好友内搜索");
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         this._addBtn.removeEventListener(MouseEvent.CLICK,this.onAddFriend);
         this._delBtn.removeEventListener(MouseEvent.CLICK,this.onDelFriend);
         this._allowBtn.removeEventListener(MouseEvent.CLICK,this.onAllowFriend);
         this._teacherBtn.removeEventListener(MouseEvent.CLICK,this.clickTeacherHandler);
         this._scrollBar.removeEventListener(MouseEvent.MOUSE_MOVE,this.onScrollMove);
         this._tabFriend.removeEventListener(MouseEvent.CLICK,this.onTabClick);
         this._tabBlack.removeEventListener(MouseEvent.CLICK,this.onTabClick);
         this._tabOnline.removeEventListener(MouseEvent.CLICK,this.onTabClick);
         this._tabRecent.removeEventListener(MouseEvent.CLICK,this.onTabClick);
         this._searchText.removeEventListener(Event.CHANGE,this.onSearchChange);
         this._searchBtn.removeEventListener(MouseEvent.CLICK,this.onSearch);
         SocketConnection.removeCmdListener(CommandID.FRIEND_SEARCH,this.onServerSearch);
         ToolTipManager.remove(this._addBtn);
         ToolTipManager.remove(this._delBtn);
         ToolTipManager.remove(this._allowBtn);
         ToolTipManager.remove(this._tabFriend);
         ToolTipManager.remove(this._tabBlack);
         ToolTipManager.remove(this._tabOnline);
         ToolTipManager.remove(this._tabRecent);
      }
      
      private function refreshItem(param1:Array, param2:int) : void
      {
         var ldLen:int;
         var lenth:int;
         var len:int;
         var i:int;
         var item:IMListItem = null;
         var dis:IMListItem = null;
         var helperInfo:UserInfo = null;
         var rel:UserInfo = null;
         var data:Array = param1;
         var max:int = param2;
         var k:int = 0;
         while(k < LIST_LENGTH)
         {
            dis = this._listCon.getChildAt(k) as IMListItem;
            dis.mouseChildren = false;
            dis.mouseEnabled = false;
            dis.removeEventListener(MouseEvent.MOUSE_OVER,this.onOver);
            dis.removeEventListener(MouseEvent.MOUSE_OUT,this.onOut);
            dis.clear();
            k++;
         }
         data.sort(function(param1:UserInfo, param2:UserInfo):int
         {
            if(param1.serverID > param2.serverID)
            {
               return -1;
            }
            if(param1.serverID < param2.serverID)
            {
               return 1;
            }
            if(param1.isVip == param2.isVip)
            {
               return 0;
            }
            if(param1.isVip)
            {
               return -1;
            }
            return 1;
         });
         if(this._currentTab == this._tabList.getValue(this._tabFriend))
         {
            helperInfo = new UserInfo();
            helperInfo.userID = NpcXMLInfo.GF_HELPER_ID;
            helperInfo.nick = "万通通";
            helperInfo.hasSimpleInfo = true;
            helperInfo.serverID = 111;
            data.unshift(helperInfo);
         }
         ldLen = int(data.length);
         this._listData = data;
         this._scrollBar.maxScrollPosition = ldLen;
         lenth = ldLen - 1;
         lenth = lenth < 0 ? 0 : lenth;
         this._txt.text = "(" + lenth + "/" + max.toString() + ")";
         len = Math.min(LIST_LENGTH,ldLen);
         i = 0;
         while(i < len)
         {
            rel = this._listData[i + this._scrollBar.scrollPosition] as UserInfo;
            item = this._listCon.getChildAt(i) as IMListItem;
            item.info = rel;
            item.mouseChildren = true;
            item.mouseEnabled = true;
            item.addEventListener(MouseEvent.MOUSE_OVER,this.onOver);
            item.addEventListener(MouseEvent.MOUSE_OUT,this.onOut);
            i++;
         }
      }
      
      private function onTabClick(param1:MouseEvent) : void
      {
         this._currentTab.hide();
         this._currentTab = this._tabList.getValue(param1.currentTarget);
         this._currentTab.show();
      }
      
      private function onScrollMove(param1:MouseEvent) : void
      {
         var _loc3_:UserInfo = null;
         var _loc4_:IMListItem = null;
         var _loc2_:int = 0;
         while(_loc2_ < LIST_LENGTH)
         {
            _loc3_ = this._listData[_loc2_ + this._scrollBar.scrollPosition] as UserInfo;
            _loc4_ = this._listCon.getChildAt(_loc2_) as IMListItem;
            _loc4_.clear();
            _loc4_.info = _loc3_;
            _loc2_++;
         }
      }
      
      public function updateInfo(param1:UserInfo) : void
      {
         var _loc3_:IMListItem = null;
         var _loc2_:int = 0;
         while(_loc2_ < LIST_LENGTH)
         {
            _loc3_ = this._listCon.getChildAt(_loc2_) as IMListItem;
            if(Boolean(_loc3_.info) && _loc3_.info.userID == param1.userID)
            {
               _loc3_.clear();
               _loc3_.info = param1;
            }
            _loc2_++;
         }
      }
      
      private function onAddFriend(param1:MouseEvent) : void
      {
         if(RelationManager.friendLength >= RelationManager.F_MAX)
         {
            AlertManager.showSimpleAlarm(CoreLanguageDefine.RELATIONMANAGER_CHARACTER_COLLECTION[1]);
            return;
         }
         AddFriendPanel.show();
      }
      
      private function onDelFriend(param1:MouseEvent) : void
      {
         SocketConnection.addCmdListener(CommandID.ALLOWORFORBID_ADD_FRIEND,this.onSetForbidden);
         SocketConnection.send(CommandID.ALLOWORFORBID_ADD_FRIEND,FORBID_ADD_FRIEND);
      }
      
      private function onAllowFriend(param1:MouseEvent) : void
      {
         SocketConnection.addCmdListener(CommandID.ALLOWORFORBID_ADD_FRIEND,this.onSetAllow);
         SocketConnection.send(CommandID.ALLOWORFORBID_ADD_FRIEND,ALLOW_ADD_FRIEND);
      }
      
      private function clickTeacherHandler(param1:MouseEvent) : void
      {
         MasterManager.instance.openMasterPanel();
      }
      
      private function onSetForbidden(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.ALLOWORFORBID_ADD_FRIEND,this.onSetForbidden);
         var _loc2_:uint = IDataInput(param1.data).readUnsignedInt();
         if(_loc2_ == FORBID_ADD_FRIEND)
         {
            this._delBtn.visible = false;
            this._allowBtn.visible = true;
            MainManager.actorInfo.allowOrForbidAddFriend = 1;
            AlertManager.showSimpleAlarm("亲爱的小侠士 \n 从现在起你已禁止其他小侠士加你为好友");
         }
      }
      
      private function onSetAllow(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.ALLOWORFORBID_ADD_FRIEND,this.onSetAllow);
         var _loc2_:uint = IDataInput(param1.data).readUnsignedInt();
         if(_loc2_ == ALLOW_ADD_FRIEND)
         {
            this._delBtn.visible = true;
            this._allowBtn.visible = false;
            MainManager.actorInfo.allowOrForbidAddFriend = 0;
            AlertManager.showSimpleAlarm("亲爱的小侠士 \n 从现在起你已允许其他小侠士加你为好友");
         }
      }
      
      private function onSearchChange(param1:Event = null) : void
      {
         var filter:String = null;
         var e:Event = param1;
         filter = this._searchText.text;
         var friends:Array = RelationManager.getFriendInfos();
         var result:Array = friends.filter(function(param1:UserInfo, param2:uint, param3:Array):Boolean
         {
            var _loc4_:* = param1.nick.indexOf(filter);
            if(_loc4_ != -1)
            {
               return true;
            }
            return false;
         });
         this.refreshItem(result,RelationManager.F_MAX);
      }
      
      private function onSearch(param1:Event) : void
      {
         this.onSearchChange();
      }
      
      private function onOver(param1:Event) : void
      {
         this._currentIMItem = param1.currentTarget as IMListItem;
         if(this._currentIMItem.online && this._currentIMItem.info.userID != NpcXMLInfo.GF_HELPER_ID)
         {
            this._showDetailTimeID = setTimeout(this.requestDetailInfo,1000);
         }
      }
      
      private function onOut(param1:Event) : void
      {
         this._currentIMItem = null;
         this.clearTimeID();
      }
      
      private function clearTimeID() : void
      {
         if(this._showDetailTimeID != 0)
         {
            clearTimeout(this._showDetailTimeID);
            this._showDetailTimeID = 0;
         }
      }
      
      private function requestDetailInfo() : void
      {
         if(this._currentIMItem != null)
         {
            SocketConnection.send(CommandID.FRIEND_SEARCH,this._currentIMItem.info.userID);
         }
      }
      
      private function onServerSearch(param1:SocketEvent) : void
      {
         this.clearTimeID();
         if(this._currentIMItem == null)
         {
            return;
         }
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         var _loc6_:String = "【" + _loc4_ + "号服务器】 ";
         var _loc7_:String = "";
         if(_loc3_ == 0)
         {
            _loc7_ = MapXMLInfo.getName(_loc5_);
         }
         else if(_loc3_ == 1)
         {
            _loc7_ = "战斗中";
         }
         else if(_loc3_ == 2)
         {
            _loc7_ = "万博会";
         }
         ToolTipManager.add(this._currentIMItem.hitMouseArea,_loc6_ + _loc7_);
      }
   }
}

