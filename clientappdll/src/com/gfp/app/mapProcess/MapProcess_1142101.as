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
   
   public class MapProcess_1142101 extends BaseMapProcess
   {
      
      private var _dieCount:int = 0;
      
      private var _skillestCount:int = 0;
      
      private var _showMC:MovieClip;
      
      private var dieNumber:McNumber;
      
      private var skillNumber:McNumber;
      
      public function MapProcess_1142101()
      {
         super();
      }
      
      override protected function init() : void
      {
         FightManager.instance.addEventListener(FightEvent.OGRE_DIE,this.onModelDied);
         this._showMC = _mapModel.libManager.getMovieClip("UI_skillCountMc");
         this.dieNumber = new McNumber(this._showMC["dieMC"]);
         StageResizeController.instance.register(this.resizePos);
         this.resizePos();
         LayerManager.topLevel.addChild(this._showMC);
         this.updateView();
      }
      
      private function onModelDied(param1:FightEvent) : void
      {
         ++this._dieCount;
         this.updateView();
      }
      
      private function resizePos() : void
      {
         this._showMC.x = LayerManager.stageWidth - 100;
         this._showMC.y = 300;
      }
      
      private function updateView() : void
      {
         this.dieNumber.setValue(this._dieCount);
      }
      
      override public function destroy() : void
      {
         StageResizeController.instance.unregister(this.resizePos);
         DisplayUtil.removeForParent(this._showMC);
      }
   }
}

