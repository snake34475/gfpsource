package com.gfp.app.cmdl
{
   import com.gfp.core.CommandID;
   import com.gfp.core.events.UserItemEvent;
   import com.gfp.core.info.item.SingleEquipInfo;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.net.SocketConnection;
   import flash.utils.ByteArray;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   
   public class EquiptPropertyChangeCmdListener extends BaseBean
   {
      
      public function EquiptPropertyChangeCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.EQUIP_PROPERTY_CHANGE,this.equiptPropertyChangeHandle);
         finish();
      }
      
      private function equiptPropertyChangeHandle(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         var _loc4_:int = int(_loc2_.readUnsignedInt());
         var _loc5_:SingleEquipInfo = ItemManager.getEquipByleftTime(_loc4_);
         if(_loc5_)
         {
            _loc5_.strengthenLV = _loc2_.readUnsignedInt();
            ItemManager.dispatcher.dispatchEvent(new UserItemEvent(UserItemEvent.ITEM_DETAIL,_loc5_));
         }
      }
   }
}

