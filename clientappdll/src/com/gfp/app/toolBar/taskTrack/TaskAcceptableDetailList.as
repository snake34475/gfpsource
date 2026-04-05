package com.gfp.app.toolBar.taskTrack
{
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.manager.TasksManager;
   import flash.display.Sprite;
   import org.taomee.utils.DisplayUtil;
   
   public class TaskAcceptableDetailList extends Sprite
   {
      
      private var _taskArr:Array;
      
      private var _taskList:Vector.<TaskAcceptableDetailItem>;
      
      public function TaskAcceptableDetailList(param1:Array)
      {
         super();
         this._taskArr = param1;
         this.initList();
         TasksManager.addListener(TaskEvent.ACCEPT,this.onAccept);
      }
      
      private function initList() : void
      {
         var _loc3_:TaskAcceptableDetailItem = null;
         this.clearList();
         this._taskList = new Vector.<TaskAcceptableDetailItem>();
         var _loc1_:uint = this._taskArr.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = new TaskAcceptableDetailItem(this._taskArr[_loc2_]);
            _loc3_.x = 0;
            _loc3_.y = _loc2_ * (_loc3_.height - 2);
            addChild(_loc3_);
            this._taskList.push(_loc3_);
            _loc2_++;
         }
      }
      
      private function clearList() : void
      {
         var _loc1_:TaskAcceptableDetailItem = null;
         if(this._taskList)
         {
            for each(_loc1_ in this._taskList)
            {
               if(_loc1_)
               {
                  DisplayUtil.removeForParent(_loc1_);
                  _loc1_.destroy();
                  _loc1_ = null;
               }
            }
            this._taskList = null;
         }
      }
      
      private function onAccept(param1:TaskEvent) : void
      {
         var _loc2_:uint = uint(param1.taskID);
         var _loc3_:int = this._taskArr.indexOf(_loc2_);
         if(_loc3_ != -1)
         {
            this._taskArr.splice(_loc3_,1);
            if(this._taskArr.length != 0)
            {
               this.initList();
            }
         }
      }
      
      public function set taskArray(param1:Array) : void
      {
         this._taskArr = param1;
         this.initList();
      }
      
      public function destroy() : void
      {
         TasksManager.removeListener(TaskEvent.ACCEPT,this.onAccept);
         this.clearList();
      }
   }
}

