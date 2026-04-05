package com.gfp.app.mapProcess
{
   import com.gfp.app.info.dialog.DialogInfoSimple;
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.action.mouse.MouseProcess;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.model.sensemodels.SightModel;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.taomee.utils.Delegate;
   
   public class MapProcess_19 extends BaseMapProcess
   {
      
      private var _npc10084:SightModel;
      
      private var _npc10085:SightModel;
      
      private var _npc10086:SightModel;
      
      private var _npc10087:SightModel;
      
      private var _npc10088:SightModel;
      
      private var _npc10089:SightModel;
      
      private var _func10084:Function;
      
      private var _func10085:Function;
      
      private var _func10086:Function;
      
      public function MapProcess_19()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.addTaskEventListener();
         this.initWoundedPerson();
      }
      
      private function addTaskEventListener() : void
      {
         TasksManager.addListener(TaskEvent.ACCEPT,this.onTaskAccept);
         TasksManager.addListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
      }
      
      private function removeTaskManagerEventListener() : void
      {
         TasksManager.removeListener(TaskEvent.ACCEPT,this.onTaskAccept);
         TasksManager.removeListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
      }
      
      private function onTaskAccept(param1:TaskEvent) : void
      {
         if(param1.taskID == 58)
         {
            MouseProcess.execWalk(MainManager.actorModel,new Point(801,355));
         }
      }
      
      private function onTaskProComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 58)
         {
            if(param1.proID == 2)
            {
               CityMap.instance.changeMap(5,0,1,new Point(500,400));
            }
         }
      }
      
      private function initWoundedPerson() : void
      {
         this._npc10084 = SightManager.getSightModel(10084);
         this._npc10085 = SightManager.getSightModel(10085);
         this._npc10086 = SightManager.getSightModel(10086);
         this._npc10084.hide();
         this._npc10085.hide();
         this._npc10086.hide();
         this._npc10087 = SightManager.getSightModel(10087);
         this._npc10088 = SightManager.getSightModel(10088);
         this._npc10089 = SightManager.getSightModel(10089);
         this._npc10087.hide();
         this._npc10088.hide();
         this._npc10089.hide();
         if(TasksManager.isAccepted(1242))
         {
            if(!TasksManager.isTaskProComplete(1242,0))
            {
               this._npc10084.show();
            }
            if(!TasksManager.isTaskProComplete(1242,1))
            {
               this._npc10085.show();
            }
            if(!TasksManager.isTaskProComplete(1242,2))
            {
               this._npc10086.show();
            }
         }
         this.addWoundedEventListener();
      }
      
      private function addWoundedEventListener() : void
      {
         this._func10084 = Delegate.create(this.onNpcClick,0,this._npc10087);
         this._func10085 = Delegate.create(this.onNpcClick,1,this._npc10088);
         this._func10086 = Delegate.create(this.onNpcClick,2,this._npc10089);
         this._npc10084.addEventListener(MouseEvent.CLICK,this._func10084);
         this._npc10085.addEventListener(MouseEvent.CLICK,this._func10085);
         this._npc10086.addEventListener(MouseEvent.CLICK,this._func10086);
      }
      
      private function onNpcClick(param1:Event, param2:int, param3:SightModel) : void
      {
         var _loc4_:DialogInfoSimple = null;
         if(ItemManager.getItemCount(1300006) >= 1)
         {
            ActivityExchangeCommander.exchange(2098);
            TasksManager.dispatchActionEvent(TaskActionEvent.TASK_MAPCOLLECT,"woundedPerson" + param2);
            (param1.currentTarget as SightModel).hide();
            param3.show();
            _loc4_ = new DialogInfoSimple([AppLanguageDefine.NPC_DIALOG_MAP19[0]],AppLanguageDefine.NPC_DIALOG_MAP19[1]);
            NpcDialogController.showForSimple(_loc4_,10087);
         }
         else
         {
            AlertManager.showSimpleAlarm(AppLanguageDefine.NPC_DIALOG_MAP19[2]);
         }
      }
      
      override public function destroy() : void
      {
         this._npc10084.removeEventListener(MouseEvent.CLICK,this._func10084);
         this._npc10085.removeEventListener(MouseEvent.CLICK,this._func10085);
         this._npc10086.removeEventListener(MouseEvent.CLICK,this._func10086);
         this._npc10084 = null;
         this._npc10085 = null;
         this._npc10086 = null;
         this.removeTaskManagerEventListener();
      }
   }
}

