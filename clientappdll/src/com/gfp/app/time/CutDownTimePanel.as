package com.gfp.app.time
{
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UIManager;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class CutDownTimePanel extends Sprite
   {
      
      private static var _instance:CutDownTimePanel;
      
      private var _mainUI:Sprite;
      
      private var _timeTxt:TextField;
      
      private var _timeID:uint;
      
      private var _timeHand:uint;
      
      private var _alwaysShow:Boolean;
      
      private var _mapID:uint;
      
      private var _swapMap:Boolean;
      
      private var _isRuning:Boolean = false;
      
      public function CutDownTimePanel()
      {
         super();
      }
      
      public static function initTime(param1:uint, param2:Boolean = false) : void
      {
         instance.initTime(param1,param2);
      }
      
      public static function destroy() : void
      {
         if(_instance != null)
         {
            instance.destroy();
            _instance = null;
         }
      }
      
      public static function initDetailTime(param1:uint, param2:uint, param3:Boolean = false, param4:Boolean = true) : void
      {
         instance.initDetailTime(param1,param2,param3,param4);
      }
      
      public static function get instance() : CutDownTimePanel
      {
         if(_instance == null)
         {
            _instance = new CutDownTimePanel();
         }
         return _instance;
      }
      
      public function get isRuning() : Boolean
      {
         return this._isRuning;
      }
      
      public function get alwaysShow() : Boolean
      {
         return this._alwaysShow;
      }
      
      public function initTime(param1:uint, param2:Boolean = false) : void
      {
         this.show();
         this.clearTime();
         this._alwaysShow = param2;
         this._timeHand = param1;
         this._timeTxt.text = this._timeHand + "s";
         this._timeID = setInterval(this.timeRate,1000);
         this._isRuning = true;
      }
      
      public function initDetailTime(param1:uint, param2:uint, param3:Boolean = false, param4:Boolean = true) : void
      {
         this.show();
         this.clearTime();
         this._alwaysShow = param3;
         this._timeHand = param1;
         this._timeTxt.text = this.timeConvert(param1);
         this._mapID = param2;
         this._swapMap = param4;
         this._timeID = setInterval(this.timeDetailRate,1000);
         this._isRuning = true;
      }
      
      private function timeRate() : void
      {
         --this._timeHand;
         this._timeTxt.text = this._timeHand + "s";
         if(this._timeHand == 0)
         {
            this.clearTime();
            if(!this._alwaysShow)
            {
               this.destroy();
            }
         }
      }
      
      private function timeDetailRate() : void
      {
         --this._timeHand;
         this._timeTxt.text = this.timeConvert(this._timeHand);
         if(this._timeHand == 0 || this._mapID != 0 && MainManager.actorInfo.mapID != this._mapID && this._swapMap)
         {
            this.clearTime();
            if(!this._alwaysShow)
            {
               this.destroy();
            }
         }
      }
      
      private function timeConvert(param1:int) : String
      {
         var _loc2_:String = "";
         _loc2_ = "00" + int(param1 / 60).toString();
         _loc2_ = _loc2_.slice(_loc2_.length - 2);
         _loc2_ += ":";
         var _loc3_:String = "00" + int(param1 % 60).toString();
         _loc3_ = _loc3_.slice(_loc3_.length - 2);
         return _loc2_ + _loc3_;
      }
      
      private function clearTime() : void
      {
         this._isRuning = false;
         if(this._timeID != 0)
         {
            clearInterval(this._timeID);
            this._timeID = 0;
         }
      }
      
      public function show() : void
      {
         if(this._mainUI == null)
         {
            this._mainUI = UIManager.getSprite("ToolBar_TopTime");
            this._timeTxt = this._mainUI["timeTxt"];
            this._mainUI.cacheAsBitmap = true;
         }
         LayerManager.topLevel.addChild(this._mainUI);
         DisplayUtil.align(this._mainUI,null,AlignType.TOP_CENTER);
      }
      
      public function setPos(param1:uint, param2:uint) : void
      {
         this._mainUI.x += param1;
         this._mainUI.y += param2;
      }
      
      public function destroy() : void
      {
         this.clearTime();
         DisplayUtil.removeForParent(this._mainUI);
         this._mainUI = null;
      }
   }
}

