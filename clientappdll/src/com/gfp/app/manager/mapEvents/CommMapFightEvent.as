package com.gfp.app.manager.mapEvents
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.xml.EscortXMLInfo;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import flash.utils.ByteArray;
   import flash.utils.clearTimeout;
   import org.taomee.net.SocketEvent;
   
   public class CommMapFightEvent implements ICommMapEvent
   {
      
      private var pveId:uint;
      
      private var pveDiff:uint;
      
      private var timeInterval:uint;
      
      public function CommMapFightEvent()
      {
         super();
      }
      
      public function init(... rest) : void
      {
         SocketConnection.addCmdListener(CommandID.REC_COMM_MAP_FIGHT,this.recFightMsg);
      }
      
      private function recFightMsg(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         this.pveId = _loc2_.readUnsignedInt();
         this.pveDiff = _loc2_.readUnsignedInt();
         var _loc4_:String = EscortXMLInfo.getFightAlert(_loc3_);
         if(_loc4_ == null || _loc4_ == "")
         {
            _loc4_ = "小侠士，您遇到了不明怪物的袭击！";
         }
         TextAlert.show(_loc4_);
         this.exec();
      }
      
      public function exec() : void
      {
         clearTimeout(this.timeInterval);
         if(CityMap.instance.isSwitching)
         {
            MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.mapSwitchCompelte);
         }
         else
         {
            this.startFight();
         }
      }
      
      private function mapSwitchCompelte(param1:MapEvent) : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.mapSwitchCompelte);
         this.startFight();
      }
      
      private function startFight() : void
      {
         FightManager.isTeamFight = false;
         PveEntry.instance.enterTollgate(this.pveId,this.pveDiff);
      }
      
      public function destroy() : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.mapSwitchCompelte);
         SocketConnection.removeCmdListener(CommandID.REC_COMM_MAP_FIGHT,this.recFightMsg);
      }
   }
}

