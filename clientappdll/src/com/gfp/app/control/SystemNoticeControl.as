package com.gfp.app.control
{
   import com.gfp.app.info.SystemNoticeInfo;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.SysNoticeManager;
   
   public class SystemNoticeControl
   {
      
      public static const TIME_NOTICE:uint = 1;
      
      public static const LOOP_NOTICE:uint = 2;
      
      public function SystemNoticeControl()
      {
         super();
      }
      
      public static function notice(param1:String = "", param2:Boolean = false, param3:uint = 2) : void
      {
         var _loc4_:SystemNoticeInfo = null;
         _loc4_ = new SystemNoticeInfo();
         _loc4_.type = param3;
         _loc4_.content = param1;
         if(param2)
         {
            SysNoticeManager.waiteNoticeArr.unshift(_loc4_);
         }
         else
         {
            SysNoticeManager.waiteNoticeArr.push(_loc4_);
         }
         ModuleManager.turnAppModule("SystemNoticePanel","",_loc4_);
      }
   }
}

