package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.ui.compoment.McNumber;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import flash.display.MovieClip;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1146901 extends BaseMapProcess
   {
      
      private var _cntMc:MovieClip;
      
      private var _numMC:MovieClip;
      
      private var _score:int = 0;
      
      private var numberMC:McNumber;
      
      public function MapProcess_1146901()
      {
         super();
      }
      
      override protected function init() : void
      {
         FightManager.instance.addEventListener(FightEvent.OGRE_DIE,this.onORG_Died);
         UserManager.addEventListener(UserEvent.EXPLODED,this.onORG_Explode);
         this._cntMc = _mapModel.libManager.getMovieClip("UI_Score1469");
         this._numMC = this._cntMc["numMC"];
         this.numberMC = new McNumber(this._numMC,"num");
         this.numberMC.setValue(this._score);
         StageResizeController.instance.register(this.resizePos);
         this.resizePos();
         LayerManager.topLevel.addChild(this._cntMc);
      }
      
      private function resizePos() : void
      {
         this._cntMc.x = LayerManager.stageWidth - this._cntMc.width + 50;
         this._cntMc.y = 300;
         this.numberMC.setValue(this._score);
      }
      
      private function onORG_Died(param1:FightEvent) : void
      {
         var _loc2_:UserInfo = param1.data as UserInfo;
         var _loc3_:int = int(_loc2_.roleType);
         if(_loc3_ == 15371)
         {
            this._score += 1;
         }
         if(_loc3_ == 15372)
         {
            --this._score;
         }
         if(this._score <= 0)
         {
            this._score = 0;
         }
         this.numberMC.setValue(this._score);
      }
      
      private function onORG_Explode(param1:UserEvent) : void
      {
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

