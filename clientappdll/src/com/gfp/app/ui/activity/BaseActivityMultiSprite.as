package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityMultiNodeInfo;
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.app.toolBar.DynamicActivityEntry;
   import com.gfp.app.toolBar.activityEntry.ActivityCustomProcess;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.UIManager;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.utils.clearTimeout;
   import flash.utils.getDefinitionByName;
   import flash.utils.setTimeout;
   
   public class BaseActivityMultiSprite extends BaseActivitySprite
   {
      
      private var _childContainer:Sprite;
      
      protected var _multiInfo:ActivityMultiNodeInfo;
      
      protected var _children:Vector.<BaseActivitySprite>;
      
      private var _hideTimerID:int;
      
      private var _bgWidth:int;
      
      public function BaseActivityMultiSprite(param1:ActivityMultiNodeInfo)
      {
         this._multiInfo = param1;
         super(param1);
         this.initChildren();
      }
      
      private function initChildren() : void
      {
         var _loc1_:BaseActivitySprite = null;
         var _loc2_:ActivityNodeInfo = null;
         var _loc3_:Class = null;
         this._children = new Vector.<BaseActivitySprite>();
         for each(_loc2_ in this._multiInfo.children)
         {
            if(_loc2_.customClass)
            {
               _loc3_ = getDefinitionByName("com.gfp.app.ui.activity." + _loc2_.customClass) as Class;
               _loc1_ = new _loc3_(_loc2_) as BaseActivitySprite;
            }
            else
            {
               _loc1_ = new BaseActivitySprite(_loc2_);
            }
            _loc1_.addEventListener(SHOW_PROMPT_EFFECT,this.promptEffectChangeHandle);
            _loc1_.addEventListener(HIDE_PROMPT_EFFECT,this.promptEffectChangeHandle);
            UIManager.setButtonAsBitmap(_loc1_);
            this._children.push(_loc1_);
            ActivityCustomProcess.initEntry(_loc2_,_loc1_);
         }
      }
      
      private function promptEffectChangeHandle(param1:Event) : void
      {
         resetPromptEffect();
      }
      
      override public function hasProptEffect() : Boolean
      {
         var _loc1_:BaseActivitySprite = null;
         for each(_loc1_ in this._children)
         {
            if(_loc1_.hasProptEffect())
            {
               return true;
            }
         }
         return super.hasProptEffect();
      }
      
      override public function addEvent() : void
      {
         this.addEventListener(MouseEvent.ROLL_OVER,this.overHandle);
         this.addEventListener(MouseEvent.ROLL_OUT,this.outHandle);
         super.addEvent();
      }
      
      override public function removeEvent() : void
      {
         this.removeEventListener(MouseEvent.ROLL_OVER,this.overHandle);
         this.removeEventListener(MouseEvent.ROLL_OUT,this.outHandle);
         super.removeEvent();
      }
      
      protected function overHandle(param1:MouseEvent) : void
      {
         this.childContainer.visible = true;
         this.parent.setChildIndex(this,this.parent.numChildren - 1);
         this.layout();
         clearTimeout(this._hideTimerID);
         var _loc2_:Sprite = DynamicActivityEntry.getIconAggregateMc()["MultiSprite_Bg"];
         this._childContainer.addChildAt(_loc2_,0);
         _loc2_.x = _loc2_.y = 0;
         _loc2_.width = this._bgWidth;
      }
      
      protected function outHandle(param1:MouseEvent) : void
      {
         this._hideTimerID = setTimeout(this.hideChildPanel,200);
      }
      
      protected function hideChildPanel() : void
      {
         if(this._childContainer)
         {
            this._childContainer.visible = false;
         }
      }
      
      private function onStageMouseDown(param1:Event) : void
      {
         var _loc2_:InteractiveObject = param1.target as InteractiveObject;
         if(Boolean(this.contains(_loc2_)) && Boolean(this._childContainer) && this._childContainer.contains(_loc2_) == false)
         {
            return;
         }
         LayerManager.stage.removeEventListener(MouseEvent.CLICK,this.onStageMouseDown);
         this.hideChildPanel();
      }
      
      protected function get childContainer() : Sprite
      {
         var _loc1_:Sprite = null;
         var _loc2_:int = 0;
         if(this._childContainer == null)
         {
            this._childContainer = new Sprite();
            _loc1_ = DynamicActivityEntry.getIconAggregateMc()["MultiSprite_Bg"];
            this._childContainer.addChild(_loc1_);
            _loc1_.x = _loc1_.y = 0;
            _loc2_ = 0;
            while(_loc2_ < this._children.length)
            {
               this._childContainer.addChild(this._children[_loc2_]);
               _loc2_++;
            }
            this.align();
         }
         return this._childContainer;
      }
      
      protected function layout() : void
      {
         this._childContainer.x = this._multiInfo.width - this._bgWidth >> 1;
         var _loc1_:Rectangle = this._childContainer.getBounds(LayerManager.stage);
         if(_loc1_.right > LayerManager.stageWidth)
         {
            this._childContainer.x -= _loc1_.right - LayerManager.stageWidth;
         }
         if(_loc1_.x < 0)
         {
            this._childContainer.x -= _loc1_.x;
         }
      }
      
      protected function align() : void
      {
         var _loc2_:BaseActivitySprite = null;
         var _loc3_:Sprite = null;
         var _loc1_:int = 5;
         this._bgWidth = _loc1_;
         for each(_loc2_ in this._children)
         {
            if(_loc2_.executeShow())
            {
               _loc2_.x = this._bgWidth + 30;
               _loc2_.y += 60;
               this._bgWidth += _loc1_ + _loc2_.width;
               _loc2_.visible = true;
            }
            else
            {
               _loc2_.visible = false;
            }
         }
         _loc3_ = this._childContainer.getChildByName("MultiSprite_Bg") as Sprite;
         _loc3_.width = this._bgWidth;
         addChild(this._childContainer);
      }
      
      override public function executeShow() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:BaseActivitySprite = null;
         if(super.executeShow())
         {
            if(_info.custom == "" && _info.params == "")
            {
               _loc1_ = 0;
               for each(_loc2_ in this._children)
               {
                  if(_loc2_.executeShow())
                  {
                     _loc1_++;
                     break;
                  }
               }
               if(_loc1_ == 0)
               {
                  return false;
               }
            }
            return true;
         }
         return false;
      }
      
      override protected function doAction() : void
      {
         if(_info.custom == "" && _info.params == "")
         {
            return;
         }
         super.doAction();
      }
      
      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
         if(param1 == false)
         {
            this.hideChildPanel();
         }
      }
      
      override public function destroy() : void
      {
         LayerManager.stage.removeEventListener(MouseEvent.CLICK,this.onStageMouseDown);
         super.destroy();
      }
   }
}

