package com.gfp.app.mapProcess
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class MapProcess_13 extends MapProcessAnimat
   {
      
      private var _hammerMC:MovieClip;
      
      private var _boxMC1:MovieClip;
      
      private var _boxMC2:MovieClip;
      
      public function MapProcess_13()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._hammerMC = _mapModel.upLevel["hammerMC"];
         addSimpleClickAnimat(this._hammerMC);
         this._boxMC1 = _mapModel.downLevel["boxMC1"];
         this._boxMC2 = _mapModel.downLevel["boxMC2"];
         this._boxMC1.buttonMode = true;
         this._boxMC2.buttonMode = true;
         this._boxMC1.addEventListener(MouseEvent.CLICK,this.onBoxMC1Click);
         this._boxMC2.addEventListener(MouseEvent.CLICK,this.onBoxMC2Click);
      }
      
      private function onBoxMC1Click(param1:Event) : void
      {
         var _loc2_:int = this._boxMC1.currentFrame == 1 ? 2 : 1;
         this._boxMC1.gotoAndStop(_loc2_);
      }
      
      private function onBoxMC2Click(param1:Event) : void
      {
         var _loc2_:int = this._boxMC2.currentFrame == 1 ? 2 : 1;
         this._boxMC2.gotoAndStop(_loc2_);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         removeSimpleClickAnimat(this._hammerMC);
      }
   }
}

