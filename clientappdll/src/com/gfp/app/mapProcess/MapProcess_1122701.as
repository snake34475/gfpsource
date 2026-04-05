package com.gfp.app.mapProcess
{
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.ui.ExtenalUIPanel;
   import com.gfp.core.utils.SpriteType;
   import com.greensock.TweenLite;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class MapProcess_1122701 extends BaseMapProcess
   {
      
      private const BIG_TUZI_ID:int = 12401;
      
      private var _tips:ExtenalUIPanel;
      
      private var _timer1:uint;
      
      public function MapProcess_1122701()
      {
         super();
      }
      
      override public function destroy() : void
      {
         super.destroy();
         UserManager.removeEventListener(UserEvent.BORN,this.onUserBorn);
         this.clearTip();
      }
      
      override protected function init() : void
      {
         super.init();
         UserManager.addEventListener(UserEvent.BORN,this.onUserBorn);
      }
      
      private function onUserBorn(param1:UserEvent) : void
      {
         var e:UserEvent = param1;
         var model:UserModel = e.data;
         if(Boolean(model) && Boolean(model.spriteType == SpriteType.OGRE) && Boolean(model.info))
         {
            if(this.BIG_TUZI_ID == model.info.roleType)
            {
               this.clearTip();
               this._tips = new ExtenalUIPanel("tuzi_deng_tip");
               this._tips.x = LayerManager.stageWidth / 2;
               this._tips.y = LayerManager.stageHeight / 2 - 50;
               LayerManager.topLevel.addChild(this._tips);
               this._timer1 = setTimeout(function():void
               {
                  clearTimeout(_timer1);
                  TweenLite.to(_tips,1,{
                     "alpha":0,
                     "onComplete":function():void
                     {
                        clearTip();
                     }
                  });
               },3000);
            }
         }
      }
      
      private function clearTip() : void
      {
         TweenLite.killTweensOf(this._tips);
         if(this._tips)
         {
            this._tips.destory();
         }
         clearTimeout(this._timer1);
      }
   }
}

