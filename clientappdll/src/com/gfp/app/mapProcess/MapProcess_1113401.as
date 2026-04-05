package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.LeftTimeTxtFeater;
   import com.gfp.core.CommandID;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import flash.display.MovieClip;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1113401 extends BaseMapProcess
   {
      
      private var _leftTimerFeather:LeftTimeTxtFeater;
      
      private var _dataList:Vector.<Object> = new Vector.<Object>();
      
      private var _timeMc:MovieClip;
      
      private var _cntMc:MovieClip;
      
      private var _liveBossId:int = 0;
      
      private var _totalPmNum:int;
      
      public function MapProcess_1113401()
      {
         this._dataList.push({
            "id":14365,
            "time":15 * 1000
         },{
            "id":14364,
            "time":25 * 1000
         },{
            "id":14363,
            "time":40 * 1000
         },{
            "id":14362,
            "time":60 * 1000
         },{
            "id":14361,
            "time":80 * 1000
         },{
            "id":14360,
            "time":100 * 1000
         },{
            "id":14359,
            "time":120 * 1000
         });
         super();
      }
      
      override protected function init() : void
      {
         this._timeMc = _mapModel.libManager.getMovieClip("UI_TimeMengHuoTxtMc");
         this._cntMc = _mapModel.libManager.getMovieClip("UI_CntMengHuoTxtMc");
         this._cntMc.cntTxt.text = "0";
         this.resizePos();
         LayerManager.topLevel.addChild(this._timeMc);
         LayerManager.topLevel.addChild(this._cntMc);
         UserManager.addEventListener(UserEvent.BORN,this.onMonsterBorn);
         SocketConnection.addCmdListener(CommandID.STAGE_MONSTER_PRO_CHANGE,this.onStageProChange);
         StageResizeController.instance.register(this.resizePos);
      }
      
      private function resizePos() : void
      {
         this._timeMc.x = LayerManager.stageWidth - this._timeMc.width >> 1;
         this._timeMc.y = 125;
         this._cntMc.x = LayerManager.stageWidth - this._timeMc.width + 190;
         this._cntMc.y = 250;
      }
      
      private function onStageProChange(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         this._cntMc.cntTxt.text = (_loc5_ - 1).toString();
      }
      
      private function onMonsterBorn(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         var _loc3_:Object = this.getBossObj(_loc2_.info.roleType);
         if(_loc3_)
         {
            this._timeMc.totalTimeTxt.text = String(_loc3_.time / 1000);
            if(this._leftTimerFeather)
            {
               this._leftTimerFeather.destroy();
            }
            this._leftTimerFeather = new LeftTimeTxtFeater(_loc3_.time,this._timeMc.leftTimeTxt,null,0);
            this._leftTimerFeather.start();
         }
      }
      
      private function getBossObj(param1:int) : Object
      {
         var _loc2_:Object = null;
         for each(_loc2_ in this._dataList)
         {
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      override public function destroy() : void
      {
         SocketConnection.removeCmdListener(CommandID.STAGE_MONSTER_PRO_CHANGE,this.onStageProChange);
         UserManager.removeEventListener(UserEvent.BORN,this.onMonsterBorn);
         StageResizeController.instance.unregister(this.resizePos);
         DisplayUtil.removeForParent(this._timeMc);
         DisplayUtil.removeForParent(this._cntMc);
      }
   }
}

