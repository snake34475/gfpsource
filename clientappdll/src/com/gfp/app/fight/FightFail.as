package com.gfp.app.fight
{
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.UIManager;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class FightFail
   {
      
      private static var _instance:FightFail;
      
      private var _mainUI:MovieClip;
      
      private var _hideTimeOut:uint;
      
      public function FightFail()
      {
         super();
      }
      
      public static function get instance() : FightFail
      {
         if(_instance == null)
         {
            _instance = new FightFail();
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
      
      public function show() : void
      {
         if(this._mainUI == null)
         {
            this._mainUI = UIManager.getSprite("Fight_fail") as MovieClip;
            this._mainUI.mouseChildren = false;
            this._mainUI.mouseEnabled = false;
         }
         LayerManager.topLevel.addChild(this._mainUI);
         DisplayUtil.align(this._mainUI,null,AlignType.MIDDLE_CENTER,new Point(5,0));
         this._hideTimeOut = setTimeout(this.timeOutHide,3000);
      }
      
      private function timeOutHide() : void
      {
         clearTimeout(this._hideTimeOut);
         this.hide();
         FightManager.quit();
      }
      
      public function destroy() : void
      {
         this.hide();
         this._mainUI = null;
      }
      
      public function hide() : void
      {
         if(this._hideTimeOut != 0)
         {
            clearTimeout(this._hideTimeOut);
            this._hideTimeOut = 0;
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

