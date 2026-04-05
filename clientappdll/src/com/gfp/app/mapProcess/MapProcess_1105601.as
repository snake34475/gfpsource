package com.gfp.app.mapProcess
{
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.ui.ExtenalUIPanel;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1105601 extends BaseMapProcess
   {
      
      private var _startMc:ExtenalUIPanel;
      
      private var _timeId:int = 0;
      
      public function MapProcess_1105601()
      {
         super();
      }
      
      override protected function init() : void
      {
         if(!this._startMc)
         {
            this._startMc = new ExtenalUIPanel("desert_angel_start");
         }
         LayerManager.topLevel.addChild(this._startMc);
         DisplayUtil.align(this._startMc,null,AlignType.MIDDLE_CENTER);
         this._timeId = setTimeout(this.removeStart,3800);
      }
      
      private function removeStart() : void
      {
         if(this._startMc)
         {
            DisplayUtil.removeForParent(this._startMc);
         }
         clearTimeout(this._timeId);
      }
      
      override public function destroy() : void
      {
         if(this._startMc)
         {
            this._startMc.destory();
            DisplayUtil.removeForParent(this._startMc);
         }
      }
   }
}

