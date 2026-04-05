package com.gfp.app.mapProcess
{
   import com.gfp.app.manager.FourYearGiveTbTimeManager;
   import com.gfp.core.CommandID;
   import com.gfp.core.cache.SwfCache;
   import com.gfp.core.cache.SwfInfo;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.events.DataEvent;
   import com.gfp.core.info.dailyActivity.SwapTimesInfo;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.sensemodels.SightModel;
   import com.gfp.core.net.SocketConnection;
   import com.greensock.TweenMax;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcessAnimat extends BaseMapProcess
   {
      
      protected var _mangoType:int = 0;
      
      private var _mangoModel:SightModel;
      
      private var _mangoAwardAnm:MovieClip;
      
      private var _mangoApearAnm:MovieClip;
      
      private var _mangoDisapearAnm:MovieClip;
      
      private var _mangoData:ByteArray;
      
      public function MapProcessAnimat()
      {
         super();
         if(this._mangoType == 1)
         {
            this.refreshMango();
            FourYearGiveTbTimeManager.instance().addEventListener(DataEvent.DATA_UPDATE,this.mangoNpcHandler);
         }
      }
      
      private function mangoNpcHandler(param1:DataEvent) : void
      {
         var _loc2_:int = int(param1.data);
         this._mangoModel = SightManager.getSightModelByName("菲欧娜姐姐");
         if(!this._mangoModel || !_mapModel || !_mapModel.info)
         {
            return;
         }
         if(_mapModel.info.id == _loc2_)
         {
            if(!this._mangoApearAnm)
            {
               SwfCache.getSwfInfo(ClientConfig.getSubUI("mangoapear"),this.onMangoApearAnmLoaded);
            }
            else
            {
               this._mangoModel.parent.addChild(this._mangoApearAnm);
               this._mangoApearAnm.addEventListener(Event.ENTER_FRAME,this.onMangoAperEnterFrame);
               this._mangoApearAnm.gotoAndPlay(1);
            }
         }
         else
         {
            if(_mapModel.info.id != FourYearGiveTbTimeManager.instance().lastMangoMapId)
            {
               return;
            }
            if(Boolean(this._mangoDisapearAnm) && this._mangoDisapearAnm.isPlaying)
            {
               return;
            }
            if(!this._mangoDisapearAnm)
            {
               SwfCache.getSwfInfo(ClientConfig.getSubUI("mangodisaperanm"),this.onMangoDisapearAnmLoaded);
            }
            else
            {
               this._mangoModel.parent.addChild(this._mangoDisapearAnm);
               this._mangoDisapearAnm.addEventListener(Event.ENTER_FRAME,this.onMangoDisaperEnterFrame);
               this._mangoDisapearAnm.gotoAndPlay(1);
            }
         }
      }
      
      protected function onMangoDisaperEnterFrame(param1:Event) : void
      {
         if(this._mangoDisapearAnm.currentFrame == 20)
         {
            TweenMax.to(this._mangoModel,1,{
               "alpha":0.1,
               "scaleX":0.1,
               "scaleY":0.1
            });
         }
         if(this._mangoDisapearAnm.currentFrame == this._mangoDisapearAnm.totalFrames)
         {
            this._mangoDisapearAnm.removeEventListener(Event.ENTER_FRAME,this.onMangoDisaperEnterFrame);
            this._mangoDisapearAnm.stop();
            DisplayUtil.removeForParent(this._mangoDisapearAnm);
            this._mangoModel.visible = false;
         }
      }
      
      private function onMangoDisapearAnmLoaded(param1:SwfInfo) : void
      {
         if(this._mangoDisapearAnm == null)
         {
            this._mangoDisapearAnm = param1.content as MovieClip;
            this._mangoDisapearAnm.x = this._mangoModel.x - 320;
            this._mangoDisapearAnm.y = this._mangoModel.y - 180;
            this._mangoModel.parent.addChild(this._mangoDisapearAnm);
            this._mangoDisapearAnm.addEventListener(Event.ENTER_FRAME,this.onMangoDisaperEnterFrame);
         }
      }
      
      private function onMangoApearAnmLoaded(param1:SwfInfo) : void
      {
         if(this._mangoApearAnm == null)
         {
            this._mangoApearAnm = param1.content as MovieClip;
            this._mangoApearAnm.x = this._mangoModel.x - 320;
            this._mangoApearAnm.y = this._mangoModel.y - 180;
            this._mangoModel.parent.addChild(this._mangoApearAnm);
            this._mangoApearAnm.addEventListener(Event.ENTER_FRAME,this.onMangoAperEnterFrame);
         }
      }
      
      protected function onMangoAperEnterFrame(param1:Event) : void
      {
         if(this._mangoApearAnm.currentFrame == this._mangoApearAnm.totalFrames)
         {
            this._mangoApearAnm.removeEventListener(Event.ENTER_FRAME,this.onMangoAperEnterFrame);
            this._mangoApearAnm.stop();
            DisplayUtil.removeForParent(this._mangoApearAnm);
            this.resertMango();
            this._mangoModel.addEventListener(MouseEvent.CLICK,this.onMangoClick,false,100);
         }
      }
      
      private function refreshMango() : void
      {
         this._mangoModel = SightManager.getSightModelByName("菲欧娜姐姐");
         if(!this._mangoModel)
         {
            return;
         }
         if(_mapModel.info.id == FourYearGiveTbTimeManager.instance().mangoMapId)
         {
            this.resertMango();
            this._mangoModel.addEventListener(MouseEvent.CLICK,this.onMangoClick,false,100);
         }
         else
         {
            this._mangoModel.visible = false;
            this._mangoModel.removeEventListener(MouseEvent.CLICK,this.onMangoClick);
         }
      }
      
      private function onMangoClick(param1:MouseEvent) : void
      {
         ActivityExchangeTimesManager.getActiviteTimeInfo(6021);
         ActivityExchangeTimesManager.addEventListener(6021,this.getTimes);
      }
      
      private function getTimes(param1:DataEvent) : void
      {
         ActivityExchangeTimesManager.removeEventListener(6021,this.getTimes);
         var _loc2_:SwapTimesInfo = param1.data as SwapTimesInfo;
         if(_loc2_.times == _mapModel.info.id)
         {
            AlertManager.showSimpleAlarm("小侠士你已经在这里领取过菲欧娜姐姐的奖励了，等下个地方吧~");
         }
         else
         {
            SocketConnection.addCmdListener(CommandID.FOUR_YEAR_TB_INFO,this.onGetAwardInfo);
            SocketConnection.send(CommandID.FOUR_YEAR_TB_INFO,_mapModel.info.id);
         }
      }
      
      private function onGetAwardInfo(param1:SocketEvent) : void
      {
         if(!this._mangoAwardAnm)
         {
            SwfCache.getSwfInfo(ClientConfig.getSubUI("mangotbanm"),this.onMangoTbAnmLoaded);
         }
         else
         {
            LayerManager.topLevel.addChild(this._mangoAwardAnm);
            DisplayUtil.align(this._mangoAwardAnm,null,AlignType.MIDDLE_CENTER);
            this._mangoAwardAnm.addEventListener(Event.ENTER_FRAME,this.onMangoEnterFrame);
            this._mangoAwardAnm.gotoAndPlay(1);
         }
         this._mangoData = param1.data as ByteArray;
         SocketConnection.removeCmdListener(CommandID.FOUR_YEAR_TB_INFO,this.onGetAwardInfo);
      }
      
      private function onMangoTbAnmLoaded(param1:SwfInfo) : void
      {
         if(this._mangoAwardAnm == null)
         {
            this._mangoAwardAnm = param1.content as MovieClip;
            LayerManager.topLevel.addChild(this._mangoAwardAnm);
            DisplayUtil.align(this._mangoAwardAnm,null,AlignType.MIDDLE_CENTER);
            this._mangoAwardAnm.addEventListener(Event.ENTER_FRAME,this.onMangoEnterFrame);
         }
      }
      
      protected function onMangoEnterFrame(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(this._mangoAwardAnm.currentFrame == this._mangoAwardAnm.totalFrames)
         {
            this._mangoAwardAnm.removeEventListener(Event.ENTER_FRAME,this.onMangoEnterFrame);
            this._mangoAwardAnm.stop();
            this._mangoData.position = 0;
            _loc2_ = int(this._mangoData.readUnsignedInt());
            _loc3_ = int(this._mangoData.readUnsignedInt());
            _loc4_ = int(this._mangoData.readUnsignedInt());
            _loc5_ = int(this._mangoData.readUnsignedInt());
            if(_loc2_ <= 10 && _loc3_ > 0)
            {
               AlertManager.showSimpleAlarm("小侠士你是第" + _loc2_.toString() + "名领取奖励的，恭喜你获得了" + _loc3_ + "通宝！");
               this.getUserGfCoins();
            }
            else if(_loc3_ > 0)
            {
               AlertManager.showSimpleAlarm("恭喜你获得了" + _loc3_ + "通宝！");
               this.getUserGfCoins();
            }
            else if(_loc5_ > 0)
            {
               AlertManager.showSimpleAlarm("恭喜你获得了珍贵的" + ItemXMLInfo.getName(_loc5_) + "，下次还有机会获得通宝哦");
            }
            else
            {
               AlertManager.showSimpleAlarm("小侠士你在菲欧娜姐姐处领的奖励已经达到本活动上限喽~不可再获得奖励了。");
            }
            this._mangoAwardAnm.stop();
            this._mangoData = null;
            DisplayUtil.removeForParent(this._mangoAwardAnm);
         }
      }
      
      protected function getUserGfCoins() : void
      {
         SocketConnection.addCmdListener(CommandID.GET_GF_COINS,this.onGetUserGfCoins);
         SocketConnection.send(CommandID.GET_GF_COINS);
      }
      
      protected function onGetUserGfCoins(param1:SocketEvent) : void
      {
         (param1.data as ByteArray).position = 0;
         SocketConnection.removeCmdListener(CommandID.GET_GF_COINS,this.onGetUserGfCoins);
         MainManager.actorInfo.gfCoin = (param1.data as ByteArray).readUnsignedInt() / 100;
      }
      
      protected function addSimpleOverOutAnimat(param1:MovieClip) : void
      {
         if(param1)
         {
            param1.buttonMode = true;
            param1.addEventListener(MouseEvent.MOUSE_OVER,this.onMcOver);
            param1.addEventListener(MouseEvent.MOUSE_OUT,this.onMcOut);
         }
      }
      
      protected function addSimpleClickAnimat(param1:MovieClip) : void
      {
         if(param1)
         {
            param1.buttonMode = true;
            param1.addEventListener(MouseEvent.CLICK,this.onMcClick);
         }
      }
      
      private function onMcClick(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         _loc2_.gotoAndPlay(2);
      }
      
      private function onMcOver(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         _loc2_.gotoAndPlay(2);
      }
      
      private function onMcOut(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         _loc2_.gotoAndStop(1);
      }
      
      protected function removeSimpleClickAnimat(param1:MovieClip) : void
      {
         if(param1)
         {
            if(param1.hasEventListener(MouseEvent.CLICK))
            {
               param1.removeEventListener(MouseEvent.CLICK,this.onMcClick);
            }
         }
      }
      
      protected function removeSimpleOverOutAnimat(param1:MovieClip) : void
      {
         if(param1)
         {
            param1.buttonMode = true;
            param1.removeEventListener(MouseEvent.MOUSE_OVER,this.onMcOver);
            param1.removeEventListener(MouseEvent.MOUSE_OUT,this.onMcOut);
         }
      }
      
      protected function addFlagClickAnimat(param1:MovieClip) : void
      {
         if(param1)
         {
            param1.buttonMode = true;
            param1.addEventListener(MouseEvent.CLICK,this.onFlagMCClick);
         }
      }
      
      private function onFlagMCClick(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         var _loc3_:int = _loc2_.currentFrame == 1 ? 2 : 1;
         _loc2_.gotoAndStop(_loc3_);
      }
      
      protected function removeFlagClickAnimat(param1:MovieClip) : void
      {
         if(param1)
         {
            if(param1.hasEventListener(MouseEvent.CLICK))
            {
               param1.removeEventListener(MouseEvent.CLICK,this.onFlagMCClick);
            }
         }
      }
      
      private function resertMango() : void
      {
         this._mangoModel.alpha = this._mangoModel.scaleX = this._mangoModel.scaleY = 1;
         this._mangoModel.visible = true;
      }
      
      override public function destroy() : void
      {
         if(this._mangoModel)
         {
            this._mangoModel = null;
         }
         FourYearGiveTbTimeManager.instance().removeEventListener(DataEvent.DATA_UPDATE,this.mangoNpcHandler);
         super.destroy();
      }
   }
}

