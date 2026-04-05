package com.gfp.app.mapProcess
{
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   import flash.display.Sprite;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1117402 extends BaseMapProcess
   {
      
      private var _startTime:int;
      
      public function MapProcess_1117402()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.addItemListener();
         this._startTime = getTimer();
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
         if(_loc2_.info.roleType == 12296)
         {
            if(getTimer() - this._startTime < 3000)
            {
               _loc3_ = _mapModel.libManager.getSprite("DestroyMC");
               _loc3_.x = _loc2_.x;
               _loc3_.y = _loc2_.y - _loc2_.height;
               _mapModel.upLevel.addChild(_loc3_);
               setTimeout(DisplayUtil.removeForParent,5000,_loc3_);
            }
         }
      }
      
      override public function destroy() : void
      {
         this.removeListener();
         super.destroy();
      }
   }
}

