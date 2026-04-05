package com.gfp.app.mapProcess
{
   import com.gfp.core.CommandID;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1117901 extends BaseMapProcess
   {
      
      private var _cntMc:MovieClip;
      
      private var _curExp:Number;
      
      private var _initExp:Number;
      
      private var _offExp:Number = 0;
      
      private var _showWarnCnt:int = 0;
      
      private var _showList:Vector.<MovieClip> = new Vector.<MovieClip>();
      
      public function MapProcess_1117901()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._cntMc = _mapModel.libManager.getMovieClip("UI_MonsterNumWarn");
         (_mapModel.downLevel as MovieClip).contentBoFang.gotoAndStop(1);
         (_mapModel.downLevel as MovieClip).contentBoFang.visible = false;
         SocketConnection.addCmdListener(CommandID.FIGHT_END,this.onEnd);
         SocketConnection.addCmdListener(CommandID.STAGE_MONSTER_PRO_CHANGE,this.onMonsterChange);
         MainManager.actorModel.addEventListener(UserEvent.GROW_CHANGE,this.growChangeHandler);
         StageResizeController.instance.register(this.resizePos);
         this.resizePos();
         this._initExp = this._curExp = MainManager.actorInfo.exp;
         LayerManager.topLevel.addChild(this._cntMc);
      }
      
      private function onMonsterChange(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         var _loc6_:uint = _loc2_.readUnsignedInt();
         this._cntMc.boTxt.text = String(5 - _loc5_);
         TextAlert.show("第" + _loc5_.toString() + "波怪物已经在关卡左边出现，请小侠士做好准备！");
      }
      
      protected function onEnd(param1:SocketEvent) : void
      {
         this._offExp = MainManager.actorInfo.exp - this._initExp;
         AlertManager.showSimpleAlarm("本次获得了" + this._offExp.toString() + "点人物经验");
      }
      
      private function onStageProChange(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:int = int(_loc2_.readUnsignedInt());
         MainManager.actorInfo.exp - this._curExp;
      }
      
      protected function growChangeHandler(param1:UserEvent) : void
      {
         var _loc3_:MovieClip = null;
         var _loc2_:Number = MainManager.actorInfo.exp - this._curExp;
         if(_loc2_ == 0)
         {
            return;
         }
         this._curExp = MainManager.actorInfo.exp;
         if(_loc2_ >= 30000)
         {
            if(((_mapModel.downLevel as MovieClip).contentBoFang as MovieClip).currentFrame == 1)
            {
               _mapModel.downLevel.addEventListener(Event.ENTER_FRAME,this.onFrameHandler);
               (_mapModel.downLevel as MovieClip).contentBoFang.play();
               (_mapModel.downLevel as MovieClip).contentBoFang.visible = true;
               ((_mapModel.downLevel as MovieClip).contentMcDaiJi as MovieClip).visible = false;
            }
         }
         else
         {
            if(this._showWarnCnt > 2)
            {
               return;
            }
            _loc3_ = _mapModel.libManager.getMovieClip("UI_MonsterDieAnm");
            _loc3_.x = LayerManager.stageWidth - _loc3_.width >> 1;
            _loc3_.y = LayerManager.stageHeight - _loc3_.height >> 1;
            LayerManager.topLevel.addChild(_loc3_);
            TweenLite.to(_loc3_,4,{
               "y":_loc3_.y - 150,
               "alpha":0.3,
               "onComplete":this.onTweenEnd,
               "onCompleteParams":[_loc3_]
            });
            this._showList.push(_loc3_);
            ++this._showWarnCnt;
         }
      }
      
      protected function onFrameHandler(param1:Event) : void
      {
         var _loc2_:MovieClip = (_mapModel.downLevel as MovieClip).contentBoFang as MovieClip;
         if(_loc2_.currentFrame == _loc2_.totalFrames)
         {
            _mapModel.downLevel.removeEventListener(Event.ENTER_FRAME,this.onFrameHandler);
            _loc2_.gotoAndStop(1);
            _loc2_.visible = false;
            ((_mapModel.downLevel as MovieClip).contentMcDaiJi as MovieClip).visible = true;
         }
      }
      
      private function onTweenEnd(... rest) : void
      {
         var _loc2_:MovieClip = rest[0];
         TweenLite.killTweensOf(_loc2_);
         DisplayUtil.removeForParent(_loc2_);
      }
      
      private function resizePos() : void
      {
         this._cntMc.x = LayerManager.stageWidth - this._cntMc.width >> 1;
         this._cntMc.y = 120;
      }
      
      override public function destroy() : void
      {
         var _loc1_:MovieClip = null;
         _mapModel.downLevel.removeEventListener(Event.ENTER_FRAME,this.onFrameHandler);
         for each(_loc1_ in this._showList)
         {
            TweenLite.killTweensOf(_loc1_);
            DisplayUtil.removeForParent(_loc1_);
         }
         MainManager.actorModel.removeEventListener(UserEvent.GROW_CHANGE,this.growChangeHandler);
         SocketConnection.removeCmdListener(CommandID.FIGHT_END,this.onEnd);
         SocketConnection.removeCmdListener(CommandID.STAGE_MONSTER_PRO_CHANGE,this.onMonsterChange);
         StageResizeController.instance.unregister(this.resizePos);
         DisplayUtil.removeForParent(this._cntMc);
         if(this._offExp == 0)
         {
            this._offExp = MainManager.actorInfo.exp - this._initExp;
         }
         ActivityExchangeCommander.exchange(7731,this._offExp);
      }
   }
}

