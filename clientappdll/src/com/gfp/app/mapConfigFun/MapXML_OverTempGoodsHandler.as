package com.gfp.app.mapConfigFun
{
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.map.IMapConfigFun;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.sensemodels.SightModel;
   import org.taomee.manager.ToolTipManager;
   
   public class MapXML_OverTempGoodsHandler implements IMapConfigFun
   {
      
      private static var _openSm:SightModel;
      
      private const TIP:String = "tip";
      
      private var _type:String;
      
      private var _xmlData:Array;
      
      private var _tip:String;
      
      public function MapXML_OverTempGoodsHandler()
      {
         super();
         MapManager.addEventListener(MapEvent.MAP_DESTROY,this.onMapDestroy);
      }
      
      public function exec(param1:SightModel, param2:XML, param3:XMLList) : void
      {
         _openSm = param1;
         var _loc4_:XML = param2.child("aim")[0];
         this._type = _loc4_.@type;
         this._xmlData = _loc4_.toString().split(",");
         this.parseData();
      }
      
      private function parseData() : void
      {
         switch(this._type)
         {
            case this.TIP:
               this._tip = this._xmlData[0];
               this.onShowTip();
         }
      }
      
      private function onShowTip() : void
      {
         ToolTipManager.add(_openSm,this._tip);
      }
      
      private function onMapDestroy(param1:MapEvent) : void
      {
         MapManager.removeEventListener(MapEvent.MAP_DESTROY,this.onMapDestroy);
         ToolTipManager.remove(_openSm);
         _openSm = null;
      }
   }
}

