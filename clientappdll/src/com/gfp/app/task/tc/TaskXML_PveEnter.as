package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.utils.Logger;
   
   public class TaskXML_PveEnter extends TaskXML_Base
   {
      
      protected var _tollgateID:int;
      
      protected var _isTeam:Boolean;
      
      public function TaskXML_PveEnter()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:String = Logger.createLogMsgByArr("TaskXML_TollgatePassed setup:",_params,param1,param2);
         Logger.info(this,_loc5_);
         var _loc6_:Array = param3.split("|");
         if(_loc6_.length >= 2)
         {
            this._tollgateID = uint(_loc6_[0]);
            this._isTeam = _loc6_[1] == "1";
         }
         else
         {
            this._tollgateID = uint(_params);
         }
      }
      
      override public function get isComplete() : Boolean
      {
         return TasksManager.getTaskProStatus(_taskID,_proID) == TasksManager.STEP_COMPLETE;
      }
      
      private function getTaskProcName(param1:uint, param2:uint) : String
      {
         return TasksXMLInfo.getProDoc(param1,param2);
      }
   }
}

