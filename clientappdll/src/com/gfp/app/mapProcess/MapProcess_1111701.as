package com.gfp.app.mapProcess
{
   import com.gfp.core.manager.LayerManager;
   import com.greensock.TweenMax;
   import flash.display.MovieClip;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1111701 extends ShowDpsMapprocess
   {
      
      private var _txtMc:MovieClip;
      
      private var _timeId:int;
      
      public function MapProcess_1111701()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._txtMc = _mapModel.libManager.getMovieClip("UI_HjTxtWarn");
         this._txtMc.cacheAsBitmap = true;
         LayerManager.topLevel.addChild(this._txtMc);
         DisplayUtil.align(this._txtMc,null,AlignType.MIDDLE_CENTER);
         this._timeId = setTimeout(this.stayTxt,5000);
      }
      
      private function stayTxt() : void
      {
         if(this._txtMc)
         {
            TweenMax.to(this._txtMc,1,{"y":50});
         }
         clearTimeout(this._timeId);
      }
      
      override public function destroy() : void
      {
         if(Boolean(this._txtMc) && Boolean(this._txtMc.parent))
         {
            this._txtMc.parent.removeChild(this._txtMc);
            this._txtMc = null;
         }
         super.destroy();
      }
   }
}

