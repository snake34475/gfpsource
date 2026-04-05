package com.gfp.app.emotion
{
   import com.gfp.core.events.DataEvent;
   import com.gfp.core.manager.FocusManager;
   import com.gfp.core.manager.UIManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.taomee.manager.PopUpManager;
   import org.taomee.utils.DisplayUtil;
   
   public class EmotionPanel extends Sprite
   {
      
      private static var _instance:EmotionPanel;
      
      private const ITEM_WIDTH:uint = 45;
      
      private const ITEM_HEIGHT:uint = 45;
      
      private var _panel:Sprite;
      
      public function EmotionPanel()
      {
         var _loc2_:EmotionListItem = null;
         super();
         this._panel = UIManager.getSprite("Panel_Background_4");
         this._panel.mouseChildren = false;
         this._panel.mouseEnabled = false;
         this._panel.cacheAsBitmap = true;
         this._panel.width = 214;
         this._panel.height = 314;
         this._panel.alpha = 0.8;
         addChild(this._panel);
         var _loc1_:int = 0;
         while(_loc1_ < 24)
         {
            _loc2_ = new EmotionListItem(_loc1_);
            _loc2_.x = 8 + (this.ITEM_WIDTH + 5) * int(_loc1_ % 4);
            _loc2_.y = 8 + (this.ITEM_HEIGHT + 5) * int(_loc1_ / 4);
            addChild(_loc2_);
            _loc2_.addEventListener(MouseEvent.CLICK,this.onItemClick);
            _loc1_++;
         }
      }
      
      public static function get instance() : EmotionPanel
      {
         if(_instance == null)
         {
            _instance = new EmotionPanel();
         }
         return _instance;
      }
      
      public static function turn(param1:DisplayObject) : void
      {
         if(DisplayUtil.hasParent(instance))
         {
            instance.hide();
         }
         else
         {
            instance.show(param1);
         }
      }
      
      public static function addEventListener(param1:String, param2:Function) : void
      {
         instance.addEventListener(param1,param2);
      }
      
      public static function removeEventListener(param1:String, param2:Function) : void
      {
         instance.removeEventListener(param1,param2);
      }
      
      public function show(param1:DisplayObject) : void
      {
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveStage);
         PopUpManager.showForDisplayObject(this,param1,PopUpManager.TOP_LEFT,true,new Point((width + param1.width) / 2,0));
      }
      
      public function hide() : void
      {
         DisplayUtil.removeForParent(this);
      }
      
      private function onRemoveStage(param1:Event) : void
      {
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveStage);
         FocusManager.setDefaultFocus();
      }
      
      private function onItemClick(param1:MouseEvent) : void
      {
         var _loc2_:EmotionListItem = param1.currentTarget as EmotionListItem;
         dispatchEvent(new DataEvent(DataEvent.DATA_UPDATE,_loc2_.id));
         this.hide();
      }
   }
}

