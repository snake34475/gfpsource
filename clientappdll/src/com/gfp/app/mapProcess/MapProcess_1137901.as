package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1137901 extends BaseMapProcess
   {
      
      private var _posArray:Array = [[595,610],[415,250],[780,250],[900,465],[295,465]];
      
      private var _radius:int = 100;
      
      private var _killCount:int = 0;
      
      private var _cntMc:MovieClip;
      
      private var _summonIdArray:Array = [12595,12596,12597,12598,12599];
      
      private var _todayCurrentScore:int = 0;
      
      public function MapProcess_1137901()
      {
         super();
         this._todayCurrentScore = ActivityExchangeTimesManager.getTimes(11394);
      }
      
      override protected function init() : void
      {
         FightManager.instance.addEventListener(FightEvent.OGRE_DIE,this.onORG_Died);
         UserManager.addEventListener(UserEvent.EXPLODED,this.onORG_Explode);
         this._cntMc = _mapModel.libManager.getMovieClip("UI_RecordCntMc_1379");
         this._cntMc["scoreTxt"].text = "" + 0;
         StageResizeController.instance.register(this.resizePos);
         this.resizePos();
         LayerManager.topLevel.addChild(this._cntMc);
      }
      
      private function resizePos() : void
      {
         this._cntMc.x = LayerManager.stageWidth - this._cntMc.width + 50;
         this._cntMc.y = 300;
         this._cntMc["scoreTxt"].text = "" + 0;
      }
      
      private function onORG_Died(param1:FightEvent) : void
      {
         ActivityExchangeTimesManager.addEventListener(11394,this.onOrgDie);
         ActivityExchangeTimesManager.getActiviteTimeInfo(11394);
      }
      
      private function onORG_Explode(param1:UserEvent) : void
      {
         ActivityExchangeTimesManager.addEventListener(11394,this.onOrgDie);
         ActivityExchangeTimesManager.getActiviteTimeInfo(11394);
      }
      
      private function onOrgDie(param1:Event) : void
      {
         ActivityExchangeTimesManager.removeEventListener(11394,this.onOrgDie);
         var _loc2_:int = ActivityExchangeTimesManager.getTimes(11394) - this._todayCurrentScore;
         this._cntMc["scoreTxt"].text = "" + _loc2_;
      }
      
      private function isDieInCertainArea(param1:Point, param2:int) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         while(_loc6_ < 5)
         {
            _loc3_ = int(this._posArray[_loc6_][0]);
            _loc4_ = int(this._posArray[_loc6_][1]);
            if(Math.pow(param1.x - _loc3_,2) + Math.pow(param1.y - _loc4_,2) <= Math.pow(this._radius,2) && param2 == this._summonIdArray[_loc6_])
            {
               _loc5_ = true;
               break;
            }
            _loc6_++;
         }
         return _loc5_;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         FightManager.instance.removeEventListener(FightEvent.OGRE_DIE,this.onORG_Died);
         UserManager.removeEventListener(UserEvent.EXPLODED,this.onORG_Explode);
         StageResizeController.instance.unregister(this.resizePos);
         DisplayUtil.removeForParent(this._cntMc);
      }
   }
}

