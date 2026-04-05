package com.gfp.app.feature
{
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.MoveEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.model.AppModel;
   import com.gfp.core.model.PeopleModel;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.PvpTypeConstantUtil;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class WanShenDianFeather extends PKBaseFeather
   {
      
      private var _securityArea:Array = [new Rectangle(850,610,1200,600)];
      
      private var _appModel:AppModel;
      
      private var _isInSecurity:Boolean;
      
      public function WanShenDianFeather()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._appModel = new AppModel(ClientConfig.getAppModule("WanShenDianPanel"),"正在加载...");
         this._appModel.show();
         this._isInSecurity = this.isUserInSecurity(MainManager.actorModel);
         this.showSecurityMessage();
      }
      
      override protected function addEvent() : void
      {
         super.addEvent();
         MainManager.actorModel.addEventListener(MoveEvent.MOVE,this.onMove);
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         MainManager.actorModel.removeEventListener(MoveEvent.MOVE,this.onMove);
      }
      
      private function onMove(param1:MoveEvent) : void
      {
         var _loc2_:Boolean = this.isUserInSecurity(MainManager.actorModel);
         if(_loc2_ != this._isInSecurity)
         {
            this._isInSecurity = _loc2_;
            this.showSecurityMessage();
         }
      }
      
      private function showSecurityMessage() : void
      {
         if(this._isInSecurity)
         {
            TextAlert.show("小侠士，您进入了万神殿的安全区域。");
         }
         else
         {
            TextAlert.show("小侠士，您进入了万神殿的非安全区域,可能被其他小侠士攻击。");
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(this._appModel)
         {
            this._appModel.destroy();
            this._appModel = null;
         }
      }
      
      override protected function getPvpId() : int
      {
         return PvpTypeConstantUtil.PVP_WAN_SHEN_DIAN;
      }
      
      override protected function isModelNeedToAdd(param1:PeopleModel) : Boolean
      {
         if(param1.info)
         {
            return true;
         }
         return false;
      }
      
      override protected function sendPvpMessage() : void
      {
         super.sendPvpMessage();
      }
      
      private function isUserInSecurity(param1:PeopleModel) : Boolean
      {
         var _loc2_:Rectangle = null;
         for each(_loc2_ in this._securityArea)
         {
            if(_loc2_.containsPoint(param1.pos))
            {
               return false;
            }
         }
         return true;
      }
      
      override protected function onUserMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:PeopleModel = param1.currentTarget as PeopleModel;
         if(_loc2_)
         {
            if(!this.isUserInSecurity(_loc2_))
            {
               showFightMouse();
            }
         }
      }
      
      override protected function getAlertMessage(param1:PeopleModel) : String
      {
         if(!this.isUserInSecurity(param1))
         {
            return "该玩家出于非安全区，是否确认对其进行攻击。";
         }
         return "";
      }
   }
}

