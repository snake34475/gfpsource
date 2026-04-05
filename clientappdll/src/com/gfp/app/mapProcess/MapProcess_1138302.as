package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.LeftTimeUI;
   import com.gfp.app.miniMap.MiniMap;
   import com.gfp.app.systems.ClientTempState;
   import com.gfp.core.config.xml.TollgateXMLInfo;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.utils.SpriteType;
   import flash.utils.setTimeout;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1138302 extends BaseMapProcess
   {
      
      private var _leftTime:LeftTimeUI;
      
      public function MapProcess_1138302()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._leftTime = new LeftTimeUI(90 * 1000);
         LayerManager.topLevel.addChild(this._leftTime);
         ++ClientTempState.endlessTowerThirdLayer;
         MiniMap.instance.changeTitle(TollgateXMLInfo.getName(1383) + "第" + ClientTempState.endlessTowerThirdLayer + "层");
         SightManager.hide(SpriteType.TELEPORTER);
         StageResizeController.instance.register(this.layout);
         UserManager.addEventListener(UserEvent.DIE,this.onUserDied);
         this.layout();
      }
      
      private function onUserDied(param1:UserEvent) : void
      {
         if(ClientTempState.endlessTowerThirdLayer > 9)
         {
            setTimeout(SightManager.hide,200,SpriteType.TELEPORTER);
         }
      }
      
      private function layout() : void
      {
         this._leftTime.x = LayerManager.stageWidth / 2;
         this._leftTime.y = 150;
      }
      
      override public function destroy() : void
      {
         StageResizeController.instance.unregister(this.layout);
         UserManager.removeEventListener(UserEvent.DIE,this.onUserDied);
         if(this._leftTime)
         {
            this._leftTime.destory();
            DisplayUtil.removeForParent(this._leftTime);
         }
         super.destroy();
      }
   }
}

