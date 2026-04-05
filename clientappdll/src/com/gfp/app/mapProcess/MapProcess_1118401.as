package com.gfp.app.mapProcess
{
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.fight.BruiseInfo;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import flash.display.MovieClip;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1118401 extends BaseMapProcess
   {
      
      private var _damageMc:MovieClip;
      
      private var _warnMc:MovieClip;
      
      private var _totalDamage:int = 0;
      
      public function MapProcess_1118401()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.addEventListener();
         this._damageMc = _mapModel.libManager.getMovieClip("UI_Damage");
         this._warnMc = _mapModel.libManager.getMovieClip("UI_Warn");
         LayerManager.topLevel.addChild(this._damageMc);
         LayerManager.topLevel.addChild(this._warnMc);
         this.resizePos();
         StageResizeController.instance.register(this.resizePos);
      }
      
      private function resizePos() : void
      {
         this._damageMc.y = 460;
         this._damageMc.x = LayerManager.stageWidth - this._damageMc.width - 300;
         this._warnMc.y = 0;
         this._warnMc.x = LayerManager.stageWidth - this._warnMc.width;
      }
      
      private function addEventListener() : void
      {
         UserManager.addEventListener(UserEvent.USER_DPS_HIT,this.onDpsHit);
      }
      
      private function removeEventListener() : void
      {
         UserManager.removeEventListener(UserEvent.USER_DPS_HIT,this.onDpsHit);
      }
      
      private function onDpsHit(param1:UserEvent) : void
      {
         var _loc2_:BruiseInfo = param1.data as BruiseInfo;
         if(_loc2_.atkerID == MainManager.actorID && _loc2_.decType == 1)
         {
            this._totalDamage += int(_loc2_.decHP / 10000);
            this._damageMc["damageTxt"].text = this._totalDamage + "万";
         }
      }
      
      override public function destroy() : void
      {
         this.removeEventListener();
         DisplayUtil.removeForParent(this._damageMc);
         DisplayUtil.removeForParent(this._warnMc);
         StageResizeController.instance.unregister(this.resizePos);
      }
   }
}

