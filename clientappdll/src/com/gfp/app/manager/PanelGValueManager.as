package com.gfp.app.manager
{
   import flash.events.EventDispatcher;
   
   public class PanelGValueManager extends EventDispatcher
   {
      
      private static var _instance:PanelGValueManager;
      
      public static var FourYearsisNotShow:Boolean;
      
      public static var FullLvBaiHuExpNotShow:Boolean;
      
      public static var EatDumplingNotShow:Boolean;
      
      public static const TUHAO_POWER_V_CHANGED:String = "tuhao_power_v_changed";
      
      public static const EXP_BALL_CLOSE:String = "exp_ball_close";
      
      public static var anyingRoleType:Array = [1,3,5];
      
      public static var isAutoIntoLingXiao:Boolean = false;
      
      public var InputTickets:int;
      
      public var HandBallCount:int;
      
      public var isShowIntroduce:Boolean = true;
      
      public var quickUnlockcount:int = 0;
      
      public var dpsIsInit:Boolean = false;
      
      public function PanelGValueManager()
      {
         super();
      }
      
      public static function instance() : PanelGValueManager
      {
         return _instance = _instance || new PanelGValueManager();
      }
   }
}

