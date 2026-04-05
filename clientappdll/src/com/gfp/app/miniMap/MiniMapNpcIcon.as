package com.gfp.app.miniMap
{
   import com.gfp.app.manager.EscortManager;
   import com.gfp.core.config.xml.EscortXMLInfo;
   import com.gfp.core.config.xml.RoleXMLInfo;
   import com.gfp.core.info.NpcInstanceInfo;
   import com.gfp.module.app.miniCityMap.UI_EscrotCityMapNpc;
   import com.gfp.module.app.miniCityMap.UI_miniCityMapNpc;
   import flash.display.Sprite;
   import org.taomee.manager.ToolTipManager;
   
   public class MiniMapNpcIcon extends Sprite
   {
      
      private var _npcInfo:NpcInstanceInfo;
      
      public function MiniMapNpcIcon(param1:NpcInstanceInfo)
      {
         var _loc4_:Sprite = null;
         super();
         buttonMode = true;
         this._npcInfo = param1;
         var _loc2_:uint = uint(EscortManager.instance.escortPathId);
         var _loc3_:uint = 0;
         if(_loc2_ > 0)
         {
            _loc3_ = uint(EscortXMLInfo.getEndNpcById(_loc2_));
         }
         if(this._npcInfo.id == _loc3_)
         {
            _loc4_ = new UI_EscrotCityMapNpc();
         }
         else
         {
            _loc4_ = new UI_miniCityMapNpc();
         }
         _loc4_.mouseChildren = false;
         _loc4_.mouseEnabled = false;
         addChild(_loc4_);
         ToolTipManager.add(this,"NPC: " + RoleXMLInfo.getName(this._npcInfo.id));
      }
   }
}

