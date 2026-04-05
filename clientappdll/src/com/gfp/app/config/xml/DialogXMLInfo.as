package com.gfp.app.config.xml
{
   import com.gfp.app.info.dialog.NpcDialogInfo;
   import org.taomee.ds.HashMap;
   
   public class DialogXMLInfo
   {
      
      private static var _dataHash:HashMap;
      
      private static var xmlClass:Class = DialogXMLInfo_xmlClass;
      
      setup();
      
      public function DialogXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var _loc2_:XML = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:NpcDialogInfo = null;
         var _loc1_:XMLList = XML(new xmlClass()).elements("npc");
         _dataHash = new HashMap();
         for each(_loc2_ in _loc1_)
         {
            _loc3_ = uint(_loc2_.@id);
            _loc4_ = uint(_loc2_.@otherId);
            _loc5_ = new NpcDialogInfo(_loc2_);
            _dataHash.add(_loc3_,_loc5_);
            if(_loc4_ != 0)
            {
               _dataHash.add(_loc4_,_loc5_);
            }
         }
      }
      
      public static function getInfos(param1:uint) : NpcDialogInfo
      {
         return _dataHash.getValue(param1);
      }
   }
}

