package com.gfp.app.mapProcess
{
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.controller.FocusKeyController;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.map.BaseMapProcess;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.taomee.manager.ToolTipManager;
   
   public class MapProcess_39 extends BaseMapProcess
   {
      
      private var _fireHit:Sprite;
      
      public function MapProcess_39()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.initMap();
         this.addMapListener();
      }
      
      private function initMap() : void
      {
         this._fireHit = _mapModel.downLevel["clickMC"];
         this._fireHit.buttonMode = true;
         ToolTipManager.add(this._fireHit,"开启关卡");
      }
      
      private function addMapListener() : void
      {
         this._fireHit.addEventListener(MouseEvent.CLICK,this.onHitClick);
         FocusKeyController.addFocusKeyListener(67,this.onKeyConfirm);
      }
      
      private function removeMapListener() : void
      {
         this._fireHit.removeEventListener(MouseEvent.CLICK,this.onHitClick);
         FocusKeyController.removeFocusKeyListener(67,this.onKeyConfirm);
      }
      
      private function onHitClick(param1:Event = null) : void
      {
         ModuleManager.turnModule(ClientConfig.getAppModule("PveAlertPanel"),"正在加载...",943);
      }
      
      private function onKeyConfirm(param1:Event) : void
      {
         if(Point.distance(MainManager.actorModel.pos,new Point(this._fireHit.x,this._fireHit.y)) <= 100)
         {
            this.onHitClick();
         }
      }
      
      override public function destroy() : void
      {
         ToolTipManager.remove(this._fireHit);
         this.removeMapListener();
         this._fireHit = null;
         super.destroy();
      }
   }
}

