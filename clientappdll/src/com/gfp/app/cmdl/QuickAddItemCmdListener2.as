package com.gfp.app.cmdl
{
   import com.gfp.app.systems.ClientTempState;
   import com.gfp.app.toolBar.chat.MultiChatPanel;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.TextUtil;
   import flash.utils.ByteArray;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   
   public class QuickAddItemCmdListener2 extends BaseBean
   {
      
      public function QuickAddItemCmdListener2()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.ITEM_QUICK_PICKUP2,this.whenQuickPickUpHandler);
         finish();
      }
      
      private function whenQuickPickUpHandler(param1:SocketEvent) : void
      {
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:String = null;
         var _loc9_:uint = 0;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:int = int(_loc2_.readUnsignedInt());
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _loc2_.readUnsignedInt();
            _loc7_ = _loc2_.readUnsignedInt();
            if(_loc3_ == MainManager.actorID)
            {
               ItemManager.addItem(_loc6_,_loc7_);
            }
            _loc8_ = "您";
            if(MapManager.currentMap == null)
            {
               TextAlert.show(_loc8_ + "获得了" + ItemXMLInfo.getName(_loc6_));
               MultiChatPanel.instance.showSystemNotice(_loc8_ + "获得了" + TextUtil.getCodeByItemId(_loc6_));
               return;
            }
            _loc9_ = uint(MapManager.currentMap.info.mapType);
            if(ClientTempState.isCatDrawerAward && _loc6_ == 1740029)
            {
               return;
            }
            if(ClientTempState.isCloseDefaultAwardAlert)
            {
               return;
            }
            if(ClientTempState.quickAddItemCallBack != null)
            {
               if(ClientTempState.quickAddItemCallBack(_loc6_,_loc7_) == true)
               {
                  return;
               }
            }
            if(_loc9_ != MapType.PVE && _loc9_ != MapType.PVP)
            {
               if(_loc6_ == 1500577)
               {
                  AlertManager.showSimpleAlarm("亲爱的小侠士，您刚才发出了" + _loc7_ / 2 + "个红包，同时您也获得了" + _loc7_ + "个发财红包！");
               }
               else
               {
                  AlertManager.showSimpleItemAlarmFly(_loc7_.toString() + "个" + ItemXMLInfo.getName(_loc6_),ClientConfig.getItemIcon(_loc6_));
                  MultiChatPanel.instance.showSystemNotice("恭喜" + _loc8_ + "获得" + _loc7_ + "个" + TextUtil.getCodeByItemId(_loc6_));
               }
            }
            else
            {
               TextAlert.show(_loc8_ + "获得了" + ItemXMLInfo.getName(_loc6_));
               MultiChatPanel.instance.showSystemNotice(_loc8_ + "获得了" + TextUtil.getCodeByItemId(_loc6_));
            }
            _loc5_++;
         }
      }
   }
}

