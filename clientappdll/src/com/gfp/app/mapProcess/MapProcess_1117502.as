package com.gfp.app.mapProcess
{
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   import com.greensock.TweenLite;
   import flash.display.Sprite;
   import flash.utils.getTimer;
   
   public class MapProcess_1117502 extends BaseMapProcess
   {
      
      private var _prevTime:int;
      
      public function MapProcess_1117502()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.addItemListener();
      }
      
      private function addItemListener() : void
      {
         UserManager.addEventListener(UserEvent.BORN,this.onUserBorn);
      }
      
      private function removeListener() : void
      {
         UserManager.removeEventListener(UserEvent.BORN,this.onUserBorn);
      }
      
      private function onUserBorn(param1:UserEvent) : void
      {
         var _loc3_:Sprite = null;
         var _loc2_:UserModel = param1.data as UserModel;
         if(_loc2_.info == null)
         {
            return;
         }
         if(_loc2_.info.roleType == 12298)
         {
            if(getTimer() - this._prevTime > 30000)
            {
               this._prevTime = getTimer();
               _loc3_ = _mapModel.libManager.getSprite("Tips1");
               LayerManager.topLevel.addChild(_loc3_);
               _loc3_.x = LayerManager.stageWidth - _loc3_.width >> 1;
               _loc3_.y = 180;
               TweenLite.to(_loc3_,1,{
                  "delay":4,
                  "y":0,
                  "alpha":0,
                  "onComplete":this.completeHandle
               });
            }
         }
      }
      
      private function completeHandle() : void
      {
         var _loc1_:Sprite = null;
         _loc1_ = _mapModel.libManager.getSprite("Tips2");
         LayerManager.topLevel.addChild(_loc1_);
         _loc1_.x = LayerManager.stageWidth - _loc1_.width >> 1;
         _loc1_.y = 180;
         TweenLite.to(_loc1_,1,{
            "delay":4,
            "y":0,
            "alpha":0
         });
      }
      
      override public function destroy() : void
      {
         this.removeListener();
         super.destroy();
      }
   }
}

