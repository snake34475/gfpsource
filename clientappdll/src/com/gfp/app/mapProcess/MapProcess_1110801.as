package com.gfp.app.mapProcess
{
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.model.sensemodels.SightModel;
   import com.gfp.core.model.sensemodels.StageTeleportModel;
   import com.gfp.core.ui.ExtenalUIPanel;
   import com.greensock.TweenMax;
   import flash.utils.clearInterval;
   import flash.utils.clearTimeout;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1110801 extends ShowDpsMapprocess
   {
      
      private var _txtInfo:ExtenalUIPanel;
      
      private var _timeId:int = 0;
      
      private var _tId:int;
      
      private var _model:SightModel;
      
      public function MapProcess_1110801()
      {
         super();
      }
      
      override protected function init() : void
      {
         var _loc2_:SightModel = null;
         super.init();
         var _loc1_:Array = SightManager.getSightModelList();
         for each(_loc2_ in _loc1_)
         {
            if(_loc2_ is StageTeleportModel)
            {
               if(_loc2_.info.id == 6)
               {
                  this._model = _loc2_;
                  break;
               }
            }
         }
         this._tId = setInterval(this.hideDoor,200);
         this._txtInfo = new ExtenalUIPanel("huang_jing");
         LayerManager.topLevel.addChild(this._txtInfo);
         DisplayUtil.align(this._txtInfo,null,AlignType.MIDDLE_CENTER);
         this._timeId = setTimeout(this.removeTxt,5000);
      }
      
      private function hideDoor() : void
      {
         if(this._model.parent)
         {
            this._model.parent.removeChild(this._model);
         }
         this._model.visible = false;
      }
      
      private function removeTxt() : void
      {
         if(this._txtInfo)
         {
            TweenMax.to(this._txtInfo,1,{
               "alpha":0,
               "onComplete":this.onTweenComp
            });
         }
         clearTimeout(this._timeId);
         clearInterval(this._tId);
      }
      
      private function onTweenComp() : void
      {
         if(Boolean(this._txtInfo) && Boolean(this._txtInfo.parent))
         {
            this._txtInfo.parent.removeChild(this._txtInfo);
            this._txtInfo = null;
         }
      }
      
      override public function destroy() : void
      {
         this.removeTxt();
         if(Boolean(this._txtInfo) && Boolean(this._txtInfo.parent))
         {
            this._txtInfo.destory();
            this._txtInfo.parent.removeChild(this._txtInfo);
            this._txtInfo = null;
         }
         super.destroy();
      }
   }
}

