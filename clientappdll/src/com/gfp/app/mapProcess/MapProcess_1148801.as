package com.gfp.app.mapProcess
{
   import com.gfp.app.ui.compoment.McNumber;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.fight.BruiseInfo;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import flash.display.MovieClip;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1148801 extends BaseMapProcess
   {
      
      private var _currentDamageMC:MovieClip;
      
      private var _mcNumber:McNumber;
      
      private var _currentDamageCount:int = 0;
      
      private var _mc:MovieClip;
      
      public function MapProcess_1148801()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._currentDamageMC = _mapModel.libManager.getMovieClip("currentLevelMc");
         this._currentDamageMC.stop();
         UserManager.addEventListener(UserEvent.USER_DPS_HIT,this.onDpsHit);
         StageResizeController.instance.register(this.resizePos);
         this.resizePos();
         LayerManager.topLevel.addChild(this._currentDamageMC);
      }
      
      private function resizePos() : void
      {
         this._currentDamageMC.x = LayerManager.stageWidth - this._currentDamageMC.width;
         this._currentDamageMC.y = LayerManager.stageHeight / 2;
      }
      
      private function onDpsHit(param1:UserEvent) : void
      {
         var _loc2_:BruiseInfo = param1.data as BruiseInfo;
         if(_loc2_.userID == 15419 || _loc2_.roleID == 15419)
         {
            if(_loc2_.hp < 300000000 * 0.3)
            {
               this._currentDamageMC.gotoAndStop(4);
               return;
            }
            if(_loc2_.hp < 300000000 * 0.5)
            {
               this._currentDamageMC.gotoAndStop(3);
               return;
            }
            if(_loc2_.hp < 300000000 * 0.7)
            {
               this._currentDamageMC.gotoAndStop(2);
               return;
            }
            this._currentDamageMC.gotoAndStop(1);
         }
      }
      
      override public function destroy() : void
      {
         UserManager.removeEventListener(UserEvent.USER_DPS_HIT,this.onDpsHit);
         StageResizeController.instance.unregister(this.resizePos);
         DisplayUtil.removeForParent(this._currentDamageMC);
      }
   }
}

