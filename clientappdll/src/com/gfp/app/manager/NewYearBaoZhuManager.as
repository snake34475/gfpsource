package com.gfp.app.manager
{
   import com.gfp.app.ui.compoment.BaoZhuPanel;
   import com.gfp.app.ui.compoment.ExtenalAnimat;
   import com.gfp.core.CommandID;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.info.MapInfo;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.net.SocketConnection;
   import flash.events.Event;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class NewYearBaoZhuManager
   {
      
      private static var _panel:BaoZhuPanel;
      
      public static const TARGET_MAP_IDS:Array = [7];
      
      public static const BAO_ITEM_ID:int = 1300837;
      
      public static const BAO0_SWAP_ID:int = 8066;
      
      public static const BAO1_SWAP_ID:int = 8067;
      
      public static const FREE_BAO_SWAP_ID:int = 8065;
      
      public function NewYearBaoZhuManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         addEvent();
         checkMap();
      }
      
      private static function addEvent() : void
      {
         MapManager.addEventListener(MapEvent.MAP_SWITCH_OPEN,onMapSwitchOpen);
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,onMapSwitchComplete);
         SocketConnection.addCmdListener(CommandID.NOTICE_SYSTEM_2,onSystemNotice);
      }
      
      private static function onMapSwitchOpen(param1:Event) : void
      {
      }
      
      private static function onSystemNotice(param1:SocketEvent) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:MapInfo = null;
         var _loc9_:ExtenalAnimat = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         if(_loc3_ == 2)
         {
            _loc4_ = int(_loc2_.readUnsignedInt());
            _loc5_ = int(_loc2_.readUnsignedInt());
            _loc6_ = int(_loc2_.readUnsignedInt());
            _loc7_ = int(_loc2_.readUnsignedInt());
            _loc8_ = MapManager.mapInfo;
            if((Boolean(_loc8_)) && _loc8_.id == _loc4_)
            {
               _loc9_ = new ExtenalAnimat("bao_zhu" + (_loc5_ - 1));
               _loc9_.x = _loc6_;
               _loc9_.y = _loc7_ - 200;
               if(_loc5_ != 5)
               {
                  _loc9_.scaleX = _loc9_.scaleY = 0.25;
               }
               else
               {
                  _loc9_.scaleX = _loc9_.scaleY = 0.75;
               }
               MapManager.currentMap.upLevel.addChild(_loc9_);
            }
         }
      }
      
      private static function onMapSwitchComplete(param1:MapEvent) : void
      {
         checkMap();
      }
      
      private static function checkMap() : void
      {
         var _loc1_:int = int(MapManager.currentMap.info.id);
         if(TARGET_MAP_IDS.indexOf(_loc1_) != -1)
         {
            if(null == _panel)
            {
               _panel = new BaoZhuPanel();
            }
            _panel.x = LayerManager.stageWidth - 170;
            _panel.y = LayerManager.stageHeight - 270;
            LayerManager.uiLevel.addChild(_panel);
         }
         else if(_panel)
         {
            DisplayUtil.removeForParent(_panel,false);
         }
      }
   }
}

