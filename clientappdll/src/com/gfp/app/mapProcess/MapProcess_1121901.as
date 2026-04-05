package com.gfp.app.mapProcess
{
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   import com.greensock.TweenLite;
   import flash.display.Sprite;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1121901 extends BaseMapProcess
   {
      
      private const BOSS_TYPEs:Vector.<uint> = new <uint>[14608,14609,14610];
      
      public function MapProcess_1121901()
      {
         super();
         this.addListener();
      }
      
      private function addListener() : void
      {
         UserManager.addEventListener(UserEvent.BORN,this.onUserBorn);
      }
      
      private function onUserBorn(param1:UserEvent) : void
      {
         var sp:Sprite = null;
         var event:UserEvent = param1;
         var model:UserModel = event.data as UserModel;
         var index:int = this.BOSS_TYPEs.indexOf(model.info.roleType);
         if(index >= 0 && index <= 2)
         {
            sp = _mapModel.libManager.getSprite("tip" + index);
            sp.x = LayerManager.stageWidth / 2;
            sp.y = LayerManager.stageHeight / 6;
            sp.alpha = 0;
            LayerManager.topLevel.addChild(sp);
            sp.scaleX = 3;
            sp.scaleY = 3;
            TweenLite.to(sp,0.5,{
               "alpha":1,
               "scaleX":1,
               "scaleY":1
            });
            TweenLite.delayedCall(10,function():void
            {
               DisplayUtil.removeForParent(sp);
            });
         }
      }
      
      private function removeListener() : void
      {
         UserManager.removeEventListener(UserEvent.BORN,this.onUserBorn);
      }
      
      override public function destroy() : void
      {
         this.removeListener();
         super.destroy();
      }
   }
}

