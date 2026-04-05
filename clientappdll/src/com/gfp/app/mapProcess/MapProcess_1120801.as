package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.LeftTimeTxtFeater;
   import com.gfp.app.fight.FightGo;
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.fight.FightMonsterClear;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.map.BaseMapProcess;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1120801 extends BaseMapProcess
   {
      
      private var _killNum:int;
      
      private var _txtInfoMc:MovieClip;
      
      private var _feather:LeftTimeTxtFeater;
      
      public function MapProcess_1120801()
      {
         super();
      }
      
      override protected function init() : void
      {
         FightGo.instance.enabledShow = false;
         FightMonsterClear.instance.enabledShow = false;
         this._txtInfoMc = _mapModel.libManager.getMovieClip("UI_TxtInfo");
         FightManager.instance.addEventListener(FightEvent.OGRE_DIE,this.onModelDied);
         this._feather = new LeftTimeTxtFeater(1 * 90 * 1000,this._txtInfoMc["timeTxt"] as TextField,null);
         this._feather.start();
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
         if(param1.data.roleType == 12379)
         {
            ++this._killNum;
            this._txtInfoMc.monsterTxt.text = this._killNum.toString();
         }
      }
      
      override public function destroy() : void
      {
         if(this._feather)
         {
            this._feather.destroy();
            this._feather = null;
         }
         DisplayUtil.removeForParent(this._txtInfoMc);
         this._txtInfoMc = null;
         FightManager.instance.removeEventListener(FightEvent.OGRE_DIE,this.onModelDied);
         StageResizeController.instance.unregister(this.resizePos);
         FightGo.instance.enabledShow = true;
         FightMonsterClear.instance.enabledShow = true;
         super.destroy();
      }
   }
}

