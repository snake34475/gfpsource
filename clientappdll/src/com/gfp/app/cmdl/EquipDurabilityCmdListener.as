package com.gfp.app.cmdl
{
   import com.gfp.app.fight.CustomEvent;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.info.item.ItemNorInfo;
   import com.gfp.core.info.item.SingleEquipInfo;
   import com.gfp.core.manager.EquipDurabilityAlertManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.TimeUtil;
   import flash.utils.ByteArray;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   
   public class EquipDurabilityCmdListener extends BaseBean
   {
      
      public function EquipDurabilityCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.EQUIP_STATUS_NOTIFY,this.onEquipDurabilityNotify);
         SocketConnection.addCmdListener(CommandID.EQUIP_FU_MO,this.onEquipFuMoHanlde);
         SocketConnection.addCmdListener(CommandID.EQUIP_RONG_LIAN,this.onEquipRongLianHandle);
         finish();
      }
      
      private function onEquipDurabilityNotify(param1:SocketEvent) : void
      {
         EquipDurabilityAlertManager.addEquipData(param1.data as ByteArray);
      }
      
      private function onEquipRongLianHandle(param1:SocketEvent) : void
      {
         var _loc12_:int = 0;
         var _loc13_:uint = 0;
         var _loc14_:uint = 0;
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         var _loc4_:int = int(_loc2_.readUnsignedInt());
         var _loc5_:int = int(_loc2_.readUnsignedInt());
         var _loc6_:int = int(_loc2_.readUnsignedInt());
         var _loc7_:int = int(_loc2_.readUnsignedInt());
         var _loc8_:int = int(_loc2_.readUnsignedInt());
         var _loc9_:int = int(_loc2_.readUnsignedInt());
         var _loc10_:int = int(_loc2_.readUnsignedInt());
         var _loc11_:int = int(_loc2_.readUnsignedInt());
         ItemManager.removeEquipByuniqueId(_loc9_);
         if(_loc11_ > 0)
         {
            _loc12_ = 0;
            while(_loc12_ < _loc11_)
            {
               _loc13_ = _loc2_.readUnsignedInt();
               _loc14_ = _loc2_.readUnsignedInt();
               ItemManager.removeItem(_loc13_,_loc14_);
               _loc12_++;
            }
         }
         var _loc15_:SingleEquipInfo = new SingleEquipInfo();
         _loc15_.itemID = _loc8_;
         _loc15_.leftTime = _loc9_;
         _loc15_.duration = int(ItemXMLInfo.getDuration(_loc15_.itemID)) * 50;
         _loc15_.level = ItemXMLInfo.getUserLevel(_loc15_.itemID);
         var _loc16_:ItemNorInfo = ItemXMLInfo.getItemInfo(_loc15_.itemID);
         if(_loc16_.lifeTime != 0)
         {
            _loc15_.gotTimeInSecond = TimeUtil.getLoginTimeInSecond();
            _loc15_.endTimeInSecond = TimeUtil.getLoginTimeInSecond() + _loc16_.lifeTime * 86400;
         }
         ItemManager.addEquip(_loc15_);
         var _loc17_:Object = {
            "action":_loc3_,
            "equip":_loc4_,
            "quality":_loc5_,
            "trade":_loc6_,
            "ronglian":_loc7_,
            "info":_loc15_
         };
         _loc15_.ronglianMode = _loc7_;
         ItemManager.dispatcher.dispatchEvent(new CustomEvent(CustomEvent.EQUIP_RONG_LIAN,false,false,_loc17_));
         MainManager.actorInfo.replaceEquip(_loc15_);
      }
      
      private function onEquipFuMoHanlde(param1:SocketEvent) : void
      {
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         var _loc6_:uint = _loc2_.readUnsignedInt();
         var _loc7_:int = 0;
         while(_loc7_ < 3)
         {
            _loc9_ = _loc2_.readUnsignedInt();
            _loc10_ = _loc2_.readUnsignedInt();
            ItemManager.removeItem(_loc9_,_loc10_);
            _loc7_++;
         }
         var _loc8_:SingleEquipInfo = ItemManager.getEquipByleftTime(_loc3_);
         if((Boolean(_loc8_)) && _loc4_ == 1)
         {
            _loc8_.classType = _loc5_;
            _loc8_.classValue = _loc6_;
            ItemManager.dispatcher.dispatchEvent(new CustomEvent(CustomEvent.EQUIP_FU_MO,false,false,_loc8_));
         }
      }
   }
}

