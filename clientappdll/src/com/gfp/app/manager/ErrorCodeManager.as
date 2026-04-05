package com.gfp.app.manager
{
   import com.gfp.app.manager.error.ErrorEvent;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.net.SocketConnection;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import org.taomee.ds.HashMap;
   import org.taomee.net.SocketEvent;
   
   public class ErrorCodeManager
   {
      
      private static var errorCodeMap:HashMap;
      
      private static var ed:EventDispatcher = new EventDispatcher();
      
      public function ErrorCodeManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         SocketConnection.addCmdListener(CommandID.ERROR_CODE,errorCodeHandler);
         errorCodeMap = new HashMap();
         if(!ClientConfig.isRelease())
         {
            errorCodeMap.add("2629_10001",1);
            errorCodeMap.add("2629_2259",1);
            errorCodeMap.add("2405_10002",1);
            errorCodeMap.add("2406_10002",1);
            errorCodeMap.add("2202_10002",1);
            errorCodeMap.add("2711_10002",1);
            errorCodeMap.add("2113_10001",1);
            errorCodeMap.add("2323_105164",1);
            errorCodeMap.add("0_105164",1);
         }
         addErrorCodeHandler(CommandID.FIGHT_ENTER,10002,enterTollgateLimitItemHandler);
         addErrorCodeHandler(CommandID.STAGE_ENTRY,10002,enterTollgateLimitItemHandler);
         addErrorCodeHandler(CommandID.TASK_COMPLETE,10002,onTaskCompErrHandler);
         addErrorCodeHandler(CommandID.TEAM_CREATE_ROOM,10002,enterTollgateLimitItemHandler);
         addErrorCodeHandler(CommandID.ESCORT_SELECT_ESCORT_TYPE,10001,enterEnterEscortHandler);
      }
      
      private static function exchangeBuffHandler(param1:ErrorEvent) : void
      {
         var _loc2_:uint = param1.errorValue;
         if(!ClientConfig.isRelease())
         {
            AlertManager.showSimpleAlarm("testinfo:还差" + _loc2_ + "秒才能重新兑换");
         }
      }
      
      private static function onTaskCompErrHandler(param1:ErrorEvent) : void
      {
         var _loc2_:uint = param1.errorValue;
         var _loc3_:String = ItemXMLInfo.getName(_loc2_);
         if(_loc3_ != "")
         {
            AlertManager.showSimpleAlarm("小侠士，完成该任务需要" + "<font color=\'#ff0000\'>" + _loc3_ + "</font>。");
         }
      }
      
      private static function enterTollgateLimitItemHandler(param1:ErrorEvent) : void
      {
         var _loc2_:uint = param1.errorValue;
         var _loc3_:String = ItemXMLInfo.getName(_loc2_);
         if(_loc3_ != "")
         {
            AlertManager.showSimpleAlarm("小侠士，进入该关卡需要" + _loc3_);
         }
      }
      
      private static function enterEnterEscortHandler(param1:ErrorEvent) : void
      {
         var _loc2_:int = int(param1.errorValue);
         var _loc3_:int = _loc2_ % 60;
         var _loc4_:int = _loc2_ / 60;
         if(_loc4_ > 0)
         {
            AlertManager.showSimpleAlarm("小侠士，还有" + String(_loc4_) + "分" + String(_loc3_) + "秒，才可以护送救援物资。");
         }
         else
         {
            AlertManager.showSimpleAlarm("小侠士，还有" + String(_loc3_) + "秒,才可以护送救援物资。");
         }
      }
      
      private static function errorCodeHandler(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         if(ed.hasEventListener(_loc3_ + "_" + _loc4_))
         {
            ed.dispatchEvent(new ErrorEvent(_loc3_ + "_" + _loc4_,_loc3_,_loc4_,_loc5_));
         }
      }
      
      public static function addErrorCodeHandler(param1:uint, param2:uint, param3:Function, param4:Boolean = false, param5:int = 0, param6:Boolean = false) : void
      {
         if(!ClientConfig.isRelease() && !errorCodeMap.containsKey(param1 + "_" + param2))
         {
            throw new Error("小侠士，你的错误码需要添加到集合中哦！");
         }
         ed.addEventListener(param1 + "_" + param2,param3,param4,param5,param6);
      }
      
      public static function removeErrorCodeHandler(param1:uint, param2:uint, param3:Function, param4:Boolean = false) : void
      {
         ed.removeEventListener(param1 + "_" + param2,param3,param4);
      }
   }
}

