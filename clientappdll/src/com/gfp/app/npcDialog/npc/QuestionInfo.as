package com.gfp.app.npcDialog.npc
{
   public class QuestionInfo
   {
      
      public static var PROC_DIALOG:uint = 1;
      
      public static var PROC_SHOP:uint = 2;
      
      public static var PROC_TASKACCEPT:uint = 3;
      
      public static var PROC_TASKPROCESS:uint = 4;
      
      public static var PROC_TASKOVER:uint = 5;
      
      public static var PROC_MINIGAME:uint = 6;
      
      public static var PROC_TOLLGATE:uint = 7;
      
      public static var PROC_PVPENTER:uint = 8;
      
      public static var PROC_SELL:uint = 9;
      
      public static var PROC_REPAIR:uint = 10;
      
      public static var PROC_APPMODULE:uint = 11;
      
      public static var PROC_ACTAMBA:uint = 12;
      
      public static var PROC_CUSTOM:uint = 13;
      
      public static var PROC_GOTOTOWER:uint = 14;
      
      public static var PROC_PAGEURL:uint = 15;
      
      public static var PROC_GOTOMAP:uint = 16;
      
      public static var PROC_ACTIVITYEXCHANGE:uint = 17;
      
      public static var PROC_ESCORT:uint = 18;
      
      public static var PROC_PLUGIN:uint = 19;
      
      public var desc:String;
      
      public var dialogs:Array;
      
      public var procType:uint;
      
      public var procParams:Array;
      
      public var sysTime:uint;
      
      public var lv:uint = 0;
      
      public var prior:uint;
      
      public var visible:String;
      
      public var callback:Function;
      
      public function QuestionInfo(param1:uint = 0)
      {
         super();
         this.prior = param1;
      }
   }
}

