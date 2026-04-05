package com.gfp.app.systems
{
   import com.adobe.serialization.json.JSON;
   import com.gfp.app.fight.FightWaitPanel;
   import com.gfp.app.fight.SinglePkManager;
   import com.gfp.app.user.UserInfoController;
   import com.gfp.core.CommandID;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.TransportPoint;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.PvpTypeConstantUtil;
   import flash.geom.Point;
   
   public class UserOperationParser
   {
      
      private static var _pkUserID:int;
      
      public function UserOperationParser()
      {
         super();
      }
      
      public static function parse(param1:String) : void
      {
         var _loc4_:TransportPoint = null;
         var _loc2_:Array = param1.split("|");
         if(_loc2_.length < 2)
         {
            _loc2_ = param1.split("_");
         }
         var _loc3_:String = _loc2_.shift();
         if(_loc3_ == "open" || _loc3_ == "appModule")
         {
            if(_loc2_.length > 1)
            {
               ModuleManager.turnAppModule(_loc2_[0],"正在加载..",com.adobe.serialization.json.JSON.decode(_loc2_[1]));
            }
            else
            {
               ModuleManager.turnAppModule(_loc2_[0]);
            }
         }
         else if(_loc3_ == "map")
         {
            _loc4_ = new TransportPoint();
            _loc4_.mapId = _loc2_[0];
            _loc4_.pos = new Point(_loc2_[1],_loc2_[2]);
            CityMap.instance.tranChangeMap(_loc4_);
         }
         else if(_loc3_ == "npc")
         {
            CityMap.instance.tranToNpc(_loc2_[0]);
         }
         else if(_loc3_ == "TOLLGATEGIZMO")
         {
            CityMap.instance.tranChangeMapByStr(param1);
         }
         else if(_loc3_ == "pvp")
         {
            _pkUserID = _loc2_[1];
            if(_pkUserID == MainManager.actorInfo.userID)
            {
               AlertManager.showSimpleAlarm("不能和自己PK！");
               return;
            }
            UserInfoController.setUserId(_pkUserID);
            UserManager.addUserListener(UserEvent.PVP_CHANGE,_pkUserID,initPvPState);
            SinglePkManager.instance.fightType = PvpTypeConstantUtil.PVP_TYPE_INVITE;
            SinglePkManager.instance.roomID = 0;
            FightWaitPanel.enterWaitPanel(int(_loc2_[0]),_pkUserID,int(_loc2_[2]));
         }
      }
      
      private static function initPvPState(param1:UserEvent) : void
      {
         if(_pkUserID == 0)
         {
            return;
         }
         UserManager.removeUserListener(UserEvent.PVP_CHANGE,_pkUserID,initPvPState);
         var _loc2_:uint = uint(int(param1.data));
         if(_loc2_ != 0)
         {
            SinglePkManager.instance.openInviteBattery();
            FightWaitPanel.showWaitPanel();
            SocketConnection.send(CommandID.TEAM_INVITE_FRIEND,2,_pkUserID,_loc2_,0,0);
         }
      }
   }
}

