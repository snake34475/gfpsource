package com.gfp.app.cityWar
{
   import com.gfp.core.ui.FightBloodBar;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class TowerBloodBar extends FightBloodBar
   {
      
      private var _mainUI:Sprite;
      
      public function TowerBloodBar(param1:uint = 1)
      {
         super();
         mouseChildren = false;
         mouseEnabled = false;
         cacheAsBitmap = true;
         this._mainUI = new UI_TowerBloodBar();
         addChild(this._mainUI);
         _mask = new Sprite();
         this._mainUI.addChild(_mask);
         _blood = this._mainUI["mc_blood"] as MovieClip;
         _blood.gotoAndStop(param1);
         _mask.x = _blood.x;
         _mask.y = _blood.y;
         _blood.mask = _mask;
      }
      
      public function changeColor(param1:uint) : void
      {
         _blood.gotoAndStop(param1);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this._mainUI = null;
      }
   }
}

