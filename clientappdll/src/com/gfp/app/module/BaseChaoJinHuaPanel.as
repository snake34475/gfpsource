package com.gfp.app.module
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.cartoon.event.AnimatEvent;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.config.xml.SummonXMLInfo;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.info.SummonInfo;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.SummonEvolveManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import flash.events.Event;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class BaseChaoJinHuaPanel extends BaseExchangeModule
   {
      
      private var _sumId:int = 1;
      
      private var _sumLv:int = 0;
      
      private var _sumQuality:int = 0;
      
      private var _sumBorn:int = 0;
      
      private var _itemId:int = 1;
      
      private var _needCnt:int = 0;
      
      private var _summonInfo:SummonInfo = null;
      
      private var _sumName:String;
      
      private var _isPlayMovie:Boolean;
      
      private var _jinHuaSwapId:int = 0;
      
      private var _selSumUniqId:int = 0;
      
      private var _anmName:String;
      
      public function BaseChaoJinHuaPanel()
      {
         super();
      }
      
      protected function setChaoJinHuaParams() : void
      {
         this.sumId = 0;
         this.sumLv = 0;
         this.sumQuality = 0;
         this.itemId = 0;
         this.needCnt = 0;
         this.sumBorn = 0;
         this.jinHuaSwapId = 0;
         this._anmName = "";
      }
      
      protected function tryChaoJinHua() : void
      {
         var _loc4_:String = null;
         var _loc1_:Array = this.getSummons();
         var _loc2_:int = int(ItemManager.getItemCount(this.itemId));
         if(_loc2_ < this._needCnt)
         {
            _loc4_ = ItemXMLInfo.getName(this.itemId);
            AlertManager.showSimpleAlarm(_loc4_ + "不足，无法进化！");
            return;
         }
         var _loc3_:Array = SummonManager.getSummonListByType(this._sumId);
         this._sumName = SummonXMLInfo.getName(this._sumId);
         if(_loc3_.length <= 0)
         {
            AlertManager.showSimpleAlarm("小侠士，你还没有" + this._sumName + "不能超进化哦！");
            return;
         }
         ModuleManager.turnAppModule("SelectSummonPanel","正在加载",{
            "summonInfos":_loc1_,
            "callback":this.doGrowUp,
            "cofirmAlert":"是否确定选择此仙兽？"
         });
      }
      
      protected function getSummons() : Array
      {
         var _loc3_:SummonInfo = null;
         var _loc1_:Array = SummonManager.getActorSummonInfo().summonList;
         var _loc2_:Array = [];
         for each(_loc3_ in _loc1_)
         {
            if(_loc3_.summonType == this._sumId && _loc3_.quality >= this._sumQuality)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      private function doGrowUp(param1:SummonInfo) : void
      {
         this._summonInfo = param1;
         this._sumName = SummonXMLInfo.getName(this._sumId);
         if(this._sumLv > 0 && this._summonInfo.lv < this._sumLv)
         {
            AlertManager.showSimpleAlarm(this._sumName + "的等级不足" + this._sumLv.toString() + "级，无法进化！");
            return;
         }
         if(this._sumBorn > 0 && this._summonInfo.curBorn < this._sumBorn)
         {
            AlertManager.showSimpleAlarm(this._sumName + "的成长不足" + this._sumBorn.toString() + "无法进化！");
            return;
         }
         if(SummonEvolveManager.checkJinHuaAlert(param1))
         {
            return;
         }
         if(this.isPlayMovie)
         {
            if(this._anmName)
            {
               AnimatPlay.addAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimateEnd);
               AnimatPlay.startAnimat(this._anmName,-1,true,0,0,false,false,true,2);
            }
            else
            {
               this.playGrowUpMovie();
            }
         }
         else
         {
            this.sendCjh();
         }
      }
      
      private function onAnimateEnd(param1:Event) : void
      {
         AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimateEnd);
         this.sendCjh();
      }
      
      private function playGrowUpMovie() : void
      {
         _mainUI["growUpMovie"].gotoAndPlay(1);
         _mainUI["growUpMovie"].addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         _mainUI.addChild(_mainUI["growUpMovie"]);
      }
      
      protected function onEnterFrame(param1:Event) : void
      {
         if(_mainUI["growUpMovie"].currentFrame == _mainUI["growUpMovie"].totalFrames)
         {
            DisplayUtil.removeForParent(_mainUI["growUpMovie"],false);
            _mainUI["growUpMovie"].removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            _mainUI["growUpMovie"].stop();
            this.sendCjh();
         }
      }
      
      protected function sendCjh() : void
      {
         if(this._jinHuaSwapId != 0)
         {
            mExchange = this._jinHuaSwapId;
            this._selSumUniqId = this._summonInfo.uniqueID;
            buyItem(false,null,null,false,this._summonInfo.uniqueID);
         }
         else
         {
            SocketConnection.addCmdListener(CommandID.SUMMON_POWERUP,this.onBackResultHandler);
            SocketConnection.send(CommandID.SUMMON_POWERUP,this._summonInfo.uniqueID,0,this._itemId,0);
         }
      }
      
      override protected function exchangeCompleteHandler(param1:ExchangeEvent) : void
      {
         if(param1.info.id == this._jinHuaSwapId)
         {
            if(this._selSumUniqId > 0)
            {
               SummonManager.removeSummonByUniqueID(this._selSumUniqId);
            }
            this._selSumUniqId = 0;
            this._summonInfo = null;
            mIsSend = false;
         }
      }
      
      protected function onBackResultHandler(param1:SocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         SocketConnection.removeCmdListener(CommandID.SUMMON_POWERUP,this.onBackResultHandler);
         var _loc5_:ByteArray = param1.data as ByteArray;
         _loc5_.position = 0;
         var _loc6_:uint = _loc5_.readUnsignedByte();
         MainManager.actorInfo.coins = _loc5_.readUnsignedInt();
         var _loc7_:uint = _loc5_.readUnsignedInt();
         _loc2_ = 0;
         while(_loc2_ < _loc7_)
         {
            _loc3_ = int(_loc5_.readUnsignedInt());
            _loc4_ = int(_loc5_.readUnsignedInt());
            ItemManager.removeItem(_loc3_,_loc4_);
            _loc2_++;
         }
         var _loc8_:uint = _loc5_.readUnsignedInt();
         _loc2_ = 0;
         while(_loc2_ < _loc8_)
         {
            _loc3_ = int(_loc5_.readUnsignedInt());
            SummonManager.removeSummonByUniqueID(_loc3_);
            _loc2_++;
         }
         var _loc9_:uint = _loc5_.readUnsignedInt();
         _loc2_ = 0;
         while(_loc2_ < _loc9_)
         {
            this.getSummon(_loc5_);
            _loc2_++;
         }
         this._summonInfo = null;
         mIsSend = false;
      }
      
      private function getSummon(param1:ByteArray) : void
      {
         var _loc2_:ByteArray = param1;
         var _loc3_:SummonInfo = new SummonInfo();
         _loc3_.readForBorn(_loc2_);
         var _loc4_:String = SummonXMLInfo.getName(_loc3_.roleID);
         if(_loc3_.succFlg == true)
         {
            if(SummonManager.isSummonBagMax())
            {
               if(!SummonManager.isSummonStorageMax())
               {
                  TextAlert.show("小侠士你的灵兽栏已满，孵化灵兽已被放入灵兽仓库！");
               }
            }
            SummonManager.addSummonForBorn(_loc3_);
            if(_loc3_.deleteID != 0)
            {
               if(SummonManager.getActorSummonInfo().currentSummonInfo == null)
               {
                  SummonManager.getActorSummonInfo().changeSelected(_loc3_.uniqueID);
               }
               else if(SummonManager.getActorSummonInfo().currentSummonInfo.uniqueID == _loc3_.deleteID)
               {
                  SummonManager.getActorSummonInfo().changeSelected(_loc3_.uniqueID);
               }
               SummonManager.removeSummonByUniqueID(_loc3_.deleteID);
            }
            MainManager.actorModel.updateSummonView();
            AlertManager.showSimpleAlarm("恭喜你，进化成功！");
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimateEnd);
      }
      
      public function get isPlayMovie() : Boolean
      {
         return this._isPlayMovie;
      }
      
      public function set isPlayMovie(param1:Boolean) : void
      {
         this._isPlayMovie = param1;
      }
      
      public function get itemId() : int
      {
         return this._itemId;
      }
      
      public function set itemId(param1:int) : void
      {
         this._itemId = param1;
      }
      
      public function get sumId() : int
      {
         return this._sumId;
      }
      
      public function set sumId(param1:int) : void
      {
         this._sumId = param1;
      }
      
      public function get sumLv() : int
      {
         return this._sumLv;
      }
      
      public function set sumLv(param1:int) : void
      {
         this._sumLv = param1;
      }
      
      public function get sumQuality() : int
      {
         return this._sumQuality;
      }
      
      public function set sumQuality(param1:int) : void
      {
         this._sumQuality = param1;
      }
      
      public function get sumBorn() : int
      {
         return this._sumBorn;
      }
      
      public function set sumBorn(param1:int) : void
      {
         this._sumBorn = param1;
      }
      
      public function get needCnt() : int
      {
         return this._needCnt;
      }
      
      public function set needCnt(param1:int) : void
      {
         this._needCnt = param1;
      }
      
      public function get jinHuaSwapId() : int
      {
         return this._jinHuaSwapId;
      }
      
      public function set jinHuaSwapId(param1:int) : void
      {
         this._jinHuaSwapId = param1;
      }
      
      public function get anmName() : String
      {
         return this._anmName;
      }
      
      public function set anmName(param1:String) : void
      {
         this._anmName = param1;
      }
   }
}

