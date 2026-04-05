package com.gfp.app.toolBar.taskTrack
{
   import com.gfp.core.info.task.TaskBufInfo;
   import com.gfp.core.info.task.TaskConditionInfo;
   import com.gfp.core.info.task.TaskConditionListInfo;
   import com.gfp.core.manager.ITasksConfigFun;
   import flash.display.Sprite;
   import org.taomee.ds.HashMap;
   
   public class TaskAcceptedDetailList extends Sprite
   {
      
      private var _taskID:uint;
      
      private var _proHash:HashMap;
      
      private var _taskBuff:TaskBufInfo;
      
      private var _conditions:TaskConditionListInfo;
      
      private var _callBack:Function;
      
      private var _state:uint;
      
      public function TaskAcceptedDetailList(param1:TaskBufInfo, param2:TaskConditionListInfo, param3:Function, param4:uint)
      {
         super();
         this._taskBuff = param1;
         this._conditions = param2;
         this._callBack = param3;
         this._state = param4;
         this._proHash = new HashMap();
         this.initSteps();
      }
      
      public function setState(param1:uint, param2:uint = 0) : void
      {
         this._state = param1;
         switch(param1)
         {
            case TaskAcceptedItem.TASK_READY:
            case TaskAcceptedItem.TASK_CANACCEPT:
            case TaskAcceptedItem.TASK_ACCEPTED:
               this.refreshProItem();
               this._callBack();
               break;
            case TaskAcceptedItem.TASK_PROCESS:
               this.checkPro(param2);
               this.updateProItem(param2);
         }
      }
      
      private function refreshProItem() : void
      {
         this.clearItems();
         this.initSteps();
      }
      
      private function checkPro(param1:uint) : void
      {
         var _loc2_:Array = null;
         var _loc3_:uint = 0;
         var _loc4_:TaskConditionInfo = null;
         if(this._proHash.containsKey(param1))
         {
            _loc2_ = this._proHash.getValue(param1);
            for each(_loc3_ in _loc2_)
            {
               _loc4_ = this._conditions.conditionList[_loc3_];
               if(_loc4_.visible != "0")
               {
                  this.addSingleItem(_loc3_);
               }
            }
            this._proHash.remove(param1);
            this._callBack();
         }
      }
      
      public function updateProItem(param1:uint) : void
      {
         var _loc6_:TaskAcceptedProItem = null;
         var _loc2_:uint = uint(this.numChildren);
         var _loc3_:ITasksConfigFun = this._taskBuff.conditionFuncs[param1] as ITasksConfigFun;
         var _loc4_:String = _loc3_.procString;
         if(_loc4_ == "-/-")
         {
            _loc4_ = _loc3_.isComplete ? "1/1" : "0/1";
         }
         var _loc5_:int = 0;
         while(_loc5_ < _loc2_)
         {
            _loc6_ = this.getChildAt(_loc5_) as TaskAcceptedProItem;
            if(_loc6_.step == param1)
            {
               _loc6_.pro = _loc4_;
            }
            _loc5_++;
         }
      }
      
      private function initSteps() : void
      {
         var _loc1_:TaskAcceptedProItem = null;
         switch(this._state)
         {
            case TaskAcceptedItem.TASK_READY:
            case TaskAcceptedItem.TASK_CANACCEPT:
               _loc1_ = new TaskAcceptedProItem(this._taskBuff.taskId,this._state);
               addChild(_loc1_);
               break;
            case TaskAcceptedItem.TASK_PROCESS:
            case TaskAcceptedItem.TASK_ACCEPTED:
               this.addToItems();
         }
      }
      
      private function addToItems() : void
      {
         var _loc3_:TaskConditionInfo = null;
         var _loc4_:uint = 0;
         var _loc5_:Array = null;
         var _loc1_:int = int(this._conditions.conditionList.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this._conditions.conditionList[_loc2_];
            if(_loc3_.visible != "0")
            {
               _loc4_ = uint(_loc3_.parent);
               if(_loc3_.parent != "" && !ITasksConfigFun(this._taskBuff.conditionFuncs[_loc4_]).isComplete)
               {
                  if(this._proHash.containsKey(_loc4_))
                  {
                     _loc5_ = this._proHash.getValue(_loc4_);
                     _loc5_.push(_loc2_);
                  }
                  else
                  {
                     this._proHash.add(_loc4_,[_loc2_]);
                  }
               }
               else
               {
                  this.addSingleItem(_loc2_);
               }
            }
            _loc2_++;
         }
      }
      
      private function addSingleItem(param1:uint) : void
      {
         var _loc2_:ITasksConfigFun = this._taskBuff.conditionFuncs[param1] as ITasksConfigFun;
         var _loc3_:String = _loc2_.procString;
         if(_loc3_ == "-/-")
         {
            _loc3_ = _loc2_.isComplete ? "1/1" : "0/1";
         }
         var _loc4_:TaskAcceptedProItem = new TaskAcceptedProItem(this._taskID,this._state,_loc3_,this._conditions.conditionList[param1],param1);
         _loc4_.y = this.height;
         addChild(_loc4_);
      }
      
      private function clearItems() : void
      {
         var _loc1_:TaskAcceptedProItem = null;
         while(this.numChildren > 0)
         {
            _loc1_ = this.getChildAt(0) as TaskAcceptedProItem;
            this.removeChild(_loc1_);
            _loc1_.destroy();
            _loc1_ = null;
         }
         this._proHash.clear();
      }
      
      public function destroy() : void
      {
         this.clearItems();
         this._proHash.clear();
         this._proHash = null;
      }
   }
}

