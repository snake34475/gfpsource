package com.gfp.app.toolBar.taskTrack
{
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.info.CurrentChainTaskInfo;
   import com.gfp.core.info.task.TaskBufInfo;
   import com.gfp.core.info.task.TaskConditionListInfo;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.manager.UIManager;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import org.taomee.utils.DisplayUtil;
   
   public class TaskAcceptedItem extends Sprite
   {
      
      public static const LIST_FOLDCHANGE:String = "list_foldchange";
      
      public static const TASK_PROCESS:uint = 0;
      
      public static const TASK_READY:uint = 1;
      
      public static const TASK_CANACCEPT:uint = 2;
      
      public static const TASK_ACCEPTED:uint = 3;
      
      private var _mainUI:Sprite;
      
      private var _taskID:uint;
      
      private var _type:int;
      
      private var _acceptTime:uint;
      
      private var _isExpand:MovieClip;
      
      private var _expandBtn:SimpleButton;
      
      private var _labelBtn:SimpleButton;
      
      private var _stateTxt:MovieClip;
      
      private var _labelTxt:TextField;
      
      private var _taskItemList:TaskAcceptedDetailList;
      
      private var _taskBuff:TaskBufInfo;
      
      private var _conditions:TaskConditionListInfo;
      
      private var _chainID:uint;
      
      private var _listCon:Sprite;
      
      private var _state:uint;
      
      private var _isNew:Boolean;
      
      public function TaskAcceptedItem(param1:int, param2:int)
      {
         var _loc3_:Boolean = false;
         super();
         this._mainUI = UIManager.getMovieClip("UI_TaskAcceptedItem");
         addChild(this._mainUI);
         this._isExpand = this._mainUI["expand"];
         this._isExpand.gotoAndStop(1);
         this._expandBtn = this._mainUI["expandBtn"];
         this._expandBtn.addEventListener(MouseEvent.CLICK,this.onExpandClick);
         this._labelBtn = this._mainUI["labelBtn"];
         this._labelBtn.addEventListener(MouseEvent.CLICK,this.onLabelClick);
         this._stateTxt = this._mainUI["state"];
         this._labelTxt = this._mainUI["label"];
         this._taskID = param1;
         this._type = param2;
         if(this._taskID > 0)
         {
            this._stateTxt.visible = true;
            _loc3_ = Boolean(TasksManager.isReady(this._taskID));
            if(_loc3_)
            {
               this._stateTxt.gotoAndStop(1);
            }
            else if(TasksManager.isAcceptable(this._taskID))
            {
               this._isNew = true;
               this._stateTxt.gotoAndStop(2);
            }
            else
            {
               this._stateTxt.gotoAndStop(3);
            }
            this._acceptTime = TasksManager.getTaskTime(this._taskID);
         }
         else
         {
            this._stateTxt.visible = false;
         }
         this.setType();
         this.initBuff();
      }
      
      private function setType() : void
      {
         var _loc4_:Array = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:String = null;
         var _loc1_:String = "";
         switch(this._type)
         {
            case 0:
               _loc1_ = "【默认】";
               break;
            case 1:
               _loc1_ = "【主线】";
               break;
            case 2:
               _loc1_ = "【支线】";
               break;
            case 3:
            case 7:
            case 14:
               _loc1_ = "【每日】";
               break;
            case 4:
               _loc1_ = "【特殊】";
               break;
            case 5:
            case 6:
               _loc1_ = "【循环】";
               break;
            case 16:
               _loc1_ = "【剧情】";
               break;
            case 10:
               _loc1_ = "【悬赏令】";
               break;
            case 17:
               _loc1_ = "【每日】";
               break;
            default:
               _loc1_ = "  ";
         }
         if(this._type == 5)
         {
            _loc4_ = TasksManager.getCurrentChainArray(this._taskID);
            if(_loc4_)
            {
               _loc5_ = _loc4_.length;
               _loc6_ = uint(TasksManager.getCurrentChainNum(this._taskID));
               _loc7_ = TasksXMLInfo.getName(this._taskID) + "(" + _loc6_.toString() + "/" + _loc5_.toString() + ")";
            }
            else
            {
               _loc7_ = TasksXMLInfo.getName(this._taskID);
            }
         }
         else if(this._taskID == -1)
         {
            _loc7_ = "经验1";
         }
         else if(this._taskID == -2)
         {
            _loc7_ = "经验2";
         }
         else
         {
            _loc7_ = TasksXMLInfo.getName(this._taskID);
         }
         var _loc2_:uint = uint(TasksXMLInfo.getTaskQualityLevel(this._taskID));
         var _loc3_:String = "";
         switch(_loc2_)
         {
            case 0:
            case 1:
               _loc3_ = "FFFFFF";
               break;
            case 2:
               _loc3_ = "00FF00";
               break;
            case 3:
               _loc3_ = "00EEFF";
               break;
            case 4:
               _loc3_ = "FF00FF";
               break;
            case 5:
               _loc3_ = "FF9900";
               break;
            default:
               _loc3_ = "FFFFFF";
         }
         this._labelTxt.htmlText = "<font color=\'#" + _loc3_ + "\'>" + _loc1_ + _loc7_ + "</font>";
         this._labelTxt.height = this._labelTxt.textHeight + 4;
         this._labelTxt.mouseWheelEnabled = false;
      }
      
      private function initBuff() : void
      {
         var _loc1_:CurrentChainTaskInfo = null;
         if(this._type == 5)
         {
            _loc1_ = TasksManager.getMasterTask(this._taskID);
            if(_loc1_)
            {
               this._chainID = _loc1_.taskCurrentID;
               if(this._chainID == 0)
               {
                  this._chainID = _loc1_.taskCurrentArray[_loc1_.taskCurrentChainNum];
               }
               this._taskBuff = TasksManager.taskHash.getValue(this._chainID) as TaskBufInfo;
               if(this._taskBuff == null)
               {
                  this._taskBuff = new TaskBufInfo();
                  this._taskBuff.create(this._chainID);
               }
               this._conditions = TasksXMLInfo.getCondition(this._chainID);
            }
            TasksManager.addListener(TaskEvent.ACCEPT,this.onAccept);
            TasksManager.addListener(TaskEvent.COMPLETE,this.onComplete);
         }
         else
         {
            this._conditions = TasksXMLInfo.getCondition(this._taskID);
            this._taskBuff = TasksManager.taskHash.getValue(this._taskID) as TaskBufInfo;
         }
         TasksManager.addListener(TaskEvent.PRO_COMPLETE,this.onProComplete);
         TasksManager.addListener(TaskEvent.PRO_CHANGE,this.onProChange);
      }
      
      private function onLabelClick(param1:MouseEvent) : void
      {
         TasksManager.transferToTask(this.taskID);
      }
      
      private function onExpandClick(param1:MouseEvent) : void
      {
         if(this._taskItemList)
         {
            this._isExpand.gotoAndStop(1);
            this.clearList();
         }
         else
         {
            this._isExpand.gotoAndStop(2);
            this.addList();
         }
         this.dispatch();
      }
      
      public function expandOn() : void
      {
         if(this._taskItemList == null)
         {
            this._isExpand.gotoAndStop(2);
            this.addList();
         }
      }
      
      public function expandOff() : void
      {
         if(this._taskItemList)
         {
            this._isExpand.gotoAndStop(1);
            this.clearList();
         }
      }
      
      private function clearList() : void
      {
         DisplayUtil.removeForParent(this._taskItemList);
         this._taskItemList.destroy();
         this._taskItemList = null;
      }
      
      private function addList() : void
      {
         if(this._taskBuff)
         {
            if(this._taskItemList == null)
            {
               this._taskItemList = new TaskAcceptedDetailList(this._taskBuff,this._conditions,this.dispatch,this.getState());
            }
            this._taskItemList.x = 20;
            this._taskItemList.y = this._labelTxt.height - 2;
            addChildAt(this._taskItemList,0);
         }
      }
      
      private function dispatch() : void
      {
         dispatchEvent(new Event(LIST_FOLDCHANGE));
      }
      
      private function onProComplete(param1:TaskEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc2_:uint = uint(param1.taskID);
         if(_loc2_ == this._taskID)
         {
            _loc3_ = this.getState();
            if(this._taskItemList)
            {
               this._taskItemList.setState(_loc3_,param1.proID);
            }
            if(_loc3_ == TASK_READY)
            {
               this._stateTxt.gotoAndStop(1);
            }
            return;
         }
         if(_loc2_ == this._chainID && Boolean(this._taskItemList))
         {
            _loc3_ = this.getState();
            this._taskItemList.setState(_loc3_,param1.proID);
         }
      }
      
      private function onProChange(param1:TaskEvent) : void
      {
         if(this._taskBuff)
         {
            if(param1.taskID == this._taskBuff.taskId && Boolean(this._taskItemList))
            {
               this._taskItemList.updateProItem(param1.proID);
            }
         }
      }
      
      private function onAccept(param1:TaskEvent) : void
      {
         var _loc2_:uint = uint(param1.taskID);
         if(_loc2_ == this._chainID)
         {
            this._taskBuff = TasksManager.taskHash.getValue(this._chainID) as TaskBufInfo;
            if(this._taskItemList)
            {
               this.clearList();
               this.addList();
            }
            this.setType();
         }
      }
      
      private function onComplete(param1:TaskEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:CurrentChainTaskInfo = null;
         var _loc2_:uint = uint(param1.taskID);
         if(_loc2_ == this._chainID)
         {
            _loc3_ = this.getState();
            if(_loc3_ == TASK_READY)
            {
               this._taskBuff = TasksManager.taskHash.getValue(this._taskID) as TaskBufInfo;
               this._stateTxt.gotoAndStop(1);
            }
            else
            {
               _loc4_ = TasksManager.getMasterTask(this._taskID);
               this._chainID = _loc4_.taskCurrentArray[_loc4_.taskCurrentChainNum];
               this._taskBuff.create(this._chainID);
               this._conditions = TasksXMLInfo.getCondition(this._chainID);
            }
            if(this._taskItemList)
            {
               this.clearList();
               this.addList();
            }
         }
      }
      
      private function removeEvent() : void
      {
         TasksManager.removeListener(TaskEvent.PRO_COMPLETE,this.onProComplete);
         TasksManager.addListener(TaskEvent.PRO_CHANGE,this.onProChange);
         TasksManager.removeListener(TaskEvent.COMPLETE,this.onComplete);
         TasksManager.removeListener(TaskEvent.ACCEPT,this.onAccept);
         this._expandBtn.removeEventListener(MouseEvent.CLICK,this.onExpandClick);
         this._labelBtn.removeEventListener(MouseEvent.CLICK,this.onLabelClick);
      }
      
      private function getState() : uint
      {
         if(TasksManager.isReady(this._taskID))
         {
            return TASK_READY;
         }
         if(this._type == 5)
         {
            if(TasksManager.isReady(this._chainID))
            {
               return TASK_READY;
            }
            if(TasksManager.isAccepted(this._chainID))
            {
               return TASK_PROCESS;
            }
            return TASK_CANACCEPT;
         }
         return TASK_PROCESS;
      }
      
      public function get taskID() : uint
      {
         return this._taskID;
      }
      
      public function get acceptTime() : uint
      {
         return this._acceptTime;
      }
      
      public function destroy() : void
      {
         this.removeEvent();
         if(this._taskItemList)
         {
            this.clearList();
         }
         DisplayUtil.removeForParent(this._mainUI);
         this._mainUI = null;
      }
   }
}

