package com.gfp.app.mapProcess
{
   import com.gfp.app.manager.PanelGValueManager;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.fight.BruiseInfo;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.MapModel;
   import flash.display.MovieClip;
   import flash.utils.clearInterval;
   import flash.utils.getTimer;
   import flash.utils.setInterval;
   import org.taomee.utils.DisplayUtil;
   
   public class ShowDpsMapprocess extends BaseMapProcess
   {
      
      private var _sumTotalHurtV:Number = 0;
      
      private var _playerTotalHurtV:Number = 0;
      
      private var _dpsPanel:MovieClip;
      
      private var _startTime:Number;
      
      private var _timeId:int = 0;
      
      private var _mapIdList:Array = [1109601,1109602,1109603,1109604,1109701,1109702,1109801,1109802,1110701,1110801,1110802,111701,1112201];
      
      public function ShowDpsMapprocess()
      {
         super();
      }
      
      override protected function init() : void
      {
         if(_mapModel.info.id == 1109601 || _mapModel.info.id == 1109701 || _mapModel.info.id == 1109801 || _mapModel.info.id == 1110701 || _mapModel.info.id == 111701 || _mapModel.info.id == 1112201 || _mapModel.info.id == 1110801)
         {
            PanelGValueManager.instance().dpsIsInit = true;
            this._dpsPanel = UIManager.getMovieClip("DpsRecordTipPanel");
            this._dpsPanel.y = 190;
            this._dpsPanel.x = LayerManager.stageWidth - this._dpsPanel.width - 2;
            LayerManager.topLevel.addChild(this._dpsPanel);
            this._startTime = getTimer();
            UserManager.addEventListener(UserEvent.USER_DPS_HIT,this.onDpsHit);
            StageResizeController.instance.register(this.resizePos);
            this._timeId = setInterval(this.updateView,1000);
            MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwtichComplete);
         }
      }
      
      private function onMapSwtichComplete(param1:MapEvent) : void
      {
         var _loc2_:MapModel = param1.mapModel;
         if(this._mapIdList.indexOf(_loc2_.info.id) == -1)
         {
            this.myDesTroy();
         }
      }
      
      private function updateView() : void
      {
         var _loc1_:Number = (getTimer() - this._startTime) / 1000;
         this._dpsPanel["psHurtTxt"].text = Math.round(this._playerTotalHurtV / _loc1_).toString();
         this._dpsPanel["ptotalHurtTxt"].text = this._playerTotalHurtV.toString();
         this._dpsPanel["sumsHurtTxt"].text = Math.round(this._sumTotalHurtV / _loc1_).toString();
         this._dpsPanel["sumTotalHurtTxt"].text = this._sumTotalHurtV.toString();
         if(this._playerTotalHurtV == 0 && this._sumTotalHurtV == 0)
         {
            this._dpsPanel["perTxt"].text = "0%";
         }
         else
         {
            this._dpsPanel["perTxt"].text = Math.round(this._sumTotalHurtV / (this._playerTotalHurtV + this._sumTotalHurtV) * 100) + "%";
         }
      }
      
      private function onDpsHit(param1:UserEvent) : void
      {
         var _loc2_:BruiseInfo = param1.data as BruiseInfo;
         if(Boolean(SummonManager.getActorSummonInfo().fightSummonInfo) && _loc2_.atkerID == SummonManager.getActorSummonInfo().fightSummonInfo.stageID)
         {
            this._sumTotalHurtV += _loc2_.decHP;
         }
         if(_loc2_.atkerID == MainManager.actorID)
         {
            this._playerTotalHurtV += _loc2_.decHP;
         }
      }
      
      private function resizePos() : void
      {
         this._dpsPanel.y = 190;
         this._dpsPanel.x = LayerManager.stageWidth - this._dpsPanel.width - 2;
      }
      
      private function myDesTroy() : void
      {
         DisplayUtil.removeForParent(this._dpsPanel);
         this._dpsPanel = null;
         clearInterval(this._timeId);
         UserManager.removeEventListener(UserEvent.USER_DPS_HIT,this.onDpsHit);
         StageResizeController.instance.unregister(this.resizePos);
      }
      
      override public function destroy() : void
      {
      }
   }
}

