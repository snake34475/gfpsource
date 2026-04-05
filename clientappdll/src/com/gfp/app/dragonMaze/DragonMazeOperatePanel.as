package com.gfp.app.dragonMaze
{
   import com.gfp.app.cityWar.CityWarOperatePanel;
   import com.gfp.app.manager.DragonMazeManager;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.map.MapType;
   import com.gfp.core.model.MapModel;
   import flash.events.Event;
   
   public class DragonMazeOperatePanel extends CityWarOperatePanel
   {
      
      private static var _instance:DragonMazeOperatePanel;
      
      public function DragonMazeOperatePanel()
      {
         super();
         setup();
      }
      
      public static function get instance() : DragonMazeOperatePanel
      {
         if(_instance == null)
         {
            _instance = new DragonMazeOperatePanel();
         }
         return _instance;
      }
      
      public static function destroy() : void
      {
         if(_instance)
         {
            _instance.destroy();
         }
         _instance = null;
      }
      
      override protected function setMainUI() : void
      {
         _mainUI = new UI_QuitGameOperation();
      }
      
      override protected function onBackHome(param1:Event) : void
      {
         DragonMazeManager.instance.quit();
         DragonMazeOperatePanel.destroy();
      }
      
      override protected function onMapComplete(param1:MapEvent) : void
      {
         var _loc2_:MapModel = param1.mapModel;
         if(_loc2_.info.mapType == MapType.STAND || _loc2_.info.mapType == MapType.TRADE)
         {
            show();
         }
         else
         {
            hide();
         }
      }
   }
}

