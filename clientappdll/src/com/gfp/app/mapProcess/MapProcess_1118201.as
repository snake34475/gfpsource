package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.DataEvent;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.info.dailyActivity.SwapTimesInfo;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.map.BaseMapProcess;
   import flash.display.MovieClip;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1118201 extends BaseMapProcess
   {
      
      private var _monsterSwapId:int = 7670;
      
      private var _killMonCnt:int = 0;
      
      private var _curMonCnt:int = 0;
      
      private var _cntMc:MovieClip;
      
      public function MapProcess_1118201()
      {
         super();
      }
      
      override protected function init() : void
      {
         ActivityExchangeTimesManager.addEventListener(this._monsterSwapId,this.getTimes);
         ActivityExchangeTimesManager.getActiviteTimeInfo(this._monsterSwapId);
         FightManager.instance.addEventListener(FightEvent.OGRE_DIE,this.onModelDied);
         this._cntMc = _mapModel.libManager.getMovieClip("UI_ShengGuangMonCntMc");
         StageResizeController.instance.register(this.resizePos);
         this.resizePos();
         LayerManager.topLevel.addChild(this._cntMc);
      }
      
      private function getTimes(param1:DataEvent) : void
      {
         var _loc2_:SwapTimesInfo = param1.data as SwapTimesInfo;
         this._killMonCnt = _loc2_.times;
         this._cntMc.cntTxt.text = this._killMonCnt.toString();
      }
      
      private function resizePos() : void
      {
         this._cntMc.x = LayerManager.stageWidth - this._cntMc.width - 50;
         this._cntMc.y = 200;
      }
      
      private function onModelDied(param1:FightEvent) : void
      {
         if((param1.data as UserInfo).roleType >= 14508 && (param1.data as UserInfo).roleType <= 14513)
         {
            ++this._killMonCnt;
            ++this._curMonCnt;
         }
         this._cntMc.cntTxt.text = this._killMonCnt.toString();
      }
      
      override public function destroy() : void
      {
         FightManager.instance.removeEventListener(FightEvent.OGRE_DIE,this.onModelDied);
         StageResizeController.instance.unregister(this.resizePos);
         DisplayUtil.removeForParent(this._cntMc);
      }
   }
}

