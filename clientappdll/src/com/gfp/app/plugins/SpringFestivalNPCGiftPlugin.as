package com.gfp.app.plugins
{
   import com.gfp.app.npcDialog.NPCDialogEvent;
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.app.npcDialog.npc.NpcDialogItemFilter;
   import com.gfp.app.npcDialog.npc.QuestionInfo;
   import com.gfp.core.cache.SwfCache;
   import com.gfp.core.cache.SwfInfo;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.utils.TimeUtil;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class SpringFestivalNPCGiftPlugin extends BasePlugin
   {
      
      public const CONFIG_NPCS:Array = [10001,10002,10146,10121,10024,10020,10066,10048,10536];
      
      public const DIALOGS:Array = ["武圣爷爷，新年我来要红包啦~","药师爷爷，不给红包我就捣乱！","清崖爷爷，我来给您拜年啦！","苏毕爷爷，我来要红包啦~","高昌，不给红包不给你押镖哦！","羊元爷爷，恭喜发财，红包拿来！","剑仙爷爷，我来给您拜年啦！","陆半仙，我来给你拜年啦~","女王大人，新年我来要红包啦！"];
      
      private var _gettedCount:int;
      
      private var _npcIDs:Array = [];
      
      private const GIFT_SWAP_IDS:Array = [8237,8238,8239,8240,8241,8242,8243,8244];
      
      private var _queue:String;
      
      public function SpringFestivalNPCGiftPlugin()
      {
         super();
      }
      
      override public function install() : void
      {
         var _loc2_:Array = null;
         var _loc1_:Date = TimeUtil.getSeverDateObject();
         if(_loc1_.month != 1 || _loc1_.date < 5 || _loc1_.date > 11)
         {
            return;
         }
         super.install();
         if(ActivityExchangeTimesManager.getTimes(8305) == 0)
         {
            _loc2_ = [2,3,4,5,6,7,8,9];
            this._queue = "1";
            while(_loc2_.length > 1)
            {
               this._queue += _loc2_.splice(int(Math.random() * _loc2_.length),1)[0].toString();
            }
            ActivityExchangeCommander.exchange(8305,int(this._queue));
         }
         else
         {
            this._queue = ActivityExchangeTimesManager.getTimes(8305).toString();
            this.init();
         }
         ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchangeComplete);
      }
      
      private function init() : void
      {
         this._gettedCount = 0;
         var _loc1_:int = int(ActivityExchangeTimesManager.getTimes(8236));
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < this.CONFIG_NPCS.length)
         {
            if(int(_loc1_ / Math.pow(10,_loc3_)) % 10)
            {
               ++this._gettedCount;
            }
            else if(_loc3_ > 0)
            {
               _loc2_.push(this.CONFIG_NPCS[_loc3_]);
            }
            _loc3_++;
         }
         if(this._gettedCount < 8)
         {
            this._npcIDs = [];
            while(this._npcIDs.length < 8 - this._gettedCount)
            {
               this._npcIDs.push(this.CONFIG_NPCS[int(this._queue.charAt(this._gettedCount + this._npcIDs.length)) - 1]);
            }
            NpcDialogController.ed.addEventListener(NPCDialogEvent.NPC_DIALOG_WILL_ADD_ITEMS,this.onAddItemsHandle);
         }
      }
      
      protected function onAddItemsHandle(param1:NPCDialogEvent) : void
      {
         var _loc3_:QuestionInfo = null;
         var _loc2_:int = param1.npcID;
         if(_loc2_ == this._npcIDs[0])
         {
            _loc3_ = new QuestionInfo();
            _loc3_.desc = this.DIALOGS[this.CONFIG_NPCS.indexOf(_loc2_)];
            _loc3_.procType = QuestionInfo.PROC_PLUGIN;
            _loc3_.callback = this.getGiftHandle;
            NpcDialogItemFilter.addQuestionInfio(_loc3_,true);
         }
      }
      
      private function getGiftHandle() : void
      {
         ActivityExchangeCommander.exchange(this.GIFT_SWAP_IDS[8 - this._npcIDs.length]);
         NpcDialogController.hide();
      }
      
      private function onExchangeComplete(param1:ExchangeEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc2_:int = int(param1.info.id);
         if(_loc2_ == this.GIFT_SWAP_IDS[8 - this._npcIDs.length])
         {
            _loc3_ = this.CONFIG_NPCS.indexOf(this._npcIDs[0]);
            _loc4_ = int(ActivityExchangeTimesManager.getTimes(8236));
            _loc4_ = _loc4_ + Math.pow(10,_loc3_) * (9 - this._npcIDs.length);
            ActivityExchangeTimesManager.updataTimes(8236,_loc4_);
            ActivityExchangeCommander.exchange(8236,_loc4_);
            SwfCache.getSwfInfo(ClientConfig.getSubUI("spring_gift"),this.onEffectLoaded);
         }
         else if(_loc2_ == 8236)
         {
            _loc4_ = int(ActivityExchangeTimesManager.getTimes(8236));
            ActivityExchangeTimesManager.updataTimes(8236,_loc4_ - 1);
            this._npcIDs.shift();
         }
         else if(_loc2_ == 8305)
         {
            this.init();
         }
      }
      
      private function onEffectLoaded(param1:SwfInfo) : void
      {
         var _loc2_:MovieClip = param1.content as MovieClip;
         _loc2_.gotoAndPlay(1);
         _loc2_.addEventListener(Event.ENTER_FRAME,this.onMoviePlaying);
         MainManager.actorModel.addHeadContainerChild(_loc2_);
      }
      
      private function onMoviePlaying(param1:Event) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         if(_loc2_.totalFrames == _loc2_.currentFrame)
         {
            _loc2_.stop();
            _loc2_.removeEventListener(Event.ENTER_FRAME,this.onMoviePlaying);
            MainManager.actorModel.removeHeadContainerChild(_loc2_);
         }
      }
      
      public function gettedCount() : int
      {
         return 8 - (this._npcIDs ? this._npcIDs.length : 0);
      }
      
      public function getNextNPC() : int
      {
         return this._npcIDs[0];
      }
      
      override public function uninstall() : void
      {
         super.uninstall();
      }
   }
}

