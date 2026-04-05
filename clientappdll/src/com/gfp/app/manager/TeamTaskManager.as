package com.gfp.app.manager
{
   import com.gfp.app.info.dialog.DialogInfoMultiple;
   import com.gfp.app.npcDialog.NPCDialogEvent;
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.app.toolBar.TimeCountDown;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.xml.RoleXMLInfo;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.events.HiddenEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.ScenceItemAddEvent;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.FunctionManager;
   import com.gfp.core.manager.HiddenManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.HiddenModel;
   import com.gfp.core.model.KeyboardModel;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import flash.utils.setTimeout;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.Delegate;
   import org.taomee.utils.DisplayUtil;
   
   public class TeamTaskManager
   {
      
      private static var _instance:TeamTaskManager;
      
      private var _ed:EventDispatcher;
      
      private var _mapType:uint;
      
      private var _taskType:uint;
      
      private var _taskID:uint;
      
      private const BOX_ID_ARRAY:Array = [30030,30031,30032];
      
      private const MC_POS_ARRAY:Array = [716.05,132.8,555.6,69.1,433.35,11];
      
      public function TeamTaskManager()
      {
         super();
      }
      
      public static function get instance() : TeamTaskManager
      {
         if(_instance == null)
         {
            _instance = new TeamTaskManager();
         }
         return _instance;
      }
      
      public static function addEventListner(param1:String, param2:Function) : void
      {
         instance.addEventListner(param1,param2);
      }
      
      public static function removeEventListener(param1:String, param2:Function) : void
      {
         instance.removeEvenListner(param1,param2);
      }
      
      public static function dispatchEvent(param1:Event) : void
      {
         instance.dispatchEvent(param1);
      }
      
      public static function destroy() : void
      {
         if(_instance)
         {
            _instance.destroy();
         }
         _instance = null;
      }
      
      public function setup() : void
      {
         this._ed = new EventDispatcher();
         this.addEvent();
         this.removeProcessTask();
      }
      
      private function removeProcessTask() : void
      {
         var _loc3_:int = 0;
         var _loc1_:int = int(ActivityExchangeTimesManager.getTimes(9255));
         var _loc2_:Array = TasksManager.getTasksByType(13);
         if(_loc1_ == 0 && _loc2_.length > 0)
         {
            for each(_loc3_ in _loc2_)
            {
               if(TasksManager.isAccepted(_loc3_))
               {
                  TasksManager.quit(_loc3_);
               }
            }
         }
      }
      
      private function addEvent() : void
      {
         SocketConnection.addCmdListener(CommandID.TEAM_TASK_INFO,this.onTeamTaskInfo);
         SocketConnection.addCmdListener(CommandID.SUMMON_NPC_STATUS,this.onBoxChange);
         this.addEventListner(ScenceItemAddEvent.TEAM_TASK_BOX_APPEARED,this.onBoxAppeared);
         NpcDialogController.ed.addEventListener(NPCDialogEvent.INIT,this.onNpcDialogShow);
      }
      
      private function removeEvent() : void
      {
         SocketConnection.removeCmdListener(CommandID.TEAM_TASK_INFO,this.onTeamTaskInfo);
         SocketConnection.removeCmdListener(CommandID.SUMMON_NPC_STATUS,this.onBoxChange);
         TasksManager.removeListener(TaskEvent.ACCEPT,this.onTaskAccept);
         TimeCountDown.instance.removeEventListener(TimeCountDown.COUNT_DOWN_OVER,this.onTimerComplete);
         TasksManager.removeListener(TaskEvent.QUIT,this.onTaskQuit);
         TasksManager.removeListener(TaskEvent.COMPLETE,this.onTaskComplete);
         FightGroupManager.instance.ed.removeEventListener(FightGroupManager.FIGHT_GROUP_QUIT,this.onGroupChange);
         FightGroupManager.instance.ed.removeEventListener(FightGroupManager.FIGHT_GROUP_CHANGE,this.onGroupChange);
      }
      
      private function onNpcDialogShow(param1:NPCDialogEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:DialogInfoMultiple = null;
         var _loc8_:String = null;
         var _loc2_:uint = uint(param1.npcID);
         if(_loc2_ >= 10504 && _loc2_ <= 10509)
         {
            NpcDialogController.hide();
            if(this._taskID != 0 && !TasksManager.isReady(this._taskID))
            {
               AlertManager.showSimpleAlarm("小侠士，你身上还有未完成的初探仙界的任务！");
               return;
            }
            _loc3_ = 0;
            _loc4_ = 0;
            _loc5_ = "你的任务不是从我这里接取的，请去别处交付吧！";
            switch(_loc2_)
            {
               case 10504:
                  if(this._taskID == 0)
                  {
                     _loc3_ = this.getRandomTaskID(1969,2003);
                     if(_loc3_ == 0)
                     {
                        return;
                     }
                     _loc4_ = 1;
                  }
                  break;
               case 10505:
                  if(this._taskID == 0)
                  {
                     _loc3_ = this.getRandomTaskID(1971,1988);
                     if(_loc3_ == 0)
                     {
                        return;
                     }
                     _loc4_ = 2;
                     break;
                  }
                  if(!this.checkLimits(1971,1988))
                  {
                     AlertManager.showSimpleAlarm(_loc5_);
                     return;
                  }
                  break;
               case 10506:
                  if(this._taskID == 0)
                  {
                     _loc3_ = this.getRandomTaskID(1989,2003);
                     if(_loc3_ == 0)
                     {
                        return;
                     }
                     _loc4_ = 2;
                     break;
                  }
                  if(!this.checkLimits(1989,2003))
                  {
                     AlertManager.showSimpleAlarm(_loc5_);
                     return;
                  }
                  break;
               case 10507:
                  if(this._taskID == 0)
                  {
                     _loc3_ = this.getRandomTaskID(1971,1988);
                     if(_loc3_ == 0)
                     {
                        return;
                     }
                     _loc4_ = 3;
                     break;
                  }
                  if(!this.checkLimits(1971,1988))
                  {
                     AlertManager.showSimpleAlarm(_loc5_);
                     return;
                  }
                  break;
               case 10508:
                  if(this._taskID == 0)
                  {
                     _loc3_ = this.getRandomTaskID(1989,1999);
                     if(_loc3_ == 0)
                     {
                        return;
                     }
                     _loc4_ = 3;
                     break;
                  }
                  if(!this.checkLimits(1989,1999))
                  {
                     AlertManager.showSimpleAlarm(_loc5_);
                     return;
                  }
                  break;
               case 10509:
                  if(this._taskID == 0)
                  {
                     _loc3_ = this.getRandomTaskID(2000,2003);
                     if(_loc3_ == 0)
                     {
                        return;
                     }
                     _loc4_ = 3;
                     break;
                  }
                  if(!this.checkLimits(2000,2003))
                  {
                     AlertManager.showSimpleAlarm(_loc5_);
                     return;
                  }
            }
            if(this._taskID == 0)
            {
               switch(_loc4_)
               {
                  case 1:
                     _loc8_ = "天界之路，孤星镇守，孤星封魔阵只考验个人。在我这里接取考验任务，在10分钟内完成并来我这里交付，我将开启阵法，送你宝箱（可能开出金龙珠哦）。";
                     break;
                  case 2:
                     _loc8_ = "天界之路，阴阳镇守，两仪八卦阵考验两人。两人组队才能在我们这里接取考验任务，在10分钟内你们两人都交付任务后，我们将开启阵法，送你宝箱（可能开出冰魄魂石哦）。记住，接取任务后，若其中一个放弃，本次任务算作失败，你们两人都需要重新接取任务！";
                     break;
                  case 3:
                     _loc8_ = "天界之路，三才镇守，三才归元阵考验三人。三人组队才能在我们这里接取任务，在10分钟内你们三人都交付任务后，我们将开启阵法，送你宝箱（可能开出神之光明碎片哦）。记住，接取任务后，若其中一个放弃，本次任务算作失败，你们三人都需要重新接取任务！";
               }
               _loc6_ = ["仙界考验(接受仙界考验扣除5万功夫豆哦)"];
               _loc7_ = new DialogInfoMultiple([_loc8_],_loc6_);
               NpcDialogController.showForMultiple(_loc7_,_loc2_,Delegate.create(this.taskAccept,_loc2_,_loc3_,_loc4_));
            }
            else
            {
               _loc7_ = new DialogInfoMultiple([TasksXMLInfo.getEndDoc(this._taskID)],["是的，已完成！"]);
               NpcDialogController.showForMultiple(_loc7_,_loc2_,this.taskComplete);
            }
         }
      }
      
      private function getRandomTaskID(param1:uint, param2:uint) : uint
      {
         var _loc3_:uint = param2 - param1 + 1;
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         while(!TasksManager.isAcceptable(_loc4_))
         {
            _loc4_ = param1 + uint(_loc3_ * Math.random());
            if(++_loc5_ > 9999)
            {
               AlertManager.showSimpleAlarm("人品太差了！");
               return 0;
            }
         }
         return _loc4_;
      }
      
      private function checkLimits(param1:uint, param2:uint) : Boolean
      {
         return this._taskID >= param1 && this._taskID <= param2;
      }
      
      private function taskAccept(param1:uint, param2:uint, param3:uint) : void
      {
         if(MainManager.actorInfo.coins < 50000)
         {
            AlertManager.showSimpleAlarm("小侠士，你身上的功夫豆不足5万！");
            return;
         }
         switch(param3)
         {
            case 1:
               if(FightGroupManager.instance.groupId != 0)
               {
                  AlertManager.showSimpleAlarm("小侠士，请解除组队后再来接取单人任务！");
                  return;
               }
               break;
            case 2:
               if(FightGroupManager.instance.groupId == 0 || FightGroupManager.instance.groupUserList.length != 2)
               {
                  AlertManager.showSimpleAlarm("小侠士，接取此初探仙界任务需要组两人队！");
                  return;
               }
               break;
            case 3:
               if(FightGroupManager.instance.groupId == 0 || FightGroupManager.instance.groupUserList.length != 3)
               {
                  AlertManager.showSimpleAlarm("小侠士，接取此初探仙界任务需要组三人队！");
                  return;
               }
               break;
            default:
               return;
         }
         ActivityExchangeCommander.exchange(2697);
         var _loc4_:Array = ["我接受考验","让我想想(重新接任务要扣除功夫豆哦！)"];
         var _loc5_:DialogInfoMultiple = new DialogInfoMultiple([TasksXMLInfo.getDoc(param2)],_loc4_);
         NpcDialogController.showForMultiple(_loc5_,param1,Delegate.create(this.confirmAccept,param2));
      }
      
      private function confirmAccept(param1:uint) : void
      {
         TasksManager.addListener(TaskEvent.ACCEPT,this.onTaskAccept);
         TasksManager.accept(param1,false,CommandID.TASK_ACTIVITY_ACCEPT);
      }
      
      private function onTaskAccept(param1:TaskEvent) : void
      {
         var _loc2_:uint = uint(param1.taskID);
         if(TasksXMLInfo.getType(_loc2_) == 13)
         {
            TasksManager.removeListener(TaskEvent.ACCEPT,this.onTaskAccept);
            this._taskID = _loc2_;
            this._taskType = MapManager.currentMap.info.id - 1045 + 1;
            TimeCountDown.instance.start(600,-120,130);
            TimeCountDown.instance.addEventListener(TimeCountDown.COUNT_DOWN_OVER,this.onTimerComplete);
            TasksManager.addListener(TaskEvent.QUIT,this.onTaskQuit);
            FightGroupManager.instance.ed.addEventListener(FightGroupManager.FIGHT_GROUP_QUIT,this.onGroupChange);
            FightGroupManager.instance.ed.addEventListener(FightGroupManager.FIGHT_GROUP_CHANGE,this.onGroupChange);
            FunctionManager.disabledFightGroup = true;
            TextAlert.show("恭喜你接受初探仙界考验，可在任务簿查看任务，记得10分钟内来交任务哦！");
         }
      }
      
      private function onTimerComplete(param1:Event) : void
      {
         AlertManager.showSimpleAlarm("时间已到，小侠士未能完成任务，下次再接再厉！");
         TasksManager.addListener(TaskEvent.QUIT,this.onTaskQuit);
         TasksManager.quit(this._taskID);
      }
      
      private function onGroupChange(param1:Event) : void
      {
         var _loc2_:Boolean = false;
         switch(this._taskType)
         {
            case 1:
               if(FightGroupManager.instance.groupId != 0)
               {
                  _loc2_ = true;
               }
               break;
            case 2:
               if(FightGroupManager.instance.groupId == 0 || FightGroupManager.instance.groupUserList.length != 2)
               {
                  _loc2_ = true;
               }
               break;
            case 3:
               if(FightGroupManager.instance.groupId == 0 || FightGroupManager.instance.groupUserList.length != 3)
               {
                  _loc2_ = true;
               }
         }
         if(_loc2_ && this._taskID != 0)
         {
            AlertManager.showSimpleAlarm("小侠士，你的组队发生变动，不满足初探仙界的任务要求，请重新接取。");
            TasksManager.addListener(TaskEvent.QUIT,this.onTaskQuit);
            TasksManager.quit(this._taskID);
         }
      }
      
      private function onTaskQuit(param1:TaskEvent) : void
      {
         var _loc2_:uint = uint(param1.taskID);
         if(TasksXMLInfo.getType(_loc2_) == 13)
         {
            TasksManager.removeListener(TaskEvent.QUIT,this.onTaskQuit);
            this.removeTask();
         }
      }
      
      private function taskComplete() : void
      {
         TasksManager.addListener(TaskEvent.COMPLETE,this.onTaskComplete);
         TasksManager.taskComplete(this._taskID,1);
      }
      
      private function onTaskComplete(param1:TaskEvent) : void
      {
         var _loc2_:uint = uint(param1.taskID);
         if(TasksXMLInfo.getType(_loc2_) == 13)
         {
            TasksManager.removeListener(TaskEvent.COMPLETE,this.onTaskComplete);
            this.removeTask();
         }
      }
      
      private function removeTask() : void
      {
         this._taskID = 0;
         this._taskType = 0;
         FightGroupManager.instance.ed.removeEventListener(FightGroupManager.FIGHT_GROUP_QUIT,this.onGroupChange);
         FightGroupManager.instance.ed.removeEventListener(FightGroupManager.FIGHT_GROUP_CHANGE,this.onGroupChange);
         FunctionManager.disabledFightGroup = false;
         this.removeTimeDown();
      }
      
      private function removeTimeDown() : void
      {
         TimeCountDown.instance.removeEventListener(TimeCountDown.COUNT_DOWN_OVER,this.onTimerComplete);
         TimeCountDown.destroy();
      }
      
      private function onTeamTaskInfo(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         if(this._taskType == 0 || this._taskType == 1)
         {
            return;
         }
         switch(_loc4_)
         {
            case 1:
               TextAlert.show("当前组队已经有" + _loc3_ + "人开始初探仙界任务。");
               break;
            case 2:
               TextAlert.show("当前组队中有人放弃了初探仙界任务。");
               break;
            case 3:
               TextAlert.show("当前组队已经有" + _loc3_ + "人完成了初探仙界任务。");
         }
      }
      
      public function set taskType(param1:uint) : void
      {
         this._taskType = param1;
      }
      
      public function get taskType() : uint
      {
         return this._taskType;
      }
      
      public function get taskID() : uint
      {
         return this._taskID;
      }
      
      private function onBoxChange(param1:SocketEvent) : void
      {
         var mapID:uint;
         var status:uint;
         var itemID:uint = 0;
         var pos:Point = null;
         var index:uint = 0;
         var mc:MovieClip = null;
         var event:SocketEvent = param1;
         var data:ByteArray = event.data as ByteArray;
         data.position = 0;
         itemID = data.readUnsignedInt();
         mapID = data.readUnsignedInt();
         pos = new Point(data.readUnsignedInt(),data.readUnsignedInt());
         status = data.readUnsignedInt();
         if(this.BOX_ID_ARRAY.indexOf(itemID) == -1)
         {
            return;
         }
         if(mapID == MapManager.currentMap.info.id)
         {
            if(status == 1)
            {
               index = uint(this.BOX_ID_ARRAY.indexOf(itemID));
               mc = UIManager.getMovieClip("TeamTaskMC_" + mapID);
               if(Boolean(mc) && index != -1)
               {
                  mc.x = this.MC_POS_ARRAY[index * 2];
                  mc.y = this.MC_POS_ARRAY[index * 2 + 1];
                  MapManager.currentMap.contentLevel.addChild(mc);
                  MainManager.closeOperate(true);
                  setTimeout(function():void
                  {
                     MainManager.openOperate();
                     DisplayUtil.removeForParent(mc);
                     mc = null;
                     TextAlert.show("恭喜你完成考验，得到奖励宝箱，赶紧去开启宝物吧！");
                     creatBox(itemID,pos);
                  },1500);
               }
            }
            else
            {
               this.deleteBox(mapID,itemID);
            }
         }
      }
      
      private function onBoxAppeared(param1:ScenceItemAddEvent) : void
      {
         this.creatBox(param1.itemID,param1.position);
      }
      
      private function creatBox(param1:uint, param2:Point) : void
      {
         var _loc5_:UserInfo = null;
         var _loc6_:KeyboardModel = null;
         var _loc3_:uint = uint(MapManager.currentMap.info.id);
         var _loc4_:uint = _loc3_ * 100000 + param1;
         if(!UserManager.contains(_loc4_))
         {
            _loc5_ = new UserInfo();
            _loc5_.roleType = param1;
            _loc5_.userID = _loc4_;
            _loc5_.pos = param2;
            _loc5_.nick = RoleXMLInfo.getName(param1);
            _loc6_ = new KeyboardModel(_loc5_);
            UserManager.add(_loc4_,_loc6_);
            HiddenManager.addMoveEventForStandMap();
            HiddenManager.add(_loc4_,_loc6_);
            HiddenManager.addEventListener(HiddenEvent.OPEN,this.onBoxOpen);
            MapManager.currentMap.contentLevel.addChild(_loc6_);
            MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         }
      }
      
      private function onBoxOpen(param1:HiddenEvent) : void
      {
         var _loc2_:HiddenModel = param1.model;
         var _loc3_:uint = uint(_loc2_.info.roleType);
         var _loc4_:int = this.BOX_ID_ARRAY.indexOf(_loc3_);
         if(_loc4_ != -1)
         {
            HiddenManager.removeMoveEventForStandMap();
            UserManager.remove(_loc2_.info.userID);
            HiddenManager.remove(_loc2_.info.userID);
            _loc2_.destroy();
            ActivityExchangeCommander.exchange(2666 + _loc4_);
         }
      }
      
      private function deleteBox(param1:uint, param2:uint) : void
      {
         var _loc3_:uint = param1 * 100000 + param2;
         var _loc4_:UserModel = UserManager.remove(_loc3_);
         if(_loc4_)
         {
            HiddenManager.removeMoveEventForStandMap();
            HiddenManager.remove(_loc3_);
            _loc4_.destroy();
            MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         }
      }
      
      private function onMapSwitchComplete(param1:MapEvent) : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         HiddenManager.removeMoveEventForStandMap();
      }
      
      public function addEventListner(param1:String, param2:Function) : void
      {
         this._ed.addEventListener(param1,param2);
      }
      
      public function removeEvenListner(param1:String, param2:Function) : void
      {
         this._ed.removeEventListener(param1,param2);
      }
      
      public function dispatchEvent(param1:Event) : void
      {
         this._ed.dispatchEvent(param1);
      }
      
      public function destroy() : void
      {
         this.removeEvent();
         this._ed = null;
      }
   }
}

