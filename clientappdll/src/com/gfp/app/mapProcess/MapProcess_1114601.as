package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.LeftTimeFeather;
   import com.gfp.core.CommandID;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.greensock.TweenMax;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1114601 extends BaseMapProcess
   {
      
      private var _listMonsterMc:Vector.<MovieClip>;
      
      private var _txtWarnMc:MovieClip;
      
      private var _txtNumMc:MovieClip;
      
      private var _round:int;
      
      private var _hasShowed:Boolean;
      
      private var _totalTime:int = 60000;
      
      private var _mapTimer:LeftTimeFeather;
      
      private var _findedTimes:int = 0;
      
      public function MapProcess_1114601()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.addEventListener();
         this._txtWarnMc = _mapModel.libManager.getMovieClip("UI_TxtWarn");
         this._txtNumMc = _mapModel.libManager.getMovieClip("UI_TxtRound");
         this._txtNumMc.gotoAndStop(1);
         DisplayUtil.align(this._txtWarnMc,null,AlignType.MIDDLE_CENTER);
         LayerManager.topLevel.addChild(this._txtWarnMc);
         LayerManager.topLevel.addChild(this._txtNumMc);
         this.resizePos();
         TweenMax.to(this._txtWarnMc,5,{
            "alpha":0,
            "delay":5,
            "onComplete":this.warnMcTweenOver
         });
         StageResizeController.instance.register(this.resizePos);
         this._mapTimer = new LeftTimeFeather(this._totalTime);
      }
      
      private function warnMcTweenOver() : void
      {
         TweenMax.killChildTweensOf(this._txtWarnMc);
         LayerManager.topLevel.removeChild(this._txtWarnMc);
      }
      
      private function resizePos() : void
      {
         this._txtNumMc.y = 50;
         this._txtNumMc.x = LayerManager.stageWidth - this._txtNumMc.width - 50;
      }
      
      private function addEventListener() : void
      {
         UserManager.addEventListener(UserEvent.DIE,this.onMonsterDie);
         SocketConnection.addCmdListener(CommandID.STAGE_MONSTER_PRO_CHANGE,this.onStageProChange);
      }
      
      private function removeEventListener() : void
      {
         UserManager.removeEventListener(UserEvent.DIE,this.onMonsterDie);
         SocketConnection.removeCmdListener(CommandID.STAGE_MONSTER_PRO_CHANGE,this.onStageProChange);
         LayerManager.gameLevel.stage.removeEventListener(Event.ENTER_FRAME,this.onFrameHandler);
      }
      
      private function onStageProChange(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         this._round = _loc2_.readUnsignedInt();
         this._txtNumMc.gotoAndStop(this._round);
         this._mapTimer.destroy();
         this._mapTimer = new LeftTimeFeather(this._totalTime);
         this._hasShowed = false;
         this._findedTimes = this._round - 1;
      }
      
      private function onMonsterDie(param1:UserEvent) : void
      {
         var _loc3_:MovieClip = null;
         var _loc2_:UserModel = param1.data as UserModel;
         if(!this._listMonsterMc)
         {
            this._listMonsterMc = new Vector.<MovieClip>();
         }
         if(_loc2_.info.roleType == 14382)
         {
            _loc2_.visible = false;
            _loc3_ = _mapModel.libManager.getMovieClip("UI_MonsterRealMovie");
            this._listMonsterMc.push(_loc3_);
            _loc3_.x = _loc2_.info.pos.x - 50;
            _loc3_.y = _loc2_.info.pos.y - 16;
            _mapModel.contentLevel.addChild(_loc3_);
            this._hasShowed = true;
            LayerManager.gameLevel.stage.addEventListener(Event.ENTER_FRAME,this.onFrameHandler);
            if(this._findedTimes == 0)
            {
               AlertManager.showSimpleAlarm("挑战失败！本次没有找出变身的天蝎座，请再接再厉。");
            }
            else
            {
               AlertManager.showSimpleAlarm("挑战失败！本次挑战已找出<font color = \'#FF0000\'>" + this._findedTimes + "</font>个变身的天蝎座。");
            }
         }
         if(_loc2_.info.roleType == 14381 && this._hasShowed == false && this._round == 3)
         {
            _loc2_.visible = false;
            _loc3_ = _mapModel.libManager.getMovieClip("UI_MonsterFateMovie");
            this._listMonsterMc.push(_loc3_);
            _loc3_.x = _loc2_.info.pos.x - 50;
            _loc3_.y = _loc2_.info.pos.y - 16;
            _mapModel.contentLevel.addChild(_loc3_);
            this._hasShowed = true;
            LayerManager.gameLevel.stage.addEventListener(Event.ENTER_FRAME,this.onFrameHandler);
            AlertManager.showSimpleAlarm("挑战成功！本次挑战已找出<font color = \'#FF0000\'>3</font>个变身的天蝎座。");
         }
      }
      
      protected function onFrameHandler(param1:Event) : void
      {
         var _loc2_:MovieClip = null;
         for each(_loc2_ in this._listMonsterMc)
         {
            if(_loc2_.currentFrame == _loc2_.totalFrames)
            {
               _loc2_.stop();
               DisplayUtil.removeForParent(_loc2_);
            }
         }
      }
      
      override public function destroy() : void
      {
         this.removeEventListener();
         TweenMax.killChildTweensOf(this._txtWarnMc);
         DisplayUtil.removeForParent(this._txtWarnMc);
         DisplayUtil.removeForParent(this._txtNumMc);
         StageResizeController.instance.unregister(this.resizePos);
         if(this._mapTimer)
         {
            this._mapTimer.destroy();
         }
      }
   }
}

