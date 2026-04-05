package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.ui.UILoader;
   import com.gfp.core.ui.loading.LoadingType;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1095201 extends BaseMapProcess
   {
      
      private var _cartoon:Sprite;
      
      private var _loader:UILoader;
      
      public function MapProcess_1095201()
      {
         super();
      }
      
      override protected function init() : void
      {
         FightManager.isAutoReasonEnd = false;
         FightManager.instance.addEventListener(FightEvent.REASON,this.onReason);
      }
      
      private function onReason(param1:FightEvent) : void
      {
         FightManager.instance.removeEventListener(FightEvent.REASON,this.onReason);
         MainManager.actorModel.execStandAction(false);
         this._loader = new UILoader(ClientConfig.getCartoon("tollgate_fail_952"),LayerManager.topLevel,LoadingType.TITLE_AND_PERCENT,"正在加载任务动画...");
         this._loader.addEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this._loader.load();
      }
      
      private function onLoadComplete(param1:UILoadEvent) : void
      {
         MainManager.closeOperate();
         this._loader.removeEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this._cartoon = param1.uiloader.loader.content as Sprite;
         this._cartoon["btn"].addEventListener(MouseEvent.CLICK,this.onClicked);
         LayerManager.topLevel.addChild(this._cartoon);
      }
      
      private function onClicked(param1:Event) : void
      {
         this._cartoon["btn"].removeEventListener(MouseEvent.CLICK,this.onClicked);
         DisplayUtil.removeForParent(this._cartoon);
         PveEntry.onReason();
      }
      
      override public function destroy() : void
      {
         this._cartoon = null;
         this._loader = null;
         super.destroy();
         FightManager.instance.removeEventListener(FightEvent.REASON,this.onReason);
      }
   }
}

