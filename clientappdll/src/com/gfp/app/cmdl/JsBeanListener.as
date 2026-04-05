package com.gfp.app.cmdl
{
   import com.gfp.app.cartoon.DailyActivityAward;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.xml.DailyActivityXMLInfo;
   import com.gfp.core.info.DailyActiveAwardInfo;
   import com.gfp.core.js.JSControl;
   import com.gfp.core.js.JsItem;
   import com.gfp.core.net.SocketConnection;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   
   public class JsBeanListener extends BaseBean
   {
      
      public function JsBeanListener()
      {
         super();
      }
      
      override public function start() : void
      {
         JSControl.getInstance().registerJS(new JsItem("backCollect",this.busBackCollect));
         finish();
      }
      
      private function busBackCollect(param1:uint, param2:String) : void
      {
         SocketConnection.addCmdListener(CommandID.DAILY_ACTIVITY,this.onGetAward);
         SocketConnection.send(CommandID.DAILY_ACTIVITY,2071);
      }
      
      private function onGetAward(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.DAILY_ACTIVITY,this.onGetAward);
         var _loc2_:DailyActiveAwardInfo = param1.data as DailyActiveAwardInfo;
         var _loc3_:uint = uint(_loc2_.type);
         if(_loc3_ != DailyActivityXMLInfo.TYPE_STONE_REWARD)
         {
            return;
         }
         DailyActivityAward.addAward(_loc2_);
      }
   }
}

