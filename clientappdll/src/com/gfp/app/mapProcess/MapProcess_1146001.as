package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.ui.compoment.McNumber;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   import flash.display.MovieClip;
   import flash.events.Event;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1146001 extends BaseMapProcess
   {
      
      private var _swapID:int = 12945;
      
      protected var ui:MovieClip;
      
      protected var tips:MovieClip;
      
      private var jingHuaMc:McNumber;
      
      public function MapProcess_1146001()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this.ui = _mapModel.libManager.getMovieClip("damage");
         this.tips = _mapModel.libManager.getMovieClip("tips");
         this.jingHuaMc = new McNumber(this.ui);
         this.jingHuaMc.setValue(0);
         StageResizeController.instance.register(this.resizePos);
         this.resizePos();
         LayerManager.topLevel.addChild(this.ui);
         LayerManager.topLevel.addChild(this.tips);
         FightManager.instance.addEventListener(FightEvent.REASON,this.reasonHandle);
         FightManager.instance.addEventListener(FightEvent.WINNER,this.reasonHandle);
         UserManager.addEventListener(UserEvent.HP_CHANGE,this.onDie);
      }
      
      private function resizePos() : void
      {
         this.tips.x = 100 + 500;
         this.tips.y = 130;
         this.ui.x = 1050;
         this.ui.y = 135;
      }
      
      private function onDie(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         if(_loc2_.info.roleType == 15292)
         {
            this.jingHuaMc.setValue(100000000 - _loc2_.info.hp);
         }
      }
      
      override public function destroy() : void
      {
         StageResizeController.instance.unregister(this.resizePos);
         FightManager.instance.removeEventListener(FightEvent.REASON,this.reasonHandle);
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.reasonHandle);
         UserManager.removeEventListener(UserEvent.DIE,this.onDie);
         DisplayUtil.removeForParent(this.ui);
         DisplayUtil.removeForParent(this.tips);
         super.destroy();
      }
      
      private function reasonHandle(param1:Event) : void
      {
         FightManager.instance.removeEventListener(FightEvent.REASON,this.reasonHandle);
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.reasonHandle);
         ActivityExchangeTimesManager.addEventListener(this._swapID,this.responseInfo);
         ActivityExchangeTimesManager.getActiviteTimeInfo(this._swapID);
      }
      
      private function responseInfo(param1:Event) : void
      {
         ActivityExchangeTimesManager.removeEventListener(this._swapID,this.responseInfo);
         var _loc2_:int = int(ActivityExchangeTimesManager.getTimes(this._swapID));
         AlertManager.showSimpleAlarm("小侠士，你一共对boss造成" + _loc2_ + "点伤害");
      }
   }
}

