package com.gfp.app.mapConfigFun
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.cartoon.event.AnimatEvent;
   import com.gfp.app.fight.FightGo;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.map.IMapConfigFun;
   import com.gfp.core.map.MapConfigUtil;
   import com.gfp.core.model.sensemodels.SightModel;
   
   public class MapXML_GotoStage implements IMapConfigFun
   {
      
      private var _stageTo:int;
      
      private var _transitionAnimat:String;
      
      public function MapXML_GotoStage()
      {
         super();
      }
      
      public function exec(param1:SightModel, param2:XML, param3:XMLList) : void
      {
         this._stageTo = int(param2.attribute(MapConfigUtil.A_STAGETO));
         this._transitionAnimat = param2.attribute(MapConfigUtil.A_TRANSTION_ANIMAT);
         var _loc4_:int = parseInt(param2.@loadType);
         if(_loc4_ == 0)
         {
            _loc4_ = 1;
         }
         if(this._transitionAnimat != null && this._transitionAnimat != "")
         {
            MainManager.closeOperate();
            AnimatPlay.addAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimatEndHandle);
            AnimatPlay.startAnimat(this._transitionAnimat);
         }
         else
         {
            PveEntry.changeMap(this._stageTo,_loc4_);
            FightGo.instance.hide();
         }
      }
      
      private function onAnimatEndHandle(param1:AnimatEvent) : void
      {
         AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimatEndHandle);
         PveEntry.changeMap(this._stageTo);
         FightGo.instance.hide();
      }
   }
}

