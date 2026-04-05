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
   
   public class MapProcess_1135401 extends BaseMapProcess
   {
      
      private var _curMonCnt:int = 0;
      
      private var _cntMc:MovieClip;
      
      private var _tipMc:MovieClip;
      
      private var _score:int = 10;
      
      private var _leftNum:MovieClip;
      
      private var _rightNum:MovieClip;
      
      private var _leftscore:McNumber;
      
      private var _rightscore:McNumber;
      
      public function MapProcess_1135401()
      {
         super();
      }
      
      override protected function init() : void
      {
         FightManager.instance.addEventListener(FightEvent.OGRE_DIE,this.onModelDied);
         this._cntMc = _mapModel.libManager.getMovieClip("UI_RecordCntMc_1354");
         this._tipMc = _mapModel.libManager.getMovieClip("UI_tip");
         StageResizeController.instance.register(this.resizePos);
         this.resizePos();
         LayerManager.topLevel.addChild(this._cntMc);
         LayerManager.topLevel.addChild(this._tipMc);
         this._cntMc.thisTime.text = "10/10";
      }
      
      private function resizePos() : void
      {
         this._cntMc.x = LayerManager.stageWidth - 110;
         this._cntMc.y = 300;
         this._tipMc.x = 200;
         this._tipMc.y = 450;
      }
      
      private function onModelDied(param1:FightEvent) : void
      {
         ++this._curMonCnt;
         this._score = 10 - this._curMonCnt;
         this._cntMc.thisTime.text = this._score + "/10";
      }
      
      override public function destroy() : void
      {
         FightManager.instance.removeEventListener(FightEvent.OGRE_DIE,this.onModelDied);
         StageResizeController.instance.unregister(this.resizePos);
         DisplayUtil.removeForParent(this._cntMc);
         DisplayUtil.removeForParent(this._tipMc);
      }
   }
}

