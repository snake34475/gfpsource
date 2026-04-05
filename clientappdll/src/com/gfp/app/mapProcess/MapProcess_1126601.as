package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.greensock.TweenLite;
   import flash.display.Sprite;
   import flash.events.Event;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1126601 extends BaseMapProcess
   {
      
      private var _swapID:int = 9544;
      
      public function MapProcess_1126601()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         var _loc1_:Sprite = _mapModel.libManager.getSprite("UI_TIPS");
         LayerManager.topLevel.addChild(_loc1_);
         _loc1_.x = LayerManager.stageWidth - _loc1_.width >> 1;
         _loc1_.y = 250;
         TweenLite.to(_loc1_,2,{
            "delay":3,
            "y":0,
            "onComplete":DisplayUtil.removeForParent,
            "onCompleteParams":[_loc1_]
         });
         FightManager.instance.addEventListener(FightEvent.REASON,this.reasonHandle);
      }
      
      override public function destroy() : void
      {
         FightManager.instance.removeEventListener(FightEvent.REASON,this.reasonHandle);
         super.destroy();
      }
      
      private function reasonHandle(param1:Event) : void
      {
         FightManager.instance.removeEventListener(FightEvent.REASON,this.reasonHandle);
         ActivityExchangeTimesManager.addEventListener(this._swapID,this.responseInfo);
         ActivityExchangeTimesManager.getActiviteTimeInfo(this._swapID);
      }
      
      private function responseInfo(param1:Event) : void
      {
         ActivityExchangeTimesManager.removeEventListener(this._swapID,this.responseInfo);
         var _loc2_:int = int(ActivityExchangeTimesManager.getTimes(this._swapID));
         var _loc3_:int = 1;
         if(_loc2_ > 90)
         {
            _loc3_ = 3;
         }
         else if(_loc2_ > 60)
         {
            _loc3_ = 2;
         }
         AlertManager.showSimpleAlarm("小侠士，你一共坚持了" + _loc2_ + "s，获得了" + _loc3_ + "个战之勋章。");
      }
   }
}

