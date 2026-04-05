package com.gfp.app.toolBar
{
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.UIManager;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.DisplayUtil;
   
   public class AmbassadorEntry
   {
      
      private static var _instance:AmbassadorEntry;
      
      private var _mainUI:SimpleButton;
      
      public function AmbassadorEntry()
      {
         super();
      }
      
      public static function get instance() : AmbassadorEntry
      {
         if(_instance == null)
         {
            _instance = new AmbassadorEntry();
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
            this._mainUI = UIManager.getButton("ToolBar_invite");
            ToolTipManager.add(this._mainUI,AppLanguageDefine.GET_AWARD_COLLECTION[7]);
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
         ModuleManager.turnModule(ClientConfig.getAppModule("AmbassadorTask"),AppLanguageDefine.LOAD_MATTER_COLLECTION[6]);
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

