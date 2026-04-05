package com.gfp.app.cityWar
{
   import com.gfp.app.manager.CityWarManager;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   import com.gfp.core.model.MapModel;
   import com.greensock.easing.Back;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.taomee.motion.Tween;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class CityWarOperatePanel
   {
      
      private static var _instance:CityWarOperatePanel;
      
      protected var _mainUI:Sprite;
      
      private var _disBtn:SimpleButton;
      
      private var _quitBtn:SimpleButton;
      
      private var _isOpened:Boolean;
      
      private var _tween:Tween;
      
      public function CityWarOperatePanel()
      {
         super();
      }
      
      public static function get instance() : CityWarOperatePanel
      {
         if(_instance == null)
         {
            _instance = new CityWarOperatePanel();
         }
         return _instance;
      }
      
      public static function destroy() : void
      {
         if(_instance)
         {
            _instance.destroy();
         }
         _instance = null;
      }
      
      public function setup() : void
      {
         this.setMainUI();
         this._disBtn = this._mainUI["disBtn"] as SimpleButton;
         this._quitBtn = this._mainUI["out_btn"] as SimpleButton;
         this._disBtn.addEventListener(MouseEvent.CLICK,this.onOtherFight);
         this._quitBtn.addEventListener(MouseEvent.CLICK,this.onBackHome);
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapComplete);
      }
      
      protected function setMainUI() : void
      {
         this._mainUI = new UI_CityWarOperatePanel();
      }
      
      public function show() : void
      {
         if(Boolean(this._mainUI) && this._mainUI.parent == null)
         {
            LayerManager.topLevel.addChild(this._mainUI);
            DisplayUtil.align(this._mainUI,null,AlignType.TOP_RIGHT,new Point(108,90));
         }
      }
      
      private function onOtherFight(param1:Event) : void
      {
         if(!this._isOpened)
         {
            this.onShow();
         }
         else
         {
            this.onClose();
         }
      }
      
      public function onShow() : void
      {
         this._tween = new Tween(this._mainUI,"x",Back.easeOut,this._mainUI.x,820,600,true);
         this._tween.start();
         this._isOpened = true;
         this._disBtn.rotationX = 180;
      }
      
      public function onClose() : void
      {
         this._tween = new Tween(this._mainUI,"x",Back.easeOut,this._mainUI.x,933.5,600,true);
         this._tween.start();
         this._isOpened = false;
         this._disBtn.rotationX = 360;
      }
      
      protected function onBackHome(param1:Event) : void
      {
         CityWarManager.instance.quit();
      }
      
      protected function onMapComplete(param1:MapEvent) : void
      {
         var _loc2_:MapModel = param1.mapModel;
         if(_loc2_.info.mapType == MapType.STAND)
         {
            this.show();
         }
         else
         {
            this.hide();
         }
      }
      
      public function destroy() : void
      {
         if(this._tween)
         {
            this._tween.stop();
            this._tween = null;
         }
         this.hide();
         this.removeEventList();
         this._mainUI = null;
      }
      
      public function hide() : void
      {
         DisplayUtil.removeForParent(this._mainUI);
      }
      
      private function removeEventList() : void
      {
         this._disBtn.removeEventListener(MouseEvent.CLICK,this.onOtherFight);
         this._quitBtn.removeEventListener(MouseEvent.CLICK,this.onBackHome);
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapComplete);
      }
   }
}

