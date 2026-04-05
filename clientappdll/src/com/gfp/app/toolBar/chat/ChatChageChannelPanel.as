package com.gfp.app.toolBar.chat
{
   import com.gfp.app.manager.FightGroupManager;
   import com.gfp.core.Constant;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.utils.TextUtil;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.taomee.component.manager.PopUpManager;
   import org.taomee.utils.DisplayUtil;
   
   public class ChatChageChannelPanel extends Sprite
   {
      
      private static const CHAT_BUTTON_NAME:String = "chatType";
      
      private var _mainUI:UI_Multi_Chat_Channel_Panel;
      
      private var _channelMenue:Sprite;
      
      private var _chageBtn:SimpleButton;
      
      private var _currentTMc:MovieClip;
      
      private var _currentType:int = 0;
      
      private var canUser_arr:Array;
      
      private var noDispatch:Boolean = false;
      
      public var nameArray:Array = ["当前","组队","团队","交易","","","","世界"];
      
      private var btnName:Array = ["chatType_0","","chatType_1","","","","","chatType_2"];
      
      public function ChatChageChannelPanel()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._mainUI = new UI_Multi_Chat_Channel_Panel();
         this._currentTMc = this._mainUI["currentTMc"];
         this._currentTMc.gotoAndStop(1);
         this._currentTMc.buttonMode = true;
         this._currentTMc.mouseEnabled = false;
         this._currentTMc.mouseChildren = false;
         buttonMode = true;
         this._chageBtn = this._mainUI.chageBtn;
         addChild(this._mainUI);
         this.canUser_arr = new Array();
         this.updateTurnnelNum();
         this.initEvent();
      }
      
      public function updateTurnnelNum() : void
      {
         var _loc3_:ChatBtn = null;
         this._channelMenue = new Sprite();
         var _loc1_:int = this.canUseTurnner();
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = new ChatBtn(this.canUser_arr[_loc2_]);
            _loc3_.x = 0;
            _loc3_.y = _loc2_ * 18.5;
            _loc3_.name = CHAT_BUTTON_NAME + "_" + _loc2_;
            _loc3_.addEventListener(MouseEvent.CLICK,this.onChannelMenueClick);
            this._channelMenue.addChild(_loc3_);
            _loc2_++;
         }
         UserManager.addEventListener(UserEvent.CHANGCHANNEL,this.onChangeChannel);
      }
      
      private function onChangeChannel(param1:UserEvent) : void
      {
         var _loc3_:ChatBtn = null;
         if(param1.data.isChannelDispatch == true)
         {
            return;
         }
         var _loc2_:int = int(param1.data.type);
         if(_loc2_ >= 0 && _loc2_ <= 7)
         {
            _loc3_ = this.getChatBtn(_loc2_);
         }
         if(_loc3_ != null)
         {
            this.noDispatch = true;
            _loc3_.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         }
      }
      
      private function getChatBtn(param1:int) : ChatBtn
      {
         var _loc2_:ChatBtn = null;
         var _loc4_:ChatBtn = null;
         var _loc3_:int = 0;
         while(_loc3_ < this._channelMenue.numChildren)
         {
            _loc4_ = this._channelMenue.getChildAt(_loc3_) as ChatBtn;
            if(_loc4_.btnLabel == this.nameArray[param1])
            {
               _loc2_ = _loc4_;
               break;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function initEvent() : void
      {
         this._chageBtn.addEventListener(MouseEvent.CLICK,this.onChageBtnClick);
      }
      
      private function canUseTurnner() : int
      {
         this.canUser_arr = new Array();
         var _loc1_:* = 2;
         this.canUser_arr.push(0);
         if(FightGroupManager.instance.groupId != 0)
         {
         }
         if(MainManager.actorInfo.fightTeamId > 0)
         {
            _loc1_++;
            this.canUser_arr.push(2);
         }
         if(MapManager.mapInfo.name == "万博会")
         {
            this.canUser_arr.push(3);
            _loc1_++;
         }
         this.canUser_arr.push(7);
         return _loc1_++;
      }
      
      private function onChannelMenueClick(param1:MouseEvent) : void
      {
         var _loc5_:int = 0;
         var _loc2_:ChatBtn = param1.currentTarget as ChatBtn;
         var _loc3_:String = param1.currentTarget.name;
         DisplayUtil.removeForParent(this._channelMenue);
         var _loc4_:int = this.nameArray.indexOf(_loc2_.btnLabel);
         if(this.noDispatch == false)
         {
            if([0,7,2].indexOf(_loc4_) != -1)
            {
               UserManager.dispatchEvent(new UserEvent(UserEvent.CHANGCHANNEL,{
                  "type":_loc4_ + 10,
                  "isChannelDispatch":true,
                  "isInfoDispatch":false
               }));
            }
         }
         this.noDispatch = false;
         if(_loc3_.indexOf(CHAT_BUTTON_NAME) != -1)
         {
            _loc5_ = int(_loc3_.split("_")[1]);
            this._currentType = this.canUser_arr[_loc5_];
            if(this._currentType == Constant.CHAT_TYPE_TEAM && FightGroupManager.instance.groupId == 0)
            {
               MultiChatPanel.instance.showSystemNotice("小侠士,您当前没有组队！");
               return;
            }
            if(this._currentType == Constant.CHAT_TYPE_XIASHITUAN && MainManager.actorInfo.fightTeamId <= 0)
            {
               MultiChatPanel.instance.showSystemNotice("小侠士,你还没有加入任何侠士团,可前往" + TextUtil.getCodeByNpcId(10142) + " 查看侠士团信息");
               return;
            }
            this._currentTMc.gotoAndStop(this._currentType + 1);
         }
         param1.stopPropagation();
      }
      
      private function onChageBtnClick(param1:MouseEvent) : void
      {
         if(this._channelMenue.parent != null)
         {
            DisplayUtil.removeForParent(this._channelMenue);
         }
         else
         {
            PopUpManager.showForDisplayObject(this._channelMenue,this._chageBtn,PopUpManager.TOP_LEFT,true,new Point((width + this._chageBtn.width) / 2,0));
         }
      }
      
      public function set currentType(param1:int) : void
      {
         this._currentType = param1;
         this._currentTMc.gotoAndStop(this._currentType + 1);
      }
      
      public function get currentType() : int
      {
         return this._currentType;
      }
   }
}

