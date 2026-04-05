package com.gfp.app.toolBar.tollgate
{
   import com.gfp.core.action.keyboard.KeyFuncProcess;
   import com.gfp.core.events.MagicChangeEvent;
   import com.gfp.core.manager.MagicChangeManager;
   import com.gfp.core.manager.SOManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.net.SharedObject;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   public class MaigcCDIcon
   {
      
      private var _mainUI:Sprite;
      
      private var _timerID:int;
      
      private var _magicChangeOnceTime:int;
      
      private var _toggleMC:MovieClip;
      
      public function MaigcCDIcon(param1:Sprite)
      {
         super();
         this._mainUI = param1;
         this._toggleMC = this._mainUI["toggleMC"];
         this._toggleMC.buttonMode = true;
         this.addListeners();
         this._magicChangeOnceTime = MagicChangeManager.instance.getMagicChangeOnceTime();
         this.reset();
         this.resetToggle();
      }
      
      private function resetToggle() : void
      {
         var _loc1_:SharedObject = SOManager.getCommonSO(SOManager.MAGIC_CHANGE_PRESS_KEY);
         var _loc2_:Boolean = Boolean(_loc1_.data.notCall);
         this._toggleMC.gotoAndStop(_loc2_ ? 1 : 2);
         KeyFuncProcess.magicChangeWhenPressKey = !_loc2_;
      }
      
      public function set visible(param1:Boolean) : void
      {
         this._mainUI.visible = param1;
      }
      
      private function addListeners() : void
      {
         MagicChangeManager.instance.addEventListener(MagicChangeEvent.CALL_FIGHT,this.onMagicChange);
         MagicChangeManager.instance.addEventListener(MagicChangeEvent.CALL_FIGHT_END,this.onMagicChange);
         this._toggleMC.addEventListener(MouseEvent.CLICK,this.toggleHandle);
      }
      
      private function removeListeners() : void
      {
         MagicChangeManager.instance.removeEventListener(MagicChangeEvent.CALL_FIGHT,this.onMagicChange);
         MagicChangeManager.instance.removeEventListener(MagicChangeEvent.CALL_FIGHT_END,this.onMagicChange);
         this._toggleMC.removeEventListener(MouseEvent.CLICK,this.toggleHandle);
         clearInterval(this._timerID);
      }
      
      private function toggleHandle(param1:MouseEvent) : void
      {
         var _loc2_:SharedObject = SOManager.getCommonSO(SOManager.MAGIC_CHANGE_PRESS_KEY);
         this._toggleMC.gotoAndStop(this._toggleMC.currentFrame == 2 ? 1 : 2);
         _loc2_.data.notCall = this._toggleMC.currentFrame == 1;
         _loc2_.flush();
         this.resetToggle();
      }
      
      private function onMagicChange(param1:MagicChangeEvent) : void
      {
         this.reset();
      }
      
      private function reset() : void
      {
         clearInterval(this._timerID);
         if(MagicChangeManager.instance.getLeftSeconds() > 0)
         {
            this._mainUI["cdFont"].visible = false;
            this._timerID = setInterval(this.onTimer,1000,1);
            this.onTimer(1);
         }
         else if(MagicChangeManager.instance.getCD() > 0)
         {
            this._mainUI["cdFont"].visible = true;
            this._timerID = setInterval(this.onTimer,1000,2);
            this.onTimer(2);
         }
         else
         {
            this._mainUI["cdFont"].visible = false;
            this._mainUI["cdLabel"].text = this._magicChangeOnceTime + "秒";
            this.setPercent(1);
         }
      }
      
      private function onTimer(param1:int) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         if(param1 == 1)
         {
            _loc3_ = int(MagicChangeManager.instance.getLeftSeconds());
            _loc2_ = _loc3_ / this._magicChangeOnceTime;
            if(_loc2_ <= 0)
            {
               _loc3_ = 0;
               _loc2_ = 0;
               clearInterval(this._timerID);
            }
         }
         else
         {
            _loc3_ = int(MagicChangeManager.instance.getCD());
            _loc2_ = 1 - MagicChangeManager.instance.getCD() / 60;
            if(_loc2_ >= 1)
            {
               _loc3_ = 0;
               _loc2_ = 1;
               this.reset();
               return;
            }
         }
         this._mainUI["cdLabel"].text = _loc3_ + "秒";
         this.setPercent(_loc2_);
      }
      
      private function setPercent(param1:Number) : void
      {
         this._mainUI["highligh"].scrollRect = new Rectangle(0,0,param1 * 45,35);
      }
      
      public function destroy() : void
      {
         this.removeListeners();
      }
   }
}

