package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightGo;
   import com.gfp.app.fight.FightMonsterClear;
   import com.gfp.app.miniMap.MiniMap;
   import com.gfp.app.time.TimerComponents;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.map.BaseMapProcess;
   import flash.display.MovieClip;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1129401 extends BaseMapProcess
   {
      
      private var _tipMc:MovieClip;
      
      public function MapProcess_1129401()
      {
         super();
      }
      
      override protected function init() : void
      {
         FightGo.instance.enabledShow = false;
         FightMonsterClear.instance.enabledShow = false;
         MiniMap.instance.hide();
         TimerComponents.instance.hide();
         this._tipMc = _mapModel.libManager.getMovieClip("UI_HongQiGongTip");
         LayerManager.topLevel.addChild(this._tipMc);
         StageResizeController.instance.register(this.relayout);
         this.relayout();
      }
      
      private function relayout() : void
      {
         this._tipMc.x = LayerManager.stageWidth - this._tipMc.width;
         this._tipMc.y = 0;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         FightGo.instance.enabledShow = true;
         FightMonsterClear.instance.enabledShow = true;
         StageResizeController.instance.unregister(this.relayout);
         DisplayUtil.removeForParent(this._tipMc);
      }
   }
}

