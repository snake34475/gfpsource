package com.gfp.app.mapProcess
{
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.UserModel;
   import flash.display.MovieClip;
   import flash.events.Event;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1125401 extends BaseMapProcess
   {
      
      private var num:int = 0;
      
      private var tipsMc:MovieClip;
      
      public function MapProcess_1125401()
      {
         super();
         UserManager.addEventListener(UserEvent.DIE,this.onDie);
      }
      
      override protected function init() : void
      {
         super.init();
         this.tipsMc = _mapModel.libManager.getMovieClip("TIPS");
         LayerManager.topLevel.addChild(this.tipsMc);
         this.tipsMc.y = 25;
         this.tipsMc.scaleX = this.tipsMc.scaleY = 0.5;
         this.tipsMc.x = (LayerManager.stageWidth - this.tipsMc.width) / 2;
      }
      
      private function onDie(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         var _loc3_:UserInfo = _loc2_.info;
         if(_loc2_.info.roleType == 14690)
         {
            ++this.num;
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(this.num == 8)
         {
            MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onWin);
         }
         else
         {
            MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onLose);
         }
         DisplayUtil.removeForParent(this.tipsMc);
      }
      
      private function onWin(param1:Event) : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onWin);
         ModuleManager.turnAppModule("HealingGodPanel");
         AlertManager.showSimpleAlarm("小侠士，你成功阻止黑龙苏醒，获得20点信仰祝福。");
      }
      
      private function onLose(param1:Event) : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onLose);
         ModuleManager.turnAppModule("HealingGodPanel");
         AlertManager.showSimpleAlarm("小侠士，你没有阻止黑龙苏醒，获得10点信仰祝福。");
      }
   }
}

