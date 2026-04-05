package com.gfp.app.plugins
{
   import com.gfp.core.CommandID;
   import com.gfp.core.config.AttributeConfig;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.InformInfo;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.MessageManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.manager.UserInfoManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.model.PeopleModel;
   import com.gfp.core.net.SocketConnection;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class Praise32TimesPlugin extends BasePlugin
   {
      
      private var _users:Vector.<PeopleModel>;
      
      public function Praise32TimesPlugin()
      {
         super();
      }
      
      private function canPraiseOther() : Boolean
      {
         return true;
      }
      
      private function canPraisedByOthers(param1:UserInfo) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         if(param1.userID == MainManager.actorID)
         {
            return param1.lv == 113 && MainManager.activedMaxLevel() == 113;
         }
         return param1.lv == 113 && param1.exp == AttributeConfig.calcTotalLvExp(param1.roleType,113,true);
      }
      
      override public function install() : void
      {
         super.install();
         this._users = new Vector.<PeopleModel>();
         UserInfoManager.ed.addEventListener(UserEvent.LVL_CHANGE,this.onLevelChange);
         UserManager.addEventListener(UserEvent.BORN,this.onUserChange);
         ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchangeComplete);
         SocketConnection.addCmdListener(CommandID.UNLOCK_114_PRAISE,this.bePraisedHandle);
         this.updateMap();
      }
      
      private function bePraisedHandle(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:InformInfo = new InformInfo(null);
         _loc3_.userID = _loc2_.readUnsignedInt();
         _loc3_.createTime = _loc2_.readUnsignedInt();
         _loc3_.nick = _loc2_.readUTFBytes(16);
         _loc3_.type = CommandID.UNLOCK_114_PRAISE;
         MessageManager.addInformInfo(_loc3_);
      }
      
      private function onLevelChange(param1:Event) : void
      {
         if(this.canPraiseOther())
         {
            this.updateMap();
         }
      }
      
      private function updateMap() : void
      {
         var _loc1_:Array = null;
         var _loc2_:* = undefined;
         this.removeUserIcons();
         if(this.canPraiseOther())
         {
            if(this.canPraisedByOthers(MainManager.actorInfo))
            {
               this.updateUser(MainManager.actorModel,true);
            }
            _loc1_ = UserManager.getModels();
            for each(_loc2_ in _loc1_)
            {
               if(Boolean(_loc2_ is PeopleModel) && Boolean(_loc2_) && this.canPraisedByOthers(_loc2_.info))
               {
                  this.updateUser(_loc2_,true);
               }
            }
         }
      }
      
      private function onUserChange(param1:UserEvent) : void
      {
         var _loc2_:PeopleModel = null;
         if(this.canPraiseOther())
         {
            _loc2_ = param1.data as PeopleModel;
            if(Boolean(_loc2_) && this.canPraisedByOthers(_loc2_.info))
            {
               this.updateUser(_loc2_,true);
            }
         }
      }
      
      private function updateUser(param1:PeopleModel, param2:Boolean) : void
      {
         var _loc3_:Sprite = null;
         if(param2)
         {
            _loc3_ = param1.headContainer.getChildByName("UI_PraiseIcon") as Sprite;
            if(_loc3_ == null)
            {
               _loc3_ = UIManager.getSprite("UI_PraiseIcon");
               _loc3_.buttonMode = true;
               _loc3_.x = -_loc3_.width * 0.5;
               _loc3_.addEventListener(MouseEvent.CLICK,this.praiseHandle,false,0,false);
               _loc3_.name = "UI_PraiseIcon";
               param1.addHeadContainerChild(_loc3_);
            }
            this._users.push(param1);
         }
         else
         {
            _loc3_ = param1.headContainer.getChildByName("UI_PraiseIcon") as Sprite;
            if(_loc3_)
            {
               param1.removeHeadContainerChild(_loc3_);
               DisplayUtil.removeForParent(_loc3_);
               _loc3_.removeEventListener(MouseEvent.CLICK,this.praiseHandle);
            }
         }
      }
      
      private function praiseHandle(param1:MouseEvent) : void
      {
         var _loc3_:UserInfo = null;
         var _loc2_:PeopleModel = param1.currentTarget.parent.parent as PeopleModel;
         if(_loc2_)
         {
            _loc3_ = _loc2_.info;
            if(_loc3_.userID == MainManager.actorID)
            {
               AlertManager.showSimpleAlarm("小侠士你现在可以邀请110级侠士来助你解锁114级了！（点击经验条解锁可查看详情）");
            }
            else if(MainManager.actorInfo.lv < 110)
            {
               AlertManager.showSimpleAlarm("小侠士，满110级后才可赞其他侠士助其一臂之力！");
            }
            else if(ActivityExchangeTimesManager.getTimes(6885))
            {
               AlertManager.showSimpleAlarm("小侠士，每天只能赞一次哦！");
            }
            else
            {
               ActivityExchangeCommander.exchange(6885,_loc3_.userID,_loc3_.createTime);
            }
         }
      }
      
      private function onExchangeComplete(param1:ExchangeEvent) : void
      {
         if(param1.info.id == 6885)
         {
            AlertManager.showSimpleAlarm("小侠士你给他点了赞，帮助他离114级解锁更近一步喽！");
         }
      }
      
      private function removeUserIcons() : void
      {
         while(this._users.length)
         {
            this.updateUser(this._users.pop(),false);
         }
      }
      
      override public function uninstall() : void
      {
         super.uninstall();
         UserManager.removeEventListener(UserEvent.BORN,this.onUserChange);
         UserInfoManager.ed.removeEventListener(UserEvent.LVL_CHANGE,this.onLevelChange);
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchangeComplete);
         SocketConnection.removeCmdListener(CommandID.UNLOCK_114_PRAISE,this.bePraisedHandle);
         this.removeUserIcons();
      }
   }
}

