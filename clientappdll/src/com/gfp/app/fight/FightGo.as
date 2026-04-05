package com.gfp.app.fight
{
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UIManager;
   import flash.display.MovieClip;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.utils.DisplayUtil;
   
   public class FightGo
   {
      
      private static var _instance:FightGo;
      
      private var _mainUI:MovieClip;
      
      private var _showTimeOutID:uint;
      
      private var _enabledShow:Boolean = true;
      
      public function FightGo()
      {
         super();
      }
      
      public static function get instance() : FightGo
      {
         if(_instance == null)
         {
            _instance = new FightGo();
         }
         return _instance;
      }
      
      public static function destroy() : void
      {
         if(_instance)
         {
            _instance.destroy();
            _instance = null;
         }
      }
      
      public function showLater() : void
      {
         this._showTimeOutID = setTimeout(this.showTimeOut,10000);
      }
      
      public function set enabledShow(param1:Boolean) : void
      {
         this._enabledShow = param1;
      }
      
      private function showTimeOut() : void
      {
         clearTimeout(this._showTimeOutID);
         this._showTimeOutID = 0;
         this.show();
      }
      
      public function show() : void
      {
         if(!this._enabledShow)
         {
            return;
         }
         if(this._mainUI == null)
         {
            this._mainUI = UIManager.getSprite("Fight_Go") as MovieClip;
            this._mainUI.mouseChildren = false;
            this._mainUI.mouseEnabled = false;
         }
         this._mainUI.y = -MainManager.actorModel.height - (this._mainUI.height / 2 + 10);
         this._mainUI.x = MainManager.actorModel.width / 2 - this._mainUI.width / 2;
         MainManager.actorModel.addChild(this._mainUI);
      }
      
      public function destroy() : void
      {
         this.hide();
         this._mainUI = null;
      }
      
      public function hide() : void
      {
         if(this._showTimeOutID != 0)
         {
            clearTimeout(this._showTimeOutID);
            this._showTimeOutID = 0;
         }
         if(this._mainUI)
         {
            this._mainUI.stop();
            DisplayUtil.removeForParent(this._mainUI,false);
            this._mainUI = null;
         }
      }
   }
}

