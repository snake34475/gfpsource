package com.gfp.app.manager
{
   import com.gfp.app.ParseSocketError;
   import com.gfp.app.info.GuaranteeTradeInfo;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.events.CommEvent;
   import com.gfp.core.events.SocketErrorCodeEvent;
   import com.gfp.core.info.FriendInviteInfo;
   import com.gfp.core.info.item.SingleEquipInfo;
   import com.gfp.core.info.item.SingleItemInfo;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.language.ModuleLanguageDefine;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.FunctionManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.PayPasswordManager;
   import com.gfp.core.manager.TradeManager;
   import com.gfp.core.net.SocketConnection;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.Delegate;
   
   public class GuaranteeTradeManager
   {
      
      private static var _instance:GuaranteeTradeManager;
      
      public static const TRADE_STATE_BEGIN:uint = 1;
      
      public static const TRADE_STATE_OK:uint = 2;
      
      public static const TRADE_STATE_SUBMIT:uint = 3;
      
      public static const GUARATEE_TRADE_BEGIN:String = "guaratee_trade_begin";
      
      public static const GUARATEE_TRADE_OK:String = "guaratee_trade_ok";
      
      public static const GUARATEE_TRADE_SUBMIT:String = "guaratee_trade_submit";
      
      public static const GUARATEE_TRADE_CANCEL:String = "guaratee_trade_cancel";
      
      public static const GUARATEE_TRADE_CANCEL_WAIT:String = "guaratee_trade_cancel_wait";
      
      private var _ed:EventDispatcher;
      
      public var tradeRoomId:uint;
      
      public var tradeUserId:uint;
      
      public var tradeState:uint;
      
      public var eachOtherItems:Vector.<GuaranteeTradeInfo>;
      
      public var eachOtherCoin:uint;
      
      public var eachOtherIsCheck:Boolean;
      
      public var popError:Boolean;
      
      public function GuaranteeTradeManager()
      {
         super();
         SocketConnection.addCmdListener(CommandID.GUARANTEE_TRADE_CANCEL,this.cancelTradeHandler);
         SocketConnection.addCmdListener(CommandID.GUARANTEE_TRADE_OK,this.okTradeHandler);
         SocketConnection.addCmdListener(CommandID.GUARANTEE_TRADE_SUBMIT,this.submitTradeHandler);
         SocketConnection.addCmdListener(CommandID.GUARANTEE_TRADE_APPLY_RESPONSE,this.responseBackHandler);
         ParseSocketError.addErrorCodeListener(CommandID.GUARANTEE_TRADE_APPLY_REQUEST,this.tradeApplyErrorHandler);
      }
      
      public static function get instance() : GuaranteeTradeManager
      {
         if(!_instance)
         {
            _instance = new GuaranteeTradeManager();
         }
         return _instance;
      }
      
      public function get ed() : EventDispatcher
      {
         if(!this._ed)
         {
            this._ed = new EventDispatcher();
         }
         return this._ed;
      }
      
      public function sendTradeRequest(param1:uint, param2:uint) : void
      {
         var backFunc:Function;
         var useId:uint = param1;
         var roleId:uint = param2;
         if(FunctionManager.disabledGuaranteeTrade)
         {
            FunctionManager.dispatchDisabledEvt();
            return;
         }
         if(useId == MainManager.actorID)
         {
            return;
         }
         if(TradeManager.isOnSale)
         {
            AlertManager.showSimpleAlarm("亲爱的小侠士，您当前处于开店状态，不能和别人进行交易！");
            return;
         }
         if(MainManager.actorInfo.lv < 40)
         {
            AlertManager.showSimpleAlarm("小侠士，满40级后才能担保交易。");
            return;
         }
         if(MainManager.actorInfo.coins < 10000)
         {
            AlertManager.showSimpleAlarm(ModuleLanguageDefine.GUARANTEE_TRADE_MSG[9]);
            return;
         }
         backFunc = function():void
         {
            popError = false;
            PayPasswordManager.instance.showPasswordCheckPanel(Delegate.create(checkPassBack,useId,roleId));
         };
         AlertManager.showSimpleAnswer(ModuleLanguageDefine.GUARANTEE_TRADE_MSG[8],backFunc);
      }
      
      private function checkPassBack(param1:uint, param2:uint) : void
      {
         ModuleManager.turnModule(ClientConfig.getAppModule("GuaranteeTradeWaitPanel"),"...");
         SocketConnection.send(CommandID.GUARANTEE_TRADE_APPLY_REQUEST,param1,param2);
         MainManager.actorInfo.coins -= 10000;
      }
      
      public function responseTradeRequest(param1:uint, param2:uint) : void
      {
         PayPasswordManager.instance.showPasswordCheckPanel(Delegate.create(this.responseTradeCheckPassBack,param1,param2));
      }
      
      private function responseTradeCheckPassBack(param1:uint, param2:uint) : void
      {
         SocketConnection.send(CommandID.GUARANTEE_TRADE_APPLY_RESPONSE,FriendInviteInfo.GUARANTEE_TRADE,param1,param2,1);
      }
      
      private function responseBackHandler(param1:SocketEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc2_:ByteArray = param1.data as ByteArray;
         if(_loc2_)
         {
            _loc3_ = _loc2_.readUnsignedInt();
            if(_loc3_ == 0)
            {
               _loc4_ = _loc2_.readUnsignedInt();
               _loc5_ = _loc2_.readUnsignedInt();
               this.init(_loc4_,_loc5_,0);
               MainManager.actorInfo.coins -= 10000;
            }
            else
            {
               AlertManager.showSimpleAlarm(ModuleLanguageDefine.GUARANTEE_TRADE_MSG[4]);
            }
         }
      }
      
      public function init(param1:uint, param2:uint, param3:uint) : void
      {
         this.tradeUserId = param1;
         this.tradeRoomId = param2;
         this.beginGuaranteeTrade();
      }
      
      public function beginGuaranteeTrade() : void
      {
         this.tradeState = TRADE_STATE_BEGIN;
         this.ed.dispatchEvent(new CommEvent(GUARATEE_TRADE_CANCEL_WAIT));
         ModuleManager.turnModule(ClientConfig.getAppModule("GuaranteeTradePanel"),"...");
      }
      
      private function tradeApplyErrorHandler(param1:SocketErrorCodeEvent) : void
      {
         this.popError = true;
         switch(param1.headInfo.error)
         {
            case 10225:
               AlertManager.showSimpleAlarm("亲爱的小侠士，对方当前不能和你进行担保交易！");
         }
         MainManager.actorInfo.coins += 10000;
         this.ed.dispatchEvent(new CommEvent(GUARATEE_TRADE_CANCEL_WAIT));
      }
      
      public function lockGuaranteeTrade(param1:Vector.<GuaranteeTradeInfo>, param2:uint) : void
      {
         var _loc8_:GuaranteeTradeInfo = null;
         this.tradeState = TRADE_STATE_OK;
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeUnsignedInt(this.tradeRoomId);
         _loc3_.writeUnsignedInt(1);
         _loc3_.writeUnsignedInt(param2);
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:ByteArray = new ByteArray();
         var _loc7_:ByteArray = new ByteArray();
         for each(_loc8_ in param1)
         {
            if(_loc8_.type != GuaranteeTradeInfo.EQUIP)
            {
               _loc4_++;
               _loc6_.writeUnsignedInt(_loc8_.itemId);
               _loc6_.writeUnsignedInt(_loc8_.itemNum);
            }
         }
         for each(_loc8_ in param1)
         {
            if(_loc8_.type == GuaranteeTradeInfo.EQUIP)
            {
               _loc5_++;
               _loc7_.writeUnsignedInt(_loc8_.itemId);
               _loc7_.writeUnsignedInt(_loc8_.uniqueId);
               _loc7_.writeUnsignedInt(SingleEquipInfo(_loc8_.info).strengthenLV);
            }
         }
         _loc3_.writeUnsignedInt(_loc4_);
         _loc3_.writeUnsignedInt(_loc5_);
         _loc3_.writeBytes(_loc6_,0,_loc6_.length);
         _loc3_.writeBytes(_loc7_,0,_loc7_.length);
         SocketConnection.send(CommandID.GUARANTEE_TRADE_OK,_loc3_);
      }
      
      public function exchangeItem() : void
      {
         this.tradeState = TRADE_STATE_BEGIN;
         var _loc1_:ByteArray = new ByteArray();
         _loc1_.writeUnsignedInt(this.tradeRoomId);
         _loc1_.writeUnsignedInt(2);
         _loc1_.writeUnsignedInt(0);
         _loc1_.writeUnsignedInt(0);
         _loc1_.writeUnsignedInt(0);
         SocketConnection.send(CommandID.GUARANTEE_TRADE_OK,_loc1_);
      }
      
      private function cancelTradeHandler(param1:SocketEvent) : void
      {
         var _loc2_:uint = (param1.data as ByteArray).readUnsignedInt();
         this.reset();
         this.ed.dispatchEvent(new CommEvent(GUARATEE_TRADE_CANCEL));
         this.ed.dispatchEvent(new CommEvent(GUARATEE_TRADE_CANCEL_WAIT));
      }
      
      private function okTradeHandler(param1:SocketEvent) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:int = 0;
         var _loc8_:GuaranteeTradeInfo = null;
         var _loc9_:uint = 0;
         var _loc10_:SingleItemInfo = null;
         var _loc11_:SingleEquipInfo = null;
         this.eachOtherItems = new Vector.<GuaranteeTradeInfo>();
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         if(_loc3_ == this.tradeRoomId)
         {
            _loc4_ = _loc2_.readUnsignedInt();
            _loc5_ = _loc2_.readUnsignedInt();
            if(_loc5_ == MainManager.actorID)
            {
               return;
            }
            this.eachOtherIsCheck = !this.eachOtherIsCheck;
            this.eachOtherCoin = _loc2_.readUnsignedInt();
            _loc6_ = _loc2_.readUnsignedInt();
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               _loc8_ = new GuaranteeTradeInfo();
               _loc8_.itemId = _loc2_.readUnsignedInt();
               _loc8_.itemNum = _loc2_.readUnsignedInt();
               _loc8_.type = GuaranteeTradeInfo.ITEM;
               _loc10_ = new SingleItemInfo();
               _loc10_.itemID = _loc8_.itemId;
               _loc10_.itemNum = _loc8_.itemNum;
               _loc8_.info = _loc10_;
               this.eachOtherItems.push(_loc8_);
               _loc7_++;
            }
            _loc9_ = _loc2_.readUnsignedInt();
            _loc7_ = 0;
            while(_loc7_ < _loc9_)
            {
               _loc8_ = new GuaranteeTradeInfo();
               _loc8_.itemId = _loc2_.readUnsignedInt();
               _loc8_.uniqueId = _loc2_.readUnsignedInt();
               _loc8_.itemNum = 1;
               _loc8_.type = GuaranteeTradeInfo.EQUIP;
               _loc11_ = new SingleEquipInfo();
               _loc11_.itemID = _loc8_.itemId;
               _loc11_.leftTime = _loc8_.uniqueId;
               _loc11_.strengthenLV = _loc2_.readUnsignedInt();
               _loc11_.legendValue1 = _loc2_.readUnsignedInt();
               _loc11_.legendValue2 = _loc2_.readUnsignedInt();
               _loc11_.legendValue3 = _loc2_.readUnsignedInt();
               _loc11_.classType = _loc2_.readUnsignedInt();
               _loc11_.classValue = _loc2_.readUnsignedInt();
               _loc11_.ronglianMode = _loc2_.readUnsignedInt();
               _loc11_.tradeMode = _loc2_.readUnsignedInt();
               _loc8_.info = _loc11_;
               this.eachOtherItems.push(_loc8_);
               _loc7_++;
            }
            this.ed.dispatchEvent(new CommEvent(GUARATEE_TRADE_OK));
         }
      }
      
      public function submitTrade() : void
      {
         SocketConnection.send(CommandID.GUARANTEE_TRADE_SUBMIT,this.tradeRoomId);
      }
      
      private function submitTradeHandler(param1:SocketEvent) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:int = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:String = null;
         var _loc13_:uint = 0;
         var _loc14_:uint = 0;
         var _loc15_:SingleEquipInfo = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         if(_loc3_ == 1)
         {
            AlertManager.showSimpleAlarm(ModuleLanguageDefine.GUARANTEE_TRADE_MSG[3]);
         }
         else
         {
            _loc4_ = _loc2_.readUnsignedInt();
            if(MainManager.actorInfo.coins < _loc4_)
            {
               AlertManager.showSimpleAlarm(AppLanguageDefine.GET_AWARD + (_loc4_ - MainManager.actorInfo.coins) + AppLanguageDefine.SPECIAL_CHARACTER_SPACE[0] + AppLanguageDefine.GET_AWARD_COLLECTION[0]);
            }
            MainManager.actorInfo.coins = _loc4_;
            _loc5_ = _loc2_.readUnsignedInt();
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc7_ = _loc2_.readUnsignedInt();
               _loc8_ = _loc2_.readUnsignedInt();
               ItemManager.removeItem(_loc7_,_loc8_);
               _loc6_++;
            }
            _loc11_ = _loc2_.readUnsignedInt();
            _loc6_ = 0;
            while(_loc6_ < _loc11_)
            {
               _loc7_ = _loc2_.readUnsignedInt();
               _loc9_ = _loc2_.readUnsignedInt();
               _loc10_ = _loc2_.readUnsignedInt();
               _loc2_.readUnsignedInt();
               _loc2_.readUnsignedInt();
               _loc2_.readUnsignedInt();
               _loc2_.readUnsignedInt();
               _loc2_.readUnsignedInt();
               _loc2_.readUnsignedInt();
               _loc2_.readUnsignedInt();
               ItemManager.removeEquipByuniqueId(_loc9_);
               _loc6_++;
            }
            _loc12_ = "";
            _loc13_ = _loc2_.readUnsignedInt();
            _loc6_ = 0;
            while(_loc6_ < _loc13_)
            {
               _loc7_ = _loc2_.readUnsignedInt();
               _loc8_ = _loc2_.readUnsignedInt();
               ItemManager.addItem(_loc7_,_loc8_);
               _loc12_ = AppLanguageDefine.GET_AWARD + _loc8_ + AppLanguageDefine.SPECIAL_CHARACTER_SPACE[0] + ItemXMLInfo.getName(_loc7_);
               AlertManager.showSimpleItemAlarm(_loc12_,ClientConfig.getItemIcon(_loc7_));
               _loc6_++;
            }
            _loc14_ = _loc2_.readUnsignedInt();
            _loc6_ = 0;
            while(_loc6_ < _loc14_)
            {
               _loc7_ = _loc2_.readUnsignedInt();
               _loc9_ = _loc2_.readUnsignedInt();
               _loc10_ = _loc2_.readUnsignedInt();
               _loc15_ = new SingleEquipInfo();
               _loc15_.itemID = _loc7_;
               _loc15_.leftTime = _loc9_;
               _loc15_.strengthenLV = _loc10_;
               _loc15_.legendValue1 = _loc2_.readUnsignedInt();
               _loc15_.legendValue2 = _loc2_.readUnsignedInt();
               _loc15_.legendValue3 = _loc2_.readUnsignedInt();
               _loc15_.classType = _loc2_.readUnsignedInt();
               _loc15_.classValue = _loc2_.readUnsignedInt();
               _loc15_.ronglianMode = _loc2_.readUnsignedInt();
               _loc15_.tradeMode = _loc2_.readUnsignedInt();
               ItemManager.addEquip(_loc15_);
               _loc12_ = AppLanguageDefine.GET_AWARD_SPACE + ItemXMLInfo.getName(_loc7_);
               AlertManager.showSimpleItemAlarm(_loc12_,ClientConfig.getItemIcon(_loc7_));
               _loc6_++;
            }
            this.reset();
            this.ed.dispatchEvent(new CommEvent(GUARATEE_TRADE_SUBMIT));
         }
      }
      
      public function cancelGuaranteeTrade() : void
      {
         SocketConnection.send(CommandID.GUARANTEE_TRADE_CANCEL,this.tradeRoomId);
      }
      
      public function reset() : void
      {
         this.eachOtherIsCheck = false;
         this.tradeRoomId = 0;
         this.tradeState = 0;
         this.tradeUserId = 0;
         this.eachOtherItems = new Vector.<GuaranteeTradeInfo>();
      }
      
      public function getCanTradeItems() : Array
      {
         var _loc5_:GuaranteeTradeInfo = null;
         var _loc6_:SingleEquipInfo = null;
         var _loc7_:SingleItemInfo = null;
         var _loc8_:SingleItemInfo = null;
         var _loc1_:Array = new Array(3);
         var _loc2_:Array = [];
         var _loc3_:Array = [];
         var _loc4_:Array = [];
         for each(_loc6_ in ItemManager.equipInBagList)
         {
            if(Boolean(_loc6_.isTradeable(true)) && _loc6_.strengthenLV < 8)
            {
               if(_loc6_.hasInlayJewelry == false)
               {
                  _loc5_ = new GuaranteeTradeInfo();
                  _loc5_.type = GuaranteeTradeInfo.EQUIP;
                  _loc5_.itemId = _loc6_.itemID;
                  _loc5_.uniqueId = _loc6_.leftTime;
                  _loc5_.info = _loc6_;
                  _loc2_.push(_loc5_);
               }
            }
         }
         for each(_loc7_ in ItemManager.itemList)
         {
            if(ItemXMLInfo.getTradeAble(_loc7_.itemID,true))
            {
               _loc5_ = new GuaranteeTradeInfo();
               _loc5_.type = GuaranteeTradeInfo.ITEM;
               _loc5_.itemId = _loc7_.itemID;
               _loc5_.itemNum = _loc7_.itemNum;
               _loc5_.info = _loc7_;
               _loc3_.push(_loc5_);
            }
         }
         for each(_loc8_ in ItemManager.materialsList)
         {
            if(ItemXMLInfo.getTradeAble(_loc8_.itemID,true))
            {
               _loc5_ = new GuaranteeTradeInfo();
               _loc5_.type = GuaranteeTradeInfo.MATERIAL;
               _loc5_.itemId = _loc8_.itemID;
               _loc5_.itemNum = _loc8_.itemNum;
               _loc5_.info = _loc8_;
               _loc4_.push(_loc5_);
            }
         }
         _loc1_[0] = _loc2_;
         _loc1_[1] = _loc3_;
         _loc1_[2] = _loc4_;
         return _loc1_;
      }
   }
}

