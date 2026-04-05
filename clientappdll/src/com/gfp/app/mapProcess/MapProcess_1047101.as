package com.gfp.app.mapProcess
{
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   
   public class MapProcess_1047101 extends BaseMapProcess
   {
      
      private var _isFail:Boolean = false;
      
      public function MapProcess_1047101()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         UserManager.addEventListener(UserEvent.DIE,this.onDie);
      }
      
      private function onDie(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         if(Boolean(_loc2_ && _loc2_.info) && Boolean(_loc2_.info.roleType == MainManager.actorInfo.roleType) && _loc2_.info.userID == MainManager.actorInfo.userID)
         {
            this._isFail = true;
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         UserManager.removeEventListener(UserEvent.DIE,this.onDie);
      }
   }
}

