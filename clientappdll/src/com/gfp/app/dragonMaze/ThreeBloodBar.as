package com.gfp.app.dragonMaze
{
   import com.gfp.core.ui.FightBloodBar;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class ThreeBloodBar extends FightBloodBar
   {
      
      private var _mainUI:Sprite;
      
      public function ThreeBloodBar(param1:uint = 1)
      {
         super();
         this.setMainUI(param1);
      }
      
      protected function setMainUI(param1:uint) : void
      {
         mouseChildren = false;
         mouseEnabled = false;
         cacheAsBitmap = true;
         this._mainUI = new UI_ThreeBloodBar();
         addChild(this._mainUI);
         _mask = new Sprite();
         this._mainUI.addChild(_mask);
         _blood = MovieClip(this._mainUI["mc_blood"]);
         _blood.gotoAndStop(param1);
         _mask.x = _blood.x;
         _mask.y = _blood.y;
         _blood.mask = _mask;
      }
   }
}

