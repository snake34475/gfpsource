package com.gfp.app.toolBar
{
   import com.gfp.core.CommandID;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.info.VipInfo;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.SOManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.manager.VipAwardManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.TipsManager;
   import com.gfp.core.ui.tips.CustomTips;
   import com.gfp.core.utils.TickManager;
   import com.gfp.core.utils.TimeUtil;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.SharedObject;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.net.SocketEvent;
   
   public class VipNewEntry extends GFFitStageItem
   {
      
      private static var _instance:VipNewEntry;
      
      private var _vipUpLvSwapId:int = 7272;
      
      private var _usLvSwapId1:int = 6219;
      
      private var _mainUI:MovieClip;
      
      private var _tips:MovieClip;
      
      private var _curNewVersion:uint;
      
      public var isFirstClick:Boolean = true;
      
      private var _goodSummonMC:MovieClip;
      
      private var _vipTimeId:int;
      
      public function VipNewEntry()
      {
         var _loc2_:uint = 0;
         super();
         this._mainUI = UIManager.getGlobalUi("UI_SWF_BottomBar")["vipEntry"];
         this._mainUI.gotoAndStop(1);
         this._goodSummonMC = UIManager.getGlobalUi("UI_SWF_BottomBar")["goodSummonMC"];
         this._goodSummonMC.visible = false;
         var _loc1_:SharedObject = SOManager.getActorSO("vipInfoTip");
         if(Boolean(MainManager.actorInfo.lv >= 80) && Boolean(_loc1_) && Boolean(_loc1_.data["20160701"]) == false)
         {
            _loc1_.data["20160701"] = true;
            _loc1_.flush();
            TickManager.instance.addRender(this.updateTrans,3000);
         }
         this._mainUI.buttonMode = true;
         this._tips = new UI_VipEntryTips();
         if(MainManager.actorInfo.isVip)
         {
            this._tips.gotoAndStop(1);
            this._tips["vipLvl"].text = MainManager.actorInfo.vipLevel.toString();
            this._tips["vipExp"].text = MainManager.actorInfo.vipExp.toString();
            this._tips["vipLeftDay"].text = this.getDayGap(MainManager.actorInfo.vipDuration);
         }
         else
         {
            this._tips.gotoAndStop(2);
         }
         this._curNewVersion = ClientConfig.newsVersion;
         _loc1_ = SOManager.getUserSO(SOManager.VIP_ENTRY);
         if(SOManager.VIP_ENTRY in _loc1_.data)
         {
            _loc2_ = uint(_loc1_.data[SOManager.VIP_ENTRY]);
         }
         this.vipShowWarn();
      }
      
      public static function get instance() : VipNewEntry
      {
         if(_instance == null)
         {
            _instance = new VipNewEntry();
         }
         return _instance;
      }
      
      public static function destroy() : void
      {
         if(_instance)
         {
            _instance.destroy();
            _instance = null;
         }
      }
      
      private function updateTrans() : void
      {
         if(this._goodSummonMC.visible)
         {
            this._goodSummonMC.visible = false;
         }
         else
         {
            this._goodSummonMC.visible = true;
         }
      }
      
      override protected function layout() : void
      {
      }
      
      private function flushCurrVersion() : void
      {
         var _loc1_:SharedObject = SOManager.getUserSO(SOManager.VIP_ENTRY);
         _loc1_.data[SOManager.VIP_ENTRY] = this._curNewVersion;
         SOManager.flush(_loc1_);
      }
      
      override public function show() : void
      {
         super.show();
         this.addEvent();
         this.layout();
      }
      
      private function addEvent() : void
      {
         TipsManager.addTip(this._mainUI,new CustomTips(this._tips));
         VipAwardManager.addListener(VipAwardManager.VIP_AWARD_COMPLETE,this.onComplete);
         VipAwardManager.addListener(VipAwardManager.VIP_AWARD_LEFT,this.onLeft);
         SocketConnection.addCmdListener(CommandID.VIP_INFO,this.onVipChange);
         this._mainUI.addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function getDayGap(param1:Number) : String
      {
         var _loc2_:int = param1 - int(TimeUtil.getSeverDateObject().getTime() / 1000);
         var _loc3_:int = Math.round(_loc2_ / 86400);
         if(_loc3_ <= 0)
         {
            return "0";
         }
         return _loc3_.toString();
      }
      
      private function onComplete(param1:Event) : void
      {
         this._mainUI.gotoAndStop(1);
      }
      
      private function onLeft(param1:Event) : void
      {
         this._mainUI.gotoAndStop(2);
      }
      
      private function onVipChange(param1:SocketEvent) : void
      {
         var _loc2_:VipInfo = param1.data as VipInfo;
         if(param1.headInfo.userID == MainManager.actorID)
         {
            if(_loc2_.bVip)
            {
               this._tips.gotoAndStop(1);
               this._tips["vipLvl"].text = _loc2_.vipLevel.toString();
               this._tips["vipExp"].text = _loc2_.vipExp.toString();
               this._tips["vipLeftDay"].text = this.getDayGap(_loc2_.vipDuration);
            }
            else
            {
               this._tips.gotoAndStop(2);
            }
         }
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(MapManager.currentMap.info.mapType == MapType.TRADE)
         {
            AlertManager.showTradeMapUnavailableAlarm();
            return;
         }
         this.flushCurrVersion();
         ModuleManager.turnModule(ClientConfig.getAppModule("VIPInfoPanel"),AppLanguageDefine.LOAD_MATTER_COLLECTION[26],1);
         if(TickManager.instance.hasRender(this.updateTrans))
         {
            TickManager.instance.removeRender(this.updateTrans);
         }
         this._goodSummonMC.visible = false;
      }
      
      public function vipShowWarn() : void
      {
         this._mainUI["vipEff"].visible = false;
         this._mainUI["notVipEff"].visible = false;
         this._mainUI["vipOutOfDateMc"].visible = false;
         if(MainManager.actorInfo.isVip)
         {
            if(int(this.getDayGap(MainManager.actorInfo.vipDuration)) <= 7)
            {
               this._mainUI["vipOutOfDateMc"].visible = true;
               this._vipTimeId = setTimeout(this.showOutOfDate,10000);
            }
            else if(ActivityExchangeTimesManager.getTimes(this._vipUpLvSwapId) <= 0)
            {
               this._mainUI["vipEff"].visible = true;
               this._mainUI["vipEff"].gotoAndPlay(2);
            }
         }
         else if(ActivityExchangeTimesManager.getTimes(this._usLvSwapId1) <= 0 && MainManager.actorInfo.lv > 29)
         {
            this._mainUI["notVipEff"].visible = true;
            this._mainUI["notVipEff"].gotoAndPlay(2);
         }
      }
      
      private function showOutOfDate() : void
      {
         clearTimeout(this._vipTimeId);
         this._mainUI["vipOutOfDateMc"].visible = false;
         if(ActivityExchangeTimesManager.getTimes(this._vipUpLvSwapId) <= 0)
         {
            this._mainUI["vipEff"].visible = true;
            this._mainUI["vipEff"].gotoAndPlay(2);
         }
      }
      
      override public function hide() : void
      {
         super.hide();
         VipAwardManager.removeListener(VipAwardManager.VIP_AWARD_COMPLETE,this.onComplete);
         VipAwardManager.removeListener(VipAwardManager.VIP_AWARD_LEFT,this.onLeft);
         SocketConnection.removeCmdListener(CommandID.VIP_INFO,this.onVipChange);
         this._mainUI.removeEventListener(MouseEvent.CLICK,this.onClick);
         TipsManager.removeTip(this._mainUI);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.hide();
         this._mainUI = null;
      }
   }
}

