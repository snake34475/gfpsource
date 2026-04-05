package com.gfp.app.im.talk
{
   import com.gfp.app.emotion.EmotionListItem;
   import com.gfp.core.events.DataEvent;
   import com.gfp.core.manager.UIManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.taomee.manager.PopUpManager;
   import org.taomee.utils.DisplayUtil;
   
   public class TEmotionPanel extends Sprite
   {
      
      private const ITEM_WIDTH:uint = 45;
      
      private const ITEM_HEIGHT:uint = 45;
      
      private var _panel:Sprite;
      
      private var _userID:uint;
      
      public function TEmotionPanel(param1:uint)
      {
         var _loc3_:EmotionListItem = null;
         super();
         this._userID = param1;
         this._panel = UIManager.getSprite("Panel_Background_4");
         this._panel.mouseChildren = false;
         this._panel.mouseEnabled = false;
         this._panel.cacheAsBitmap = true;
         this._panel.width = 390;
         this._panel.height = 155;
         this._panel.alpha = 0.6;
         addChild(this._panel);
         var _loc2_:int = 0;
         while(_loc2_ < 24)
         {
            _loc3_ = new EmotionListItem(_loc2_);
            _loc3_.x = 6 + (this.ITEM_WIDTH + 2) * int(_loc2_ / 3);
            _loc3_.y = 6 + (this.ITEM_HEIGHT + 2) * int(_loc2_ % 3);
            addChild(_loc3_);
            _loc3_.addEventListener(MouseEvent.CLICK,this.onItemClick);
            _loc2_++;
         }
      }
      
      public function show(param1:DisplayObject) : void
      {
         PopUpManager.showForDisplayObject(this,param1,PopUpManager.TOP_RIGHT,true,new Point(-30,0));
      }
      
      public function hide() : void
      {
         DisplayUtil.removeForParent(this);
      }
      
      private function onItemClick(param1:MouseEvent) : void
      {
         var _loc2_:EmotionListItem = param1.currentTarget as EmotionListItem;
         dispatchEvent(new DataEvent(DataEvent.DATA_UPDATE,_loc2_.id));
         this.hide();
      }
   }
}

