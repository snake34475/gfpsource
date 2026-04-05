package com.gfp.app.task
{
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.info.task.TaskConditionInfo;
   import com.gfp.core.info.task.TaskConditionListInfo;
   import com.gfp.core.manager.ITasksConfigFun;
   import com.gfp.core.map.CityMap;
   
   public class TaskXML_Base implements ITasksConfigFun
   {
      
      protected var _taskID:uint;
      
      protected var _proID:uint;
      
      protected var _params:String;
      
      protected var _bSkip:Boolean;
      
      public function TaskXML_Base()
      {
         super();
      }
      
      public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         this._taskID = param1;
         this._proID = param2;
         this._params = param3;
         this._bSkip = param4;
      }
      
      public function init(param1:Boolean) : void
      {
         if(!this.isComplete)
         {
            this.addListener();
         }
         if(param1 && Boolean(TasksXMLInfo.getProAutoExec(this._taskID,this._proID)))
         {
            this.autoExec();
         }
      }
      
      public function autoExec() : void
      {
         var _loc2_:String = null;
         var _loc1_:TaskConditionListInfo = TasksXMLInfo.getCondition(this._taskID);
         if(Boolean(_loc1_) && _loc1_.conditionList.length > this._proID)
         {
            _loc2_ = TaskConditionInfo(_loc1_.conditionList[this._proID]).tran;
            if(_loc2_)
            {
               CityMap.instance.tranChangeMapByStr(_loc2_);
            }
         }
      }
      
      protected function addListener() : void
      {
      }
      
      public function uninit() : void
      {
      }
      
      public function taskComplete() : void
      {
      }
      
      public function get isComplete() : Boolean
      {
         return true;
      }
      
      public function get procString() : String
      {
         return "-/-";
      }
      
      public function get isSkip() : Boolean
      {
         return this._bSkip;
      }
   }
}

