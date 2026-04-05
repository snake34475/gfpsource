package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.LeftTimeFeather;
   import com.gfp.core.CommandID;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.ByteArrayUtil;
   import com.gfp.core.utils.TextFormatUtil;
   import flash.utils.ByteArray;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.net.SocketEvent;
   
   public class MapProcess_1107601 extends BaseMapProcess
   {
      
      private var _timeId:int = 0;
      
      private var _cnt:int;
      
      private var _feather:LeftTimeFeather;
      
      public function MapProcess_1107601()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._feather = new LeftTimeFeather(60 * 5 * 1000);
         SocketConnection.addCmdListener(CommandID.ACTION_SKILL,this.onAction);
      }
      
      private function onAction(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:ByteArray = ByteArrayUtil.clone(_loc2_);
         var _loc4_:uint = _loc3_.readUnsignedInt();
         var _loc5_:uint = _loc3_.readUnsignedInt();
         var _loc6_:uint = _loc3_.readUnsignedInt();
         if(_loc6_ == 4120595)
         {
            this._cnt = 0;
            this.showWarn();
            this._timeId = setTimeout(this.showWarn,2000);
         }
      }
      
      private function showWarn() : void
      {
         ++this._cnt;
         if(this._cnt >= 4)
         {
            clearTimeout(this._timeId);
            return;
         }
         clearTimeout(this._timeId);
         TextAlert.show(TextFormatUtil.getRedText("赵云要释放毁天灭地了，赶快到金钟罩里去！"));
         this._timeId = setTimeout(this.showWarn,2000);
      }
      
      override public function destroy() : void
      {
         SocketConnection.removeCmdListener(CommandID.ACTION_SKILL,this.onAction);
         if(this._feather)
         {
            this._feather.destroy();
            this._feather = null;
         }
         super.destroy();
      }
   }
}

