package com.gfp.app.toolBar
{
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.controller.ToolBarQuickKey;
   import com.gfp.core.info.AlignInfo;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.SOManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.SharedObject;
   
   public class MallEntry extends GFFitStageItem
   {
      
      private static var _instance:MallEntry;
      
      private var _mainUI:MovieClip;
      
      private var _actMc:MovieClip;
      
      public function MallEntry()
      {
         super();
         this._mainUI = UIManager.getGlobalUi("UI_SWF_BottomBar")["mallEntry"];
         this._actMc = UIManager.getGlobalUi("UI_SWF_BottomBar")["sumHuFaEffMc"];
         if(this._actMc)
         {
            this._actMc.mouseEnabled = this._actMc.mouseChildren = false;
         }
         this._mainUI.buttonMode = true;
         ItemManager.dispatcher.addEventListener("MALL_STATE",this.updateView);
         if(Boolean(this.getShareBookObj().data["isClickToday"]) || MainManager.actorInfo.lv < 60)
         {
            this._actMc && (this._actMc.visible = false);
         }
         else
         {
            this._actMc && (this._actMc.visible = true);
         }
         this.updateView(null);
      }
      
      public static function get instance() : MallEntry
      {
         if(_instance == null)
         {
            _instance = new MallEntry();
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
      
      protected function updateView(param1:Event) : void
      {
         if(ActivityExchangeTimesManager.getTimes(3515) > 0)
         {
            this._mainUI.gotoAndStop(1);
         }
         else
         {
            this._mainUI.gotoAndStop(2);
         }
      }
      
      override protected function layout() : void
      {
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.hide();
         this._mainUI = null;
      }
      
      override public function show() : void
      {
         super.show();
         ToolBarQuickKey.addTip(this._mainUI,7);
         ToolBarQuickKey.registQuickKey(7,this.onQuickKey);
         this._mainUI.addEventListener(MouseEvent.CLICK,this.onMall);
      }
      
      override public function hide() : void
      {
         super.hide();
      }
      
      private function onQuickKey() : void
      {
         this.onMall(new MouseEvent(MouseEvent.CLICK));
      }
      
      private function getShareBookObj() : SharedObject
      {
         return SOManager.getActorSO("mallactivity_zmd" + "20160218");
      }
      
      private function onMall(param1:MouseEvent) : void
      {
         if(MapManager.currentMap.info.mapType == MapType.TRADE)
         {
            AlertManager.showTradeMapUnavailableAlarm();
            return;
         }
         SOManager.HAVE_SHOPPING_SLOW = true;
         var _loc2_:AlignInfo = new AlignInfo();
         _loc2_.right = 160;
         _loc2_.bottom = 75;
         this.getShareBookObj().data["isClickToday"] = true;
         this.getShareBookObj().flush();
         this._actMc && (this._actMc.visible = false);
         ModuleManager.turnModule(ClientConfig.getAppModule("Mall"),AppLanguageDefine.LOAD_MATTER_COLLECTION[23],{
            "triggerPosition":_loc2_,
            "firstPage":0
         });
         if(Boolean(this._mainUI.con) && Boolean(this._mainUI.con.halfMc))
         {
            this._mainUI.con.halfMc.visible = false;
         }
      }
   }
}

