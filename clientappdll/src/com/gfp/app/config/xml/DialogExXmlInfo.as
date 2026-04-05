package com.gfp.app.config.xml
{
   import com.gfp.app.info.dialogex.DialogExInfo;
   import flash.utils.Dictionary;
   
   public class DialogExXmlInfo
   {
      
      private static var dic:Dictionary;
      
      private static var xmlClass:Class = DialogExXmlInfo_xmlClass;
      
      setup();
      
      public function DialogExXmlInfo()
      {
         super();
      }
      
      public static function getDialogInfoById(param1:int) : DialogExInfo
      {
         return dic[param1];
      }
      
      private static function setup() : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:DialogExInfo = null;
         dic = new Dictionary();
         var _loc1_:XMLList = XML(new xmlClass()).elements("d");
         for each(_loc2_ in _loc1_)
         {
            _loc3_ = parseInt(_loc2_.@id);
            _loc4_ = new DialogExInfo();
            buildDialogInfo(_loc2_,_loc4_);
            dic[_loc3_] = _loc4_;
         }
      }
      
      private static function buildDialogInfo(param1:XML, param2:DialogExInfo) : void
      {
         var _loc3_:DialogExInfo = null;
         var _loc4_:XMLList = null;
         var _loc5_:XML = null;
         var _loc6_:DialogExInfo = null;
         param2.id = parseInt(param1.@id);
         param2.title = param1.@t;
         param2.select = param1.@s;
         param2.npcID = parseInt(param1.@npc);
         param2.mass = parseInt(param1.@m);
         param2.tran = param1.@tr;
         param2.params = param1.@p;
         if(param1.hasOwnProperty("d"))
         {
            _loc3_ = new DialogExInfo();
            param2.next = _loc3_;
            buildDialogInfo(param1.d[0],_loc3_);
         }
         else if(param1.hasOwnProperty("c"))
         {
            if(param1.c[0].hasOwnProperty("@s"))
            {
               param2.showCount = param1.c[0].@s;
            }
            param2.children = new Vector.<DialogExInfo>();
            _loc4_ = param1.c[0].d;
            for each(_loc5_ in _loc4_)
            {
               _loc6_ = new DialogExInfo();
               param2.children.push(_loc6_);
               buildDialogInfo(_loc5_,_loc6_);
            }
         }
      }
   }
}

