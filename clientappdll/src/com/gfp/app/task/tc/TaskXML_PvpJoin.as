package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.Logger;
   import com.gfp.core.utils.StringConstants;
   
   public class TaskXML_PvpJoin extends TaskXML_Base
   {
      
      private var _pvpType:int;
      
      private var _mapID:int;
      
      public function TaskXML_PvpJoin()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:String = Logger.createLogMsgByArr("TaskXML_PvpJoin setup:",_params,param1,param2);
         Logger.info(this,_loc5_);
         var _loc6_:Array = _params.split(StringConstants.TASK_PARAM_SIGN);
         if(MainManager.actorInfo.isTurnBack)
         {
            this._pvpType = uint(_loc6_[2]);
            this._mapID = uint(_loc6_[3]);
         }
         else
         {
            this._pvpType = uint(_loc6_[0]);
            this._mapID = uint(_loc6_[1]);
         }
      }
      
      override protected function addListener() : void
      {
         TasksManager.addActionListener(TaskActionEvent.TASK_PVP_WIN,this._pvpType + StringConstants.SIGN + this._mapID,this.onPvpWin);
         TasksManager.addActionListener(TaskActionEvent.TASK_PVP_UNWIN,null,this.onPvpUnWin);
      }
      
      private function onPvpWin(param1:TaskActionEvent) : void
      {
         TasksManager.taskProComplete(_taskID,_proID);
         TextAlert.show(this.getTaskProcName(_taskID,_proID) + " (完成)");
         this.uninit();
      }
      
      private function onPvpUnWin(param1:TaskActionEvent) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:String = param1.param.toString();
         var _loc3_:Array = _loc2_.split(StringConstants.SIGN);
         if(_loc3_.length == 2)
         {
            _loc4_ = parseInt(_loc3_[0]);
            _loc5_ = parseInt(_loc3_[1]);
            if((this._pvpType == 0 || _loc4_ == _loc5_) && (this._mapID == 0 || this._mapID == _loc5_))
            {
               TasksManager.taskProComplete(_taskID,_proID);
               TextAlert.show(this.getTaskProcName(_taskID,_proID) + " (完成)");
               this.uninit();
            }
         }
      }
      
      override public function uninit() : void
      {
         TasksManager.removeActionListener(TaskActionEvent.TASK_PVP_WIN,this._pvpType + StringConstants.SIGN + this._mapID,this.onPvpWin);
         TasksManager.removeActionListener(TaskActionEvent.TASK_PVP_UNWIN,null,this.onPvpUnWin);
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

