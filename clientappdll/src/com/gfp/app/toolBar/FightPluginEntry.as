package com.gfp.app.toolBar
{
   import com.gfp.app.manager.FightPluginManager;
   import com.gfp.app.manager.fightPlugin.AutoTollgateTransManager;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.FocusManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.utils.WebURLUtil;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class FightPluginEntry
   {
      
      private static var _instance:FightPluginEntry;
      
      private var _mainUI:Sprite;
      
      private var _opentCloseBtn:MovieClip;
      
      private var _settingBtn:SimpleButton;
      
      public function FightPluginEntry()
      {
         super();
         this._mainUI = new UI_FightPluginEntry();
         this._opentCloseBtn = this._mainUI["opentCloseBtn"];
         this._opentCloseBtn.buttonMode = true;
         this._settingBtn = this._mainUI["settingBtn"];
      }
      
      public static function get instance() : FightPluginEntry
      {
         if(_instance == null)
         {
            _instance = new FightPluginEntry();
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
      
      public function show() : void
      {
         LayerManager.toolsLevel.addChild(this._mainUI);
         this.layout();
         if(FightPluginManager.instance.isPluginRunning)
         {
            this._opentCloseBtn.gotoAndStop(2);
         }
         else
         {
            this._opentCloseBtn.gotoAndStop(1);
         }
         this.addEvent();
      }
      
      private function layout() : void
      {
         var _loc1_:Number = LayerManager.stageWidth / 960;
         var _loc2_:Number = LayerManager.stageHeight / 560;
         DisplayUtil.align(this._mainUI,null,AlignType.BOTTOM_CENTER,new Point(56 * _loc1_,-82 * _loc2_));
      }
      
      public function hide() : void
      {
         this.removeEvent();
         DisplayUtil.removeForParent(this._mainUI);
      }
      
      private function addEvent() : void
      {
         this._opentCloseBtn.addEventListener(MouseEvent.CLICK,this.onOpenClose);
         this._settingBtn.addEventListener(MouseEvent.CLICK,this.onSetting);
         FightPluginManager.addEventListener(FightPluginManager.PLUGIN_CHANGE,this.onPluginChange);
         FightPluginManager.addEventListener(FightPluginManager.PLUGIN_CANCEL,this.onPluginCancel);
         StageResizeController.instance.register(this.layout);
      }
      
      private function removeEvent() : void
      {
         this._opentCloseBtn.removeEventListener(MouseEvent.CLICK,this.onOpenClose);
         this._settingBtn.removeEventListener(MouseEvent.CLICK,this.onSetting);
         FightPluginManager.removeEventListener(FightPluginManager.PLUGIN_CHANGE,this.onPluginChange);
         FightPluginManager.removeEventListener(FightPluginManager.PLUGIN_CANCEL,this.onPluginCancel);
         StageResizeController.instance.unregister(this.layout);
      }
      
      private function onOpenClose(param1:MouseEvent) : void
      {
         var _loc2_:Boolean = Boolean(MainManager.actorInfo.isVip);
         if(FightPluginManager.instance.isPluginRunning)
         {
            this._opentCloseBtn.gotoAndStop(1);
            FightPluginManager.instance.stop();
            AutoTollgateTransManager.instance.destroy();
         }
         else if(_loc2_)
         {
            this._opentCloseBtn.gotoAndStop(2);
            FightPluginManager.instance.goOn();
            AutoTollgateTransManager.instance.setup();
         }
         else
         {
            AlertManager.showSimpleAlert("<font size = \'25\'>立即开通VIP,  \n享受全自动战斗特权！\n</font><font color=\'#FF0000\'>更有超强VIP福利等你领取！ </font>",this.confirm);
         }
         FocusManager.setDefaultFocus();
      }
      
      private function confirm() : void
      {
         WebURLUtil.intance.navigatePayVip();
      }
      
      private function onPluginChange(param1:Event) : void
      {
         if(FightPluginManager.instance.isPluginRunning)
         {
            this._opentCloseBtn.gotoAndStop(2);
         }
         else
         {
            this._opentCloseBtn.gotoAndStop(1);
         }
      }
      
      private function onPluginCancel(param1:Event) : void
      {
         this.hide();
      }
      
      private function onSetting(param1:MouseEvent) : void
      {
         ModuleManager.turnAppModule("FightPluginSettingPanel");
      }
      
      public function destroy() : void
      {
         this.hide();
         this._mainUI = null;
      }
      
      public function get opentCloseBtn() : MovieClip
      {
         return this._opentCloseBtn;
      }
   }
}

