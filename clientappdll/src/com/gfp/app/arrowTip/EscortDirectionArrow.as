package com.gfp.app.arrowTip
{
   import com.gfp.core.manager.MainManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import org.taomee.utils.DisplayUtil;
   
   public class EscortDirectionArrow extends Sprite
   {
      
      private static var _instance:EscortDirectionArrow;
      
      private var _mainUI:Sprite;
      
      private var _effict:MovieClip;
      
      public function EscortDirectionArrow()
      {
         super();
         this._mainUI = new UI_EscortDirectionArrow();
         this._effict = this._mainUI["effict"];
         this._effict.gotoAndStop(1);
         this._mainUI.y = 0;
         this._mainUI.x = 0;
      }
      
      public static function get instance() : EscortDirectionArrow
      {
         if(_instance == null)
         {
            _instance = new EscortDirectionArrow();
         }
         return _instance;
      }
      
      public static function destroy() : void
      {
         if(_instance)
         {
            _instance.destroy();
         }
         _instance = null;
      }
      
      public function show() : void
      {
         MainManager.actorModel.addChildAt(this._mainUI,0);
         this._effict.play();
      }
      
      public function turnRound(param1:Number) : void
      {
         this._mainUI.rotation = param1;
      }
      
      public function isShown() : Boolean
      {
         if(this._mainUI.parent == null)
         {
            return false;
         }
         return true;
      }
      
      public function hide() : void
      {
         DisplayUtil.removeForParent(this._mainUI);
         this._effict.stop();
      }
      
      public function destroy() : void
      {
         this.hide();
         this._mainUI = null;
      }
   }
}

