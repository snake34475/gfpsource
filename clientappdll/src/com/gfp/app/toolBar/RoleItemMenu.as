package com.gfp.app.toolBar
{
   import com.gfp.app.control.GloryFightControl;
   import com.gfp.app.fight.FightWaitPanel;
   import com.gfp.app.fight.SinglePkManager;
   import com.gfp.app.im.talk.TalkManager;
   import com.gfp.app.manager.FightGroupManager;
   import com.gfp.app.manager.GuaranteeTradeManager;
   import com.gfp.app.user.MoreUserInfoController;
   import com.gfp.app.user.UserInfoController;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.controller.SocketSendController;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.language.CoreLanguageDefine;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.RelationManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.manager.TeamsRelationManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.PanelType;
   import com.gfp.core.utils.PvpIDConstantUtil;
   import com.gfp.core.utils.PvpTypeConstantUtil;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class RoleItemMenu extends Sprite
   {
      
      private static var _instance:RoleItemMenu;
      
      public static const TYPE_ROLE:uint = 0;
      
      public static const TYPE_SUMMON:uint = 1;
      
      private const ROLE_CELL:String = "Head_Cell_";
      
      private const SUMMON_CELL:String = "Head_Summon_Cell_";
      
      private var _menuList:Array;
      
      protected var _info:*;
      
      protected var _menuType:uint;
      
      protected var _type:uint = 1;
      
      protected var roleMenuMap:Array;
      
      protected var summonMenuMap:Array;
      
      public function RoleItemMenu()
      {
         super();
         this._menuList = [];
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
      }
      
      public static function get instance() : RoleItemMenu
      {
         if(_instance == null)
         {
            _instance = new RoleItemMenu();
         }
         return _instance;
      }
      
      public static function show(param1:*, param2:uint = 0, param3:DisplayObjectContainer = null, param4:Number = 0, param5:Number = 0) : void
      {
         instance.show(param1,param2,param3,param4,param5);
      }
      
      public static function hide() : void
      {
         instance.hide();
      }
      
      public static function destory() : void
      {
         instance.destroy();
      }
      
      protected function setupMenuMap() : void
      {
         var _loc1_:uint = 0;
         this.roleMenuMap = [];
         this.summonMenuMap = [];
         _loc1_ = 1;
         while(_loc1_ <= 8)
         {
            this.roleMenuMap.push(this.ROLE_CELL + _loc1_);
            _loc1_++;
         }
         _loc1_ = 1;
         while(_loc1_ <= 2)
         {
            this.summonMenuMap.push(this.SUMMON_CELL + _loc1_);
            _loc1_++;
         }
      }
      
      public function show(param1:*, param2:uint = 0, param3:DisplayObjectContainer = null, param4:Number = 0, param5:Number = 0) : void
      {
         if(this._type == PanelType.SHOW)
         {
            this.hide();
            return;
         }
         this._type = PanelType.SHOW;
         this._info = param1;
         this._menuType = param2;
         this.menuLimit();
         this.viewMenu();
         x = param4;
         y = param5;
         if(param3 == null)
         {
            param3 = LayerManager.stage;
         }
         LayerManager.stage.addEventListener(MouseEvent.MOUSE_DOWN,this.onStageDown);
         param3.addChild(this);
      }
      
      public function reSizeForStage() : void
      {
         if(LayerManager.stage.mouseX + width + 20 >= LayerManager.stageWidth)
         {
            x = LayerManager.stageWidth - width - 10;
         }
         else
         {
            x = LayerManager.stage.mouseX + 10;
         }
         if(LayerManager.stage.mouseY + height + 20 >= LayerManager.stageHeight)
         {
            y = LayerManager.stageHeight - height - 10;
         }
         else
         {
            y = LayerManager.stage.mouseY + 20;
         }
      }
      
      private function onStageDown(param1:MouseEvent) : void
      {
         if(!this.hitTestPoint(param1.stageX,param1.stageY))
         {
            this.hide();
         }
      }
      
      public function viewMenu() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:Sprite = null;
         this.clear();
         if(this._menuType == TYPE_ROLE)
         {
            _loc1_ = 0;
            while(_loc1_ < this.roleMenuMap.length)
            {
               _loc2_ = UIManager.getSprite(this.roleMenuMap[_loc1_]);
               _loc2_.name = this.roleMenuMap[_loc1_];
               _loc2_.y = _loc1_ * _loc2_.height;
               this._menuList.push(_loc2_);
               addChild(_loc2_);
               if(_loc2_)
               {
                  _loc2_.addEventListener(MouseEvent.CLICK,this.onMenuItemClick);
               }
               _loc1_++;
            }
         }
         else if(this._menuType == TYPE_SUMMON)
         {
            _loc1_ = 0;
            while(_loc1_ < this.summonMenuMap.length)
            {
               _loc2_ = UIManager.getSprite(this.summonMenuMap[_loc1_]);
               _loc2_.name = this.summonMenuMap[_loc1_];
               _loc2_.y = _loc1_ * _loc2_.height;
               this._menuList.push(_loc2_);
               addChild(_loc2_);
               if(_loc2_)
               {
                  _loc2_.addEventListener(MouseEvent.CLICK,this.onMenuItemClick);
               }
               _loc1_++;
            }
         }
      }
      
      private function onMenuItemClick(param1:Event) : void
      {
         var _loc3_:int = 0;
         var _loc4_:UserModel = null;
         var _loc5_:UserInfo = null;
         if(MainManager.actorModel.isZhengGued)
         {
            return;
         }
         var _loc2_:Sprite = param1.currentTarget as Sprite;
         switch(_loc2_.name)
         {
            case this.ROLE_CELL + 1:
               this.showPeopleInfo();
               break;
            case this.ROLE_CELL + 2:
               this.addFriend();
               break;
            case this.ROLE_CELL + 3:
               GuaranteeTradeManager.instance.sendTradeRequest(this._info.userID,this._info.createTime);
               break;
            case this.ROLE_CELL + 4:
               UserManager.addUserListener(UserEvent.PVP_CHANGE,this._info.userID,this.initPvPState);
               this.invitePK();
               break;
            case this.ROLE_CELL + 5:
               this.inviteHeroTeam();
               break;
            case this.ROLE_CELL + 6:
               TalkManager.showTalkPanel(this._info.userID,this._info.createTime,true);
               break;
            case this.ROLE_CELL + 7:
               FightGroupManager.instance.inviteEnterGroup(this._info.userID,this._info.createTime);
               break;
            case this.ROLE_CELL + 8:
               ModuleManager.turnAppModule("FightPowerComparePanel","正在加载...",this._info);
               break;
            case this.SUMMON_CELL + 1:
               this.showSummonInfo();
               break;
            case this.SUMMON_CELL + 2:
               _loc3_ = int(SummonManager.getMasterID(this._info.uniqueID));
               _loc4_ = UserManager.getModel(_loc3_);
               if((Boolean(_loc4_)) && Boolean(_loc4_.info))
               {
                  _loc5_ = _loc4_.info;
                  UserInfoController.showForID(_loc5_.userID,false,_loc5_.createTime);
                  break;
               }
               UserInfoController.showForID(_loc3_);
         }
         this.hide();
      }
      
      private function showPeopleInfo() : void
      {
         if(this._info.userID == MainManager.actorID)
         {
            MoreUserInfoController.show(this._info,LayerManager.uiLevel);
            MoreUserInfoController.setStatus = true;
         }
         else
         {
            UserInfoController.showForInfo(this._info);
         }
      }
      
      private function invitePK() : void
      {
         if(MainManager.actorInfo.wulinID != 0)
         {
            AlertManager.showSimpleAlarm(CoreLanguageDefine.WULIN_MSG_ARR[1]);
            return;
         }
         if(GloryFightControl.instance.isGloryFightMap())
         {
            AlertManager.showSimpleAlarm("小侠士，该地图不能进行其他操作。");
            return;
         }
         SocketSendController.sendPvpInviteCMD(false,PvpIDConstantUtil.INVITE_PK_PVP_ID,PvpTypeConstantUtil.PVP_TYPE_INVITE,0);
      }
      
      private function initPvPState(param1:UserEvent) : void
      {
         if(this._info == null)
         {
            return;
         }
         UserManager.removeUserListener(UserEvent.PVP_CHANGE,this._info.userID,this.initPvPState);
         var _loc2_:uint = uint(int(param1.data));
         if(_loc2_ != 0)
         {
            SinglePkManager.instance.openInviteBattery();
            FightWaitPanel.showWaitPanel();
            SocketConnection.send(CommandID.TEAM_INVITE_FRIEND,2,this._info.userID,_loc2_,0,0);
         }
      }
      
      private function addFriend() : void
      {
         if(RelationManager.friendLength >= RelationManager.F_MAX)
         {
            AlertManager.showSimpleAlarm(CoreLanguageDefine.RELATIONMANAGER_CHARACTER_COLLECTION[1]);
            return;
         }
         AlertManager.showSimpleAlert(AppLanguageDefine.USERINFO_CHARACTER_COLLECTION[8] + this._info.nick + "(" + this._info.userID + AppLanguageDefine.USERINFO_CHARACTER_COLLECTION[9],function():void
         {
            RelationManager.requestAddFriend(_info.userID);
         });
      }
      
      private function delFriend() : void
      {
         AlertManager.showSimpleAlert(AppLanguageDefine.USERINFO_CHARACTER_COLLECTION[12] + this._info.nick + "(" + this._info.userID + AppLanguageDefine.USERINFO_CHARACTER_COLLECTION[13],function():void
         {
            RelationManager.removeFriend(_info.userID);
         });
      }
      
      private function inviteHeroTeam() : void
      {
         if(TeamsRelationManager.instance.getSelfTeamMemberNum() >= TeamsRelationManager.FIGHT_TEAM_MEMBER_MAX)
         {
            TextAlert.show("小侠士,你的侠士团人数已到上限" + TeamsRelationManager.FIGHT_TEAM_MEMBER_MAX + "人");
         }
         else
         {
            TeamsRelationManager.instance.inviteTeamMember(this._info);
         }
      }
      
      private function showSummonInfo() : void
      {
         var _loc1_:int = 0;
         if(MapManager.currentMap.info.mapType == MapType.STAND)
         {
            _loc1_ = int(SummonManager.getMasterID(this._info.uniqueID));
            if(_loc1_ == MainManager.actorInfo.userID)
            {
               CityToolBar.instance.turnSummonInfoPanel();
            }
            else
            {
               ModuleManager.turnModule(ClientConfig.getAppModule("SummonSimpleInfoPanel"),"",this._info);
            }
         }
      }
      
      protected function menuLimit() : void
      {
         var _loc1_:uint = 0;
         this.setupMenuMap();
         if(this.isActorInfo())
         {
            this.roleMenuMap = [];
            this.roleMenuMap.push(this.ROLE_CELL + 1);
         }
         if(this.isFriend())
         {
            _loc1_ = uint(this.roleMenuMap.indexOf(this.ROLE_CELL + 2));
            this.roleMenuMap.splice(_loc1_,1);
         }
      }
      
      private function isActorInfo() : Boolean
      {
         if(this._info is UserInfo)
         {
            if(this._info.userID == MainManager.actorID)
            {
               return true;
            }
         }
         return false;
      }
      
      private function isFriend() : Boolean
      {
         if(this._info is UserInfo)
         {
            if(RelationManager.isFriend(this._info.userID))
            {
               return true;
            }
         }
         return false;
      }
      
      public function get info() : *
      {
         return this._info;
      }
      
      private function onMapSwitchComplete(param1:MapEvent) : void
      {
         this.destroy();
      }
      
      private function clear() : void
      {
         var _loc1_:Sprite = null;
         for each(_loc1_ in this._menuList)
         {
            _loc1_.removeEventListener(MouseEvent.CLICK,this.onMenuItemClick);
            DisplayUtil.removeForParent(_loc1_);
            _loc1_ = null;
         }
         this._menuList = [];
      }
      
      public function hide() : void
      {
         this.clear();
         this._type = PanelType.HIDE;
         LayerManager.stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.onStageDown);
      }
      
      public function destroy() : void
      {
         this.hide();
         this.roleMenuMap = [];
         this.summonMenuMap = [];
         this._info = null;
         _instance = null;
         this._type = PanelType.DESTROY;
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
      }
   }
}

