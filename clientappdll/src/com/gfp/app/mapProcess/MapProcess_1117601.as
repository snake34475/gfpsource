package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.LeftTimeTxtFeater;
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.map.BaseMapProcess;
   import flash.display.MovieClip;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1117601 extends BaseMapProcess
   {
      
      private var _leftTimerFeather:LeftTimeTxtFeater;
      
      private var _timeMc:MovieClip;
      
      private var _cntMc:MovieClip;
      
      private var _timeLimit:int = 60000;
      
      private var _curExp:int;
      
      private var _curBorn:int;
      
      public function MapProcess_1117601()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._timeMc = _mapModel.libManager.getMovieClip("UI_AYZCTimeTxtMc");
         this._cntMc = _mapModel.libManager.getMovieClip("UI_AYZCExpBornTxtMc");
         this._leftTimerFeather = new LeftTimeTxtFeater(this._timeLimit,this._timeMc["leftTimeShowTxt"],null);
         FightManager.instance.addEventListener(FightEvent.OGRE_DIE,this.onModelDied);
         this._leftTimerFeather.start();
         StageResizeController.instance.register(this.resizePos);
         this.resizePos();
         LayerManager.topLevel.addChild(this._timeMc);
         LayerManager.topLevel.addChild(this._cntMc);
      }
      
      private function onStageProChange(param1:int, param2:int) : void
      {
         this._cntMc.expTxt.text = param1.toString();
         this._cntMc.bornTxt.text = param2.toString();
      }
      
      private function resizePos() : void
      {
         this._timeMc.x = LayerManager.stageWidth - this._timeMc.width >> 1;
         this._timeMc.y = 125;
         this._cntMc.x = LayerManager.stageWidth - this._cntMc.width - 50;
         this._cntMc.y = 200;
      }
      
      private function onModelDied(param1:FightEvent) : void
      {
         if((param1.data as UserInfo).roleType == 12304)
         {
            this._curExp += 360000;
            if(this._curExp > 7200000)
            {
               this._curExp = 7200000;
            }
         }
         if(param1.data.roleType == 12305)
         {
            this._curBorn += 9;
            if(this._curBorn > 50)
            {
               this._curBorn = 50;
            }
         }
         this.onStageProChange(this._curExp,this._curBorn);
      }
      
      override public function destroy() : void
      {
         FightManager.instance.removeEventListener(FightEvent.OGRE_DIE,this.onModelDied);
         StageResizeController.instance.unregister(this.resizePos);
         DisplayUtil.removeForParent(this._timeMc);
         DisplayUtil.removeForParent(this._cntMc);
      }
   }
}

