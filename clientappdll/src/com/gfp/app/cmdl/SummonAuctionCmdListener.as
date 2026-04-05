package com.gfp.app.cmdl
{
   import com.gfp.app.systems.ClientTempState;
   import com.gfp.core.CommandID;
   import com.gfp.core.cache.SwfCache;
   import com.gfp.core.cache.SwfInfo;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.TimeUtil;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class SummonAuctionCmdListener extends BaseBean
   {
      
      private static const SELL_SUMMON_NUM:int = 31;
      
      private var _summonID:int;
      
      private var _isOk:Boolean;
      
      private var _oldUserID:int;
      
      private var _oldRoleTime:int;
      
      private var _oldScore:int;
      
      private var _newUserID:int;
      
      private var _newRoleTime:int;
      
      private var _newScore:int;
      
      private var _mainUI:MovieClip;
      
      private var _rankListStart:int = (TimeUtil.getSeverWeekIndex() + 2) % 7;
      
      public function SummonAuctionCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.SUMMON_AUCTION_INFO,this.onSummonAuction);
         finish();
      }
      
      private function onSummonAuction(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         this._summonID = _loc2_.readUnsignedInt();
         this._isOk = Boolean(_loc2_.readUnsignedInt());
         this._oldUserID = _loc2_.readUnsignedInt();
         this._oldRoleTime = _loc2_.readUnsignedInt();
         this._oldScore = _loc2_.readUnsignedInt();
         this._newUserID = _loc2_.readUnsignedInt();
         this._newRoleTime = _loc2_.readUnsignedInt();
         this._newScore = _loc2_.readUnsignedInt();
         this.showMessage();
      }
      
      private function showMessage() : void
      {
         if(this._oldUserID == MainManager.actorID && this._isOk == true && this._newUserID != MainManager.actorID)
         {
            SwfCache.getSwfInfo(ClientConfig.getSubUI("summon_auction"),this.loadComplete);
            ClientTempState.summonAuctionRankList[this._summonID - this._rankListStart * SELL_SUMMON_NUM - 1].prize = this._newScore;
            ClientTempState.summonAuctionRankList[this._summonID - this._rankListStart * SELL_SUMMON_NUM - 1].buyerID = this._newUserID;
            ClientTempState.summonAuctionRankList[this._summonID - this._rankListStart * SELL_SUMMON_NUM - 1].buyerRoleTime = this._newRoleTime;
         }
         else if(this._newUserID == MainManager.actorID && this._isOk == false)
         {
            AlertManager.showSimpleAlarm("小侠士很可惜，由于别的小侠士已出更高的价格竞拍，你的竞拍失败了。");
            ClientTempState.summonAuctionRankList[this._summonID - this._rankListStart * SELL_SUMMON_NUM - 1].prize = this._oldScore;
            ClientTempState.summonAuctionRankList[this._summonID - this._rankListStart * SELL_SUMMON_NUM - 1].buyerID = this._oldUserID;
            ClientTempState.summonAuctionRankList[this._summonID - this._rankListStart * SELL_SUMMON_NUM - 1].buyerRoleTime = this._oldRoleTime;
         }
         else if(this._newUserID == MainManager.actorID && this._isOk == true)
         {
            AlertManager.showSimpleAlarm("恭喜小侠士竞拍成功！");
            ClientTempState.summonAuctionRankList[this._summonID - this._rankListStart * SELL_SUMMON_NUM - 1].prize = this._newScore;
            ClientTempState.summonAuctionRankList[this._summonID - this._rankListStart * SELL_SUMMON_NUM - 1].buyerID = this._newUserID;
            ClientTempState.summonAuctionRankList[this._summonID - this._rankListStart * SELL_SUMMON_NUM - 1].buyerRoleTime = this._newRoleTime;
         }
         ClientTempState.summonAuctionTimer = getTimer();
      }
      
      private function loadComplete(param1:SwfInfo) : void
      {
         this._mainUI = param1.content as MovieClip;
         this._mainUI.height = 170;
         this._mainUI.width = 757;
         this._mainUI.x = 200;
         this._mainUI.y = 300;
         this._mainUI.buttonMode = true;
         if(MapManager.curMapIsFightMap())
         {
            this._mainUI["goBtn"].visible = false;
         }
         else
         {
            this._mainUI["goBtn"].addEventListener(MouseEvent.CLICK,this.onGoClick);
            this._mainUI["goBtn"].buttonMode = true;
         }
         LayerManager.topLevel.addChild(this._mainUI);
         setTimeout(this.hide,3000);
      }
      
      private function onGoClick(param1:MouseEvent) : void
      {
         ModuleManager.turnAppModule("SummonAuctionEntryPanel");
      }
      
      private function hide() : void
      {
         this._mainUI["goBtn"].removeEventListener(MouseEvent.CLICK,this.onGoClick);
         TweenLite.to(this._mainUI,1,{
            "alpha":0,
            "onComplete":this.tweenComplete
         });
      }
      
      private function tweenComplete() : void
      {
         DisplayUtil.removeForParent(this._mainUI);
      }
   }
}

