package com.gfp.app.cmdl
{
   import com.gfp.app.systems.ClientTempState;
   import com.gfp.app.toolBar.chat.MultiChatPanel;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.info.item.ItemNorInfo;
   import com.gfp.core.info.item.SingleEquipInfo;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.MessageManager;
   import com.gfp.core.manager.RideManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.TextFormatUtil;
   import com.gfp.core.utils.TextUtil;
   import flash.utils.ByteArray;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   
   public class QuickAddItemCmdListener extends BaseBean
   {
      
      public function QuickAddItemCmdListener()
      {
         super();
      }
      
      private static function addEquipt(param1:SingleEquipInfo, param2:Function, param3:Boolean) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:int = 0;
         ItemManager.addEquip(param1);
         if(ItemXMLInfo.isRideEquip(param1.itemID))
         {
            _loc5_ = uint(param1.itemID);
            _loc6_ = MainManager.loginTimeInSecond + _loc6_ * 86400;
            _loc6_ = int(ItemXMLInfo.getLifeTime(_loc5_));
            _loc6_ != 0 && (_loc6_);
            RideManager.addRide(_loc5_,_loc6_,param1.leftTime);
         }
         var _loc4_:String = AppLanguageDefine.GET_AWARD_SPACE + ItemXMLInfo.getName(param1.itemID);
         if(param3)
         {
            AlertManager.showSimpleItemAlarmFly(ItemXMLInfo.getName(param1.itemID),ClientConfig.getItemIcon(param1.itemID),{"num":1},param2);
         }
         else
         {
            MessageManager.showSystemChatMsg(_loc4_);
            TextAlert.show(TextFormatUtil.getRedText(_loc4_));
         }
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.ITEM_QUICK_PICKUP,this.whenQuickPickUpHandler);
         finish();
      }
      
      private function whenQuickPickUpHandler(param1:SocketEvent) : void
      {
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:SingleEquipInfo = null;
         var _loc10_:ItemNorInfo = null;
         var _loc11_:String = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         if(_loc2_.length == 12)
         {
            _loc7_ = _loc2_.readUnsignedInt();
         }
         else
         {
            _loc8_ = _loc2_.readUnsignedInt();
            _loc7_ = _loc2_.readUnsignedInt();
         }
         if(_loc3_ == MainManager.actorID)
         {
            if(_loc8_ == 1)
            {
               _loc9_ = new SingleEquipInfo();
               _loc9_.itemID = uint(_loc4_);
               _loc9_.leftTime = _loc7_;
               _loc9_.duration = int(ItemXMLInfo.getDuration(_loc9_.itemID)) * 50;
               _loc9_.level = ItemXMLInfo.getUserLevel(_loc9_.itemID);
               _loc10_ = ItemXMLInfo.getItemInfo(_loc9_.itemID);
               addEquipt(_loc9_,null,false);
               if(Boolean(ItemXMLInfo.isEquipt(_loc9_.itemID)) && !ItemXMLInfo.isFashionEquip(_loc9_.itemID))
               {
                  ItemManager.getEquiptDetail(_loc9_.leftTime);
               }
            }
            else
            {
               ItemManager.addItem(_loc4_,_loc7_);
            }
         }
         var _loc5_:String = "您";
         if(MapManager.currentMap == null)
         {
            TextAlert.show(_loc5_ + "获得了" + ItemXMLInfo.getName(_loc4_));
            MultiChatPanel.instance.showSystemNotice(_loc5_ + "获得了" + TextUtil.getCodeByItemId(_loc4_));
            return;
         }
         var _loc6_:uint = uint(MapManager.currentMap.info.mapType);
         if(ClientTempState.isCatDrawerAward && _loc4_ == 1740029)
         {
            return;
         }
         if(ClientTempState.isCloseDefaultAwardAlert)
         {
            return;
         }
         if(ClientTempState.isOpenDragonTreatmentPane == true && _loc4_ == 1740029)
         {
            return;
         }
         if(ClientTempState.quickAddItemCallBack != null)
         {
            if(ClientTempState.quickAddItemCallBack(_loc4_,_loc7_) == true)
            {
               return;
            }
         }
         if(_loc6_ != MapType.PVE && _loc6_ != MapType.PVP)
         {
            if(ClientTempState.isOpenDragonTreatmentPane)
            {
               _loc11_ = ClientConfig.getItemIcon(_loc4_);
               if(_loc4_ <= 10)
               {
                  _loc11_ = "";
               }
               AlertManager.showSimpleItemAlert("恭喜你完成本轮治疗，获得" + ItemXMLInfo.getName(_loc4_),_loc11_);
            }
            else if(_loc4_ == 1500577)
            {
               AlertManager.showSimpleAlarm("亲爱的小侠士，您刚才发出了" + _loc7_ / 2 + "个红包，同时您也获得了" + _loc7_ + "个发财红包！");
            }
            else
            {
               AlertManager.showSimpleItemAlarmFly(_loc7_.toString() + "个" + ItemXMLInfo.getName(_loc4_),ClientConfig.getItemIcon(_loc4_));
               MultiChatPanel.instance.showSystemNotice("恭喜" + _loc5_ + "获得" + _loc7_ + "个" + TextUtil.getCodeByItemId(_loc4_));
            }
         }
         else
         {
            TextAlert.show(_loc5_ + "获得了" + ItemXMLInfo.getName(_loc4_));
            MultiChatPanel.instance.showSystemNotice(_loc5_ + "获得了" + TextUtil.getCodeByItemId(_loc4_));
         }
      }
   }
}

