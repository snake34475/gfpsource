package com.gfp.app.toolBar
{
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.manager.UIManager;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.DisplayUtil;
   
   public class HonorPanelEntry
   {
      
      private static var _instance:HonorPanelEntry;
      
      private var _mainUI:SimpleButton;
      
      public function HonorPanelEntry()
      {
         super();
      }
      
      public static function get instance() : HonorPanelEntry
      {
         if(_instance == null)
         {
            _instance = new HonorPanelEntry();
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
      
      public function show() : void
      {
      }
      
      private function showIcon() : void
      {
         if(this._mainUI == null)
         {
            this._mainUI = UIManager.getButton("ToolBar_Honor");
            ToolTipManager.add(this._mainUI,AppLanguageDefine.GET_AWARD_COLLECTION[11]);
         }
      }
      
      private function onEnterTradeMap(param1:MapEvent) : void
      {
         this._mainUI.visible = false;
      }
      
      private function onLeaveTradeMap(param1:MapEvent) : void
      {
         this._mainUI.visible = true;
      }
      
      private function onOpenClick(param1:MouseEvent) : void
      {
         if(TasksManager.isProcess(1323,0))
         {
            ModuleManager.turnModule(ClientConfig.getAppModule("HonorDescibePanel"),AppLanguageDefine.LOAD_MATTER_COLLECTION[35]);
            return;
         }
      }
      
      public function destroy() : void
      {
         if(this._mainUI)
         {
            this._mainUI.removeEventListener(MouseEvent.CLICK,this.onOpenClick);
            DisplayUtil.removeForParent(this._mainUI);
         }
      }
      
      public function hide() : void
      {
         if(this._mainUI)
         {
            DisplayUtil.removeForParent(this._mainUI);
         }
      }
   }
}

