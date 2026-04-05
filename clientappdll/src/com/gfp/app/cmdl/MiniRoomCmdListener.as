package com.gfp.app.cmdl
{
   import com.gfp.app.fight.PveEntry;
   import com.gfp.app.toolBar.CityToolBar;
   import com.gfp.app.toolBar.EverydaySignEntry;
   import com.gfp.app.toolBar.RedBlueMasterEntry;
   import com.gfp.core.CommandID;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.MiniRoomManager;
   import com.gfp.core.manager.RelationManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.map.MapType;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.SummonRoomType;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   
   public class MiniRoomCmdListener extends BaseBean
   {
      
      public function MiniRoomCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.MINIROOM_ME_ENTER,this.onMiniRoomSelfEnter);
         SocketConnection.addCmdListener(CommandID.MINIROOM_OTHER_ENTER,this.onMiniRoomOtherEnter);
         SocketConnection.addCmdListener(CommandID.MINIROOM_LEAVE,this.onMiniRoomLeave);
         SocketConnection.addCmdListener(CommandID.SUMMON_ROOM_KICK_OFF,this.onKickOff);
         SocketConnection.addCmdListener(CommandID.SUMMON_ROOM_CLOSE,this.onClose);
         finish();
      }
      
      private function onMiniRoomSelfEnter(param1:SocketEvent) : void
      {
         CityMap.instance.changeMap(40,MapType.MINI_ROOM);
         MainManager.actorInfo.inSummonRoom = SummonRoomType.SELF;
         MiniRoomManager.ownerID = MainManager.actorInfo.userID;
         MiniRoomManager.ownerNick = MainManager.actorInfo.nick;
      }
      
      private function onMiniRoomOtherEnter(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         MiniRoomManager.ownerID = _loc3_;
         MiniRoomManager.createTime = _loc4_;
         var _loc5_:UserInfo = RelationManager.getFriendInfo(_loc3_);
         if(_loc5_)
         {
            MiniRoomManager.ownerNick = _loc5_.nick;
         }
         CityMap.instance.changeMap(40,MapType.MINI_ROOM);
         MainManager.actorInfo.inSummonRoom = SummonRoomType.OTHER;
      }
      
      private function onMiniRoomLeave(param1:SocketEvent) : void
      {
         var _loc10_:UserInfo = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         var _loc6_:uint = _loc2_.readUnsignedInt();
         var _loc7_:uint = _loc2_.readUnsignedInt();
         var _loc8_:uint = _loc2_.readUnsignedInt();
         var _loc9_:uint = _loc2_.readUnsignedInt();
         if(_loc6_ == 1)
         {
            MainManager.actorInfo.inSummonRoom = SummonRoomType.NONE;
            MiniRoomManager.ownerID = 0;
            if(_loc8_ != 0 && _loc9_ != 0)
            {
               CityMap.instance.changeMap(_loc7_);
            }
            else
            {
               CityMap.instance.changeMap(_loc7_,0,1,new Point(_loc8_,_loc9_));
            }
            this.mapUnlimit();
            return;
         }
         if(_loc6_ == 2)
         {
            MainManager.actorInfo.inSummonRoom = SummonRoomType.NONE;
            MiniRoomManager.ownerID = 0;
            this.mapUnlimit();
            if(_loc8_ == 0)
            {
               _loc8_ = 1;
            }
            PveEntry.enterTollgate(_loc7_,_loc8_);
            return;
         }
         if(_loc4_ != 0)
         {
            _loc10_ = new UserInfo();
            _loc10_.userID = _loc4_;
            _loc10_.createTime = _loc5_;
            if(_loc4_ == MainManager.actorInfo.userID)
            {
               CityMap.instance.changeMiniHome();
            }
            else
            {
               CityMap.instance.changeMiniHome(SummonRoomType.OTHER,_loc10_);
            }
         }
         else
         {
            this.gotoMap7();
         }
      }
      
      private function mapUnlimit() : void
      {
         CityToolBar.instance.show();
         EverydaySignEntry.instance.show();
         RedBlueMasterEntry.instance.show();
      }
      
      private function onKickOff(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         if(_loc3_ == MainManager.actorInfo.userID && _loc4_ == MainManager.actorInfo.createTime && MainManager.actorInfo.inSummonRoom == SummonRoomType.OTHER)
         {
            TextAlert.show(AppLanguageDefine.SUMMON_ROOM_LEAVE_ALERT[0]);
            this.leaveSummonRoom();
         }
      }
      
      private function gotoMap7() : void
      {
         MainManager.actorInfo.inSummonRoom = SummonRoomType.NONE;
         MiniRoomManager.ownerID = 0;
         CityMap.instance.changeMap(7);
         this.mapUnlimit();
      }
      
      private function onClose(param1:SocketEvent) : void
      {
         AlertManager.showSimpleAlarm(AppLanguageDefine.SUMMON_ROOM_LEAVE_ALERT[1],this.leaveSummonRoom);
      }
      
      private function leaveSummonRoom() : void
      {
         CityMap.instance.leaveMiniRoom(0,0,0,0,0);
      }
   }
}

