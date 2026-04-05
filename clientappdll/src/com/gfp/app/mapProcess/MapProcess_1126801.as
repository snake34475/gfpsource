package com.gfp.app.mapProcess
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.cartoon.event.AnimatEvent;
   import com.gfp.app.ui.compoment.McNumber;
   import com.gfp.core.CommandID;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.fight.BruiseInfo;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.net.SocketConnection;
   import flash.display.MovieClip;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1126801 extends BaseMapProcess
   {
      
      private var _currentHitMC:MovieClip;
      
      private var _mcNumber:McNumber;
      
      private var _currentDamageCount:int = 0;
      
      private var _playAnimate:int = 0;
      
      private var _mc:MovieClip;
      
      public function MapProcess_1126801()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._mc = _mapModel.libManager.getMovieClip("UI_RecordCntMc_126801");
         this._currentHitMC = this._mc["currentHit"];
         this._mcNumber = new McNumber(this._currentHitMC);
         this._mcNumber.setValue(0);
         UserManager.addEventListener(UserEvent.USER_DPS_HIT,this.onDpsHit);
         SocketConnection.addCmdListener(CommandID.BUFF_STATE,this.onAddBuff);
         StageResizeController.instance.register(this.resizePos);
         this.resizePos();
         LayerManager.topLevel.addChild(this._mc);
      }
      
      private function resizePos() : void
      {
         this._mc.x = LayerManager.stageWidth - this._mc.width;
         this._mc.y = LayerManager.stageHeight / 2;
      }
      
      private function onAddBuff(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedShort();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         var _loc6_:Boolean = _loc2_.readUnsignedByte() == 1;
         if(_loc4_ == 3370)
         {
            this.playAnimation();
         }
      }
      
      private function onDpsHit(param1:UserEvent) : void
      {
         var _loc2_:BruiseInfo = param1.data as BruiseInfo;
         if(_loc2_.roleID >= 14721 && _loc2_.roleID <= 14723)
         {
            this._currentDamageCount += 1;
         }
         this._mcNumber.setValue(this._currentDamageCount);
      }
      
      private function playAnimation() : void
      {
         AnimatPlay.startAnimat("Lightning",-1,true);
         AnimatPlay.addAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimatEndHandle);
      }
      
      private function onAnimatEndHandle(param1:AnimatEvent) : void
      {
         AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimatEndHandle);
         AnimatPlay.destory();
      }
      
      override public function destroy() : void
      {
         UserManager.removeEventListener(UserEvent.USER_DPS_HIT,this.onDpsHit);
         SocketConnection.removeCmdListener(CommandID.BUFF_STATE,this.onAddBuff);
         StageResizeController.instance.unregister(this.resizePos);
         DisplayUtil.removeForParent(this._mc);
      }
   }
}

