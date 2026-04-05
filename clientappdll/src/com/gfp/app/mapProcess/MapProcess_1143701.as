package com.gfp.app.mapProcess
{
   import com.gfp.app.ui.compoment.McNumber;
   import com.gfp.core.CommandID;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import flash.display.MovieClip;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1143701 extends BaseMapProcess
   {
      
      private var _cntMc:MovieClip;
      
      private var _power:McNumber;
      
      private var _price:int;
      
      private var power:MovieClip;
      
      private var anmDieAnm:MovieClip;
      
      public function MapProcess_1143701()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._cntMc = _mapModel.libManager.getMovieClip("UI_MonsterNumWarn");
         SocketConnection.addCmdListener(CommandID.STAGE_MONSTER_PRO_CHANGE,this.onMonsterChange);
         LayerManager.topLevel.addChild(this._cntMc);
         this._cntMc.boTxt.text = "30";
         this.power = _mapModel.libManager.getMovieClip("power");
         this.power.x = LayerManager.stageWidth - this.power.width >> 1;
         this.power.y = LayerManager.stageHeight - this.power.height >> 1;
         LayerManager.topLevel.addChild(this.power);
         this._power = new McNumber(this.power["_power"]);
         this._power.setValue(0);
         StageResizeController.instance.register(this.resizePos);
         this.resizePos();
         SocketConnection.addCmdListener(CommandID.ABSORB_HP,this.onGetSwap);
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
      
      private function updateView() : void
      {
         this._power.setValue(this._price);
      }
      
      private function onMonsterChange(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         var _loc6_:uint = _loc2_.readUnsignedInt();
         this._cntMc.boTxt.text = String(_loc5_);
         TextAlert.show("第" + _loc5_.toString() + "波怪物已经在关卡左边出现，请小侠士做好准备！");
      }
      
      private function resizePos() : void
      {
         this._cntMc.x = LayerManager.stageWidth - this._cntMc.width >> 1;
         this._cntMc.y = 100;
         this.power.x = 1000;
         this.power.y = 300;
      }
      
      override public function destroy() : void
      {
         SocketConnection.removeCmdListener(CommandID.STAGE_MONSTER_PRO_CHANGE,this.onMonsterChange);
         SocketConnection.removeCmdListener(CommandID.ABSORB_HP,this.onGetSwap);
         StageResizeController.instance.unregister(this.resizePos);
         DisplayUtil.removeForParent(this._cntMc);
         DisplayUtil.removeForParent(this.power);
      }
   }
}

