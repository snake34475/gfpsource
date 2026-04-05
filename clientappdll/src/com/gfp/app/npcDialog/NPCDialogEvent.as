package com.gfp.app.npcDialog
{
   import flash.events.Event;
   
   public class NPCDialogEvent extends Event
   {
      
      public static const INIT:String = "NPC_Dialog_INIT";
      
      public static const NPC_DIALOG_WILL_ADD_ITEMS:String = "NPC_DIALOG_WILL_ADD_ITEMS";
      
      public var npcID:int;
      
      public function NPCDialogEvent(param1:int, param2:String, param3:Boolean = false, param4:Boolean = false)
      {
         this.npcID = param1;
         super(param2,param3,param4);
      }
   }
}

