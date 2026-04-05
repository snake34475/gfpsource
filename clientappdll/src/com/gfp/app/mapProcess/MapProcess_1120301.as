package com.gfp.app.mapProcess
{
   import com.gfp.core.CommandID;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.net.SocketConnection;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1120301 extends BaseMapProcess
   {
      
      private var _tipSp:Sprite;
      
      private var _lightMC:MovieClip;
      
      public function MapProcess_1120301()
      {
         super();
         this.addListener();
      }
      
      override protected function init() : void
      {
         this._tipSp = _mapModel.libManager.getSprite("ruleTip");
         this._tipSp.x = LayerManager.stageWidth - 180;
         this._tipSp.y = 90;
         LayerManager.uiLevel.addChild(this._tipSp);
         this._lightMC = _mapModel.libManager.getMovieClip("lightMC");
         this._lightMC.x = 600;
         this._lightMC.y = LayerManager.stageHeight - 95;
         LayerManager.uiLevel.addChild(this._lightMC);
         this._lightMC.gotoAndStop(1);
      }
      
      private function addListener() : void
      {
         SocketConnection.addCmdListener(CommandID.FIGHT_MONSTER_DIALOG,this.onGetLightInfo);
      }
      
      private function onGetLightInfo(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         this._lightMC.gotoAndStop(_loc2_.readUnsignedInt());
      }
      
      private function removeListener() : void
      {
         SocketConnection.removeCmdListener(CommandID.FIGHT_MONSTER_DIALOG,this.onGetLightInfo);
      }
      
      override public function destroy() : void
      {
         this.removeListener();
         if(this._tipSp)
         {
            DisplayUtil.removeForParent(this._tipSp);
         }
         super.destroy();
      }
   }
}

