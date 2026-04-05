package com.gfp.app.manager
{
   import com.gfp.app.info.PeachTreeInfo;
   import com.gfp.app.systems.ClientTempState;
   import com.gfp.core.CommandID;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.PvpTypeConstantUtil;
   import flash.events.Event;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class GetPeachManager
   {
      
      private static var _isSetup:Boolean;
      
      public static var tempInfo:PeachTreeInfo;
      
      public function GetPeachManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         if(!_isSetup)
         {
            _isSetup = true;
            TasksManager.addActionListener(TaskActionEvent.TASK_PVP_WIN,PvpTypeConstantUtil.GET_PEACH + "_0",onPvpSuccess);
            SocketConnection.addCmdListener(CommandID.PICK_OTHER_PEACH,onPickOtherPeach);
         }
      }
      
      private static function onPickOtherPeach(param1:SocketEvent) : void
      {
         var _loc5_:Array = null;
         var _loc6_:PeachTreeInfo = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         var _loc4_:int = int(_loc2_.readUnsignedInt());
         if(!(_loc3_ != 0 && _loc4_ > 0))
         {
            if(_loc3_ == 0)
            {
               _loc5_ = ClientTempState.peachTreeInfos;
               for each(_loc6_ in _loc5_)
               {
                  if(Boolean(tempInfo) && Boolean(tempInfo.userId == _loc6_.userId) && tempInfo.createTime == _loc6_.createTime)
                  {
                     _loc6_.count -= _loc4_;
                  }
               }
            }
         }
      }
      
      private static function onPvpSuccess(param1:Event) : void
      {
         if(tempInfo)
         {
            SocketConnection.send(CommandID.PICK_OTHER_PEACH,tempInfo.userId,tempInfo.createTime,0);
         }
      }
   }
}

