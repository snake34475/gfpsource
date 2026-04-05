package com.gfp.app.bag
{
   import flash.events.Event;
   
   public class BagEvent extends Event
   {
      
      public static const EQUIP_COMPLETE:String = "equipLoadComplete";
      
      public static const EQUIP_CHANGE:String = "equipChange";
      
      public static const ITEM_COMPLETE:String = "itemLoadComplete";
      
      public static const PAGE_CHANGE:String = "pageChange";
      
      public function BagEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}

