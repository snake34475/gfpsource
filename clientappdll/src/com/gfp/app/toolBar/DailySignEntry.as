package com.gfp.app.toolBar
{
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.utils.RoleDisplayUtil;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class DailySignEntry
   {
      
      private static var _instance:DailySignEntry;
      
      private var _mainUI:SimpleButton;
      
      public function DailySignEntry()
      {
         super();
         this._mainUI = UIManager.getButton("ToolBar_Sign");
         this._mainUI.scaleX = this._mainUI.scaleY = 0.9;
         ToolTipManager.add(this._mainUI,AppLanguageDefine.GET_AWARD_COLLECTION[13]);
      }
      
      public static function get instance() : DailySignEntry
      {
         if(_instance == null)
         {
            _instance = new DailySignEntry();
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
      
      public function destroy() : void
      {
         this.hide();
         this._mainUI = null;
      }
      
      public function show() : void
      {
         if(!RoleDisplayUtil.isRoleGraduate())
         {
            return;
         }
         LayerManager.toolsLevel.addChild(this._mainUI);
         DisplayUtil.align(this._mainUI,null,AlignType.TOP_RIGHT);
         this._mainUI.x -= 142;
         this._mainUI.y += 8;
         this._mainUI.addEventListener(MouseEvent.CLICK,this.turnDailySignModule);
         MapManager.addEventListener(MapEvent.USER_ENTER_TRADE_MAP,this.onEnterTradeMap);
         MapManager.addEventListener(MapEvent.USER_LEAVE_TRADE_MAP,this.onLeaveTradeMap);
      }
      
      public function hide() : void
      {
         if(this._mainUI)
         {
            this._mainUI.removeEventListener(MouseEvent.CLICK,this.turnDailySignModule);
            DisplayUtil.removeForParent(this._mainUI,false);
         }
         MapManager.removeEventListener(MapEvent.USER_ENTER_TRADE_MAP,this.onEnterTradeMap);
         MapManager.removeEventListener(MapEvent.USER_LEAVE_TRADE_MAP,this.onLeaveTradeMap);
      }
      
      private function onEnterTradeMap(param1:MapEvent) : void
      {
         this._mainUI.visible = false;
      }
      
      private function onLeaveTradeMap(param1:MapEvent) : void
      {
         this._mainUI.visible = true;
      }
      
      private function onQuickKey() : void
      {
         this.turnDailySignModule(new MouseEvent(MouseEvent.CLICK));
      }
      
      private function turnDailySignModule(param1:MouseEvent) : void
      {
         ModuleManager.turnModule(ClientConfig.getAppModule("DailySignPanel"),"正在加载....");
      }
   }
}

