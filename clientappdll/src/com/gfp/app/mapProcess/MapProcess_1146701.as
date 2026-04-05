package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.ui.compoment.McNumber;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.map.BaseMapProcess;
   import flash.display.MovieClip;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1146701 extends BaseMapProcess
   {
      
      private var jingHua:MovieClip;
      
      private var _currentKillMC:MovieClip;
      
      private var jingHuaMc:McNumber;
      
      private var killCount:int;
      
      private var dd:int;
      
      public function MapProcess_1146701()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this.jingHua = _mapModel.libManager.getMovieClip("firstBlood");
         this._currentKillMC = this.jingHua["currentKill"];
         this.jingHuaMc = new McNumber(this._currentKillMC);
         this.dd = ActivityExchangeTimesManager.getTimes(13148);
         this.killCount = this.dd;
         this.jingHuaMc.setValue(this.killCount);
         FightManager.instance.addEventListener(FightEvent.OGRE_DIE,this.onModelDied);
         StageResizeController.instance.register(this.resizePos);
         this.resizePos();
         LayerManager.topLevel.addChild(this.jingHua);
      }
      
      private function resizePos() : void
      {
         this.jingHua.x = LayerManager.stageWidth / 2 + 290;
         this.jingHua.y = LayerManager.stageHeight / 2 - 160;
      }
      
      private function onModelDied(param1:FightEvent) : void
      {
         var _loc2_:UserInfo = param1.data as UserInfo;
         ++this.killCount;
         if(this.killCount > 1000)
         {
            this.killCount = 1000;
         }
         this.jingHuaMc.setValue(this.killCount);
      }
      
      override public function destroy() : void
      {
         FightManager.instance.removeEventListener(FightEvent.OGRE_DIE,this.onModelDied);
         StageResizeController.instance.unregister(this.resizePos);
         DisplayUtil.removeForParent(this.jingHua);
         super.destroy();
      }
   }
}

