package com.gfp.app.cmdl
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.manager.CityWarManager;
   import com.gfp.core.CommandID;
   import com.gfp.core.action.ActionInfo;
   import com.gfp.core.action.constants.SubType;
   import com.gfp.core.action.net.NetMoveAction;
   import com.gfp.core.action.net.OgreMoveAction;
   import com.gfp.core.action.net.OgreTeleportAction;
   import com.gfp.core.action.net.PvPMoveAction;
   import com.gfp.core.config.xml.ActionXMLInfo;
   import com.gfp.core.effect.skill.SkillLiYaRotate;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.NetPackageQueue;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.net.udp.UdpConnection;
   import com.gfp.core.net.udp.UdpItemInfo;
   import com.gfp.core.utils.FightMode;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   
   public class MoveCmdListener extends BaseBean
   {
      
      public function MoveCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.MOVE,this.onMove);
         SocketConnection.addCmdListener(CommandID.PVP_MOVE,this.onPvpMove);
         SocketConnection.addCmdListener(CommandID.OGRE_MOVE,this.onOgreMove);
         SocketConnection.addCmdListener(CommandID.SUMMON_MOVE,this.onSummonMove);
         SocketConnection.addCmdListener(CommandID.SUMMON_FOLLOW,this.onSummonFollow);
         finish();
      }
      
      private function onMove(param1:SocketEvent) : void
      {
         var _loc3_:ByteArray = null;
         var _loc4_:uint = 0;
         var _loc5_:Point = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:UserModel = null;
         var _loc9_:ActionInfo = null;
         var _loc10_:uint = 0;
         var _loc11_:UserInfo = null;
         var _loc2_:uint = uint(param1.headInfo.userID);
         if(_loc2_ != MainManager.actorID)
         {
            _loc3_ = param1.data as ByteArray;
            _loc3_.position = 0;
            _loc3_.readUnsignedInt();
            _loc4_ = _loc3_.readUnsignedInt();
            _loc5_ = new Point(_loc3_.readUnsignedInt(),_loc3_.readUnsignedInt());
            _loc6_ = _loc3_.readUnsignedByte();
            _loc7_ = _loc3_.readUnsignedByte();
            if(CityWarManager.isInCityWar())
            {
               _loc11_ = new UserInfo();
               _loc11_.userID = _loc2_;
               _loc11_.mapID = _loc4_;
               _loc11_.pos = _loc5_;
            }
            _loc8_ = UserManager.getModel(_loc2_);
            if(_loc8_ != null)
            {
               if(_loc7_ == SubType.WALK)
               {
                  _loc9_ = ActionXMLInfo.getInfo(10002);
               }
               else if(_loc7_ == SubType.RUN)
               {
                  _loc9_ = ActionXMLInfo.getInfo(10003);
               }
               UserManager.execAction(_loc2_,new NetMoveAction(_loc9_,_loc6_,_loc5_,0,0));
            }
         }
      }
      
      private function onPvpMove(param1:SocketEvent) : void
      {
         var _loc3_:ByteArray = null;
         var _loc4_:Point = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:UdpItemInfo = null;
         var _loc13_:UserModel = null;
         var _loc14_:SkillLiYaRotate = null;
         var _loc2_:uint = uint(param1.headInfo.userID);
         if(_loc2_ != MainManager.actorID || FightManager.fightMode == FightMode.WATCH)
         {
            _loc3_ = param1.data as ByteArray;
            _loc3_.position = 0;
            _loc4_ = new Point(_loc3_.readUnsignedInt(),_loc3_.readUnsignedInt());
            _loc5_ = _loc3_.readUnsignedInt();
            _loc6_ = _loc3_.readUnsignedByte();
            _loc7_ = _loc3_.readUnsignedByte();
            _loc8_ = _loc3_.readUnsignedShort();
            _loc9_ = _loc3_.readUnsignedInt();
            _loc10_ = _loc3_.readUnsignedInt();
            _loc11_ = _loc9_ * 1000 + _loc10_;
            _loc12_ = NetPackageQueue.getPack(_loc2_,_loc11_);
            if(_loc12_)
            {
               if(Point.distance(_loc4_,new Point(_loc12_.posX,_loc12_.posY)) < 2)
               {
                  return;
               }
               UdpConnection.instance.closeGroup();
            }
            else
            {
               _loc12_ = new UdpItemInfo();
               _loc12_.posTime = _loc11_;
               _loc12_.posX = _loc4_.x;
               _loc12_.posY = _loc4_.y;
               NetPackageQueue.addPackage(_loc2_,_loc12_);
            }
            _loc13_ = UserManager.getModel(_loc2_);
            if(_loc13_)
            {
               _loc14_ = _loc13_.effectManager.getEffect("SkillLiYaRotate") as SkillLiYaRotate;
               if(_loc14_)
               {
                  _loc14_.syncMoveAction(new PvPMoveAction(ActionXMLInfo.getInfo(10002),_loc6_,_loc4_,_loc5_,_loc8_));
                  return;
               }
            }
            if(_loc7_ == SubType.WALK)
            {
               UserManager.execAction(_loc2_,new PvPMoveAction(ActionXMLInfo.getInfo(10002),_loc6_,_loc4_,_loc5_,_loc8_));
            }
            else if(_loc7_ == SubType.RUN)
            {
               UserManager.execAction(_loc2_,new PvPMoveAction(ActionXMLInfo.getInfo(10003),_loc6_,_loc4_,_loc5_,_loc8_));
            }
         }
      }
      
      private function onOgreMove(param1:SocketEvent) : void
      {
         var _loc3_:ByteArray = null;
         var _loc4_:Point = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:UserModel = null;
         var _loc2_:uint = uint(param1.headInfo.userID);
         if(_loc2_ != MainManager.actorID)
         {
            _loc3_ = param1.data as ByteArray;
            _loc3_.position = 0;
            _loc4_ = new Point(_loc3_.readUnsignedInt(),_loc3_.readUnsignedInt());
            _loc5_ = _loc3_.readUnsignedInt();
            _loc6_ = _loc3_.readUnsignedByte();
            _loc7_ = _loc3_.readUnsignedByte();
            _loc8_ = _loc3_.readUnsignedShort();
            _loc9_ = UserManager.getModel(_loc2_);
            if(_loc9_ != null && _loc9_.speed <= 0 && _loc7_ != SubType.TELEPORT)
            {
               return;
            }
            if(_loc7_ == SubType.WALK)
            {
               UserManager.execAction(_loc2_,new OgreMoveAction(ActionXMLInfo.getInfo(10002),_loc6_,_loc4_,_loc5_,_loc8_));
            }
            else if(_loc7_ == SubType.RUN)
            {
               UserManager.execAction(_loc2_,new OgreMoveAction(ActionXMLInfo.getInfo(10003),_loc6_,_loc4_,_loc5_,_loc8_));
            }
            else if(_loc7_ == SubType.TELEPORT)
            {
               UserManager.execAction(_loc2_,new OgreTeleportAction(ActionXMLInfo.getInfo(10011),_loc6_,_loc4_,_loc5_,_loc8_));
            }
         }
      }
      
      private function onSummonMove(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         var _loc4_:int = int(_loc2_.readUnsignedInt());
         var _loc5_:int = int(_loc2_.readUnsignedInt());
         var _loc6_:int = int(_loc2_.readUnsignedInt());
         var _loc7_:int = int(_loc2_.readUnsignedInt());
         var _loc8_:int = int(_loc2_.readUnsignedInt());
         var _loc9_:Point = new Point(_loc7_,_loc8_);
      }
      
      private function onSummonFollow(param1:SocketEvent) : void
      {
         var _loc4_:UserModel = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc5_:UserModel = UserManager.getModel(param1.headInfo.userID);
         if(_loc3_ == MainManager.actorID)
         {
            _loc4_ = MainManager.actorModel;
         }
         else
         {
            _loc4_ = UserManager.getModel(_loc3_);
         }
         if(Boolean(_loc5_) && Boolean(_loc4_))
         {
            _loc5_.execFollow(_loc4_);
         }
      }
   }
}

