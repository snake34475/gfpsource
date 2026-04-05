package com.gfp.app.cmdl
{
   import com.gfp.core.action.constants.SubType;
   import com.gfp.core.action.net.PvPMoveAction;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.ActionXMLInfo;
   import com.gfp.core.events.UdpEvent;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.net.NetPackageQueue;
   import com.gfp.core.net.udp.UdpConnection;
   import com.gfp.core.net.udp.UdpItemInfo;
   import flash.geom.Point;
   import org.taomee.bean.BaseBean;
   
   public class ActionSynCmdListener extends BaseBean
   {
      
      public function ActionSynCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         if(!ClientConfig.isRelease())
         {
            UdpConnection.addEventListener(UdpEvent.POSTION_SYN,this.onActionSyn);
         }
         finish();
      }
      
      private function onActionSyn(param1:UdpEvent) : void
      {
         var _loc2_:UdpItemInfo = param1.data as UdpItemInfo;
         var _loc3_:uint = uint(_loc2_.posTime);
         var _loc4_:UdpItemInfo = NetPackageQueue.getPack(param1.userID,_loc3_);
         if(_loc4_)
         {
            if(Point.distance(new Point(_loc2_.posX,_loc2_.posY),new Point(_loc4_.posX,_loc4_.posY)) >= 2)
            {
               UdpConnection.instance.closeGroup();
            }
            return;
         }
         var _loc5_:uint = uint(_loc2_.type);
         var _loc6_:uint = uint(param1.userID);
         var _loc7_:uint = uint(_loc2_.dir);
         var _loc8_:Point = new Point(_loc2_.posX,_loc2_.posY);
         NetPackageQueue.addPackage(_loc6_,_loc2_);
         if(_loc5_ == SubType.WALK)
         {
            UserManager.execAction(_loc6_,new PvPMoveAction(ActionXMLInfo.getInfo(10002),_loc7_,_loc8_));
         }
         else if(_loc5_ == SubType.RUN)
         {
            UserManager.execAction(_loc6_,new PvPMoveAction(ActionXMLInfo.getInfo(10003),_loc7_,_loc8_));
         }
      }
   }
}

