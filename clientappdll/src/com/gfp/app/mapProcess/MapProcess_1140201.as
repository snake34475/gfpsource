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
   
   public class MapProcess_1140201 extends BaseMapProcess
   {
      
      public static var tt:int;
      
      private var _currentDamageMC:MovieClip;
      
      private var _mcNumber:McNumber;
      
      private var _currentDamageCount:int = 0;
      
      private var _mc:MovieClip;
      
      public function MapProcess_1140201()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._mc = _mapModel.libManager.getMovieClip("UI_RecordCntMc_1391");
         this._currentDamageMC = this._mc["currentDamageMC"];
         this._mcNumber = new McNumber(this._currentDamageMC);
         this._mcNumber.setValue(0);
         UserManager.addEventListener(UserEvent.USER_DPS_HIT,this.onDpsHit);
         StageResizeController.instance.register(this.resizePos);
         this.resizePos();
         LayerManager.topLevel.addChild(this._mc);
      }
      
      private function resizePos() : void
      {
         this._mc.x = LayerManager.stageWidth - this._mc.width;
         this._mc.y = LayerManager.stageHeight / 2;
      }
      
      private function onDpsHit(param1:UserEvent) : void
      {
         var _loc2_:BruiseInfo = param1.data as BruiseInfo;
         this._currentDamageCount += _loc2_.decHP;
         var _loc3_:int = this._currentDamageCount / 10000;
         this._mcNumber.setValue(_loc3_);
         tt = _loc3_;
      }
      
      override public function destroy() : void
      {
         UserManager.removeEventListener(UserEvent.USER_DPS_HIT,this.onDpsHit);
         StageResizeController.instance.unregister(this.resizePos);
         DisplayUtil.removeForParent(this._mc);
      }
   }
}

