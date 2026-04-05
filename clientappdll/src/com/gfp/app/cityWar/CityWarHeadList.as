package com.gfp.app.cityWar
{
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.greensock.easing.Back;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.motion.Tween;
   import org.taomee.utils.DisplayUtil;
   
   public class CityWarHeadList
   {
      
      private static var _instance:CityWarHeadList;
      
      private var _mainUI:Sprite;
      
      private var _memberHeadCon:Sprite;
      
      private var _showBtn:SimpleButton;
      
      private var _isShown:Boolean = true;
      
      private var _tween:Tween;
      
      public function CityWarHeadList()
      {
         super();
      }
      
      public static function get instance() : CityWarHeadList
      {
         if(_instance == null)
         {
            _instance = new CityWarHeadList();
         }
         return _instance;
      }
      
      public static function removeHeadPanel(param1:uint) : void
      {
         if(_instance)
         {
            _instance.removeHeadPanel(param1);
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
      
      public function setup(param1:Array) : void
      {
         var infos:Array = param1;
         this._mainUI = new Sprite();
         this._memberHeadCon = new Sprite();
         this._mainUI.addChild(this._memberHeadCon);
         infos.forEach(function(param1:UserInfo, param2:int, param3:Array):void
         {
            var _loc4_:CityWarHeadPanel = null;
            if(param1.userID != MainManager.actorID)
            {
               _loc4_ = new CityWarHeadPanel();
               _loc4_.init(param1);
               _loc4_.y = param2 * 50;
               _memberHeadCon.addChild(_loc4_);
            }
         });
         this._showBtn = new UI_SWF_Left_Right_btn();
         this._showBtn.scaleX = this._showBtn.scaleY = 0.75;
         this._showBtn.addEventListener(MouseEvent.CLICK,this.onShowHandler);
         this._showBtn.x = 136;
         this._showBtn.y = 15;
         this._mainUI.addChild(this._showBtn);
         if(infos.length <= 0)
         {
            this._showBtn.visible = false;
         }
         ToolTipManager.add(this._showBtn,"点击关闭快捷栏");
         this._mainUI.y = 105;
         LayerManager.toolsLevel.addChild(this._mainUI);
      }
      
      private function onShowHandler(param1:MouseEvent) : void
      {
         if(this._isShown)
         {
            this.onClose();
         }
         else
         {
            this.onShow();
         }
      }
      
      public function onShow() : void
      {
         this._tween = new Tween(this._mainUI,"x",Back.easeOut,this._mainUI.x,0,600,true);
         this._tween.start();
         this._isShown = true;
         this._showBtn.rotationY = 180;
         ToolTipManager.add(this._showBtn,"点击关闭快捷栏");
      }
      
      public function onClose() : void
      {
         this._tween = new Tween(this._mainUI,"x",Back.easeOut,this._mainUI.x,-125,600,true);
         this._tween.start();
         this._isShown = false;
         this._showBtn.rotationY = 0;
         ToolTipManager.add(this._showBtn,"点击打开快捷栏");
      }
      
      public function removeHeadPanel(param1:uint) : void
      {
         var _loc4_:CityWarHeadPanel = null;
         var _loc5_:int = 0;
         if(this._memberHeadCon == null)
         {
            return;
         }
         var _loc2_:uint = uint(this._memberHeadCon.numChildren);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._memberHeadCon.getChildAt(_loc3_) as CityWarHeadPanel;
            if((Boolean(_loc4_)) && _loc4_.userID == param1)
            {
               this._memberHeadCon.removeChildAt(_loc3_);
               _loc4_.destroy();
               _loc4_ = null;
               if(_loc2_ <= 1)
               {
                  this._showBtn.visible = false;
                  return;
               }
               _loc5_ = _loc3_;
               while(_loc5_ < _loc2_ - 1)
               {
                  _loc4_ = this._memberHeadCon.getChildAt(_loc5_) as CityWarHeadPanel;
                  _loc4_.y -= 50;
                  _loc5_++;
               }
               break;
            }
            _loc3_++;
         }
      }
      
      public function destroy() : void
      {
         var _loc1_:CityWarHeadPanel = null;
         if(this._mainUI)
         {
            DisplayUtil.removeForParent(this._mainUI);
            this._showBtn.removeEventListener(MouseEvent.CLICK,this.onShowHandler);
            ToolTipManager.remove(this._showBtn);
         }
         this._tween = null;
         while(Boolean(this._memberHeadCon) && this._memberHeadCon.numChildren > 0)
         {
            _loc1_ = this._memberHeadCon.getChildAt(0) as CityWarHeadPanel;
            this._memberHeadCon.removeChildAt(0);
            _loc1_.destroy();
            _loc1_ = null;
         }
         this._memberHeadCon = null;
         this._mainUI = null;
      }
   }
}

