package com.gfp.app.cmdl
{
   import com.gfp.app.miniMap.MiniMap;
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.action.ActionManager;
   import com.gfp.core.action.mouse.MouseProcess;
   import com.gfp.core.config.xml.NpcXMLInfo;
   import com.gfp.core.config.xml.TollgateXMLInfo;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.MoveEvent;
   import com.gfp.core.info.MapInfo;
   import com.gfp.core.info.TollgateInfo;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   import com.gfp.core.model.sensemodels.SightModel;
   import flash.geom.Point;
   import org.taomee.algo.AStar;
   import org.taomee.bean.BaseBean;
   
   public class SystemGlobalCmdListener extends BaseBean
   {
      
      public function SystemGlobalCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         MainManager.actorModel.addEventListener(MoveEvent.MOVE_END,this.onPlayerMoveEnd);
         finish();
      }
      
      private function onPlayerMoveEnd(param1:MoveEvent) : void
      {
         this.showTargetNpcDialog();
      }
      
      private function onMapSwitchComplete(param1:MapEvent) : void
      {
         this.showTargetNpcDialog();
         this.showTargetTollgateEntry();
         this.checkMiniMap();
      }
      
      private function checkMiniMap() : void
      {
         var _loc1_:MapInfo = MapManager.currentMap.info;
         if(Boolean(_loc1_.name) && (_loc1_.mapType == MapType.PVAI || _loc1_.mapType == MapType.PVP))
         {
            MiniMap.instance.changeTitle(_loc1_.name);
         }
      }
      
      private function showTargetNpcDialog() : void
      {
         var _loc2_:Point = null;
         var _loc3_:Array = null;
         var _loc4_:ActionManager = null;
         if(MapManager.mapInfo == null)
         {
            return;
         }
         if(MainManager.targetNpcId <= 0)
         {
            return;
         }
         if(MapManager.mapInfo.mapType != MapType.STAND)
         {
            return;
         }
         var _loc1_:SightModel = SightManager.getSightModel(MainManager.targetNpcId);
         if(_loc1_ != null)
         {
            _loc2_ = NpcXMLInfo.getTtranPos(MainManager.targetNpcId);
            if(Point.distance(MainManager.actorModel.pos,_loc2_) < 100)
            {
               if(MapManager.mapInfo.mapType == MapType.STAND)
               {
                  NpcDialogController.showForNpc(MainManager.targetNpcId);
               }
               MainManager.targetNpcId = 0;
            }
            else
            {
               _loc3_ = AStar.instance.find(MainManager.actorModel.pos.clone(),_loc2_);
               if(_loc3_)
               {
                  _loc4_ = MainManager.actorModel.actionManager;
                  if(_loc4_.hasID(9001) == false && _loc4_.hasID(9002) == false && _loc4_.hasID(10002) == false && _loc4_.hasID(10003) == false)
                  {
                     MouseProcess.execRun(MainManager.actorModel,_loc2_);
                  }
               }
            }
         }
      }
      
      private function showTargetTollgateEntry() : void
      {
         if(MapManager.mapInfo == null)
         {
            return;
         }
         if(MainManager.targetTollgateId <= 0)
         {
            return;
         }
         if(MapManager.mapInfo.mapType != MapType.STAND)
         {
            return;
         }
         var _loc1_:TollgateInfo = TollgateXMLInfo.getTollgateInfoById(MainManager.targetTollgateId);
         if(_loc1_.tollgateMapID == MapManager.mapInfo.id)
         {
            if(_loc1_ != null && _loc1_.tollgatePosInMap.length != 0)
            {
               MouseProcess.execRun(MainManager.actorModel,_loc1_.tollgatePosInMap);
            }
            MainManager.targetTollgateId = 0;
         }
      }
   }
}

