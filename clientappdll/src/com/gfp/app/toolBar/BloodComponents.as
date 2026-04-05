package com.gfp.app.toolBar
{
   import com.gfp.core.model.UserModel;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Rectangle;
   
   public class BloodComponents
   {
      
      private var _speed:int;
      
      private var _greed:Sprite;
      
      private var _red:Sprite;
      
      private var _alphaColor:Sprite;
      
      private var _dec:int;
      
      private var _decHP:int = 0;
      
      private var _hpWidth:Number;
      
      private var _hpRect:Rectangle;
      
      private var _hpChangeRect:Rectangle;
      
      private var _light:int;
      
      public function BloodComponents(param1:DisplayObjectContainer, param2:int = 2)
      {
         super();
         this._speed = param2;
         this._hpRect = new Rectangle(0,0,0,param1.height);
         this._hpChangeRect = new Rectangle(0,0,0,param1.height);
         this._hpWidth = param1.width;
         this._greed = param1["green"];
         this._red = param1["red"];
         this._alphaColor = param1["alphaColor"];
      }
      
      public function hit(param1:UserModel) : void
      {
         if(param1.getHP() > 0)
         {
            this._dec = param1.getDecHP();
         }
         else if(param1.lastRoundHP != 0)
         {
            this._dec = param1.lastRoundHP;
         }
         else
         {
            this._dec = param1.getTotalHP();
         }
         this.changeRect(param1);
      }
      
      private function changeRect(param1:UserModel) : void
      {
         this._hpChangeRect.width = (param1.getHP() + this._dec) / param1.getTotalHP() * this._hpWidth;
         this._hpRect.width = param1.getHP() / param1.getTotalHP() * this._hpWidth;
         this._greed.scrollRect = this._hpRect;
         this._alphaColor.scrollRect = this._hpChangeRect;
         this._alphaColor.visible = true;
         this._red.scrollRect = this._hpChangeRect;
         this._light = 10;
         param1.lastRoundHP = param1.getHP();
         this._red.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         if(this._hpChangeRect.width > this._hpRect.width)
         {
            if(this._light <= 0)
            {
               this._alphaColor.visible = false;
               this._hpChangeRect.width -= this._speed;
               this._red.scrollRect = this._hpChangeRect;
            }
            else
            {
               this._light -= 2;
            }
         }
         else
         {
            this._red.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
      }
      
      public function closeBlood() : void
      {
         if(this._red)
         {
            this._red.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
         this._greed = null;
         this._red = null;
         this._alphaColor = null;
      }
   }
}

