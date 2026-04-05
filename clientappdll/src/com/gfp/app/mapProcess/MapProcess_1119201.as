package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.LeftTimeTxtFeater;
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.map.BaseMapProcess;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1119201 extends BaseMapProcess
   {
      
      private var _feather:LeftTimeTxtFeater;
      
      private var _killNum:int;
      
      private var _txtInfoMc:MovieClip;
      
      public function MapProcess_1119201()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._txtInfoMc = _mapModel.libManager.getMovieClip("UI_TxtInfo");
         this._feather = new LeftTimeTxtFeater(1 * 60 * 1000,this._txtInfoMc["timeTxt"] as TextField,null);
         this._feather.start();
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
         if(param1.data.roleType >= 14551 && param1.data.roleType <= 14556)
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
         super.destroy();
      }
   }
}

