package com.gfp.app.mapProcess
{
   import com.gfp.app.ui.compoment.McNumber;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import flash.display.MovieClip;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1142001 extends BaseMapProcess
   {
      
      private var _currentDamageMC:MovieClip;
      
      private var _mcNumber:McNumber;
      
      private var _targetDamageMC:MovieClip;
      
      private var _mcNumber1:McNumber;
      
      private var _currentDamageCount:int = 0;
      
      private var _preDamageCount:int = 0;
      
      private var _mc:MovieClip;
      
      public function MapProcess_1142001()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._mc = _mapModel.libManager.getMovieClip("UI_RecordCntMc_1420");
         this._preDamageCount = ActivityExchangeTimesManager.getTimes(12082);
         this._targetDamageMC = this._mc["targetDamageMC"];
         this._currentDamageMC = this._mc["currentDamageMC"];
         this._mcNumber1 = new McNumber(this._targetDamageMC);
         this._mcNumber = new McNumber(this._currentDamageMC);
         this._mcNumber1.setValue(500);
         this._mcNumber.setValue(int(this._preDamageCount / 10000));
         this._mc.width = 0.75 * this._mc.width;
         this._mc.height = 0.75 * this._mc.height;
         UserManager.addEventListener(UserEvent.USER_DPS_HIT,this.onDpsHit);
         StageResizeController.instance.register(this.resizePos);
         this.resizePos();
         LayerManager.topLevel.addChild(this._mc);
      }
      
      private function resizePos() : void
      {
         this._mc.x = LayerManager.stageWidth - this._mc.width;
         this._mc.y = LayerManager.stageHeight / 2 - 145;
      }
      
      private function onDpsHit(param1:UserEvent) : void
      {
         this._currentDamageCount = this._preDamageCount + Math.floor(200000000 - UserManager.getModelByRoleType(15119).info.hp);
         var _loc2_:int = this._currentDamageCount / 10000;
         this._mcNumber.setValue(_loc2_);
         this._mcNumber1.setValue(500);
      }
      
      override public function destroy() : void
      {
         UserManager.removeEventListener(UserEvent.USER_DPS_HIT,this.onDpsHit);
         StageResizeController.instance.unregister(this.resizePos);
         DisplayUtil.removeForParent(this._mc);
      }
   }
}

