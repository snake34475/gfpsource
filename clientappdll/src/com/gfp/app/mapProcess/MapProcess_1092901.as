package com.gfp.app.mapProcess
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.cartoon.event.AnimatEvent;
   import com.gfp.app.fight.FightGo;
   import com.gfp.app.fight.FightMonsterClear;
   import com.gfp.app.miniMap.MiniMap;
   import com.gfp.app.time.TimerComponents;
   import com.gfp.core.config.xml.TollgateXMLInfo;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.ui.UILoader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1092901 extends BaseMapProcess
   {
      
      private const FIREND_OGRE_ID:uint = 11315;
      
      private const ENEMY_OGRE_ID:uint = 11314;
      
      private const MISTAKE_SCORE:uint = 0;
      
      private const SCORE_MAX:uint = 30;
      
      private const ANIMAT_HEAD:String = "cutdown_";
      
      private const ANIMAT_ID:uint = 2;
      
      private var _socre:int;
      
      private var _time:uint;
      
      private var _timeID:uint;
      
      private var _scoreUI:Sprite;
      
      private var _scoreText:TextField;
      
      private var _timeText:TextField;
      
      private var _timerComp:TimerComponents;
      
      private var _loader:UILoader;
      
      private var _mainMC:MovieClip;
      
      public function MapProcess_1092901()
      {
         super();
      }
      
      override protected function init() : void
      {
         FightGo.instance.enabledShow = false;
         FightMonsterClear.instance.enabledShow = false;
         MiniMap.instance.hide();
         this._timerComp = TimerComponents.instance;
         this._timerComp.hide();
         this.loadAnimat();
         this.initScoreUI();
         this.addMapListener();
      }
      
      private function loadAnimat() : void
      {
         AnimatPlay.startAnimat(this.ANIMAT_HEAD,this.ANIMAT_ID,true,0,0,false,false,true,2);
      }
      
      private function initScoreUI() : void
      {
         this._scoreUI = UIManager.getSprite("ToolBar_TollgateScoreUI");
         this._timeText = this._scoreUI["time_txt"];
         this._scoreText = this._scoreUI["score_txt"];
         LayerManager.topLevel.addChild(this._scoreUI);
         DisplayUtil.align(this._scoreUI,null,AlignType.TOP_CENTER);
         this._time = TollgateXMLInfo.getTollgateInfoById(929).countDownTime;
         this.updateTime();
         this.updateScore();
      }
      
      private function destroyScoreUI() : void
      {
         DisplayUtil.removeForParent(this._scoreUI);
         this._scoreUI = null;
      }
      
      private function addMapListener() : void
      {
         AnimatPlay.addAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimatEnd);
         UserManager.addEventListener(UserEvent.DIE,this.onUserDied);
      }
      
      private function removeMapListener() : void
      {
         AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimatEnd);
         UserManager.removeEventListener(UserEvent.DIE,this.onUserDied);
      }
      
      private function onAnimatEnd(param1:AnimatEvent) : void
      {
         this._timeID = setInterval(this.timeChange,1000);
      }
      
      private function onUserDied(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         if(_loc2_.info.roleType == this.ENEMY_OGRE_ID)
         {
            ++this._socre;
            if(this._socre == this.SCORE_MAX)
            {
               this.detroyTime();
            }
         }
         else if(_loc2_.info.roleType == this.FIREND_OGRE_ID)
         {
            this._socre -= this.MISTAKE_SCORE;
            this._socre = this._socre < 0 ? 0 : this._socre;
         }
         this.updateScore();
      }
      
      private function timeChange() : void
      {
         --this._time;
         this.updateTime();
         if(this._time == 0)
         {
            this.detroyTime();
         }
      }
      
      private function updateScore() : void
      {
         this._scoreText.text = this._socre + "/" + this.SCORE_MAX;
      }
      
      private function updateTime() : void
      {
         this._timeText.text = this._time.toString();
      }
      
      private function detroyTime() : void
      {
         if(this._timeID != 0)
         {
            clearInterval(this._timeID);
            this._timeID = 0;
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         AnimatPlay.destory();
         this.detroyTime();
         this.removeMapListener();
         this.destroyScoreUI();
         FightGo.instance.enabledShow = true;
         FightMonsterClear.instance.enabledShow = true;
      }
   }
}

