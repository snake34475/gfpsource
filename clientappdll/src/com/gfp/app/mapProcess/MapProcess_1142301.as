package com.gfp.app.mapProcess
{
   import com.gfp.core.CommandID;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.net.SocketConnection;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1142301 extends BaseMapProcess
   {
      
      private var _totalAbsorbtion:TextField;
      
      private var _leftAbsorbtion:TextField;
      
      private var _leftAbsorbtionNum:int;
      
      private var _mc:MovieClip;
      
      public function MapProcess_1142301()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._mc = _mapModel.libManager.getMovieClip("UI_RecordCntMc_142301");
         this._totalAbsorbtion = this._mc["totalAbsorbtion"];
         this._leftAbsorbtion = this._mc["leftAbsorbtion"];
         this._leftAbsorbtionNum = 50000000;
         this._totalAbsorbtion.text = "" + 50000000;
         this._leftAbsorbtion.text = "" + 50000000;
         SocketConnection.addCmdListener(CommandID.ABSORB_HP,this.onHpMp);
         StageResizeController.instance.register(this.resizePos);
         this.resizePos();
         LayerManager.topLevel.addChild(this._mc);
      }
      
      private function resizePos() : void
      {
         this._mc.x = LayerManager.stageWidth - this._mc.width;
         this._mc.y = LayerManager.stageHeight / 2;
      }
      
      private function onHpMp(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         this._leftAbsorbtionNum = 50000000 - _loc3_;
         if(this._leftAbsorbtionNum <= 0)
         {
            this._leftAbsorbtionNum = 0;
         }
         this._leftAbsorbtion.text = "" + this._leftAbsorbtionNum;
      }
      
      override public function destroy() : void
      {
         StageResizeController.instance.unregister(this.resizePos);
         SocketConnection.removeCmdListener(CommandID.INFORM_USER_HPMP,this.onHpMp);
         DisplayUtil.removeForParent(this._mc);
      }
   }
}

