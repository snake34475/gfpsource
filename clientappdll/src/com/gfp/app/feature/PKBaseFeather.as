package com.gfp.app.feature
{
   import com.gfp.app.fight.FightWaitPanel;
   import com.gfp.app.fight.SinglePkManager;
   import com.gfp.core.CommandID;
   import com.gfp.core.controller.SocketSendController;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.model.MapModel;
   import com.gfp.core.model.PeopleModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.PvpTypeConstantUtil;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.ui.Mouse;
   import org.taomee.utils.DisplayUtil;
   
   public class PKBaseFeather
   {
      
      private var _mapModel:MapModel;
      
      private var _arrow:Sprite;
      
      protected var _userModels:Vector.<PeopleModel> = new Vector.<PeopleModel>();
      
      protected var _selectInfo:UserInfo;
      
      public function PKBaseFeather()
      {
         super();
         this.init();
      }
      
      protected function init() : void
      {
         this.addEvent();
      }
      
      protected function addEvent() : void
      {
         UserManager.addEventListener(UserEvent.BORN,this.onUserBorn);
         UserManager.addEventListener(UserEvent.LEAVE,this.onUserLeave);
      }
      
      protected function removeEvent() : void
      {
         UserManager.removeEventListener(UserEvent.BORN,this.onUserBorn);
         UserManager.removeEventListener(UserEvent.LEAVE,this.onUserLeave);
         if(this._selectInfo)
         {
            UserManager.removeUserListener(UserEvent.PVP_CHANGE,this._selectInfo.userID,this.initPvPState);
         }
      }
      
      private function onUserBorn(param1:UserEvent) : void
      {
         var _loc2_:PeopleModel = param1.data as PeopleModel;
         if(_loc2_)
         {
            if(this.isModelNeedToAdd(_loc2_))
            {
               this.addModel(_loc2_);
            }
         }
      }
      
      protected function addModel(param1:PeopleModel) : void
      {
         this.addModelEvent(param1);
         this._userModels.push(param1);
      }
      
      private function onUserLeave(param1:UserEvent) : void
      {
         var _loc2_:PeopleModel = param1.data as PeopleModel;
         if(_loc2_)
         {
            this.removeModel(_loc2_);
         }
      }
      
      protected function isModelNeedToAdd(param1:PeopleModel) : Boolean
      {
         throw new Error("this function must be inherit");
      }
      
      protected function getAlertMessage(param1:PeopleModel) : String
      {
         throw new Error("this function must be inherit");
      }
      
      protected function getPvpId() : int
      {
         throw new Error("this function must be inherit");
      }
      
      protected function getSelectInfoClearMessage() : String
      {
         throw new Error("this function must be inherit");
      }
      
      protected function onModelClick(param1:MouseEvent) : void
      {
         var model:PeopleModel = null;
         var e:MouseEvent = param1;
         model = e.currentTarget as PeopleModel;
         var message:String = this.getAlertMessage(model);
         if(message)
         {
            AlertManager.showSimpleAlert(message,function():void
            {
               _selectInfo = model.info;
               if(Boolean(getAlertMessage(model)) && Boolean(_selectInfo))
               {
                  sendPvpMessage();
               }
            });
         }
         e.stopImmediatePropagation();
      }
      
      protected function sendPvpMessage() : void
      {
         UserManager.addUserListener(UserEvent.PVP_CHANGE,this._selectInfo.userID,this.initPvPState);
         SocketSendController.sendPvpInviteCMD(false,this.getPvpId(),PvpTypeConstantUtil.PVP_TYPE_INVITE,0);
      }
      
      private function initPvPState(param1:UserEvent) : void
      {
         var _loc3_:String = null;
         if(this._selectInfo == null)
         {
            return;
         }
         UserManager.removeUserListener(UserEvent.PVP_CHANGE,this._selectInfo.userID,this.initPvPState);
         if(this.getModelById(this._selectInfo.userID) == null)
         {
            this._selectInfo = null;
            _loc3_ = this.getSelectInfoClearMessage();
            if(_loc3_)
            {
               AlertManager.showSimpleAlarm(_loc3_);
            }
            return;
         }
         var _loc2_:uint = uint(int(param1.data));
         if(_loc2_ != 0)
         {
            SinglePkManager.instance.openInviteBattery();
            FightWaitPanel.showWaitPanel();
            SocketConnection.send(CommandID.TEAM_INVITE_FRIEND,this.getPvpId(),this._selectInfo.userID,_loc2_,0,0);
         }
      }
      
      protected function showFightMouse() : void
      {
         if(this._arrow == null)
         {
            this._arrow = new UI_MouseArrow();
            this._arrow.mouseChildren = false;
            this._arrow.mouseEnabled = false;
         }
         Mouse.hide();
         this._arrow.x = LayerManager.stage.mouseX;
         this._arrow.y = LayerManager.stage.mouseY;
         LayerManager.stage.addChild(this._arrow);
         this._arrow.startDrag();
      }
      
      protected function hideFightMouse() : void
      {
         if(this._arrow)
         {
            DisplayUtil.removeForParent(this._arrow,false);
            this._arrow.stopDrag();
         }
         Mouse.show();
      }
      
      protected function onUserMouseOver(param1:MouseEvent) : void
      {
         this.showFightMouse();
      }
      
      private function onUserMouseOut(param1:MouseEvent) : void
      {
         this.hideFightMouse();
      }
      
      protected function removeModelEvent(param1:PeopleModel) : void
      {
         param1.removeEventListener(MouseEvent.MOUSE_OVER,this.onUserMouseOver);
         param1.removeEventListener(MouseEvent.MOUSE_OUT,this.onUserMouseOut);
         param1.removeEventListener(MouseEvent.CLICK,this.onModelClick);
      }
      
      protected function addModelEvent(param1:PeopleModel) : void
      {
         param1.addEventListener(MouseEvent.MOUSE_OVER,this.onUserMouseOver);
         param1.addEventListener(MouseEvent.MOUSE_OUT,this.onUserMouseOut);
         param1.addEventListener(MouseEvent.CLICK,this.onModelClick);
      }
      
      protected function removeModel(param1:PeopleModel) : void
      {
         var _loc2_:int = this._userModels.indexOf(param1);
         if(_loc2_ != -1)
         {
            if(param1.hitTestPoint(param1.mouseX,param1.mouseY))
            {
               this.hideFightMouse();
            }
            this.removeModelEvent(param1);
            this._userModels.splice(_loc2_,1);
         }
      }
      
      protected function getModelById(param1:int) : PeopleModel
      {
         var _loc2_:PeopleModel = null;
         for each(_loc2_ in this._userModels)
         {
            if(Boolean(_loc2_.info) && _loc2_.info.userID == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function destroy() : void
      {
         Mouse.show();
         this.removeEvent();
         while(this._userModels.length > 0)
         {
            this.removeModel(this._userModels[0]);
         }
      }
   }
}

