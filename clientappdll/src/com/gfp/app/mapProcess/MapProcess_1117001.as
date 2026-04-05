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
   import com.gfp.core.player.NumSprite;
   import com.gfp.core.ui.DialogBox;
   import com.gfp.core.utils.FilterUtil;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1117001 extends BaseMapProcess
   {
      
      private var _leftTimerFeather:LeftTimeTxtFeater;
      
      private var _timeMc:MovieClip;
      
      private var _cntMc:MovieClip;
      
      private var _skillMc:MovieClip;
      
      private var _skillBtn:SimpleButton;
      
      private var _timeLimit:int = 180000;
      
      private var _expNum:NumSprite;
      
      private var _expQianNum:NumSprite;
      
      private var _bornNum:NumSprite;
      
      private var _dialogBox:DialogBox;
      
      private var _expBornStateBar:MovieClip;
      
      private var _power:int;
      
      public function MapProcess_1117001()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._timeMc = _mapModel.libManager.getMovieClip("UI_TimeTxtMc");
         this._cntMc = _mapModel.libManager.getMovieClip("UI_ExpBornTxtMc");
         this._skillMc = _mapModel.libManager.getMovieClip("UI_SkillEffMc");
         this._expBornStateBar = _mapModel.libManager.getMovieClip("UI_ExpBornStateBar");
         this._skillBtn = this._expBornStateBar.skillBtn;
         this._skillBtn.mouseEnabled = false;
         this._skillMc.visible = false;
         this._skillBtn.filters = FilterUtil.GRAY_FILTER;
         this._leftTimerFeather = new LeftTimeTxtFeater(this._timeLimit,this._timeMc["leftTimeShowTxt"],null);
         UserManager.addEventListener(UserEvent.BORN,this.onMonsterBorn);
         SocketConnection.addCmdListener(CommandID.FIGHT_COMMON_NOTIFY,this.onStageProChange);
         this._leftTimerFeather.start();
         this._skillBtn.addEventListener(MouseEvent.CLICK,this.onSkillBtnClick);
         StageResizeController.instance.register(this.resizePos);
         this._cntMc["expNum"].visible = false;
         this._cntMc["expQianNum"].visible = true;
         this.resizePos();
         LayerManager.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         LayerManager.topLevel.addChild(this._timeMc);
         LayerManager.topLevel.addChild(this._cntMc);
         LayerManager.topLevel.addChild(this._expBornStateBar);
         LayerManager.topLevel.addChild(this._skillMc);
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         var _loc2_:int = 0;
         switch(param1.keyCode)
         {
            case Keyboard.NUMBER_8:
               if(this._power >= 100)
               {
                  this.onSkillBtnClick(null);
               }
         }
      }
      
      private function onMonsterBorn(param1:UserEvent) : void
      {
         var _loc3_:String = null;
         var _loc2_:UserModel = param1.data as UserModel;
         if(Boolean(_loc2_) && _loc2_.info.roleType == 14478)
         {
            _loc3_ = "呀~快点逃啊~不能让他们把成长值抢到手~~";
            this._dialogBox = new DialogBox();
            this._dialogBox.show(_loc3_,0,-_loc2_.height,_loc2_);
         }
      }
      
      protected function onSkillBtnClick(param1:MouseEvent) : void
      {
         SocketConnection.send(CommandID.FIGHT_ACTIVITY_EFFECT,8,4120774,0);
         this._skillMc.visible = false;
         this._skillBtn.filters = FilterUtil.GRAY_FILTER;
         (this._skillBtn.upState as MovieClip).gotoAndStop(1);
         this._skillBtn.mouseEnabled = false;
      }
      
      private function runingJnCd() : void
      {
         this._skillBtn.filters = null;
         this._skillBtn.mouseEnabled = true;
         this._skillBtn.mask = null;
         (this._skillBtn.upState as MovieClip).play();
         this._skillMc.visible = true;
      }
      
      private function onStageProChange(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         var _loc6_:uint = _loc2_.readUnsignedInt();
         var _loc7_:uint = _loc2_.readUnsignedInt();
         var _loc8_:uint = _loc2_.readUnsignedInt();
         var _loc9_:uint = _loc2_.readUnsignedInt();
         var _loc10_:uint = _loc2_.readUnsignedInt();
         this._power = _loc2_.readUnsignedInt();
         if(this._expBornStateBar)
         {
            this._expBornStateBar.barMc.gotoAndStop(this._power);
         }
         if(this._power >= 100)
         {
            this.runingJnCd();
         }
         if(!this._expNum)
         {
            this._expNum = new NumSprite(this._cntMc["expNum"],0);
         }
         if(!this._expQianNum)
         {
            this._expQianNum = new NumSprite(this._cntMc["expQianNum"],0);
         }
         if(_loc5_ < 10000)
         {
            this._expQianNum.value = _loc5_;
            this._expQianNum.max_live = 4;
            this._cntMc["expNum"].visible = false;
            this._cntMc["expQianNum"].visible = true;
         }
         else
         {
            this._cntMc["expNum"].visible = true;
            this._cntMc["expQianNum"].visible = false;
            this._expNum.max_live = 3;
            this._expNum.value = Math.floor(_loc5_ / 10000);
         }
         if(!this._bornNum)
         {
            this._bornNum = new NumSprite(this._cntMc["bornNum"],0);
            this._bornNum.max_live = 3;
         }
         this._bornNum.value = _loc6_;
      }
      
      private function resizePos() : void
      {
         this._timeMc.x = LayerManager.stageWidth - this._timeMc.width >> 1;
         this._timeMc.y = 125;
         this._cntMc.x = LayerManager.stageWidth - this._cntMc.width - 50;
         this._cntMc.y = 200;
         this._expBornStateBar.x = 50;
         this._expBornStateBar.y = 150;
         this._skillMc.x = 120 - (53 + 85);
         this._skillMc.y = 170 + (407 - 375);
      }
      
      override public function destroy() : void
      {
         SocketConnection.removeCmdListener(CommandID.FIGHT_COMMON_NOTIFY,this.onStageProChange);
         LayerManager.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         StageResizeController.instance.unregister(this.resizePos);
         this._skillBtn.removeEventListener(MouseEvent.CLICK,this.onSkillBtnClick);
         UserManager.removeEventListener(UserEvent.BORN,this.onMonsterBorn);
         DisplayUtil.removeForParent(this._expBornStateBar);
         DisplayUtil.removeForParent(this._timeMc);
         DisplayUtil.removeForParent(this._cntMc);
         DisplayUtil.removeForParent(this._skillMc);
      }
   }
}

