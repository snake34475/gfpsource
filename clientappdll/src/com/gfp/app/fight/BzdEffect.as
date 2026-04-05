package com.gfp.app.fight
{
   import com.gfp.app.toolBar.FightToolBar;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   import com.gfp.core.model.MapModel;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class BzdEffect
   {
      
      public function BzdEffect()
      {
         var map:MapModel;
         var ui:MovieClip = null;
         var secPos:Point = null;
         var end:Point = null;
         super();
         map = MapManager.currentMap;
         if(Boolean(map) && (map.info.mapType == MapType.PVE || map.info.mapType == MapType.PVP))
         {
            ui = UIManager.getMovieClip("ToolBar_Fight_BZD_Effect");
            secPos = map.camera.totalToView(MainManager.actorModel.pos);
            secPos.y -= MainManager.actorModel.height;
            ui.x = secPos.x;
            ui.y = secPos.y;
            LayerManager.topLevel.addChild(ui);
            end = FightToolBar.instance.getBzdPoint();
            TweenLite.to(ui,0.2,{
               "x":end.x,
               "y":end.y,
               "onComplete":function():void
               {
                  LayerManager.topLevel.removeChild(ui);
                  FightToolBar.instance.updateBzdPoint();
               }
            });
         }
      }
   }
}

