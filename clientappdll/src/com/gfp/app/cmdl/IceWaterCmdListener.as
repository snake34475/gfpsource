package com.gfp.app.cmdl
{
   import com.gfp.core.CommandID;
   import com.gfp.core.config.xml.DailyActivityXMLInfo;
   import com.gfp.core.info.DailyActiveAwardInfo;
   import com.gfp.core.info.dailyActivity.DailyActivityAward;
   import com.gfp.core.net.SocketConnection;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   
   public class IceWaterCmdListener extends BaseBean
   {
      
      public function IceWaterCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.DAILY_ACTIVITY,this.onGetAward);
         finish();
      }
      
      public function onGetAward(param1:SocketEvent) : void
      {
         var _loc2_:DailyActiveAwardInfo = param1.data as DailyActiveAwardInfo;
         var _loc3_:uint = uint(_loc2_.type);
         if(_loc3_ != DailyActivityXMLInfo.TYPE_ICEWATER)
         {
            return;
         }
         DailyActivityAward.addAward(_loc2_);
      }
   }
}

