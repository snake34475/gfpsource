package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.utils.Logger;
   import com.gfp.core.utils.StringConstants;
   
   public class TaskXML_ItemUseXor extends TaskXML_Base
   {
      
      private var _itemsXorList:Array = new Array();
      
      public function TaskXML_ItemUseXor()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:String = Logger.createLogMsgByArr(_params,param1,param2);
         Logger.info(this,_loc5_);
         this._itemsXorList = _params.split(StringConstants.TASK_PARAM_SIGN);
      }
      
      override protected function addListener() : void
      {
         var _loc3_:String = null;
         var _loc1_:int = int(this._itemsXorList.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this._itemsXorList[_loc2_];
            TasksManager.addActionListener(TaskActionEvent.TASK_ITEMUSE,_loc3_,this.onXorItemUse);
            _loc2_++;
         }
      }
      
      private function onXorItemUse(param1:TaskActionEvent) : void
      {
         var _loc4_:String = null;
         var _loc2_:int = int(this._itemsXorList.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._itemsXorList[_loc3_];
            TasksManager.removeActionListener(TaskActionEvent.TASK_ITEMUSE,_loc4_,this.onXorItemUse);
            _loc3_++;
         }
         TasksManager.taskProComplete(_taskID,_proID);
      }
      
      override public function get isComplete() : Boolean
      {
         return TasksManager.getTaskProStatus(_taskID,_proID) == TasksManager.STEP_COMPLETE;
      }
   }
}

