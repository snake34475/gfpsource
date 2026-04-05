package com.gfp.app.npcDialog
{
   import com.gfp.app.config.xml.DialogXMLInfo;
   import com.gfp.app.info.dialog.DialogInfoMultiple;
   import com.gfp.app.info.dialog.DialogInfoSimple;
   import com.gfp.app.info.dialog.NpcDialogInfo;
   import com.gfp.core.events.CommEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.MoveEvent;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.utils.Logger;
   import com.gfp.core.utils.StringConstants;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import org.taomee.ds.HashMap;
   import org.taomee.utils.DisplayUtil;
   
   public class NpcDialogController
   {
      
      private static var _panel:NpcDialogPanel;
      
      private static var _ed:EventDispatcher;
      
      public static const NPC_DIALOG_OPTIONS_MODEL_SELECT:String = "NPC_DIALOG_OPTIONS_MODEL_SELECT";
      
      private static var _haspMap:HashMap = new HashMap();
      
      public function NpcDialogController()
      {
         super();
      }
      
      public static function get panel() : NpcDialogPanel
      {
         if(_panel == null)
         {
            _panel = new NpcDialogPanel();
         }
         return _panel;
      }
      
      public static function get ed() : EventDispatcher
      {
         if(!_ed)
         {
            _ed = new EventDispatcher();
         }
         return _ed;
      }
      
      public static function showForNpc(param1:uint) : void
      {
         var _loc2_:NpcDialogInfo = null;
         if(DisplayUtil.hasParent(panel))
         {
            return;
         }
         _loc2_ = DialogXMLInfo.getInfos(param1);
         if(_loc2_)
         {
            panel.initForNpc(param1);
            panel.show();
            ed.dispatchEvent(new NPCDialogEvent(param1,NPCDialogEvent.INIT));
         }
         else
         {
            Logger.error(null,"NPC对话未配置");
         }
      }
      
      public static function showForSimple(param1:DialogInfoSimple, param2:uint = 0, param3:Function = null, param4:Function = null) : void
      {
         panel.hide();
         panel.initForSimple(param1,param2,param3,param4);
         panel.show();
      }
      
      public static function showForMultiple(param1:DialogInfoMultiple, param2:uint, ... rest) : void
      {
         panel.hide();
         panel.initForMultiple(param1,param2,rest);
         panel.show();
      }
      
      public static function showForMultipleEx(param1:DialogInfoMultiple, param2:uint, param3:Function, param4:int = 3) : void
      {
         panel.hide();
         panel.initForMultipleEx(param1,param2,param3,param4);
         panel.show();
      }
      
      public static function showForSingles(param1:Array, param2:Array, param3:uint, param4:Function = null, param5:Function = null) : void
      {
         panel.hide();
         if(param1.length == 0)
         {
            if(param4 != null)
            {
               param4();
            }
            return;
         }
         panel.initForSingles(param1,param2,param3,param4,param5);
         panel.show();
      }
      
      public static function showForArr(param1:int, param2:Array, param3:Array) : void
      {
         panel.hide();
         panel.initForArr(param1,param2,param3);
         panel.show();
      }
      
      public static function showOptionsNpcDialog(param1:uint, param2:int, param3:Function) : void
      {
         panel.hide();
         panel.initForOptions(param1,param2);
         panel.show();
         ed.addEventListener(NPC_DIALOG_OPTIONS_MODEL_SELECT,whenSelectOptionHandler);
         _haspMap.add(param1 + StringConstants.SIGN + param2,param3);
      }
      
      private static function whenSelectOptionHandler(param1:CommEvent) : void
      {
         var _loc5_:Function = null;
         var _loc2_:String = param1.data as String;
         var _loc3_:Array = _loc2_.split(StringConstants.SIGN);
         var _loc4_:String = _loc3_[0] + StringConstants.SIGN + _loc3_[1];
         if(_haspMap.containsKey(_loc4_))
         {
            _loc5_ = _haspMap.getValue(_loc4_);
            _loc5_(int(_loc3_[2]));
            _haspMap.remove(_loc4_);
         }
         if(_haspMap.length == 0)
         {
            ed.removeEventListener(NPC_DIALOG_OPTIONS_MODEL_SELECT,whenSelectOptionHandler);
         }
      }
      
      public static function hide() : void
      {
         panel.hide();
      }
      
      public static function isTongGuanSMTOrBHLY() : Boolean
      {
         return Boolean(MainManager.stageRecordInfo.isStagePass(472,0)) || Boolean(MainManager.stageRecordInfo.isStagePass(473,0)) || Boolean(MainManager.stageRecordInfo.isStagePass(122,0));
      }
      
      public static function tryGotoTianGong() : void
      {
         if(isTongGuanSMTOrBHLY())
         {
            goToNpc(108,10564,1308,731);
         }
         else
         {
            AlertManager.showSimpleAlert("小侠士，你需要通关冰火炼狱或神魔塔才能见到孙悟空参加该活动，是否现在就去？",onGotoQinQiu);
         }
      }
      
      private static function onGotoQinQiu() : void
      {
         goToNpc(107,10563,1355,548);
      }
      
      public static function goToNpc(param1:int, param2:int, param3:int, param4:int, param5:String = null, param6:Function = null) : void
      {
         var temp:Array;
         var point:Point = null;
         var onMapComplete:Function = null;
         var onMoveEnd:Function = null;
         var map:int = param1;
         var npc:int = param2;
         var x:int = param3;
         var y:int = param4;
         var panel:String = param5;
         var callBack:Function = param6;
         var str:String = map + "," + x + "," + y;
         CityMap.instance.tranChangeMapByStr(str);
         temp = str.split(",");
         point = new Point(temp[1],temp[2]);
         if(MapManager.mapInfo.id != map)
         {
            onMapComplete = function(param1:Event):void
            {
               MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,onMapComplete);
               goToNpc(map,npc,x,y,panel,callBack);
            };
            MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,onMapComplete);
         }
         else
         {
            onMoveEnd = function(param1:MoveEvent):void
            {
               MainManager.actorModel.removeEventListener(MoveEvent.MOVE_END,onMoveEnd);
               if(Point.distance(MainManager.actorModel.pos,point) < 100)
               {
                  if(panel == null)
                  {
                     if(callBack != null)
                     {
                        callBack();
                     }
                     else
                     {
                        NpcDialogController.showForNpc(npc);
                     }
                  }
                  else
                  {
                     ModuleManager.turnAppModule(panel);
                  }
               }
            };
            MainManager.actorModel.addEventListener(MoveEvent.MOVE_END,onMoveEnd);
         }
      }
   }
}

