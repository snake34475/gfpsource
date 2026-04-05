package com.gfp.app.mapProcess
{
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.ui.NumExtenalUIPanel;
   
   public class MapProcess_1123301 extends BaseMapProcess
   {
      
      private var _total:Number = 0;
      
      private var _numSprite:NumExtenalUIPanel;
      
      public function MapProcess_1123301()
      {
         super();
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(this._numSprite)
         {
            this._numSprite.destory();
            this._numSprite = null;
         }
         UserManager.removeEventListener(UserEvent.DIE,this.onUserDied);
      }
      
      override protected function init() : void
      {
         super.init();
         this._numSprite = new NumExtenalUIPanel("summon_exp");
         this._numSprite.y = 100;
         this._numSprite.x = LayerManager.stageWidth - 30;
         LayerManager.topLevel.addChild(this._numSprite);
         UserManager.addEventListener(UserEvent.DIE,this.onUserDied);
      }
      
      private function onUserDied(param1:UserEvent) : void
      {
         var _loc3_:Number = NaN;
         var _loc2_:UserModel = param1.data;
         if(_loc2_)
         {
            _loc3_ = 0;
            if(_loc2_.info.roleType == 12402)
            {
               _loc3_ = 3;
            }
            else if(_loc2_.info.roleType == 12403)
            {
               _loc3_ = 6;
            }
            else if(_loc2_.info.roleType == 12404)
            {
               _loc3_ = 8;
            }
            else if(_loc2_.info.roleType == 12405)
            {
               _loc3_ = 10;
            }
            if(_loc3_ != 0)
            {
               this._total += _loc3_;
               this._numSprite.num = this._total;
            }
         }
      }
   }
}

