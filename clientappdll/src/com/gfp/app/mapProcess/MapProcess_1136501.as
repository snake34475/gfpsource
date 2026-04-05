package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.ui.compoment.McNumber;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.map.BaseMapProcess;
   import flash.display.MovieClip;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1136501 extends BaseMapProcess
   {
      
      private var _currentKillMC:MovieClip;
      
      private var _mcNumber:McNumber;
      
      private var _currentKillCount:int = 0;
      
      private var _mc:MovieClip;
      
      public function MapProcess_1136501()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._mc = _mapModel.libManager.getMovieClip("UI_RecordCntMc_1365");
         this._currentKillMC = this._mc["currentKill"];
         this._mcNumber = new McNumber(this._currentKillMC);
         this._mcNumber.setValue(0);
         FightManager.instance.addEventListener(FightEvent.OGRE_DIE,this.onModelDied);
         StageResizeController.instance.register(this.resizePos);
         this.resizePos();
         LayerManager.topLevel.addChild(this._mc);
      }
      
      private function resizePos() : void
      {
         this._mc.x = LayerManager.stageWidth - this._mc.width;
         this._mc.y = LayerManager.stageHeight / 2;
      }
      
      private function onModelDied(param1:FightEvent) : void
      {
         ++this._currentKillCount;
         this._mcNumber.setValue(this._currentKillCount);
      }
      
      override public function destroy() : void
      {
         FightManager.instance.removeEventListener(FightEvent.OGRE_DIE,this.onModelDied);
         StageResizeController.instance.unregister(this.resizePos);
         DisplayUtil.removeForParent(this._mc);
      }
   }
}

