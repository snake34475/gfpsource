package com.gfp.app.mapProcess
{
   import com.gfp.app.systems.ClientTempState;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.map.BaseMapProcess;
   import flash.display.MovieClip;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1041201 extends BaseMapProcess
   {
      
      private var _tips:MovieClip;
      
      public function MapProcess_1041201()
      {
         super();
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(this._tips)
         {
            DisplayUtil.removeForParent(this._tips);
            this._tips = null;
         }
      }
      
      override protected function init() : void
      {
         super.init();
         if(ClientTempState.storedBuffInfo)
         {
            this._tips = UIManager.getMovieClip("Fight_InfoTip");
            this._tips["infoTxt"].text = ClientTempState.storedBuffInfo;
            this._tips.x = 535;
            this._tips.y = 425;
            LayerManager.toolUiLevel.addChild(this._tips);
         }
      }
   }
}

