package com.gfp.app.mapProcess
{
   import com.gfp.app.info.dialog.DialogInfoSimple;
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.CommandID;
   import com.gfp.core.action.mouse.MouseProcess;
   import com.gfp.core.config.xml.DailyActivityXMLInfo;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.info.DailyActiveAwardInfo;
   import com.gfp.core.info.dailyActivity.DailyActivityAward;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.sensemodels.SightModel;
   import com.gfp.core.net.SocketConnection;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class MapProcess_33 extends BaseMapProcess
   {
      
      private var acquisitionArray:Array = [];
      
      private var state:int;
      
      private var dailyID:uint;
      
      private var _npc10139:SightModel;
      
      public function MapProcess_33()
      {
         super();
      }
      
      override protected function init() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = null;
         this.addEvent();
         if(Boolean(TasksManager.isAccepted(71)) && Boolean(TasksManager.isProcess(71,3)))
         {
            this.acquisitionArray = [];
            _loc1_ = 0;
            while(_loc1_ < 4)
            {
               _loc2_ = _mapModel.root["content_mc"]["Acquisition" + _loc1_];
               _loc2_.buttonMode = true;
               this.acquisitionArray.push(_loc2_);
               this.acquisitionArray[_loc1_].addEventListener(MouseEvent.CLICK,this.onClick);
               _loc1_++;
            }
         }
         this.initForTask71();
      }
      
      private function initForTask71() : void
      {
         if(Boolean(TasksManager.isTaskProComplete(71,8)) && Boolean(TasksManager.isProcess(71,3)))
         {
            SocketConnection.addCmdListener(CommandID.DAILY_USE_TIME,this.onCheckTimes);
            SocketConnection.send(CommandID.DAILY_USE_TIME,2082);
         }
      }
      
      private function onCheckTimes(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         _loc2_.position = 0;
         if(_loc3_ == 2082)
         {
            SocketConnection.removeCmdListener(CommandID.DAILY_USE_TIME,this.onCheckTimes);
            if(_loc4_ == 0)
            {
               this._npc10139 = SightManager.getSightModel(10139);
               this._npc10139.addEventListener(MouseEvent.CLICK,this.onNpc10139Click);
            }
         }
      }
      
      private function onNpc10139Click(param1:MouseEvent) : void
      {
         this._npc10139.removeEventListener(MouseEvent.CLICK,this.onNpc10139Click);
         var _loc2_:DialogInfoSimple = new DialogInfoSimple(["这是你的海潮之石"],"谢谢!");
         NpcDialogController.showForSimple(_loc2_,10139,this.send2082);
      }
      
      private function send2082() : void
      {
         SocketConnection.addCmdListener(CommandID.DAILY_ACTIVITY,this.onAward);
         SocketConnection.send(CommandID.DAILY_ACTIVITY,2082);
      }
      
      private function addEvent() : void
      {
         TasksManager.addListener(TaskEvent.ACCEPT,this.onTaskAccept);
         TasksManager.addListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
         TasksManager.addListener(TaskEvent.COMPLETE,this.onTaskComplete);
      }
      
      private function removeEvent() : void
      {
         SocketConnection.removeCmdListener(CommandID.DAILY_ACTIVITY,this.onAward);
         SocketConnection.removeCmdListener(CommandID.DAILY_USE_TIME,this.onCheckTimes);
         TasksManager.removeListener(TaskEvent.ACCEPT,this.onTaskAccept);
         TasksManager.removeListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
         TasksManager.removeListener(TaskEvent.COMPLETE,this.onTaskComplete);
      }
      
      private function onTaskAccept(param1:TaskEvent) : void
      {
         if(param1.taskID == 70)
         {
            MouseProcess.execWalk(MainManager.actorModel,new Point(888,1014));
         }
         if(param1.taskID == 71)
         {
            MouseProcess.execWalk(MainManager.actorModel,new Point(273,1338));
         }
         if(param1.taskID == 72)
         {
            MouseProcess.execWalk(MainManager.actorModel,new Point(422,1774));
         }
      }
      
      private function onTaskProComplete(param1:TaskEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         if(param1.taskID == 70)
         {
            if(param1.proID == 0)
            {
               NpcDialogController.showForNpc(10139);
            }
         }
         if(param1.taskID == 71)
         {
            if(param1.proID == 2)
            {
               this.acquisitionArray = [];
               _loc2_ = 0;
               while(_loc2_ < 4)
               {
                  _loc3_ = _mapModel.root["content_mc"]["Acquisition" + _loc2_];
                  _loc3_.buttonMode = true;
                  this.acquisitionArray.push(_loc3_);
                  this.acquisitionArray[_loc2_].addEventListener(MouseEvent.CLICK,this.onClick);
                  _loc2_++;
               }
            }
         }
         if(param1.taskID == 71)
         {
            if(param1.proID == 8)
            {
               SocketConnection.addCmdListener(CommandID.DAILY_ACTIVITY,this.onAward);
               SocketConnection.send(CommandID.DAILY_ACTIVITY,2082);
            }
         }
      }
      
      private function onTaskComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 70)
         {
            if(TasksManager.isAccepted(71) == false)
            {
               TasksManager.accept(71);
            }
         }
         if(param1.taskID == 71)
         {
            if(TasksManager.isAccepted(72) == false)
            {
               TasksManager.accept(72);
            }
         }
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         param1.currentTarget.gotoAndPlay(1);
         param1.currentTarget.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         var _loc2_:int = this.acquisitionArray.indexOf(param1.currentTarget);
         switch(_loc2_)
         {
            case 0:
               this.dailyID = 2078;
               break;
            case 1:
               this.dailyID = 2079;
               break;
            case 2:
               this.dailyID = 2080;
               break;
            case 3:
               this.dailyID = 2081;
         }
         this.acquisitionArray[_loc2_].buttonMode = false;
         this.acquisitionArray[_loc2_].removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         if(param1.currentTarget.currentFrame == param1.currentTarget.totalFrames)
         {
            param1.currentTarget.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            SocketConnection.addCmdListener(CommandID.DAILY_ACTIVITY,this.onAward);
            SocketConnection.send(CommandID.DAILY_ACTIVITY,this.dailyID);
         }
      }
      
      private function onAward(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.DAILY_ACTIVITY,this.onAward);
         var _loc2_:DailyActiveAwardInfo = param1.data as DailyActiveAwardInfo;
         var _loc3_:uint = uint(_loc2_.type);
         if(_loc3_ != DailyActivityXMLInfo.TYPE_REAP_MATERIAL)
         {
            return;
         }
         DailyActivityAward.addAward(_loc2_);
      }
      
      override public function destroy() : void
      {
         if(this._npc10139)
         {
            this._npc10139.removeEventListener(MouseEvent.CLICK,this.onNpc10139Click);
            this._npc10139 = null;
         }
         this.removeEvent();
      }
   }
}

