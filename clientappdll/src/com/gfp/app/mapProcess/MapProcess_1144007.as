package com.gfp.app.mapProcess
{
   import com.gfp.app.ui.compoment.McNumber;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.map.BaseMapProcess;
   import flash.display.MovieClip;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1144007 extends BaseMapProcess
   {
      
      private var cd:MovieClip;
      
      private var _minites:McNumber;
      
      private var _seconds:McNumber;
      
      private var _timer:int;
      
      private var cdTime:int = 180;
      
      public function MapProcess_1144007()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.cd = _mapModel.libManager.getMovieClip("time");
         this.cd.x = LayerManager.stageWidth - this.cd.width >> 1;
         this._minites = new McNumber(this.cd["num0"],"number",true);
         this._seconds = new McNumber(this.cd["num1"],"number",true);
         this.cd.y = LayerManager.stageHeight - this.cd.height >> 1;
         LayerManager.topLevel.addChild(this.cd);
         this.cdFunction();
         StageResizeController.instance.register(this.resizePos);
         this.resizePos();
      }
      
      private function cdFunction() : void
      {
         if(this._timer)
         {
            clearInterval(this._timer);
         }
         setInterval(this.cdTimer,970);
      }
      
      private function cdTimer() : void
      {
         var _loc1_:int = this.cdTime % 60;
         var _loc2_:int = int(uint(this.cdTime / 60));
         this._minites.setValue(_loc2_,false);
         this._seconds.setValue(_loc1_,false);
         if(this.cdTime != 0)
         {
            --this.cdTime;
         }
      }
      
      private function resizePos() : void
      {
         this.cd.x = 600;
         this.cd.y = 160;
      }
      
      override public function destroy() : void
      {
         StageResizeController.instance.unregister(this.resizePos);
         DisplayUtil.removeForParent(this.cd);
      }
   }
}

