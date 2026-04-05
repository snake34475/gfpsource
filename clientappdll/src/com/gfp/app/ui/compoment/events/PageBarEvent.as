package com.gfp.app.ui.compoment.events
{
   import flash.events.Event;
   
   public class PageBarEvent extends Event
   {
      
      public static const NEXT_PAGE:String = "next_page";
      
      public static const PREV_PAGE:String = "prev_page";
      
      public static const UPDATE:String = "update";
      
      public function PageBarEvent(param1:String)
      {
         super(param1);
      }
   }
}

