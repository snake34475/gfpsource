package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.LeftTimeFeather;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1108201 extends BaseMapProcess
   {
      
      private var _totalTime:int = 180000;
      
      private var _mapTimer:LeftTimeFeather;
      
      private var _timerCartoon:uint;
      
      private var _totalTimeCartoon:int = 3000;
      
      private const MONSTER_ID:Array = [12188,12189,12190,12194,12195,12196];
      
      private var _killLongNum:int;
      
      private var _subKillUI:MovieClip;
      
      private var _subMissionUI:MovieClip;
      
      public function MapProcess_1108201()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._mapTimer = new LeftTimeFeather(this._totalTime);
         this._subMissionUI = _mapModel.libManager.getMovieClip("longling_tip");
         this._subMissionUI.x = LayerManager.stageWidth * 0.3;
         this._subMissionUI.y = LayerManager.stageHeight * 0.4;
         this._subKillUI = _mapModel.libManager.getMovieClip("longling_tag");
         this._subKillUI.x = LayerManager.stageWidth * 0.75;
         this._subKillUI.y = LayerManager.stageHeight * 0.65;
         this.updateView();
         LayerManager.topLevel.addChildAt(this._subKillUI,0);
         LayerManager.topLevel.addChildAt(this._subMissionUI,0);
         this._timerCartoon = setTimeout(this.hideTip,this._totalTimeCartoon);
         UserManager.addEventListener(UserEvent.DIE,this.onDie);
      }
      
      private function hideTip() : void
      {
         clearTimeout(this._timerCartoon);
         TweenLite.to(this._subMissionUI,1,{
            "alpha":0,
            "onComplete":this.tweenComplete
         });
      }
      
      private function tweenComplete() : void
      {
         DisplayUtil.removeForParent(this._subMissionUI);
      }
      
      private function onDie(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         if(_loc2_.info == null || _loc2_.info.roleType == MainManager.actorInfo.roleType)
         {
            return;
         }
         if(this.MONSTER_ID.indexOf(_loc2_.info.roleType) != -1)
         {
            ++this._killLongNum;
         }
         this.updateView();
      }
      
      private function updateView() : void
      {
         this.setKill();
      }
      
      private function setKill() : void
      {
         this._subKillUI["num0"].gotoAndStop(int(this._killLongNum * 0.001) % 10 + 1);
         this._subKillUI["num1"].gotoAndStop(int(this._killLongNum * 0.01) % 10 + 1);
         this._subKillUI["num2"].gotoAndStop(int(this._killLongNum * 0.1) % 10 + 1);
         this._subKillUI["num3"].gotoAndStop(int(this._killLongNum * 1) % 10 + 1);
      }
      
      override public function destroy() : void
      {
         if(this._subKillUI.parent)
         {
            DisplayUtil.removeForParent(this._subKillUI);
         }
         if(this._subMissionUI.parent)
         {
            DisplayUtil.removeForParent(this._subMissionUI);
         }
         UserManager.removeEventListener(UserEvent.DIE,this.onDie);
         if(this._mapTimer)
         {
            this._mapTimer.destroy();
         }
         clearTimeout(this._timerCartoon);
         super.destroy();
      }
   }
}

