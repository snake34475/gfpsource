package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.fight.FightOgreManager;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.utils.SpriteType;
   import flash.display.MovieClip;
   import flash.events.Event;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1090301 extends BaseMapProcess
   {
      
      private var _beastToBeautyMC:MovieClip;
      
      public function MapProcess_1090301()
      {
         super();
      }
      
      override protected function init() : void
      {
         FightManager.isAutoWinnerEnd = false;
         FightManager.isAutoReasonEnd = false;
         FightManager.outToMapID = 18;
         FightManager.instance.addEventListener(FightEvent.WINNER,this.onWinner);
         FightManager.instance.addEventListener(FightEvent.REASON,this.onReason);
         UserManager.addEventListener(UserEvent.DIE,this.onUserDied);
      }
      
      private function onUserDied(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data;
         if(_loc2_.spriteType == SpriteType.OGRE)
         {
            if(_loc2_.info.roleType == 13023)
            {
               _loc2_.hide();
            }
         }
      }
      
      private function playBeastToBeauty() : void
      {
         this._beastToBeautyMC = _mapModel.libManager.getMovieClip("beastToBeautyMC");
         this._beastToBeautyMC.addEventListener(Event.ENTER_FRAME,this.onBeastToBeauty);
         this._beastToBeautyMC.x = 431;
         this._beastToBeautyMC.y = 231;
         _mapModel.contentLevel.addChild(this._beastToBeautyMC);
      }
      
      private function onBeastToBeauty(param1:Event) : void
      {
         if(this._beastToBeautyMC.currentFrame == this._beastToBeautyMC.totalFrames)
         {
            this._beastToBeautyMC.removeEventListener(Event.ENTER_FRAME,this.onBeastToBeauty);
            DisplayUtil.removeForParent(this._beastToBeautyMC);
            MainManager.openOperate();
            FightManager.quit();
         }
      }
      
      private function onWinner(param1:FightEvent) : void
      {
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onWinner);
         FightManager.outToMapID = 20;
         MainManager.closeOperate(true);
         FightOgreManager.clearOgre();
         this.playBeastToBeauty();
      }
      
      private function onReason(param1:FightEvent) : void
      {
         FightManager.instance.removeEventListener(FightEvent.REASON,this.onReason);
         FightManager.outToMapID = 18;
         PveEntry.onReason();
      }
      
      override public function destroy() : void
      {
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onWinner);
         FightManager.instance.removeEventListener(FightEvent.REASON,this.onReason);
         UserManager.removeEventListener(UserEvent.DIE,this.onUserDied);
         if(this._beastToBeautyMC)
         {
            this._beastToBeautyMC.removeEventListener(Event.ENTER_FRAME,this.onBeastToBeauty);
            this._beastToBeautyMC = null;
         }
      }
   }
}

