package com.gfp.app.miniMap
{
   import com.gfp.app.time.TimerComponents;
   import com.gfp.core.cache.ShareObjectByteCache;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.XMLEvent;
   import com.gfp.core.info.MapInfo;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.map.MapType;
   import com.gfp.core.net.XMLLoader;
   import flash.display.Sprite;
   import flash.text.TextField;
   import org.taomee.utils.DisplayUtil;
   
   public class MiniMap extends Sprite
   {
      
      private static var _instance:MiniMap;
      
      private var _blockCon:BlockContainer;
      
      private var _mainUI:Sprite;
      
      private var _title:TextField;
      
      private var _xmlloader:XMLLoader;
      
      private var _stageID:uint;
      
      private var _difficulty:String;
      
      public function MiniMap()
      {
         super();
         this._mainUI = UIManager.getSprite("ToolBar_MiniMap_Panel");
         this._mainUI.cacheAsBitmap = true;
         addChild(this._mainUI);
         this._title = this._mainUI["titleTxt"];
         this._blockCon = new BlockContainer();
         this._blockCon.y = 22;
         this._blockCon.x = 20;
         addChild(this._blockCon);
         this._xmlloader = new XMLLoader();
      }
      
      public static function get instance() : MiniMap
      {
         if(_instance == null)
         {
            _instance = new MiniMap();
         }
         return _instance;
      }
      
      public static function destroy() : void
      {
         if(_instance)
         {
            _instance.destroy();
            _instance = null;
         }
      }
      
      public function init(param1:uint) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         this._stageID = param1;
         if(this._stageID > 0)
         {
            _loc2_ = ClientConfig.getStageConfig(this._stageID);
            _loc3_ = ShareObjectByteCache.getCatchString(_loc2_);
            if(_loc3_ != null && _loc3_ != "")
            {
               this.xmlParseComplete(new XML(_loc3_));
            }
            else
            {
               this._xmlloader.addEventListener(XMLEvent.COMPLETE,this.onXMLComplete);
               this._xmlloader.load(_loc2_);
            }
         }
         TimerComponents.instance.start(this._stageID);
      }
      
      public function show() : void
      {
         LayerManager.toolsLevel.addChildAt(this,0);
         TimerComponents.instance.show();
         this.layout();
         if(MainManager.actorInfo.mapType == MapType.PVP)
         {
            this.visible = false;
         }
         StageResizeController.instance.register(this.layout);
      }
      
      private function layout() : void
      {
         this.x = LayerManager.stageWidth - this.width - 13;
         this.y = LayerManager.stageHeight - this.height - 35;
      }
      
      public function hide() : void
      {
         DisplayUtil.removeForParent(this,false);
      }
      
      public function destroy() : void
      {
         this.hide();
         if(this._xmlloader)
         {
            this._xmlloader.removeEventListener(XMLEvent.COMPLETE,this.onXMLComplete);
            this._xmlloader = null;
         }
         this._blockCon.destroy();
         this._blockCon = null;
         this._mainUI.cacheAsBitmap = false;
         this._mainUI = null;
         this._title = null;
         TimerComponents.instance.destroy();
         StageResizeController.instance.unregister(this.layout);
      }
      
      public function changeMap(param1:MapInfo) : void
      {
         this._blockCon.changeMap(param1.id);
         if(param1.name != "" && param1.name != null)
         {
            this._title.text = param1.name;
         }
      }
      
      public function changeTitle(param1:String) : void
      {
         if(this._title)
         {
            this._title.text = param1;
         }
      }
      
      public function teammateChangeMap(param1:uint) : void
      {
         this._blockCon.teammateChangeMap(param1);
      }
      
      public function reset() : void
      {
         this._blockCon.reset();
         TimerComponents.instance.reset();
      }
      
      private function onXMLComplete(param1:XMLEvent) : void
      {
         this._xmlloader.removeEventListener(XMLEvent.COMPLETE,this.onXMLComplete);
         var _loc2_:XML = param1.data;
         var _loc3_:String = ClientConfig.getStageConfig(this._stageID);
         ShareObjectByteCache.refreshSoCache(_loc3_,_loc2_.toString());
         this.xmlParseComplete(_loc2_);
      }
      
      private function xmlParseComplete(param1:XML) : void
      {
         var _loc2_:String = String(param1.@name);
         if(Boolean(_loc2_) && _loc2_.length > 0)
         {
            this._title.text = _loc2_;
         }
         this._difficulty = String(param1.@difficulty);
         this._blockCon.init(param1);
      }
   }
}

