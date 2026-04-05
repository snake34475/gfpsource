package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.DataEvent;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.map.BaseMapProcess;
   import flash.display.MovieClip;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1131301 extends BaseMapProcess
   {
      
      private var _totalSwapId:int = 10186;
      
      private var _killMonCnt:int = ActivityExchangeTimesManager.getTimes(this._totalSwapId);
      
      private var _curMonCnt:int = 0;
      
      private var _cntMc:MovieClip;
      
      public function MapProcess_1131301()
      {
         super();
      }
      
      override protected function init() : void
      {
         ActivityExchangeTimesManager.addEventListener(this._totalSwapId,this.getTimes);
         ActivityExchangeTimesManager.getActiviteTimeInfo(this._totalSwapId);
         FightManager.instance.addEventListener(FightEvent.OGRE_DIE,this.onModelDied);
         this._cntMc = _mapModel.libManager.getMovieClip("UI_RecordCntMc_1313");
         StageResizeController.instance.register(this.resizePos);
         this.resizePos();
         LayerManager.topLevel.addChild(this._cntMc);
      }
      
      private function getTimes(param1:DataEvent) : void
      {
         this._killMonCnt = ActivityExchangeTimesManager.getTimes(this._totalSwapId);
         this._curMonCnt = 0;
         this._cntMc.thisTime.text = this._curMonCnt.toString();
         this._cntMc.accumulation.text = this._killMonCnt.toString();
      }
      
      private function resizePos() : void
      {
         this._cntMc.x = LayerManager.stageWidth - 110;
         this._cntMc.y = 300;
      }
      
      private function onModelDied(param1:FightEvent) : void
      {
         if((param1.data as UserInfo).roleType == 14837)
         {
            ++this._killMonCnt;
            ++this._curMonCnt;
         }
         this._cntMc.thisTime.text = this._curMonCnt.toString();
         this._cntMc.accumulation.text = this._killMonCnt.toString();
      }
      
      override public function destroy() : void
      {
         FightManager.instance.removeEventListener(FightEvent.OGRE_DIE,this.onModelDied);
         StageResizeController.instance.unregister(this.resizePos);
         DisplayUtil.removeForParent(this._cntMc);
      }
   }
}

