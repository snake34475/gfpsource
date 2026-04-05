package com.gfp.app.manager
{
   import com.gfp.app.ParseSocketError;
   import com.gfp.app.manager.mapEvents.CommMapEventIds;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.events.CommEvent;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.events.ServerUniqDataEvent;
   import com.gfp.core.events.SocketErrorCodeEvent;
   import com.gfp.core.info.ActivityExchangeAwardInfo;
   import com.gfp.core.info.SwapActionLimitInfo;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.FunctionManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.ServerUniqDataManager;
   import com.gfp.core.net.SocketConnection;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import org.taomee.ds.HashMap;
   import org.taomee.net.SocketEvent;
   
   public class GfCityCelebrateManager
   {
      
      private static var isGetting:Boolean;
      
      public static var isGetGift:Boolean;
      
      public static var giftCountMap:HashMap;
      
      private static var _giftIndex:uint;
      
      public static var isFull:Boolean;
      
      public static const COMMIT_COMPLETE:String = "COMMIT_COMPLETE";
      
      public static const GET_GIFT_COUNT_BACK:String = "GET_GIFT_COUNT_BACK";
      
      public static const SWAP_IDS:Array = [1482,1483,1484,1485];
      
      public static const ITEM_IDS:Array = [1400229,1400230,1400231,1400232];
      
      public static const COMMIT_SWAP_IDS:Array = [1486,1487,1488,1489];
      
      public static var evtDispatch:EventDispatcher = new EventDispatcher();
      
      public function GfCityCelebrateManager()
      {
         super();
      }
      
      public static function getGift(param1:uint) : void
      {
         if(!isGetting)
         {
            if(!isGetGift)
            {
               isGetting = true;
               ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,exchangeCompleteHandler);
               ActivityExchangeCommander.exchange(SWAP_IDS[param1]);
               ParseSocketError.addErrorCodeListener(CommandID.ACTIVITY_EXCHANGE,swapErrorHandler);
            }
            else
            {
               AlertManager.showSimpleAlarm("小侠士，每次只能运送一个礼品，请送至功夫城陆半仙后再回来索取！");
            }
         }
      }
      
      private static function swapErrorHandler(param1:SocketErrorCodeEvent) : void
      {
         isGetting = false;
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,exchangeCompleteHandler);
         ParseSocketError.removeErrorCodeListener(CommandID.ACTIVITY_EXCHANGE,swapErrorHandler);
      }
      
      private static function exchangeCompleteHandler(param1:ExchangeEvent) : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc2_:ActivityExchangeAwardInfo = param1.info;
         var _loc3_:int = SWAP_IDS.indexOf(_loc2_.id);
         if(_loc3_ != -1)
         {
            isGetting = false;
            isGetGift = true;
            ModuleManager.closeAllModule();
            ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,exchangeCompleteHandler);
            ParseSocketError.removeErrorCodeListener(CommandID.ACTIVITY_EXCHANGE,swapErrorHandler);
            ItemManager.addItem(ITEM_IDS[_loc3_],1);
            _loc4_ = ItemXMLInfo.getName(ITEM_IDS[_loc3_]);
            _loc5_ = AppLanguageDefine.GET_AWARD + 1 + AppLanguageDefine.SPECIAL_CHARACTER_SPACE[0] + _loc4_ + ", 请速速运往功夫城陆半仙处！";
            AlertManager.showSimpleItemAlarm(_loc5_,ClientConfig.getItemIcon(ITEM_IDS[_loc3_]));
            CommMapEventManager.addTimerFightEvent();
            FunctionManager.disabledActivityPanel = true;
            FunctionManager.disabledDemonreCorded = true;
            FunctionManager.disabledFightTeam = true;
            FunctionManager.disabledMap = true;
            FunctionManager.disabledMiniHome = true;
            FunctionManager.disabledMsg = true;
            FunctionManager.disabledNewspaper = true;
            FunctionManager.disabledPickItem = true;
            FunctionManager.disabledTask = true;
            FunctionManager.disabledTransfiguration = true;
            FunctionManager.disabledStorehouse = true;
            FunctionManager.disabledPvp = true;
            FunctionManager.disabledTradeHouse = true;
            FunctionManager.disabledPointTran = true;
            FunctionManager.disabledMail = true;
            FunctionManager.disabledGuaranteeTrade = true;
            FunctionManager.allowTollgate = [728,729,730,731,732];
            FunctionManager.evtDispatch.addEventListener(FunctionManager.FUNCTION_DISABLED,functionDisabledHandler);
            SocketConnection.addCmdListener(CommandID.REC_FIGHT_EVENT_OVER,escortFightResult);
         }
      }
      
      private static function functionDisabledHandler(param1:CommEvent) : void
      {
         AlertManager.showSimpleAlarm("小侠士，你正在押运物资，不能进行该操作。");
      }
      
      public static function commitGift(param1:int) : void
      {
         _giftIndex = param1;
         ActivityExchangeCommander.exchange(COMMIT_SWAP_IDS[param1]);
         ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,commitCompleteHandler);
         ParseSocketError.addErrorCodeListener(CommandID.ACTIVITY_EXCHANGE,commitGiftError);
      }
      
      private static function commitCompleteHandler(param1:ExchangeEvent) : void
      {
         var _loc2_:ActivityExchangeAwardInfo = param1.info;
         var _loc3_:int = COMMIT_SWAP_IDS.indexOf(_loc2_.id);
         if(_loc3_ != -1)
         {
            overEscor();
            evtDispatch.dispatchEvent(new CommEvent(COMMIT_COMPLETE));
            getGiftStock();
         }
      }
      
      public static function escortFightResult(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            AlertManager.showSimpleAlarm("小侠士，礼品已被怪物夺走，下次要努力哦!");
            overEscor();
         }
      }
      
      private static function overEscor() : void
      {
         isGetGift = false;
         var _loc1_:int = 0;
         while(_loc1_ < ITEM_IDS.length)
         {
            if(ItemManager.getItemCount(GfCityCelebrateManager.ITEM_IDS[_loc1_]) > 0)
            {
               ItemManager.removeItem(ITEM_IDS[_loc1_],1);
               break;
            }
            _loc1_++;
         }
         FunctionManager.disabledActivityPanel = false;
         FunctionManager.disabledDemonreCorded = false;
         FunctionManager.disabledFightTeam = false;
         FunctionManager.disabledMap = false;
         FunctionManager.disabledMiniHome = false;
         FunctionManager.disabledMsg = false;
         FunctionManager.disabledNewspaper = false;
         FunctionManager.disabledPickItem = false;
         FunctionManager.disabledTask = false;
         FunctionManager.disabledTransfiguration = false;
         FunctionManager.disabledStorehouse = false;
         FunctionManager.disabledPvp = false;
         FunctionManager.disabledTradeHouse = false;
         FunctionManager.disabledPointTran = false;
         FunctionManager.disabledMail = false;
         FunctionManager.disabledGuaranteeTrade = false;
         FunctionManager.allowTollgate = [];
         FunctionManager.evtDispatch.removeEventListener(FunctionManager.FUNCTION_DISABLED,functionDisabledHandler);
         SocketConnection.removeCmdListener(CommandID.REC_FIGHT_EVENT_OVER,escortFightResult);
         CommMapEventManager.destroyEvtById(CommMapEventIds.TIME_FIGHT);
      }
      
      private static function commitGiftError(param1:SocketErrorCodeEvent = null) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < ITEM_IDS.length)
         {
            if(ItemManager.getItemCount(GfCityCelebrateManager.ITEM_IDS[_loc2_]) > 0)
            {
               if(!param1)
               {
                  AlertManager.showSimpleAlarm("小侠士，我需要的" + ItemXMLInfo.getName(GfCityCelebrateManager.ITEM_IDS[_loc2_]) + "已经满了，您的速度不够快哦！");
               }
               overEscor();
               return;
            }
            _loc2_++;
         }
      }
      
      public static function getGiftStock() : void
      {
         ServerUniqDataManager.addListener(ServerUniqDataEvent.EVENT_GF_CITY_CELEBRATE,getGiftStockHandler);
         ServerUniqDataManager.requestDateByType(ServerUniqDataManager.TYPE_GF_CITY_CELEBRATE);
      }
      
      private static function getGiftStockHandler(param1:ServerUniqDataEvent) : void
      {
         var _loc3_:SwapActionLimitInfo = null;
         var _loc2_:Vector.<SwapActionLimitInfo> = param1.serverUniqDataInfo.infoArr;
         giftCountMap = new HashMap();
         isFull = true;
         for each(_loc3_ in _loc2_)
         {
            giftCountMap.add(_loc3_.dailyID,_loc3_.limitCount);
            if(_loc3_.limitCount != 0)
            {
               isFull = false;
            }
         }
         evtDispatch.dispatchEvent(new CommEvent(GET_GIFT_COUNT_BACK));
         if(isFull && isGetGift)
         {
            ActivityExchangeCommander.exchange(1499);
            commitGiftError();
         }
      }
   }
}

