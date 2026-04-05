package com.gfp.app.miniMap
{
   import com.gfp.app.manager.EscortManager;
   import com.gfp.core.config.xml.EscortXMLInfo;
   import com.gfp.core.config.xml.MapXMLInfo;
   import com.gfp.core.map.MapManager;
   import com.gfp.module.app.miniCityMap.UI_EscortCityMapTran;
   import com.gfp.module.app.miniCityMap.UI_miniCityMapTran;
   import flash.display.Sprite;
   import org.taomee.manager.ToolTipManager;
   
   public class MiniMapTeleporterIcon extends Sprite
   {
      
      private var _mapId:int;
      
      public function MiniMapTeleporterIcon(param1:String)
      {
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:Sprite = null;
         super();
         buttonMode = true;
         if(param1.indexOf(",") != -1)
         {
            this._mapId = param1.split(",")[0];
         }
         else
         {
            this._mapId = int(param1);
         }
         var _loc2_:uint = uint(EscortManager.instance.escortPathId);
         var _loc3_:uint = 0;
         if(_loc2_ > 0)
         {
            _loc4_ = EscortXMLInfo.getEscortPath(_loc2_);
            _loc5_ = _loc4_.indexOf(MapManager.mapInfo.id.toString());
            if(_loc5_ != -1 && _loc5_ < _loc4_.length - 1)
            {
               _loc3_ = uint(_loc4_[_loc5_ + 1]);
            }
         }
         if(this._mapId == _loc3_)
         {
            _loc6_ = new UI_EscortCityMapTran();
         }
         else
         {
            _loc6_ = new UI_miniCityMapTran();
         }
         _loc6_.mouseChildren = false;
         _loc6_.mouseEnabled = false;
         addChild(_loc6_);
         ToolTipManager.add(this,"传送点: " + MapXMLInfo.getName(this._mapId));
      }
   }
}

