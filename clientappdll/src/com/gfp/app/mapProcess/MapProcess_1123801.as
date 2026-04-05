package com.gfp.app.mapProcess
{
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   import flash.display.Sprite;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1123801 extends BaseMapProcess
   {
      
      private var _pointMC:Sprite;
      
      private var _point:int;
      
      private var _prevPoint:int;
      
      public function MapProcess_1123801()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._pointMC = _mapModel.libManager.getSprite("pointMC");
         LayerManager.topLevel.addChild(this._pointMC);
         StageResizeController.instance.register(this.layout);
         UserManager.addEventListener(UserEvent.DIE,this.onUserDieHandle);
         this._prevPoint = this._point = ActivityExchangeTimesManager.getTimes(8828);
         this.updatePoint();
         this.layout();
      }
      
      override public function destroy() : void
      {
         StageResizeController.instance.unregister(this.layout);
         UserManager.removeEventListener(UserEvent.DIE,this.onUserDieHandle);
         DisplayUtil.removeForParent(this._pointMC);
         var _loc1_:int = this._point - this._prevPoint;
         if(_loc1_ > 0)
         {
            AlertManager.showSimpleAlarm("小侠士，你从该关卡中获得" + _loc1_ + "点竞速积分。");
         }
         else
         {
            AlertManager.showSimpleAlarm("小侠士，你从该关卡中没有获得竞速积分。");
         }
      }
      
      private function onUserDieHandle(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         if(_loc2_.info.roleType == 14662)
         {
            ++this._point;
         }
         else if(_loc2_.info.roleType == 14661)
         {
            this._point -= 2;
            if(this._point < 0)
            {
               this._point = 0;
            }
         }
         this.updatePoint();
      }
      
      private function updatePoint() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 4)
         {
            this._pointMC["num" + _loc1_].gotoAndStop(int(this._point * Math.pow(0.1,_loc1_)) % 10 + 1);
            _loc1_++;
         }
      }
      
      private function layout() : void
      {
         this._pointMC.x = LayerManager.stageWidth - this._pointMC.width >> 1;
         this._pointMC.y = 80;
      }
   }
}

