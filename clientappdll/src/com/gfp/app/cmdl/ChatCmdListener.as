package com.gfp.app.cmdl
{
   import com.gfp.core.CommandID;
   import com.gfp.core.Constant;
   import com.gfp.core.behavior.ChatBehavior;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.events.ChatEvent;
   import com.gfp.core.info.ChatInfo;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.MessageManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.TextUtil;
   import org.taomee.net.SocketEvent;
   
   public class ChatCmdListener
   {
      
      public function ChatCmdListener()
      {
         super();
      }
      
      public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.CHAT,this.onChat);
      }
      
      private function onChat(param1:SocketEvent) : void
      {
         var _loc2_:ChatInfo = param1.data as ChatInfo;
         if(_loc2_.toID == 0)
         {
            _loc2_.msg = TextUtil.encodeEmotion(_loc2_.msg);
            UserManager.execBehavior(_loc2_.senderID,new ChatBehavior(0,_loc2_.msg,0,false),false);
            MessageManager.dispatchEvent(new ChatEvent(ChatEvent.CHAT_COM,_loc2_));
            if(_loc2_.type == Constant.CHAT_TYPE_TRADE)
            {
               this.processTrace(_loc2_);
            }
            else if(_loc2_.type == Constant.CHAT_TYPE_SUPER_TRADE)
            {
               this.processSuperTrace(_loc2_);
            }
            else if(_loc2_.type == Constant.CHAT_TYPE_LABA)
            {
               if(_loc2_.senderID == MainManager.actorInfo.userID)
               {
                  if(ItemManager.getItemCount(1301212) > 0)
                  {
                     ItemManager.removeItem(1301212,1);
                  }
                  else if(ItemManager.getItemCount(1303031) > 0)
                  {
                     ItemManager.removeItem(1303031,1);
                  }
               }
            }
         }
         else
         {
            MessageManager.addChatInfo(_loc2_);
         }
      }
      
      private function processSuperTrace(param1:ChatInfo) : void
      {
         if(param1.senderID == MainManager.actorInfo.userID)
         {
            if(ItemManager.getItemCount(1303027) > 0)
            {
               ItemManager.removeItem(1303027,1);
            }
         }
      }
      
      private function processTrace(param1:ChatInfo) : void
      {
         var _loc2_:int = 0;
         if(param1.senderID == MainManager.actorInfo.userID)
         {
            _loc2_ = int(ItemXMLInfo.HAOJIAO_SHOP);
            if(ItemManager.getItemCount(ItemXMLInfo.HAOJIAO_SHOP) == 0)
            {
               _loc2_ = int(ItemXMLInfo.HAOJIAO_NOR);
            }
            ItemManager.removeItem(_loc2_,1);
         }
      }
   }
}

