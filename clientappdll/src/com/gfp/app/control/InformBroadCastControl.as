package com.gfp.app.control
{
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.ui.alert.TextAlert;
   import flash.utils.IDataInput;
   
   public class InformBroadCastControl
   {
      
      public function InformBroadCastControl()
      {
         super();
      }
      
      public static function parseInfo(param1:IDataInput) : void
      {
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc2_:uint = param1.readUnsignedInt();
         var _loc3_:uint = param1.readUnsignedInt();
         var _loc4_:uint = param1.readUnsignedInt();
         var _loc5_:String = param1.readUTFBytes(16);
         _loc6_ = param1.readUnsignedInt();
         _loc7_ = param1.readUnsignedInt();
         switch(_loc2_)
         {
            case 1:
               _loc8_ = _loc6_;
               _loc9_ = _loc7_;
               TextAlert.show("恭喜你，" + _loc5_ + "向你的南瓜罐里扔了" + _loc9_ + "个" + ItemXMLInfo.getName(_loc8_));
         }
      }
   }
}

