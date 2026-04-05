package com.gfp.app.toolBar.taskTrack
{
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class TaskAcceptableItem extends Sprite
   {
      
      public static const LIST_FOLDCHANGE:String = "list_foldchange";
      
      private var _taskArr:Array;
      
      private var _mainUI:Sprite;
      
      private var _isExpand:MovieClip;
      
      private var _expandBtn:SimpleButton;
      
      private var _type:uint;
      
      private var _taskItemList:TaskAcceptableDetailList;
      
      public function TaskAcceptableItem(param1:uint)
      {
         super();
         this._mainUI = new UI_TaskAcceptableItem();
         this._type = param1;
         this.setType();
         this._isExpand = this._mainUI["expand"];
         this._isExpand.gotoAndStop(1);
         this._expandBtn = this._mainUI["expandBtn"];
         this._expandBtn.addEventListener(MouseEvent.CLICK,this.onLabelClick);
         TasksManager.addListener(TaskEvent.ACCEPT,this.onTaskChange);
         TasksManager.addListener(TaskEvent.COMPLETE,this.onTaskChange);
         TasksManager.addListener(TaskEvent.QUIT,this.onTaskChange);
         MainManager.actorModel.addEventListener(UserEvent.LVL_CHANGE,this.onLvlChange);
         this._taskArr = new Array();
         this.taskArray = this.getAcceptableArray();
      }
      
      private function setType() : void
      {
         var _loc1_:String = "";
         switch(this._type)
         {
            case 1:
               _loc1_ = "主线";
               break;
            case 2:
               _loc1_ = "支线";
               break;
            case 3:
            case 7:
               _loc1_ = "每日";
               break;
            case 4:
               _loc1_ = "特殊";
               break;
            case 5:
            case 6:
               _loc1_ = "循环";
               break;
            case 16:
               _loc1_ = "剧情";
         }
         this._mainUI["label"].text = "【" + _loc1_ + "】";
      }
      
      private function getAcceptableArray() : Array
      {
         var _loc1_:Array = TasksXMLInfo.getAllTaskByType(this._type);
         return _loc1_.filter(this.filterList);
      }
      
      private function filterList(param1:uint, param2:uint, param3:Array) : Boolean
      {
         return Boolean(TasksXMLInfo.displayInAcceptable(param1)) && Boolean(TasksManager.isAcceptable(param1));
      }
      
      private function onLabelClick(param1:MouseEvent) : void
      {
         if(this._taskItemList == null)
         {
            this.addList();
         }
         else
         {
            this.clearList();
         }
         dispatchEvent(new Event(LIST_FOLDCHANGE));
      }
      
      public function expandOn() : void
      {
         if(Boolean(this._mainUI.parent) && this._taskItemList == null)
         {
            this.addList();
         }
      }
      
      public function expandOff() : void
      {
         if(Boolean(this._mainUI.parent) && Boolean(this._taskItemList))
         {
            this.clearList();
         }
      }
      
      private function addList() : void
      {
         this._isExpand.gotoAndStop(2);
         if(this._taskItemList == null)
         {
            this._taskItemList = new TaskAcceptableDetailList(this._taskArr);
         }
         this._taskItemList.x = 20;
         this._taskItemList.y = 20;
         addChildAt(this._taskItemList,0);
      }
      
      private function clearList() : void
      {
         this._isExpand.gotoAndStop(1);
         DisplayUtil.removeForParent(this._taskItemList);
         this._taskItemList.destroy();
         this._taskItemList = null;
      }
      
      private function onTaskChange(param1:TaskEvent) : void
      {
         var _loc2_:uint = uint(param1.taskID);
         var _loc3_:uint = uint(TasksXMLInfo.getType(_loc2_));
         _loc3_ = _loc3_ == 7 ? 3 : _loc3_;
         if(TaskAcceptablePanel.TASK_TRACK_TYPES.indexOf(_loc3_) != -1)
         {
            if(!TasksManager.isCountAccept())
            {
               this.taskArray = new Array();
               return;
            }
            if(param1.type != TaskEvent.ACCEPT && TasksManager.MAX_TASK_ACCEPT_NUM - TasksManager.taskHash.length == 1)
            {
               this.taskArray = this.getAcceptableArray();
               return;
            }
            if(_loc3_ == this._type)
            {
               this.taskArray = this.getAcceptableArray();
            }
         }
      }
      
      private function onLvlChange(param1:UserEvent) : void
      {
         this.taskArray = this.getAcceptableArray();
      }
      
      public function get type() : uint
      {
         return this._type;
      }
      
      private function set taskArray(param1:Array) : void
      {
         if(this._taskArr.length == param1.length)
         {
            return;
         }
         this._taskArr = param1;
         if(this._taskArr.length > 0)
         {
            addChild(this._mainUI);
         }
         else
         {
            removeChild(this._mainUI);
         }
         if(this._taskItemList)
         {
            this._taskItemList.taskArray = this._taskArr;
         }
         dispatchEvent(new Event(LIST_FOLDCHANGE));
      }
      
      public function get index() : uint
      {
         return TaskAcceptablePanel.TASK_TRACK_TYPES.indexOf(this._type);
      }
      
      public function destroy() : void
      {
         if(this._taskItemList)
         {
            DisplayUtil.removeForParent(this._taskItemList);
            this._taskItemList.destroy();
            this._taskItemList = null;
         }
         TasksManager.removeListener(TaskEvent.ACCEPT,this.onTaskChange);
         TasksManager.removeListener(TaskEvent.COMPLETE,this.onTaskChange);
         MainManager.actorModel.removeEventListener(UserEvent.LVL_CHANGE,this.onLvlChange);
         this._expandBtn.removeEventListener(MouseEvent.CLICK,this.onLabelClick);
         DisplayUtil.removeForParent(this._mainUI);
         this._mainUI = null;
      }
   }
}

