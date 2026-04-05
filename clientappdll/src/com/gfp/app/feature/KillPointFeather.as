package com.gfp.app.feature
{
   import com.gfp.core.CommandID;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.model.PeopleModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.PvpTypeConstantUtil;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class KillPointFeather extends PKBaseFeather
   {
      
      public function KillPointFeather()
      {
         super();
      }
      
      override protected function isModelNeedToAdd(param1:PeopleModel) : Boolean
      {
         if(Boolean(param1.info) && param1.info.killPoint >= 100)
         {
            return true;
         }
         return false;
      }
      
      override protected function getAlertMessage(param1:PeopleModel) : String
      {
         var _loc2_:String = null;
         if(MainManager.actorInfo.killPoint > 0)
         {
            _loc2_ = "小侠士，该玩家的杀气值已过100，您的杀气值大于0，输了会掉落部分功夫豆，是否确认战斗？";
         }
         else
         {
            _loc2_ = "小侠士，该玩家的杀气值已过100，是否确认战斗？";
         }
         return _loc2_;
      }
      
      override protected function getPvpId() : int
      {
         return PvpTypeConstantUtil.PVP_KILL_POINT;
      }
      
      override protected function getSelectInfoClearMessage() : String
      {
         return "该玩家的杀气值已降到100以下哦，无法对其进行强制pk。";
      }
      
      override protected function addModelEvent(param1:PeopleModel) : void
      {
         super.addModelEvent(param1);
      }
      
      override protected function removeModelEvent(param1:PeopleModel) : void
      {
         super.removeModelEvent(param1);
      }
      
      override protected function addEvent() : void
      {
         super.addEvent();
         SocketConnection.addCmdListener(CommandID.KILL_POINT_CHANGED,this.onKPChanged);
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         SocketConnection.removeCmdListener(CommandID.KILL_POINT_CHANGED,this.onKPChanged);
      }
      
      private function onKPChanged(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         var _loc4_:int = int(_loc2_.readUnsignedInt());
         var _loc5_:PeopleModel = UserManager.getModel(_loc3_) as PeopleModel;
         if((Boolean(_loc5_)) && Boolean(_loc5_.info))
         {
            _loc5_.info.killPoint = _loc4_;
            if(_loc4_ < 100)
            {
               if(_userModels.indexOf(_loc5_) != -1)
               {
                  removeModel(_loc5_);
               }
            }
            else if(_userModels.indexOf(_loc5_) == -1)
            {
               addModel(_loc5_);
            }
         }
      }
   }
}

