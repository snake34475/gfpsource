package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.core.manager.MainManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TurnStrongEquipButton extends BaseActivitySprite
   {
      
      private var _movie:MovieClip;
      
      private var _filters:Array;
      
      public function TurnStrongEquipButton(param1:ActivityNodeInfo)
      {
         super(param1);
         this._movie = _sprite["mc"] as MovieClip;
         this._filters = this._movie.filters;
         this._movie.gotoAndStop(MainManager.actorInfo.roleType);
         _sprite.addEventListener(MouseEvent.ROLL_OVER,this.overHandle);
         _sprite.addEventListener(MouseEvent.ROLL_OUT,this.outHandle);
         (_sprite as Sprite).buttonMode = true;
         this._movie.filters = [];
      }
      
      private function overHandle(param1:MouseEvent) : void
      {
         this._movie.filters = this._filters;
      }
      
      private function outHandle(param1:MouseEvent) : void
      {
         this._movie.filters = [];
      }
   }
}

