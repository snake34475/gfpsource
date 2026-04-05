package com.gfp.app.control
{
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.net.SocketConnection;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class HelpNcpConroller
   {
      
      private static var _inst:HelpNcpConroller;
      
      private var _customStart:int = 1041006;
      
      private var _npcIds:Array = [10410,10048,10402,10123];
      
      private var _itemArr:Array = [2740373,2740374,2740375];
      
      private var _swapIds:Array = [5190,5191,5192,5193];
      
      private var _customID:int;
      
      private var _needItems:Array;
      
      public function HelpNcpConroller()
      {
         super();
      }
      
      public static function get inst() : HelpNcpConroller
      {
         if(_inst == null)
         {
            _inst = new HelpNcpConroller();
         }
         return _inst;
      }
      
      public function getSwap(param1:int) : void
      {
         this._customID = param1;
         SocketConnection.addCmdListener(CommandID.HELP_NPC_GET_NEED,this.onGetNeed);
         SocketConnection.send(CommandID.HELP_NPC_GET_NEED,this._customID - this._customStart);
      }
      
      private function onGetNeed(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.HELP_NPC_GET_NEED,this.onGetNeed);
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         var _loc4_:Array = [];
         var _loc5_:int = 0;
         while(_loc5_ < 3)
         {
            _loc4_.push(_loc2_.readUnsignedInt());
            _loc5_++;
         }
         this._needItems = [];
         _loc5_ = 0;
         while(_loc5_ < 3)
         {
            if(_loc4_[_loc5_] != 0)
            {
               this._needItems.push({
                  "id":this._itemArr[_loc5_],
                  "count":_loc4_[_loc5_]
               });
            }
            _loc5_++;
         }
         var _loc6_:Array = ["当日六翼神龙袭击了功夫城，弄得我现在浑身上下都是伤，需要" + ItemXMLInfo.getName(this._needItems[0].id) + this._needItems[0].count + "个，" + ItemXMLInfo.getName(this._needItems[1].id) + this._needItems[1].count + "个来帮助我疗伤，小侠士能帮助我吗？"];
         var _loc7_:Array = ["我正好有这些东西"];
         NpcDialogController.showForSingles(_loc6_,_loc7_,this._npcIds[this._customID - this._customStart],this.confirmFunc);
      }
      
      private function confirmFunc() : void
      {
         if(this.getCount(this._needItems[0].id) >= this._needItems[0].count && this.getCount(this._needItems[1].id) >= this._needItems[1].count)
         {
            ActivityExchangeCommander.instance.closeID(this._swapIds[this._customID - this._customStart]);
            ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onSwapRewardOver);
            ActivityExchangeCommander.exchange(this._swapIds[this._customID - this._customStart]);
         }
         else
         {
            AlertManager.showSimpleAlarm("小侠士你的物品不足，你需要<font color=\'#FF0000\'>" + this.getName(this._needItems[0].id) + " * " + this._needItems[0].count + "，" + this.getName(this._needItems[1].id) + " * " + this._needItems[1].count + "</font>才能兑换。");
         }
      }
      
      private function getCount(param1:int) : int
      {
         return ItemManager.getItemCount(param1);
      }
      
      private function getName(param1:int) : String
      {
         return ItemXMLInfo.getName(param1);
      }
      
      private function onSwapRewardOver(param1:ExchangeEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onSwapRewardOver);
         if(param1.info.addVec.length > 0)
         {
            _loc2_ = int(param1.info.addVec[0].count);
            _loc3_ = int(param1.info.addVec[0].id);
            AlertManager.showSimpleAlarm("恭喜你获得" + _loc2_ + "个" + "贡献值" + "!");
         }
      }
   }
}

