package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.map.BaseMapProcess;
   import flash.display.MovieClip;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1119301 extends BaseMapProcess
   {
      
      private var _killNum:int;
      
      private var _txtInfoMc:MovieClip;
      
      public function MapProcess_1119301()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._txtInfoMc = _mapModel.libManager.getMovieClip("UI_TxtInfo");
         FightManager.instance.addEventListener(FightEvent.OGRE_DIE,this.onModelDied);
         StageResizeController.instance.register(this.resizePos);
         this.resizePos();
      }
      
      private function resizePos() : void
      {
         this._txtInfoMc.x = LayerManager.stageWidth - this._txtInfoMc.width >> 1;
         this._txtInfoMc.y = 165;
         LayerManager.topLevel.addChild(this._txtInfoMc);
      }
      
      private function onModelDied(param1:FightEvent) : void
      {
         if(param1.data.roleType == 14558)
         {
            ++this._killNum;
            this._txtInfoMc.monsterTxt.text = this._killNum.toString();
         }
      }
      
      override public function destroy() : void
      {
         DisplayUtil.removeForParent(this._txtInfoMc);
         this._txtInfoMc = null;
         FightManager.instance.removeEventListener(FightEvent.OGRE_DIE,this.onModelDied);
         StageResizeController.instance.unregister(this.resizePos);
         super.destroy();
      }
   }
}

