package com.gfp.app.cmdl
{
   import com.gfp.app.control.RunMatchControl;
   import com.gfp.core.CommandID;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.HiddenManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import flash.utils.ByteArray;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   
   public class RunMatchCmdListener extends BaseBean
   {
      
      public function RunMatchCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.RUNMATCH_START,this.onRunMatchStart);
         SocketConnection.addCmdListener(CommandID.RUNMATCH_END,this.onRunMatchEnd);
         SocketConnection.addCmdListener(CommandID.RUNMATCH_BOX_EVENT,this.onBoxEvent);
         SocketConnection.addCmdListener(CommandID.RUNMATCH_INFO,this.onRunMatchInfo);
         finish();
      }
      
      private function onRunMatchStart(param1:SocketEvent) : void
      {
         var _loc6_:uint = 0;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _loc2_.readUnsignedInt();
            RunMatchControl.addStartPlayer(_loc6_);
            _loc5_++;
         }
         TextAlert.show("侠士竞速比赛正式开始，参赛的小侠士们冲啊！");
         RunMatchControl.startMatch();
      }
      
      private function onRunMatchEnd(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         var _loc6_:uint = _loc2_.readUnsignedInt();
         RunMatchControl.endMatch();
         if(_loc6_ > 0)
         {
            AlertManager.showSimpleAlarm("竞速比赛结束！\n恭喜你小侠士，你获得了第" + _loc6_ + "名，耗时" + _loc5_ + "秒");
         }
         else
         {
            AlertManager.showSimpleAlarm("很遗憾，你在本场竞速比赛中失败了，小侠士你还需要努力哦！");
         }
      }
      
      private function onBoxEvent(param1:SocketEvent) : void
      {
         var _loc7_:UserModel = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         var _loc6_:uint = _loc2_.readUnsignedInt();
         if(!MapManager.isFightMap)
         {
            _loc7_ = UserManager.getModel(_loc5_);
            if(_loc7_)
            {
               _loc7_.destroy();
               HiddenManager.remove(_loc5_);
               UserManager.remove(_loc5_);
            }
            RunMatchControl.addOpenedBox(_loc5_);
         }
         else
         {
            RunMatchControl.addClearBox(_loc5_);
         }
      }
      
      private function onRunMatchInfo(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         RunMatchControl.execEvent(_loc3_,_loc4_,_loc5_);
      }
   }
}

