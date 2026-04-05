package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.events.TaskCommonEvent;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.Logger;
   import com.gfp.core.utils.StringConstants;
   import flash.utils.ByteArray;
   
   public class TaskXML_FightPvpWin extends TaskXML_Base
   {
      
      private var _pvpTypes:Array;
      
      public function TaskXML_FightPvpWin()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:String = Logger.createLogMsgByArr("TaskXML_FightPvpWin setup:",_params,param1,param2);
         Logger.info(this,_loc5_);
         this._pvpTypes = _params.split(StringConstants.TASK_PARAM_SIGN);
      }
      
      override protected function addListener() : void
      {
         TasksManager.addCommonListener(TaskCommonEvent.TASK_FIGHTPVP_WIN,this.onFightPvpWin);
      }
      
      private function onFightPvpWin(param1:TaskCommonEvent) : void
      {
         var _loc4_:uint = 0;
         var _loc2_:uint = uint(param1.data);
         var _loc3_:ByteArray = TasksManager.getTaskProBytes(_taskID,_proID);
         if(_loc3_)
         {
            _loc3_.position = 1;
            _loc4_ = _loc3_.readUnsignedByte();
            if(_loc4_ < 1)
            {
               if(this._pvpTypes.indexOf(String(_loc2_)) != -1)
               {
                  _loc3_.position = 1;
                  _loc3_.writeByte(1);
                  TasksManager.setTaskProBytes(_taskID,_proID,_loc3_,true);
                  TasksManager.taskProComplete(_taskID,_proID);
                  TextAlert.show(this.getTaskProcName(_taskID,_proID) + " (完成)");
                  this.uninit();
               }
            }
            else
            {
               TasksManager.setTaskProBytes(_taskID,_proID,_loc3_,true);
               TasksManager.taskProComplete(_taskID,_proID);
               TextAlert.show(this.getTaskProcName(_taskID,_proID) + " (完成)");
               this.uninit();
            }
         }
      }
      
      override public function uninit() : void
      {
         TasksManager.removeCommonListener(TaskCommonEvent.TASK_FIGHTPVP_WIN,this.onFightPvpWin);
      }
      
      override public function get isComplete() : Boolean
      {
         var _loc1_:int = int(TasksManager.getTaskProStatus(_taskID,_proID));
         return TasksManager.getTaskProStatus(_taskID,_proID) == TasksManager.STEP_COMPLETE;
      }
      
      private function getTaskProcName(param1:uint, param2:uint) : String
      {
         return TasksXMLInfo.getProDoc(param1,param2);
      }
   }
}

