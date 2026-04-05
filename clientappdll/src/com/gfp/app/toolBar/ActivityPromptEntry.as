package com.gfp.app.toolBar
{
   import com.gfp.app.manager.ActivityPromptManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.player.MovieClipPlayer;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class ActivityPromptEntry
   {
      
      private static var _instance:ActivityPromptEntry;
      
      private var _mainUI:MovieClipPlayer;
      
      public function ActivityPromptEntry()
      {
         super();
      }
      
      public static function get instance() : ActivityPromptEntry
      {
         if(_instance == null)
         {
            _instance = new ActivityPromptEntry();
         }
         return _instance;
      }
      
      public static function show() : void
      {
         if(_instance)
         {
            _instance.show();
         }
      }
      
      public static function hide() : void
      {
         if(_instance)
         {
            _instance.hide();
         }
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
         this._mainUI = new MovieClipPlayer(new UI_ActivityPromptEntry());
         this._mainUI.buttonMode = true;
         ActivityPromptManager.instance.setup();
         ActivityPromptManager.instance.addEventListener(ActivityPromptManager.ADD_PROMPT,this.onAddPrompt);
         ActivityPromptManager.instance.addEventListener(ActivityPromptManager.REMOVE_PROMPT,this.onRemovePrompt);
      }
      
      private function onAddPrompt(param1:Event) : void
      {
         this._mainUI.play();
         this.show();
      }
      
      private function onRemovePrompt(param1:Event) : void
      {
         this.hide();
      }
      
      public function show() : void
      {
         if(this._mainUI.parent == null)
         {
            this._mainUI.addEventListener(MouseEvent.CLICK,this.onPromptClick);
            LayerManager.toolUiLevel.addChild(this._mainUI);
            DisplayUtil.align(this._mainUI,null,AlignType.BOTTOM_RIGHT,new Point(-100,-100));
         }
      }
      
      private function onPromptClick(param1:MouseEvent) : void
      {
         this._mainUI.stop();
         ModuleManager.turnAppModule("ActivityPromptPanel");
      }
      
      public function hide() : void
      {
         if(this._mainUI.parent)
         {
            DisplayUtil.removeForParent(this._mainUI);
            this._mainUI.removeEventListener(MouseEvent.CLICK,this.onPromptClick);
         }
      }
      
      public function destroy() : void
      {
         this.hide();
         ActivityPromptManager.instance.removeEventListener(ActivityPromptManager.ADD_PROMPT,this.onAddPrompt);
         ActivityPromptManager.instance.removeEventListener(ActivityPromptManager.REMOVE_PROMPT,this.onRemovePrompt);
         ActivityPromptManager.destroy();
         this._mainUI.destory();
         this._mainUI = null;
      }
   }
}

