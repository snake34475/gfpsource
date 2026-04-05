package com.gfp.app.mapProcess
{
   import com.gfp.app.ui.compoment.McNumber;
   import com.gfp.core.CommandID;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.net.SocketConnection;
   import flash.display.MovieClip;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1143801 extends BaseMapProcess
   {
      
      private var _cntMc:MovieClip;
      
      private var _power:McNumber;
      
      private var _price:int;
      
      private var power:MovieClip;
      
      public function MapProcess_1143801()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.power = _mapModel.libManager.getMovieClip("power");
         this.power.x = LayerManager.stageWidth - this.power.width >> 1;
         this.power.y = LayerManager.stageHeight - this.power.height >> 1;
         LayerManager.topLevel.addChild(this.power);
         this._power = new McNumber(this.power["_power"]);
         StageResizeController.instance.register(this.resizePos);
         this.resizePos();
         this._power.setValue(0);
         SocketConnection.addCmdListener(CommandID.ABSORB_HP,this.onGetSwap);
      }
      
      private function _exchangeCompleteHandler(param1:ExchangeEvent) : void
      {
         this.updateView();
      }
      
      private function updateView() : void
      {
         this._power.setValue(this._price);
      }
      
      private function onGetSwap(param1:SocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ByteArray = param1.data as ByteArray;
         _loc3_.position = 0;
         _loc2_ = int(_loc3_.readUnsignedInt());
         this._price += _loc2_;
         this.updateView();
      }
      
      private function resizePos() : void
      {
         this.power.x = 900;
         this.power.y = 260;
      }
      
      override public function destroy() : void
      {
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this._exchangeCompleteHandler);
         StageResizeController.instance.unregister(this.resizePos);
         DisplayUtil.removeForParent(this.power);
      }
   }
}

