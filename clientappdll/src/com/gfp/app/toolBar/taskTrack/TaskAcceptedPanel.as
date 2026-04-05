package com.gfp.app.toolBar.taskTrack
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.ActivityExchangeAwardInfo;
   import com.gfp.core.info.task.TaskConfigInfo;
   import com.gfp.core.info.task.TaskType;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.manager.UserInfoManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.TimeUtil;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.net.SocketEvent;
   
   public class TaskAcceptedPanel extends TaskBasePreviewPanel
   {
      
      public static const TASK_TRACK_TYPES:Array = [1,2,3,4,5,7,16,14,17];
      
      private static var _hasSendXuanShangLing:Boolean = false;
      
      private var _taskIds:Array;
      
      private var _back:MovieClip;
      
      private var _laterUpdate:uint;
      
      private var _specialTaskId:Array;
      
      private var _isFirstLoad:Boolean = true;
      
      private const _advanceTaskIds:Array = [1725,1726,1727,1728,1729,1331,1332,1333,1921,1922,1923,1924,1925,1926];
      
      private const _turnBackTaskIds:Array = [2081,2082,2083,2084,2090];
      
      private var hasGetedDaily:Boolean = false;
      
      private var isSending:Boolean = false;
      
      public function TaskAcceptedPanel()
      {
         super();
         this.initList();
         TasksManager.addListener(TaskEvent.ACCEPT,this.onAccept);
         TasksManager.addListener(TaskEvent.PRO_COMPLETE,this.onProComplete);
         TasksManager.addListener(TaskEvent.COMPLETE,this.onComplete);
         TasksManager.addListener(TaskEvent.QUIT,this.onQuit);
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         UserInfoManager.ed.addEventListener(UserEvent.LVL_CHANGE,this.onLevelChange);
         UserManager.addEventListener(UserEvent.TURN_BACK,this.onLevelChange);
         FightManager.instance.addEventListener(FightEvent.QUITE,this.onFightQuit);
         this._laterUpdate = setTimeout(this.initList,1000);
         this._isFirstLoad = false;
      }
      
      private function getSpecailTask(param1:Array, param2:int = 2) : Array
      {
         var _loc5_:int = 0;
         var _loc6_:TaskConfigInfo = null;
         var _loc3_:Array = this._advanceTaskIds.concat(this._turnBackTaskIds);
         var _loc4_:Array = [];
         for each(_loc5_ in param1)
         {
            _loc6_ = TasksXMLInfo.getTaskConfigInfoByID(_loc5_);
            if((Boolean(_loc6_)) && (Boolean(_loc6_.type == 4 || _loc6_.type == 16)) && _loc3_.indexOf(_loc5_) == -1)
            {
               _loc4_.push(_loc5_);
            }
         }
         _loc4_.sort(this.sortTaskId);
         if(_loc4_.length > param2)
         {
            _loc4_ = _loc4_.slice(_loc4_.length - param2,_loc4_.length);
         }
         return _loc4_;
      }
      
      private function initList() : void
      {
         var _loc2_:int = 0;
         var _loc3_:TaskAcceptedItem = null;
         if(this._laterUpdate != 0)
         {
            clearTimeout(this._laterUpdate);
            this._laterUpdate = 0;
         }
         this.clearList();
         _list = new Array();
         var _loc1_:Array = this.getTraceTasks();
         for each(_loc2_ in _loc1_)
         {
            _loc3_ = new TaskAcceptedItem(_loc2_,TasksXMLInfo.getType(_loc2_));
            if(isExpanded)
            {
               _loc3_.expandOn();
            }
            _loc3_.addEventListener(TaskAcceptedItem.LIST_FOLDCHANGE,this.onListFlodChange);
            _list.push(_loc3_);
         }
         this._taskIds = _loc1_;
         updateListShow();
      }
      
      private function removeSame(param1:Array) : Array
      {
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(_loc2_.indexOf(param1[_loc3_]) == -1)
            {
               _loc2_.push(param1[_loc3_]);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      override protected function setMainUI() : void
      {
         super.setMainUI();
         this._back = _mainUI["back"];
         this._back.visible = true;
         this.hideBack();
         _container.addChild(this._back);
      }
      
      public function hideBack() : void
      {
         if(this._back)
         {
            this._back.x = -300;
            this._back.y = -300;
         }
      }
      
      override protected function clearContainer() : void
      {
         super.clearContainer();
         _container.addChild(this._back);
      }
      
      private function getSepcialAcceptableArray(param1:int = 2) : Array
      {
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc2_:Array = [4,16];
         var _loc3_:Array = [];
         if(!MainManager.isNewUser())
         {
            for each(_loc4_ in _loc2_)
            {
               _loc5_ = TasksXMLInfo.getAllTaskByType(_loc4_);
               _loc3_ = _loc3_.concat(_loc5_);
            }
            _loc3_ = _loc3_.filter(this.filterAcceptableList);
            _loc3_ = this.getSpecailTask(_loc3_,param1);
         }
         return _loc3_;
      }
      
      private function getNormalAcceptableArray() : Array
      {
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc1_:Array = [1,2,5];
         var _loc2_:Array = [];
         for each(_loc3_ in _loc1_)
         {
            _loc4_ = TasksXMLInfo.getAllTaskByType(_loc3_);
            _loc2_ = _loc2_.concat(_loc4_);
         }
         return _loc2_.filter(this.filterAcceptableList);
      }
      
      private function filterAcceptedList(param1:uint, param2:uint, param3:Array) : Boolean
      {
         var _loc4_:TaskConfigInfo = TasksXMLInfo.getTaskConfigInfoByID(param1);
         if((Boolean(_loc4_)) && (_loc4_.type == 10 || _loc4_.type == 17))
         {
            return false;
         }
         if(_loc4_)
         {
            return _loc4_.displayInAccepted;
         }
         return false;
      }
      
      private function filterAcceptableList(param1:uint, param2:uint, param3:Array) : Boolean
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc4_:TaskConfigInfo = TasksXMLInfo.getTaskConfigInfoByID(param1);
         var _loc5_:Boolean = Boolean(_loc4_.displayInAcceptable) && Boolean(TasksManager.isAcceptable(param1));
         if(Boolean(_loc4_) && _loc5_)
         {
            if(_loc4_.type == 2)
            {
               _loc6_ = int(MainManager.actorInfo.lv);
               _loc7_ = _loc4_.taskLevel != 0 ? int(_loc4_.taskLevel) : int(_loc4_.roleLevel);
               if(_loc6_ - _loc7_ >= 0 && _loc6_ - _loc7_ <= 5)
               {
                  return true;
               }
               return false;
            }
         }
         return _loc5_;
      }
      
      private function sortTaskId(param1:int, param2:int) : int
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc3_:int = int(TasksXMLInfo.getType(param1));
         var _loc4_:int = int(TasksXMLInfo.getType(param2));
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         _loc5_ = int(TasksXMLInfo.getTaskQualityLevel(param1));
         _loc6_ = int(TasksXMLInfo.getTaskQualityLevel(param2));
         if(_loc5_ > _loc6_)
         {
            return -1;
         }
         if(_loc5_ < _loc6_)
         {
            return 1;
         }
         if(param1 > param2)
         {
            return 1;
         }
         if(param1 < param2)
         {
            return -1;
         }
         return 0;
      }
      
      public function getTraceTasks() : Array
      {
         var _loc9_:int = 0;
         var _loc1_:Array = TasksManager.taskHash.getKeys();
         _loc1_.sort(this.sortAcceptedArr);
         _loc1_ = _loc1_.filter(this.filterAcceptedList);
         var _loc2_:Array = this.getMustAcceptableTask();
         _loc2_.sort(this.sortQuality);
         var _loc3_:int = this.getTypeCount([4,16],_loc1_) + _loc2_.length;
         var _loc4_:Array = this.getNormalAcceptableArray();
         _loc4_.sort(this.sortQuality);
         var _loc5_:int = 5 - _loc4_.length;
         _loc5_ = _loc5_ - _loc3_;
         var _loc6_:Array = [];
         if(_loc5_ > 0)
         {
            _loc6_ = this.getSepcialAcceptableArray(_loc5_);
         }
         var _loc7_:Array = _loc1_.concat(_loc2_).concat(_loc4_).concat(_loc6_);
         var _loc8_:Array = TasksXMLInfo.getAllTaskByType(TaskType.EVERYDAY_TASK);
         var _loc10_:int = 0;
         while(_loc10_ < _loc8_.length)
         {
            _loc9_ = int(_loc8_[_loc10_]);
            if(Boolean(TasksManager.isAcceptable(_loc9_)) || Boolean(TasksManager.isAccepted(_loc9_)))
            {
               _loc7_.unshift(_loc9_);
            }
            _loc10_++;
         }
         return this.removeSame(_loc7_);
      }
      
      private function onTaskExchangeComplete(param1:Event) : void
      {
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onTaskExchangeComplete);
         ActivityExchangeTimesManager.addEventListener(8299,this.getXuanShangTaskIdBack);
         ActivityExchangeTimesManager.getActiviteTimeInfo(8299);
      }
      
      private function getDailyTaskIdBack(param1:Event) : void
      {
         ActivityExchangeTimesManager.removeEventListener(8113,this.getDailyTaskIdBack);
         this.initList();
      }
      
      private function getXuanShangTaskIdBack(param1:Event) : void
      {
         ActivityExchangeTimesManager.removeEventListener(8299,this.getXuanShangTaskIdBack);
         this.initList();
      }
      
      private function checkDailyTaskStatus() : int
      {
         if(!MainManager.actorInfo.isTurnBack && MainManager.actorInfo.lv >= 40)
         {
            if(MainManager.actorInfo.lv < 50)
            {
               if(ActivityExchangeTimesManager.getTimes(8314) == 0)
               {
                  return 1;
               }
            }
            else if(MainManager.actorInfo.lv < 60)
            {
               if(ActivityExchangeTimesManager.getTimes(8315) == 0)
               {
                  return 2;
               }
            }
            else if(MainManager.actorInfo.lv < 70)
            {
               if(ActivityExchangeTimesManager.getTimes(8316) == 0)
               {
                  return 3;
               }
            }
            else
            {
               if(MainManager.actorInfo.lv >= 80)
               {
                  return 5;
               }
               if(ActivityExchangeTimesManager.getTimes(8317) == 0)
               {
                  return 4;
               }
            }
         }
         if(Boolean(MainManager.actorInfo.isTurnBack) && MainManager.actorInfo.lv >= 80)
         {
            if(MainManager.actorInfo.lv < 90)
            {
               if(ActivityExchangeTimesManager.getTimes(9326) == 0)
               {
                  return 6;
               }
            }
            else if(MainManager.actorInfo.lv < 100)
            {
               if(ActivityExchangeTimesManager.getTimes(9327) == 0)
               {
                  return 7;
               }
            }
            else if(MainManager.actorInfo.lv < 105)
            {
               if(ActivityExchangeTimesManager.getTimes(9328) == 0)
               {
                  return 8;
               }
            }
            else if(MainManager.actorInfo.lv < 110)
            {
               if(ActivityExchangeTimesManager.getTimes(9329) == 0)
               {
                  return 9;
               }
            }
            else
            {
               if(MainManager.actorInfo.lv > 115)
               {
                  return 5;
               }
               if(ActivityExchangeTimesManager.getTimes(9330) == 0)
               {
                  return 10;
               }
            }
         }
         return 0;
      }
      
      private function onRandomDailyTaskComplete(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.ACTIVITY_EXCHANGE,this.onRandomDailyTaskComplete);
         var _loc2_:ActivityExchangeAwardInfo = param1.data as ActivityExchangeAwardInfo;
         ActivityExchangeTimesManager.updateTimes(int(_loc2_.addVec[0].id),_loc2_.addVec[0].count);
         this.initList();
         ActivityExchangeTimesManager.addEventListener(8113,this.getDailyTaskIdBack);
         ActivityExchangeTimesManager.getActiviteTimeInfo(8113);
      }
      
      private function getTypeCount(param1:Array, param2:Array) : int
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = int(param2.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = int(param2[_loc5_]);
            _loc7_ = int(TasksXMLInfo.getType(_loc6_));
            if(param1.indexOf(_loc6_) != -1)
            {
               _loc3_++;
            }
            _loc5_++;
         }
         return _loc3_;
      }
      
      private function getMustAcceptableTask() : Array
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc1_:Array = [];
         if(!MainManager.isNewUser())
         {
            _loc2_ = int(this._advanceTaskIds.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = int(this._advanceTaskIds[_loc3_]);
               if(TasksManager.isAcceptable(_loc4_))
               {
                  _loc1_.push(_loc4_);
                  break;
               }
               _loc3_++;
            }
            _loc2_ = int(this._turnBackTaskIds.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = int(this._turnBackTaskIds[_loc3_]);
               if(TasksManager.isAcceptable(_loc4_))
               {
                  _loc1_.push(_loc4_);
                  break;
               }
               _loc3_++;
            }
         }
         return _loc1_;
      }
      
      private function sortQuality(param1:int, param2:int) : int
      {
         var _loc3_:int = int(TasksXMLInfo.getTaskQualityLevel(param1));
         var _loc4_:int = int(TasksXMLInfo.getTaskQualityLevel(param2));
         if(_loc3_ > _loc4_)
         {
            return -1;
         }
         if(_loc3_ < _loc4_)
         {
            return 1;
         }
         return 0;
      }
      
      private function sortAcceptedArr(param1:int, param2:int) : int
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc3_:Boolean = Boolean(TasksManager.isReady(param1));
         var _loc4_:Boolean = Boolean(TasksManager.isReady(param2));
         if(_loc3_ && !_loc4_)
         {
            return -1;
         }
         if(!_loc3_ && _loc4_)
         {
            return 1;
         }
         _loc5_ = int(TasksXMLInfo.getTaskQualityLevel(param1));
         _loc6_ = int(TasksXMLInfo.getTaskQualityLevel(param2));
         if(_loc5_ > _loc6_)
         {
            return -1;
         }
         if(_loc5_ < _loc6_)
         {
            return 1;
         }
         _loc7_ = uint(TasksManager.getTaskTime(param1));
         _loc8_ = uint(TasksManager.getTaskTime(param2));
         if(_loc7_ > _loc8_)
         {
            return -1;
         }
         return 1;
      }
      
      public function getTaskArea(param1:int) : Rectangle
      {
         var _loc2_:TaskAcceptedItem = null;
         var _loc3_:TaskAcceptedItem = null;
         var _loc4_:Rectangle = null;
         var _loc5_:Point = null;
         for each(_loc3_ in _list)
         {
            if(_loc3_.taskID == param1)
            {
               _loc2_ = _loc3_;
               break;
            }
         }
         if(_loc2_)
         {
            _loc4_ = new Rectangle();
            _loc4_.width = _loc2_.width;
            _loc4_.height = _loc2_.height;
            _loc5_ = _loc2_.localToGlobal(new Point(0,0));
            _loc4_.x = _loc5_.x;
            _loc4_.y = _loc5_.y;
            return _loc4_;
         }
         return null;
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:TaskAcceptedItem = null;
         var _loc3_:TaskAcceptedItem = null;
         for each(_loc3_ in _list)
         {
            if(_loc3_.hitTestPoint(param1.stageX,param1.stageY))
            {
               _loc2_ = _loc3_;
               break;
            }
         }
         if(_loc2_)
         {
            TweenLite.killTweensOf(_loc2_);
            TweenLite.to(this._back,0.2,{
               "y":_loc2_.y,
               "height":_loc2_.height
            });
            this._back.x = _loc2_.x - 4;
            this._back.width = _loc2_.width;
         }
      }
      
      override public function set isExpanded(param1:Boolean) : void
      {
         var _loc2_:TaskAcceptedItem = null;
         if(isExpanded == param1)
         {
            return;
         }
         super.isExpanded = param1;
         if(param1)
         {
            for each(_loc2_ in _list)
            {
               _loc2_.expandOn();
            }
         }
         else
         {
            for each(_loc2_ in _list)
            {
               _loc2_.expandOff();
            }
         }
         updateListShow();
      }
      
      private function onListFlodChange(param1:Event) : void
      {
         updateListShow();
      }
      
      private function onAccept(param1:TaskEvent) : void
      {
         var _loc2_:uint = uint(param1.taskID);
         var _loc3_:uint = uint(TasksXMLInfo.getType(_loc2_));
         if(TaskAcceptedPanel.TASK_TRACK_TYPES.indexOf(_loc3_) != -1)
         {
            this.initList();
         }
         TasksManager.setTaskTime(_loc2_,TimeUtil.getSeverDateObject().time / 1000);
      }
      
      private function onLevelChange(param1:Event) : void
      {
         this.initList();
      }
      
      private function onProComplete(param1:TaskEvent) : void
      {
         var _loc2_:uint = uint(param1.taskID);
         if(Boolean(this._taskIds) && this._taskIds.indexOf(_loc2_) != -1)
         {
            this.initList();
         }
         TasksManager.setTaskTime(_loc2_,TimeUtil.getSeverDateObject().time / 1000);
      }
      
      private function onComplete(param1:TaskEvent) : void
      {
         var _loc2_:uint = uint(param1.taskID);
         if(Boolean(this._taskIds) && this._taskIds.indexOf(_loc2_) != -1)
         {
            this.initList();
         }
         TasksManager.setTaskTime(_loc2_,TimeUtil.getSeverDateObject().time / 1000);
      }
      
      private function onQuit(param1:TaskEvent) : void
      {
         var _loc2_:uint = uint(param1.taskID);
         this.removeTask(_loc2_);
      }
      
      private function removeTask(param1:uint) : void
      {
         var id:uint = param1;
         _list.some(function(param1:TaskAcceptedItem, param2:int, param3:Array):Boolean
         {
            if(param1.taskID == id)
            {
               param1.removeEventListener(TaskAcceptedItem.LIST_FOLDCHANGE,onListFlodChange);
               param1.destroy();
               param1 = null;
               param3.splice(param2,1);
               return true;
            }
            return false;
         });
         updateListShow();
      }
      
      private function clearList() : void
      {
         var _loc1_:TaskAcceptedItem = null;
         this.hideBack();
         if(_list)
         {
            for each(_loc1_ in _list)
            {
               _loc1_.removeEventListener(TaskAcceptedItem.LIST_FOLDCHANGE,this.onListFlodChange);
               _loc1_.destroy();
            }
            _list = null;
         }
      }
      
      override protected function removeEvent() : void
      {
         var _loc1_:TaskAcceptedItem = null;
         super.removeEvent();
         TasksManager.removeListener(TaskEvent.ACCEPT,this.onAccept);
         TasksManager.removeListener(TaskEvent.COMPLETE,this.onComplete);
         TasksManager.removeListener(TaskEvent.QUIT,this.onQuit);
         removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         UserInfoManager.ed.removeEventListener(UserEvent.LVL_CHANGE,this.onLevelChange);
         UserManager.removeEventListener(UserEvent.TURN_BACK,this.onLevelChange);
         FightManager.instance.removeEventListener(FightEvent.QUITE,this.onFightQuit);
         for each(_loc1_ in _list)
         {
            if(_loc1_)
            {
               _loc1_.removeEventListener(TaskAcceptedItem.LIST_FOLDCHANGE,this.onListFlodChange);
            }
         }
      }
      
      private function onFightQuit(param1:Event) : void
      {
         this.initList();
      }
   }
}

