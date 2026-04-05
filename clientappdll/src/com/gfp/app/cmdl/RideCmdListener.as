package com.gfp.app.cmdl
{
   import com.gfp.app.toolBar.HeadRideBar;
   import com.gfp.core.CommandID;
   import com.gfp.core.behavior.ChangeRideBehavior;
   import com.gfp.core.behavior.ChangeRoleBehavior;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.config.xml.RoleXMLInfo;
   import com.gfp.core.events.RideEvent;
   import com.gfp.core.info.RideInfo;
   import com.gfp.core.info.fight.SkillInfo;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.RideManager;
   import com.gfp.core.manager.SkillManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.net.SocketConnection;
   import flash.utils.ByteArray;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   
   public class RideCmdListener extends BaseBean
   {
      
      public function RideCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.CHANGE_ROLE,this.onChangeRole);
         SocketConnection.addCmdListener(CommandID.COST_HUNTAWARD,this.onCostHuntAward);
         SocketConnection.addCmdListener(CommandID.RIDE_LIST,this.onGetRideList);
         SocketConnection.addCmdListener(CommandID.GET_RIDE,this.onGetRide);
         SocketConnection.addCmdListener(CommandID.CHANGE_RIDE,this.onChangeRide);
         SocketConnection.addCmdListener(CommandID.RIDE_SKILL,this.onRideSkill);
         SocketConnection.send(CommandID.RIDE_LIST);
         finish();
      }
      
      private function onChangeRole(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         if(_loc3_ == MainManager.actorID)
         {
            if(_loc4_ == 0)
            {
               RideManager.isOnRide = false;
               RideManager.dispatchEvent(new RideEvent(RideEvent.RIDE_OFF));
            }
            HeadRideBar.showRide();
         }
         else
         {
            UserManager.execBehavior(_loc3_,new ChangeRoleBehavior(_loc4_,false),true);
         }
         RideManager.dispatchEvent(new RideEvent(RideEvent.ROLE_CHANGE,_loc4_));
      }
      
      private function onCostHuntAward(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         MainManager.actorInfo.huntAward = _loc3_;
         if(_loc3_ <= 0)
         {
            MainManager.actorModel.execBehavior(new ChangeRoleBehavior(0,true));
         }
      }
      
      private function onGetRideList(param1:SocketEvent) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_.readUnsignedInt();
            _loc6_ = _loc2_.readUnsignedInt();
            _loc7_ = _loc2_.readUnsignedInt();
            RideManager.addRide(_loc5_,_loc6_,_loc7_);
            _loc4_++;
         }
         RideManager.dispatchEvent(new RideEvent(RideEvent.RIDE_LIST_GET));
      }
      
      private function onGetRide(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         RideManager.dispatchEvent(new RideEvent(RideEvent.RIDE_GET,_loc3_));
      }
      
      private function onChangeRide(param1:SocketEvent) : void
      {
         var _loc6_:RideInfo = null;
         var _loc7_:SkillInfo = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         if(_loc4_ != 0)
         {
            _loc6_ = RideManager.getRide(_loc4_);
            if((Boolean(_loc6_)) && _loc6_.beSkillID != 0)
            {
               _loc7_ = new SkillInfo();
               SkillManager.addRideSkill(_loc6_.beSkillID);
            }
         }
         if(_loc3_ == MainManager.actorID)
         {
            if(_loc4_ > 0)
            {
               ActivityExchangeTimesManager.updataTimes(11265,_loc4_);
            }
            RideManager.isOnRide = _loc4_ != 0;
            RideManager.callRideID = _loc4_;
            HeadRideBar.instance.updateTips();
            if(_loc4_ != 0)
            {
               RideManager.dispatchEvent(new RideEvent(RideEvent.RIDE_ON,_loc4_));
            }
            else
            {
               RideManager.dispatchEvent(new RideEvent(RideEvent.RIDE_OFF));
            }
         }
         UserManager.execBehavior(_loc3_,new ChangeRideBehavior(_loc4_,false),true);
      }
      
      private function onRideSkill(param1:SocketEvent) : void
      {
         var _loc5_:uint = 0;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         if(_loc4_ == RideManager.callRideID)
         {
            _loc5_ = uint(ItemXMLInfo.getRideID(_loc4_));
            RideManager.rideSkill = RoleXMLInfo.getSkillID(_loc5_);
         }
      }
   }
}

