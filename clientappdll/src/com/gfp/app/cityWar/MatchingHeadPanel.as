package com.gfp.app.cityWar
{
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.UIManager;
   import com.greensock.TweenLite;
   import com.greensock.easing.Back;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   
   public class MatchingHeadPanel extends Sprite
   {
      
      private var _mainUI:Sprite;
      
      private var _startX:Number;
      
      private const ITEM_GAP:Number = 140;
      
      private var _team:uint;
      
      private var _parent:DisplayObjectContainer;
      
      public function MatchingHeadPanel(param1:UserInfo)
      {
         super();
         this._team = param1.overHeadState;
         if(this._team == 1)
         {
            this._mainUI = UIManager.getSprite("UI_RedMatchingHeadPanel");
            this.x = -150;
         }
         else
         {
            this._mainUI = UIManager.getSprite("UI_BlueMatchingHeadPanel");
            this.x = 1110;
         }
         this._mainUI["title"].text = "Lv." + param1.lv + " " + param1.nick;
         this._mainUI["roleMC"].gotoAndStop(param1.roleType);
         addChild(this._mainUI);
      }
      
      public function show(param1:DisplayObjectContainer) : void
      {
         var _loc2_:Number = NaN;
         this._parent = param1;
         if(this._team == 1)
         {
            _loc2_ = (5 - this._parent.numChildren) * this.ITEM_GAP;
         }
         else
         {
            _loc2_ = this._parent.numChildren * this.ITEM_GAP;
         }
         this._parent.addChild(this);
         TweenLite.to(this,0.5,{
            "x":_loc2_,
            "ease":Back.easeOut
         });
      }
      
      public function updatePos() : void
      {
         var _loc1_:Number = NaN;
         if(this._team == 1)
         {
            _loc1_ = (5 - this._parent.numChildren) * this.ITEM_GAP;
         }
         else
         {
            _loc1_ = this._parent.numChildren * this.ITEM_GAP;
         }
         this.x = _loc1_;
         this._parent.addChild(this);
      }
      
      public function destory() : void
      {
         if(this._parent)
         {
            this._parent.removeChild(this);
         }
         this._parent = null;
         this._mainUI = null;
      }
   }
}

