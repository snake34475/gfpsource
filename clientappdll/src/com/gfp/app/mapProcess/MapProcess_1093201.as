package com.gfp.app.mapProcess
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.cartoon.DailyActivityAward;
   import com.gfp.app.fight.FightGo;
   import com.gfp.app.fight.FightMonsterClear;
   import com.gfp.app.miniMap.MiniMap;
   import com.gfp.app.time.TimerComponents;
   import com.gfp.app.toolBar.HeadSelfPanel;
   import com.gfp.app.toolBar.HeadSummonPanel;
   import com.gfp.core.CommandID;
   import com.gfp.core.cache.SoundCache;
   import com.gfp.core.cache.SoundInfo;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.HiddenEvent;
   import com.gfp.core.info.DailyActiveAwardInfo;
   import com.gfp.core.manager.HiddenManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.SummonModel;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.sound.SoundManager;
   import com.gfp.core.ui.UILoader;
   import com.gfp.core.utils.HiddenState;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1093201 extends BaseMapProcess
   {
      
      private const ANIMAT_HEAD:String = "cutdown_";
      
      private const ANIMAT_ID:uint = 1;
      
      private const MISS_TOTAL:uint = 5;
      
      private const SCORE_TOTAL:uint = 30;
      
      private const ROUND_TOTAL:uint = 40;
      
      private var _socre:int;
      
      private var _miss:uint;
      
      private var _wordID:uint;
      
      private var _wordsMC:MovieClip;
      
      private var _pageMC:MovieClip;
      
      private var _scoreMainUI:MovieClip;
      
      private var _missMainUI:MovieClip;
      
      private var _loader:UILoader;
      
      private var _roundTxt:TextField;
      
      private var _plantArr:Array;
      
      private const PlantDailyID:uint = 334;
      
      public function MapProcess_1093201()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.initMapUI();
         this.loadAnimat();
         this.addMapListener();
         this.initPlants();
      }
      
      private function initMapUI() : void
      {
         FightGo.instance.enabledShow = false;
         FightMonsterClear.instance.enabledShow = false;
         MiniMap.instance.hide();
         TimerComponents.instance.hide();
         HeadSelfPanel.instance.hide();
         var _loc1_:SummonModel = SummonManager.getUserSummonModel(MainManager.actorInfo.userID);
         if(_loc1_)
         {
            HeadSummonPanel.instance.hide();
         }
         this._wordsMC = _mapModel.downLevel["words_mc"];
         this._pageMC = _mapModel.downLevel["page_mc"];
         this._scoreMainUI = _mapModel.downLevel["score_ui"];
         this._missMainUI = _mapModel.downLevel["miss_ui"];
         this._roundTxt = _mapModel.downLevel["round_txt"];
         this._wordsMC.gotoAndStop(1);
         this._roundTxt.text = this.ROUND_TOTAL.toString();
         this.updateScore();
         this.updateMiss();
      }
      
      private function loadAnimat() : void
      {
         AnimatPlay.startAnimat(this.ANIMAT_HEAD,this.ANIMAT_ID,true,0,0,false,false,true,2);
      }
      
      private function addMapListener() : void
      {
         SocketConnection.addCmdListener(CommandID.STAGE_MONSTER_PRO_CHANGE,this.onStageProChange);
         HiddenManager.addEventListener(HiddenEvent.OPEN,this.onHidenOpen);
         this._pageMC.addEventListener("page_over",this.onPageOver);
         this._pageMC.addEventListener("page_out",this.onPageOut);
      }
      
      private function initPlants() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:MovieClip = null;
         this._plantArr = new Array();
         while(_loc1_ < 2)
         {
            _loc2_ = MapManager.currentMap.downLevel["plant_" + _loc1_];
            _loc2_.gotoAndStop(1);
            if(TasksManager.isProcess(1325,2))
            {
               _loc2_.buttonMode = true;
               _loc2_.addEventListener(MouseEvent.CLICK,this.onPlantClick);
            }
            this._plantArr.push(_loc2_);
            _loc1_++;
         }
      }
      
      private function onPlantClick(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         _loc2_.addEventListener(Event.ENTER_FRAME,this.onPlantEnterFrame);
         _loc2_.gotoAndPlay(2);
      }
      
      private function onPlantEnterFrame(param1:Event) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         if(_loc2_.currentFrame == _loc2_.totalFrames)
         {
            _loc2_.removeEventListener(Event.ENTER_FRAME,this.onPlantEnterFrame);
            _loc2_.gotoAndStop(1);
            SocketConnection.addCmdListener(CommandID.DAILY_ACTIVITY,this.onGetAward);
            SocketConnection.send(CommandID.DAILY_ACTIVITY,this.PlantDailyID);
         }
      }
      
      private function onGetAward(param1:SocketEvent) : void
      {
         var _loc2_:DailyActiveAwardInfo = param1.data as DailyActiveAwardInfo;
         var _loc3_:uint = uint(_loc2_.dailyActivityId);
         if(_loc3_ == this.PlantDailyID)
         {
            DailyActivityAward.addAward(_loc2_);
         }
      }
      
      private function removeMapListener() : void
      {
         SocketConnection.removeCmdListener(CommandID.STAGE_MONSTER_PRO_CHANGE,this.onStageProChange);
         HiddenManager.removeEventListener(HiddenEvent.OPEN,this.onHidenOpen);
      }
      
      private function onStageProChange(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         _loc2_.readUnsignedInt();
         _loc2_.readUnsignedInt();
         var _loc6_:uint = _loc2_.readUnsignedInt();
         if(_loc3_ == 932 && _loc4_ == 1093201)
         {
            this._wordID = _loc5_ + 1;
            this._pageMC.gotoAndPlay(1);
            this._roundTxt.text = String(this.ROUND_TOTAL - _loc6_);
         }
      }
      
      private function onHidenOpen(param1:HiddenEvent) : void
      {
         var _loc4_:MovieClip = null;
         var _loc2_:uint = uint(param1.state);
         var _loc3_:UserModel = param1.model;
         if(_loc2_ == HiddenState.STATE_OPEN)
         {
            _loc4_ = UIManager.getMovieClip("Fight_UI_right");
            ++this._socre;
            this.playSound("sound_score.mp3");
         }
         if(_loc2_ == HiddenState.STATE_CHANGE_THREE)
         {
            _loc4_ = UIManager.getMovieClip("Fight_UI_mistake");
            ++this._miss;
            this.playSound("sound_mistake.mp3");
         }
         LayerManager.topLevel.addChild(_loc4_);
         DisplayUtil.align(_loc4_,null,AlignType.TOP_CENTER);
         _loc4_.scaleX = _loc4_.scaleY = 2;
         _loc4_.y += 30;
         _loc4_.addEventListener(Event.ENTER_FRAME,this.onAnimatFrame);
         this.updateScore();
         this.updateMiss();
      }
      
      private function onAnimatFrame(param1:Event) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         if(_loc2_.currentFrame == _loc2_.totalFrames)
         {
            _loc2_.removeEventListener(Event.ENTER_FRAME,this.onAnimatFrame);
            _loc2_.stop();
            DisplayUtil.removeForParent(_loc2_);
            _loc2_ = null;
         }
      }
      
      private function onPageOver(param1:Event) : void
      {
         this._wordsMC.visible = false;
      }
      
      private function onPageOut(param1:Event) : void
      {
         this._wordsMC.gotoAndStop(this._wordID);
         this._wordsMC.visible = true;
      }
      
      private function updateScore() : void
      {
         this.setNum(this._scoreMainUI["num1"],uint(this._socre / 10));
         this.setNum(this._scoreMainUI["num2"],uint(this._socre % 10));
         this.setNum(this._scoreMainUI["num3"],uint(this.SCORE_TOTAL / 10));
         this.setNum(this._scoreMainUI["num4"],uint(this.SCORE_TOTAL % 10));
      }
      
      private function updateMiss() : void
      {
         this.setNum(this._missMainUI["num5"],uint(this._miss / 10));
         this.setNum(this._missMainUI["num6"],uint(this._miss % 10));
         this.setNum(this._missMainUI["num7"],uint(this.MISS_TOTAL / 10));
         this.setNum(this._missMainUI["num8"],uint(this.MISS_TOTAL % 10));
      }
      
      private function setNum(param1:MovieClip, param2:uint) : void
      {
         param1.gotoAndStop(param2 + 1);
      }
      
      private function playSound(param1:String) : void
      {
         if(SoundManager.isMusicEnable)
         {
            SoundCache.load(ClientConfig.getSoundOther(param1),this.onSoundComplete,null);
         }
      }
      
      private function onSoundComplete(param1:SoundInfo) : void
      {
         SoundManager.playSound(param1.url,0,false,0.6);
      }
      
      override public function destroy() : void
      {
         var _loc1_:MovieClip = null;
         while(this._plantArr.length > 0)
         {
            _loc1_ = this._plantArr.pop();
            _loc1_.removeEventListener(MouseEvent.CLICK,this.onPlantClick);
         }
         SocketConnection.removeCmdListener(CommandID.DAILY_ACTIVITY,this.onGetAward);
         this._pageMC.removeEventListener("page_over",this.onPageOver);
         this._pageMC.removeEventListener("page_out",this.onPageOut);
         this.removeMapListener();
         super.destroy();
         this._pageMC = null;
         this._wordsMC = null;
         this._scoreMainUI = null;
         this._missMainUI = null;
         this._plantArr = null;
         FightGo.instance.enabledShow = true;
         FightMonsterClear.instance.enabledShow = true;
      }
   }
}

