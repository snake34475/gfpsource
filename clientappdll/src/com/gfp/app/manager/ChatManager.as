package com.gfp.app.manager
{
   import com.gfp.app.chat.constant.ChatConstants;
   import com.gfp.core.Constant;
   import com.gfp.core.info.ChatInfo;
   import flash.events.EventDispatcher;
   
   public class ChatManager
   {
      
      public static var dispatcher:EventDispatcher = new EventDispatcher();
      
      private static var _boxVec:Vector.<ChatInfo> = new Vector.<ChatInfo>();
      
      public function ChatManager()
      {
         super();
      }
      
      public static function addBox(param1:ChatInfo) : void
      {
         addBoxVec(param1);
      }
      
      public static function getBoxs(param1:int) : Vector.<ChatInfo>
      {
         var vec:Vector.<ChatInfo> = null;
         var type:int = param1;
         if(type == Constant.CHAT_TYPE_ALL)
         {
            vec = _boxVec.filter(function(param1:ChatInfo, param2:int, param3:Vector.<ChatInfo>):Boolean
            {
               if(param1.type != Constant.CHAT_TYPE_SYSTEM && param1.type != Constant.CHAT_TYPE_SUPER_TRADE)
               {
                  return true;
               }
               return false;
            });
         }
         else
         {
            vec = _boxVec.filter(function(param1:ChatInfo, param2:int, param3:Vector.<ChatInfo>):Boolean
            {
               if(param1.type == type)
               {
                  return true;
               }
               return false;
            });
         }
         return vec;
      }
      
      public static function clearBox(param1:int = 999) : void
      {
         var type:int = param1;
         if(type == 999)
         {
            _boxVec.length = 0;
         }
         else
         {
            _boxVec = _boxVec.filter(function(param1:ChatInfo, param2:int, param3:Vector.<ChatInfo>):Boolean
            {
               if(param1.type == type)
               {
                  return false;
               }
               return true;
            });
         }
      }
      
      private static function addBoxVec(param1:ChatInfo) : void
      {
         _boxVec.push(param1);
         if(_boxVec.length > ChatConstants.BOX_VIEW_LINE)
         {
            _boxVec.shift();
         }
      }
   }
}

