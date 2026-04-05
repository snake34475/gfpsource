package com.gfp.app.im.talk
{
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.map.MapManager;
   import org.taomee.ds.HashMap;
   
   public class TalkManager
   {
      
      private static var _list:HashMap = new HashMap();
      
      public function TalkManager()
      {
         super();
      }
      
      public static function showTalkPanel(param1:uint, param2:uint, param3:Boolean = false) : void
      {
         MapManager.addEventListener(MapEvent.MAP_SWITCH_OPEN,onMapOpen);
         var _loc4_:TalkPanel = getTalkPanel(param1);
         if(_loc4_ == null)
         {
            _loc4_ = new TalkPanel();
            _list.add(param1,_loc4_);
            if(param3)
            {
               _loc4_.show(LayerManager.topLevel);
            }
            else
            {
               _loc4_.show();
            }
            _loc4_.init(param1,param2);
         }
      }
      
      public static function closeTalkPanel(param1:uint) : void
      {
         var _loc2_:TalkPanel = _list.remove(param1) as TalkPanel;
         if(_loc2_)
         {
            _loc2_.destroy();
            _loc2_ = null;
         }
         if(_list.length == 0)
         {
            MapManager.removeEventListener(MapEvent.MAP_SWITCH_OPEN,onMapOpen);
         }
      }
      
      public static function closeAll() : void
      {
         _list.clear();
      }
      
      public static function getTalkPanel(param1:uint) : TalkPanel
      {
         return _list.getValue(param1) as TalkPanel;
      }
      
      public static function isOpen(param1:uint) : Boolean
      {
         return _list.containsKey(param1);
      }
      
      private static function onMapOpen(param1:MapEvent) : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_OPEN,onMapOpen);
         closeAll();
      }
   }
}

