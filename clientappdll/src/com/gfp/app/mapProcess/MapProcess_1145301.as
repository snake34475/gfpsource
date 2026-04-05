package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightMonsterClear;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.map.BaseMapProcess;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1145301 extends BaseMapProcess
   {
      
      private var _tipMc:MovieClip;
      
      private var _futureMc:MovieClip;
      
      private var _num:int;
      
      public function MapProcess_1145301()
      {
         super();
      }
      
      override protected function init() : void
      {
         FightMonsterClear.instance.addEventListener(FightMonsterClear.FIGHT_MONSTER_CLEAR,this._monsterClearHandler);
         this._tipMc = _mapModel.libManager.getMovieClip("UI_PassTip");
         this._futureMc = _mapModel.libManager.getMovieClip("UI_Future");
         LayerManager.topLevel.addChild(this._tipMc);
         LayerManager.topLevel.addChild(this._futureMc);
         StageResizeController.instance.register(this.relayout);
         this.relayout();
         this._num = ActivityExchangeTimesManager.getTimes(12641);
         (this._tipMc["numTxt"] as TextField).text = this._num.toString();
      }
      
      protected function _monsterClearHandler(param1:Event) : void
      {
         ++this._num;
         (this._tipMc["numTxt"] as TextField).text = this._num.toString();
         if(this._num % 5 == 0)
         {
            this._futureMc.visible = true;
            this._futureMc.addEventListener(Event.ENTER_FRAME,this.playFutureTip);
            this._futureMc.gotoAndPlay(1);
         }
      }
      
      private function playFutureTip(param1:Event) : void
      {
         if(this._futureMc.currentFrame == this._futureMc.totalFrames)
         {
            this._futureMc.removeEventListener(Event.ENTER_FRAME,this.playFutureTip);
            this._futureMc.stop();
            this._futureMc.visible = false;
         }
      }
      
      private function relayout() : void
      {
         this._tipMc.x = LayerManager.stageWidth - this._tipMc.width;
         this._tipMc.y = 0;
         this._futureMc.x = (LayerManager.stageWidth - this._futureMc.width) / 2;
         this._futureMc.y = 200;
         this._futureMc.stop();
         this._futureMc.visible = false;
      }
      
      override public function destroy() : void
      {
         FightMonsterClear.instance.removeEventListener(FightMonsterClear.FIGHT_MONSTER_CLEAR,this._monsterClearHandler);
         this._futureMc.removeEventListener(Event.ENTER_FRAME,this.playFutureTip);
         StageResizeController.instance.unregister(this.relayout);
         DisplayUtil.removeForParent(this._tipMc);
         DisplayUtil.removeForParent(this._futureMc);
      }
   }
}

