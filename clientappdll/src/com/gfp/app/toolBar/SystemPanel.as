package com.gfp.app.toolBar
{
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.manager.DeffEquiptManager;
   import com.gfp.core.manager.FocusManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.PayPasswordManager;
   import com.gfp.core.manager.ServerBuffManager;
   import com.gfp.core.utils.ClientType;
   import com.gfp.core.utils.WebURLUtil;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.taomee.manager.PopUpManager;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.DisplayUtil;
   
   public class SystemPanel extends Sprite
   {
      
      private static var __instance:SystemPanel;
      
      private var _mainUI:ToolBar_System;
      
      private var _mailBtn:MovieClip;
      
      private var _changeKeyBtn:MovieClip;
      
      private var _deffaultEquiptBtn:MovieClip;
      
      private var _payPasswordrBtn:MovieClip;
      
      private var _pvpStatBtn:MovieClip;
      
      private var _qualityBtn:MovieClip;
      
      private var _safeBtn:MovieClip;
      
      public function SystemPanel(param1:Blocker)
      {
         super();
         this.initialize();
      }
      
      public static function show(param1:DisplayObject) : void
      {
         if(!__instance)
         {
            __instance = new SystemPanel(new Blocker());
         }
         if(DisplayUtil.hasParent(__instance))
         {
            __instance.hide();
         }
         else
         {
            __instance.show(param1);
         }
      }
      
      public static function initPayPasswordBtn() : void
      {
         if(__instance == null)
         {
            return;
         }
         __instance.initPayPasswordBtn();
      }
      
      public static function checkPayPassward() : void
      {
         PayPasswordManager.instance.isSwitchPwd = true;
         PayPasswordManager.instance.showPasswordCheckPanel(updatePayPasswordState);
      }
      
      private static function updatePayPasswordState() : void
      {
         ServerBuffManager.instance.addUpdateListener(ServerBuffManager.PAY_PASSWORD_INDEX,onPayPasswordUpdate);
         ServerBuffManager.instance.setPayPasswordState(!ServerBuffManager.instance.isOpenPayPassword);
      }
      
      private static function onPayPasswordUpdate(param1:Event) : void
      {
         ServerBuffManager.instance.removeUpdateListener(ServerBuffManager.PAY_PASSWORD_INDEX,onPayPasswordUpdate);
         PayPasswordManager.instance.setPayPasswordState(ServerBuffManager.instance.isOpenPayPassword);
         initPayPasswordBtn();
      }
      
      private function initialize() : void
      {
         this.initUI();
         this.initEvent();
      }
      
      private function initUI() : void
      {
         if(ClientConfig.clientType != ClientType.KAIXIN)
         {
            this._mainUI = new ToolBar_System();
         }
         addChild(this._mainUI);
         if(ClientConfig.clientType != ClientType.KAIXIN)
         {
            this.initMailBtn();
         }
         this._payPasswordrBtn = this._mainUI.payPasswordrBtn;
         this._pvpStatBtn = this._mainUI.pvpStateBtn;
         this._qualityBtn = this._mainUI.qualityBtn;
         this._safeBtn = this._mainUI.safeBtn;
         this.initChangeKeyBtn();
         this.initPlayerBtn();
         this.initPvpStatBtn();
      }
      
      private function initMailBtn() : void
      {
         this._mailBtn = this._mainUI["mailBtn"];
         ToolTipManager.add(this._mailBtn,"意见箱");
         this.enableMcAsBtn(this._mailBtn);
      }
      
      private function initChangeKeyBtn() : void
      {
         this._changeKeyBtn = this._mainUI["changeKeyBtn"];
         ToolTipManager.add(this._changeKeyBtn,"修改键盘操作方式");
      }
      
      private function initPlayerBtn() : void
      {
         this._deffaultEquiptBtn = this._mainUI["deffaultEquiptBtn"];
         this.setDeffaultBtn();
      }
      
      public function initPayPasswordBtn() : void
      {
         if(PayPasswordManager.instance.isOpenPayPassword)
         {
            this._payPasswordrBtn.gotoAndStop(2);
            ToolTipManager.add(this._payPasswordrBtn,"关闭支付密码保护");
         }
         else
         {
            this._payPasswordrBtn.gotoAndStop(1);
            ToolTipManager.add(this._payPasswordrBtn,"开启支付密码保护");
         }
      }
      
      private function initPvpStatBtn() : void
      {
         if(ServerBuffManager.instance.isAllowPvp)
         {
            this._pvpStatBtn.gotoAndStop(2);
            ToolTipManager.add(this._pvpStatBtn,"拒绝非好友邀请");
         }
         else
         {
            this._pvpStatBtn.gotoAndStop(1);
            ToolTipManager.add(this._pvpStatBtn,"接受所有侠士邀请");
         }
      }
      
      private function enableMcAsBtn(param1:MovieClip) : void
      {
         param1.buttonMode = true;
         param1.useHandCursor = true;
      }
      
      private function initEvent() : void
      {
         if(ClientConfig.clientType != ClientType.KAIXIN)
         {
            this._mailBtn.addEventListener(MouseEvent.CLICK,this.onMailClick);
         }
         this._changeKeyBtn.addEventListener(MouseEvent.CLICK,this.onChengeKeyClick);
         this._deffaultEquiptBtn.addEventListener(MouseEvent.CLICK,this.onDeffaultEquiptBtn);
         this._payPasswordrBtn.addEventListener(MouseEvent.CLICK,this.onPayPasswordBtnClick);
         this._pvpStatBtn.addEventListener(MouseEvent.CLICK,this.onPvpStateBtnClick);
         this._qualityBtn.addEventListener(MouseEvent.CLICK,this.onQualitySetHandle);
         ToolTipManager.add(this._qualityBtn,"修改画质");
         this._safeBtn.addEventListener(MouseEvent.CLICK,this.onClickSafeBtn);
         ToolTipManager.add(this._safeBtn,"账号安全");
      }
      
      private function onClickSafeBtn(param1:MouseEvent) : void
      {
         ModuleManager.turnAppModule("AccountSafePanel");
      }
      
      protected function onQualitySetHandle(param1:MouseEvent) : void
      {
         ModuleManager.turnAppModule("ChangeStageQualityPanel");
      }
      
      private function onPvpStateBtnClick(param1:MouseEvent) : void
      {
         ServerBuffManager.instance.setAllowPvpState(!ServerBuffManager.instance.isAllowPvp);
         this.hide();
      }
      
      private function onPayPasswordBtnClick(param1:MouseEvent) : void
      {
         checkPayPassward();
         this.hide();
      }
      
      private function onDeffaultEquiptBtn(param1:MouseEvent) : void
      {
         DeffEquiptManager.changeEquiptDisplay(!DeffEquiptManager.isDisplayDeffEquipt);
         this.setDeffaultBtn();
         this.hide();
      }
      
      private function setDeffaultBtn() : void
      {
         var _loc1_:int = 0;
         if(DeffEquiptManager.isDisplayDeffEquipt)
         {
            ToolTipManager.add(this._deffaultEquiptBtn,"关卡中显示正常装备");
            _loc1_ = 1;
         }
         else
         {
            ToolTipManager.add(this._deffaultEquiptBtn,"关卡中所有侠士显示默认装备");
            _loc1_ = 2;
         }
         this._deffaultEquiptBtn.gotoAndStop(_loc1_);
      }
      
      private function onChengeKeyClick(param1:MouseEvent) : void
      {
         ModuleManager.turnModule(ClientConfig.getAppModule("ChangeKeyControlModel"),"修改键盘操作");
         this.hide();
      }
      
      private function onMailClick(param1:MouseEvent) : void
      {
         if(ClientConfig.clientType != ClientType.TAIWAN)
         {
            WebURLUtil.intance.navigateService();
         }
         else
         {
            ModuleManager.turnModule(ClientConfig.getAppModule("FeedbackPanel"),"意见箱",10);
         }
         this.hide();
      }
      
      public function show(param1:DisplayObject) : void
      {
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveStage);
         PopUpManager.showForDisplayObject(this,param1,PopUpManager.TOP_LEFT,true,new Point((width + param1.width) / 2,35));
         this.initPvpStatBtn();
         this.initPayPasswordBtn();
      }
      
      private function onRemoveStage(param1:Event) : void
      {
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveStage);
         FocusManager.setDefaultFocus();
      }
      
      public function hide() : void
      {
         DisplayUtil.removeForParent(this);
      }
   }
}

class Blocker
{
   
   public function Blocker()
   {
      super();
   }
}
