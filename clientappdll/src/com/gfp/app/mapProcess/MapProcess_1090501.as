package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.fight.FightOgreManager;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.Constant;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.ActorModel;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.utils.SpriteType;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1090501 extends BaseMapProcess
   {
      
      private var _task29Animation2:MovieClip;
      
      private var _task29Animation3:MovieClip;
      
      private var _actorInitPosition:Point;
      
      public function MapProcess_1090501()
      {
         super();
      }
      
      override protected function init() : void
      {
         FightManager.isAutoWinnerEnd = false;
         FightManager.isAutoReasonEnd = false;
         FightManager.outToMapID = 1;
         this.addFightEventListener();
         this.addMapEventListener();
      }
      
      private function addFightEventListener() : void
      {
         FightManager.instance.addEventListener(FightEvent.WINNER,this.onWin);
         FightManager.instance.addEventListener(FightEvent.REASON,this.onReason);
         UserManager.addEventListener(UserEvent.DIE,this.onUserDied);
      }
      
      private function onWin(param1:FightEvent) : void
      {
         MainManager.actorModel.execStandAction(true);
         this.resetActorPosition();
         FightManager.outToMapID = 2;
         MainManager.closeOperate(true);
         FightOgreManager.clearOgre();
         MapManager.currentMap.camera.scroll(0,62);
         this.hideActor();
         this.initTask29Animation3();
      }
      
      private function onReason(param1:FightEvent) : void
      {
         FightManager.outToMapID = 1;
         PveEntry.onReason();
      }
      
      private function onUserDied(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data;
         if(_loc2_.spriteType == SpriteType.OGRE)
         {
            _loc2_.hide();
         }
      }
      
      private function removeFightEventListener() : void
      {
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onWin);
         FightManager.instance.removeEventListener(FightEvent.REASON,this.onReason);
         UserManager.removeEventListener(UserEvent.DIE,this.onUserDied);
      }
      
      private function addMapEventListener() : void
      {
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
      }
      
      private function onMapSwitchComplete(param1:MapEvent) : void
      {
         MainManager.closeOperate(true);
         this.hideActor();
         this.initTask29Animation2();
         MapManager.currentMap.camera.scroll(0,62);
      }
      
      private function hideActor() : void
      {
         SummonManager.setActorSummonVisible(false);
         var _loc1_:ActorModel = MainManager.actorModel;
         _loc1_.visible = false;
         this._actorInitPosition = new Point(_loc1_.x,_loc1_.y);
      }
      
      private function resetActorPosition() : void
      {
         var _loc1_:ActorModel = MainManager.actorModel;
         _loc1_.x = this._actorInitPosition.x;
         _loc1_.y = this._actorInitPosition.y;
      }
      
      private function showActor() : void
      {
         MainManager.actorModel.visible = true;
         SummonManager.setActorSummonVisible(true);
      }
      
      private function initTask29Animation2() : void
      {
         var _loc1_:int = int(MainManager.actorInfo.roleType);
         if(_loc1_ >= Constant.ROLE_TYPE_DARGON)
         {
            _loc1_ = 1;
         }
         this._task29Animation2 = _mapModel.libManager.getMovieClip("task29Animation2_" + _loc1_);
         this._task29Animation2.x = 495;
         this._task29Animation2.y = 350;
         this._task29Animation2.addEventListener(Event.ENTER_FRAME,this.onAnimation2Play);
         LayerManager.topLevel.addChild(this._task29Animation2);
      }
      
      private function onAnimation2Play(param1:Event) : void
      {
         MainManager.closeOperate(true);
         if(this._task29Animation2.currentFrame == this._task29Animation2.totalFrames)
         {
            this._task29Animation2.removeEventListener(Event.ENTER_FRAME,this.onAnimation2Play);
            DisplayUtil.removeForParent(this._task29Animation2);
            this._task29Animation2 = null;
            MainManager.openOperate();
            this.showActor();
         }
      }
      
      private function initTask29Animation3() : void
      {
         var _loc1_:int = int(MainManager.actorInfo.roleType);
         if(_loc1_ >= Constant.ROLE_TYPE_DARGON)
         {
            _loc1_ = 1;
         }
         this._task29Animation3 = _mapModel.libManager.getMovieClip("task29Animation3_" + _loc1_);
         this._task29Animation3.x = 493;
         this._task29Animation3.y = 300;
         this._task29Animation3.addEventListener(Event.ENTER_FRAME,this.onAnimation3Play);
         LayerManager.topLevel.addChild(this._task29Animation3);
         this.hideActor();
      }
      
      private function onAnimation3Play(param1:Event) : void
      {
         if(this._task29Animation3.currentFrame == this._task29Animation3.totalFrames)
         {
            this._task29Animation3.removeEventListener(Event.ENTER_FRAME,this.onAnimation3Play);
            DisplayUtil.removeForParent(this._task29Animation3);
            this._task29Animation3 = null;
            MainManager.openOperate();
            FightManager.quit();
         }
      }
      
      private function removeMapEventListener() : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
      }
      
      override public function destroy() : void
      {
         this.removeMapEventListener();
         this.removeFightEventListener();
         this.showActor();
         super.destroy();
      }
   }
}

