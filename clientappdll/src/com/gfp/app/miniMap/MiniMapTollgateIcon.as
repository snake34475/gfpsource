package com.gfp.app.miniMap
{
   import com.gfp.core.config.xml.TollgateXMLInfo;
   import com.gfp.module.app.miniCityMap.UI_miniCityMapTollgate;
   import flash.display.Sprite;
   import org.taomee.manager.ToolTipManager;
   
   public class MiniMapTollgateIcon extends Sprite
   {
      
      private var _tollgateId:int;
      
      public function MiniMapTollgateIcon(param1:int)
      {
         super();
         buttonMode = true;
         this._tollgateId = param1;
         var _loc2_:Sprite = new UI_miniCityMapTollgate();
         _loc2_.mouseChildren = false;
         _loc2_.mouseEnabled = false;
         addChild(_loc2_);
         ToolTipManager.add(this,"关卡: " + TollgateXMLInfo.getName(this._tollgateId));
      }
   }
}

