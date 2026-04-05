package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.LeftTimeUI;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.greensock.TweenLite;
   import flash.display.DisplayObject;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1125701 extends BaseMapProcess
   {
      
      protected var _totalSeconds:int;
      
      protected var _successBuffID:int;
      
      protected var _failtBuffID:int;
      
      protected var _leftTime:LeftTimeUI;
      
      private var _endBuffGetted:Boolean;
      
      public function MapProcess_1125701()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.initData();
         UserManager.addEventListener(UserEvent.BUFF,this.buffHandle);
         this.checkShowCount();
         var _loc1_:DisplayObject = _mapModel.libManager.getSprite("UI_Timer_Alert");
         LayerManager.topLevel.addChild(_loc1_);
         _loc1_.x = LayerManager.stageWidth >> 1;
         _loc1_.y = 300;
         TweenLite.to(_loc1_,1,{
            "y":"-300",
            "delay":1,
            "alpha":0,
            "onComplete":DisplayUtil.removeForParent,
            "onCompleteParams":[_loc1_]
         });
      }
      
      protected function initData() : void
      {
         this._totalSeconds = 30;
         this._successBuffID = 3077;
         this._failtBuffID = 3074;
      }
      
      private function checkShowCount() : void
      {
         this._leftTime = new LeftTimeUI(this._totalSeconds * 1000);
         this._leftTime.x = LayerManager.stageWidth / 2;
         this._leftTime.y = 150;
         LayerManager.topLevel.addChild(this._leftTime);
      }
      
      private function buffHandle(param1:UserEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:DisplayObject = null;
         if(!this._endBuffGetted)
         {
            _loc2_ = int(param1.data);
            if(_loc2_ == this._successBuffID)
            {
               _loc3_ = _mapModel.libManager.getSprite("UI_PASSED");
            }
            else if(_loc2_ == this._failtBuffID)
            {
               _loc3_ = _mapModel.libManager.getSprite("UI_NOT_PASSED");
            }
            if(_loc3_)
            {
               this._endBuffGetted = true;
               LayerManager.topLevel.addChild(_loc3_);
               _loc3_.x = LayerManager.stageWidth >> 1;
               _loc3_.y = 300;
               TweenLite.to(_loc3_,1,{
                  "y":"-300",
                  "delay":1,
                  "alpha":0,
                  "onComplete":DisplayUtil.removeForParent,
                  "onCompleteParams":[_loc3_]
               });
            }
         }
      }
      
      override public function destroy() : void
      {
         this._leftTime.destory();
         UserManager.removeEventListener(UserEvent.BUFF,this.buffHandle);
         super.destroy();
      }
   }
}

