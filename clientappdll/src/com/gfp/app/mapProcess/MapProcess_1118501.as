package com.gfp.app.mapProcess
{
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   import flash.display.MovieClip;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1118501 extends BaseMapProcess
   {
      
      private static const KILL_COUNT_SWAP_ID:int = 7748;
      
      private const MONSTER_ID:Array = [14519,14520,14521,14522,14523,14524];
      
      private var _killLongNum:int;
      
      private var _subKillUI:MovieClip;
      
      public function MapProcess_1118501()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._subKillUI = _mapModel.libManager.getMovieClip("longling_tag");
         this._subKillUI.x = LayerManager.stageWidth - this._subKillUI.width;
         this._subKillUI.y = 0;
         this._killLongNum = ActivityExchangeTimesManager.getTimes(KILL_COUNT_SWAP_ID);
         this.updateView();
         LayerManager.topLevel.addChildAt(this._subKillUI,0);
         UserManager.addEventListener(UserEvent.DIE,this.onDie);
      }
      
      private function onDie(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         if(_loc2_.info.roleType == MainManager.actorInfo.roleType)
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
         this._subKillUI["num0"].gotoAndStop(int(this._killLongNum * 0.01) % 10 + 1);
         this._subKillUI["num1"].gotoAndStop(int(this._killLongNum * 0.1) % 10 + 1);
         this._subKillUI["num2"].gotoAndStop(int(this._killLongNum * 1) % 10 + 1);
      }
      
      override public function destroy() : void
      {
         if(this._subKillUI.parent)
         {
            DisplayUtil.removeForParent(this._subKillUI);
         }
         super.destroy();
      }
   }
}

