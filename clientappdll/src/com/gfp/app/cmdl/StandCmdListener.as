package com.gfp.app.cmdl
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.manager.CityWarManager;
   import com.gfp.core.CommandID;
   import com.gfp.core.action.net.NetStandAction;
   import com.gfp.core.effect.skill.SkillLiYaRotate;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.FightMode;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   
   public class StandCmdListener extends BaseBean
   {
      
      private var _data:ByteArray;
      
      public function StandCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.STAND,this.onEvent);
         finish();
      }
      
      private function onEvent(param1:SocketEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:Point = null;
         var _loc5_:UserModel = null;
         var _loc6_:UserInfo = null;
         var _loc7_:SkillLiYaRotate = null;
         var _loc2_:uint = uint(param1.headInfo.userID);
         if(_loc2_ != MainManager.actorID || FightManager.fightMode == FightMode.WATCH)
         {
            this._data = param1.data as ByteArray;
            this._data.position = 0;
            _loc3_ = this._data.readUnsignedInt();
            _loc4_ = new Point(this._data.readUnsignedInt(),this._data.readUnsignedInt());
            if(CityWarManager.isInCityWar())
            {
               _loc6_ = new UserInfo();
               _loc6_.userID = _loc2_;
               _loc6_.mapID = _loc3_;
               _loc6_.pos = _loc4_;
               UserManager.dispatchEvent(new UserEvent(UserEvent.MOVE_OUT_MAP,_loc6_));
               if(!UserManager.contains(_loc2_))
               {
                  return;
               }
            }
            _loc5_ = UserManager.getModel(_loc2_);
            if(_loc5_)
            {
               _loc7_ = _loc5_.effectManager.getEffect("SkillLiYaRotate") as SkillLiYaRotate;
               if(_loc7_)
               {
                  _loc7_.syncMoveAction(new NetStandAction(UserManager.isVip(_loc2_),_loc4_,this._data.readUnsignedByte()));
                  return;
               }
            }
            UserManager.execAction(_loc2_,new NetStandAction(UserManager.isVip(_loc2_),_loc4_,this._data.readUnsignedByte()));
         }
      }
   }
}

