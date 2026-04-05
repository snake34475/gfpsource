package com.gfp.app.toolBar.communityTips
{
   import com.gfp.app.systems.UserOperationParser;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.info.ModuleOpenNoticeInfo;
   import com.gfp.core.manager.LayerManager;
   import flash.display.InteractiveObject;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class CommunityOpenNoticeItem extends Sprite
   {
      
      private var _info:ModuleOpenNoticeInfo;
      
      private var goBtn:InteractiveObject;
      
      protected var closeBtn:SimpleButton;
      
      public function CommunityOpenNoticeItem(param1:ModuleOpenNoticeInfo)
      {
         super();
         this._info = param1;
         var _loc2_:UI_CommunityOpenNoticeItem = new UI_CommunityOpenNoticeItem();
         addChild(_loc2_);
         _loc2_["name_txt"].text = param1.alert;
         this.goBtn = _loc2_.goBtn;
         this.closeBtn = _loc2_.closeBtn;
         this.addEvents();
         this.layout();
      }
      
      protected function onClick(param1:MouseEvent) : void
      {
         UserOperationParser.parse(this._info.action);
      }
      
      protected function addEvents() : void
      {
         addEventListener(Event.REMOVED_FROM_STAGE,this.removed);
         this.goBtn.addEventListener(MouseEvent.CLICK,this.onClick);
         this.closeBtn.addEventListener(MouseEvent.CLICK,this.closeHandler);
         StageResizeController.instance.register(this.layout);
      }
      
      protected function removeEvents() : void
      {
         removeEventListener(Event.REMOVED_FROM_STAGE,this.removed);
         this.goBtn.removeEventListener(MouseEvent.CLICK,this.onClick);
         this.closeBtn.removeEventListener(MouseEvent.CLICK,this.closeHandler);
         StageResizeController.instance.unregister(this.layout);
      }
      
      private function layout() : void
      {
         x = LayerManager.stageWidth - 271;
         y = LayerManager.stageHeight - 166;
      }
      
      private function closeHandler(param1:MouseEvent) : void
      {
         this.destory();
      }
      
      private function removed(param1:Event) : void
      {
         this.destory(true);
      }
      
      public function destory(param1:Boolean = false) : void
      {
         this.removeEvents();
         if(!param1 && Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

