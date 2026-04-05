package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.app.toolBar.DynamicActivityEntry;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UserManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class TurnbackRoadButton extends BaseActivitySprite
   {
      
      private var _movie:MovieClip;
      
      private var _filters:Array;
      
      public function TurnbackRoadButton(param1:ActivityNodeInfo)
      {
         super(param1);
         UserManager.addEventListener(UserEvent.SECOND_TURN_BACK,this.updateHandle);
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
      
      private function updateHandle(param1:Event) : void
      {
         if(MainManager.actorInfo.secondTurnBackType > 0)
         {
            DynamicActivityEntry.instance.updateAlign();
         }
      }
      
      override public function executeShow() : Boolean
      {
         return Boolean(super.executeShow()) && MainManager.actorInfo.secondTurnBackType == 0;
      }
   }
}

