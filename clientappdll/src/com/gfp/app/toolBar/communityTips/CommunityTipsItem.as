package com.gfp.app.toolBar.communityTips
{
   import com.gfp.app.toolBar.CommunityTipsEntry;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.ui.ItemIconTip;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class CommunityTipsItem extends Sprite
   {
      
      public static const EQUIP:int = 1;
      
      public static const ANIMAL:int = 2;
      
      protected var _type:int;
      
      protected var itemID:int;
      
      protected var data:Object;
      
      protected var name_txt:TextField;
      
      protected var nameBg:DisplayObject;
      
      protected var icoMC:MovieClip;
      
      protected var btnMC:MovieClip;
      
      protected var checkMC:MovieClip;
      
      protected var tipsMC:MovieClip;
      
      protected var closeBtn:SimpleButton;
      
      private var _executeWhenDestroy:Function;
      
      public function CommunityTipsItem(param1:int, param2:Function = null)
      {
         this._executeWhenDestroy = param2;
         var _loc3_:UI_CommunityTips = new UI_CommunityTips();
         addChild(_loc3_);
         this.name_txt = _loc3_.name_txt;
         this.nameBg = _loc3_.nameBg;
         this.icoMC = _loc3_.icoMC;
         this.btnMC = _loc3_.btnMC;
         this.checkMC = _loc3_.checkMC;
         this.tipsMC = _loc3_.tipsMC;
         this.closeBtn = _loc3_.closeBtn;
         this.itemID = param1;
         super();
         this.addEvents();
         this.showICO();
         this.name_txt.text = ItemXMLInfo.getName(param1);
         this.layout();
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function initData(param1:Object) : void
      {
         this.data = param1;
      }
      
      protected function showICO() : void
      {
         var _loc1_:ItemIconTip = new ItemIconTip();
         _loc1_.setID(this.itemID);
         this.icoMC.addChild(_loc1_);
      }
      
      protected function addEvents() : void
      {
         addEventListener(Event.REMOVED_FROM_STAGE,this.removed);
         this.btnMC.addEventListener(MouseEvent.CLICK,this.onClick);
         this.closeBtn.addEventListener(MouseEvent.CLICK,this.closeHandler);
         this.checkMC.addEventListener(MouseEvent.CLICK,this.checkHandler);
         this.checkMC.addEventListener(MouseEvent.MOUSE_OVER,this.checkHandler);
         this.checkMC.addEventListener(MouseEvent.MOUSE_OUT,this.checkHandler);
         this.checkMC.buttonMode = true;
         StageResizeController.instance.register(this.layout);
      }
      
      private function layout() : void
      {
         x = LayerManager.stageWidth - 271;
         y = LayerManager.stageHeight - 166;
      }
      
      private function checkHandler(param1:MouseEvent) : void
      {
         if(param1.type == MouseEvent.MOUSE_OVER)
         {
            if(this.checkMC.currentFrame == 3)
            {
               return;
            }
            this.checkMC.gotoAndStop(2);
         }
         else if(param1.type == MouseEvent.MOUSE_OUT)
         {
            if(this.checkMC.currentFrame == 3)
            {
               return;
            }
            this.checkMC.gotoAndStop(1);
         }
         else if(param1.type == MouseEvent.CLICK)
         {
            if(this.checkMC.currentFrame != 3)
            {
               this.checkMC.gotoAndStop(3);
            }
            else
            {
               this.checkMC.gotoAndStop(1);
            }
         }
      }
      
      protected function removeEvents() : void
      {
         removeEventListener(Event.REMOVED_FROM_STAGE,this.removed);
         this.btnMC.removeEventListener(MouseEvent.CLICK,this.onClick);
         this.closeBtn.removeEventListener(MouseEvent.CLICK,this.closeHandler);
         this.checkMC.removeEventListener(MouseEvent.CLICK,this.checkHandler);
         this.checkMC.removeEventListener(MouseEvent.MOUSE_OVER,this.checkHandler);
         this.checkMC.removeEventListener(MouseEvent.MOUSE_OUT,this.checkHandler);
         StageResizeController.instance.unregister(this.layout);
      }
      
      private function closeHandler(param1:MouseEvent) : void
      {
         this.destory();
      }
      
      protected function onClick(param1:MouseEvent) : void
      {
      }
      
      private function removed(param1:Event) : void
      {
         this.destory(true);
      }
      
      public function destory(param1:Boolean = false) : void
      {
         this.removeEvents();
         if(this.checkMC.currentFrame == 3)
         {
            CommunityTipsEntry.instance.uninstall();
         }
         if(!param1 && Boolean(parent))
         {
            parent.removeChild(this);
         }
         if(this._executeWhenDestroy != null)
         {
            if(this._executeWhenDestroy.length == 0)
            {
               this._executeWhenDestroy();
            }
            else if(this._executeWhenDestroy.length == 1)
            {
               this._executeWhenDestroy(this.itemID);
            }
            this._executeWhenDestroy = null;
         }
      }
   }
}

