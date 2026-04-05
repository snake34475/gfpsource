package com.gfp.app.cmdl
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.manager.fightPlugin.AutoFightManager;
   import com.gfp.app.toolBar.FightToolBar;
   import com.gfp.app.toolBar.chat.MultiChatPanel;
   import com.gfp.core.CommandID;
   import com.gfp.core.action.normal.PickupAction;
   import com.gfp.core.config.xml.ActionXMLInfo;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.KeyManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SOManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.Logger;
   import com.gfp.core.utils.TextFormatUtil;
   import com.gfp.core.utils.TextUtil;
   import flash.net.SharedObject;
   import flash.utils.ByteArray;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   
   public class ItemPickupCmdListener extends BaseBean
   {
      
      public function ItemPickupCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.ITEM_PICKUP,this.onItemPickup);
         finish();
      }
      
      private function onItemPickup(param1:SocketEvent) : void
      {
         var _loc4_:Boolean = false;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc9_:SharedObject = null;
         var _loc10_:uint = 0;
         var _loc11_:String = null;
         var _loc12_:uint = 0;
         var _loc13_:UserModel = null;
         var _loc14_:String = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         if(_loc3_ > 0 && !FightManager.isTeamFight && Boolean(MainManager.actorInfo.isVip) && !AutoFightManager.isAutoFighting)
         {
            if(MainManager.pveTollgateId != 0)
            {
               _loc9_ = SOManager.getActorSO("TollgatePickEff" + MainManager.actorID + MainManager.actorInfo.nick);
               if((Boolean(_loc9_)) && !_loc9_.data[MainManager.pveTollgateId])
               {
                  _loc9_.data[MainManager.pveTollgateId] = true;
                  FightToolBar.instance.showPickEff();
               }
            }
         }
         var _loc8_:int = 0;
         for(; _loc8_ < _loc3_; _loc8_++)
         {
            _loc4_ = _loc2_.readUnsignedByte() == 1;
            _loc5_ = _loc2_.readUnsignedInt();
            _loc6_ = _loc2_.readUnsignedInt();
            _loc7_ = _loc2_.readUnsignedInt();
            if(_loc4_)
            {
               _loc10_ = uint(param1.headInfo.userID);
               _loc11_ = Logger.createLogMsgByArr("拾取返回：",_loc5_,_loc10_);
               Logger.info(this,_loc11_);
               _loc12_ = uint(ItemManager.pickupItem(_loc5_,_loc10_,_loc6_));
               if(_loc12_ > 0)
               {
                  if(_loc10_ == MainManager.actorID)
                  {
                     TextAlert.show("你获得了 " + TextFormatUtil.getRedText(ItemXMLInfo.getName(_loc12_)));
                     MultiChatPanel.instance.showSystemNotice("你获得了 " + TextUtil.getCodeByItemId(_loc12_));
                     if(ItemXMLInfo.getCatID(_loc12_) == ItemXMLInfo.MEDICINE_CAT)
                     {
                        if(ItemXMLInfo.getShortcutable(_loc12_))
                        {
                           KeyManager.autoAddItemQuick(_loc12_,ItemXMLInfo.getUserLevel(_loc12_));
                        }
                     }
                  }
                  else
                  {
                     _loc13_ = UserManager.getModel(_loc10_);
                     if(_loc13_)
                     {
                        _loc14_ = TextUtil.htmlEncode(_loc13_.info.nick);
                        TextAlert.show(_loc14_ + "获得了" + TextFormatUtil.getRedText(ItemXMLInfo.getName(_loc12_)));
                        MultiChatPanel.instance.showSystemNotice(_loc14_ + "获得了" + TextUtil.getCodeByItemId(_loc12_));
                     }
                  }
                  if(_loc10_ != MainManager.actorID && _loc7_ == 0)
                  {
                     UserManager.execAction(_loc10_,new PickupAction(ActionXMLInfo.getInfo(10006),_loc5_,false));
                  }
               }
               continue;
            }
            switch(_loc5_)
            {
               case 3113:
                  TextAlert.show("装备背包已满");
                  break;
               case 3123:
                  TextAlert.show("物品背包已满");
                  break;
               case 1006:
                  TextAlert.show("物品数量超过上限");
            }
         }
      }
   }
}

