package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.config.xml.RoleXMLInfo;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.Logger;
   import com.gfp.core.utils.StringConstants;
   import com.gfp.core.utils.TextFormatUtil;
   import flash.utils.ByteArray;
   
   public class TaskXML_DifficultyMonsterWanted extends TaskXML_Base
   {
      
      private var _tollgateId:int;
      
      private var _tollgateDifficulty:int;
      
      private var _monsterID:uint;
      
      private var _monsterCount:uint;
      
      public function TaskXML_DifficultyMonsterWanted()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:String = Logger.createLogMsgByArr("TaskXML_DifficultyMonsterWanted setup:",_params,param1,param2);
         Logger.info(this,_loc5_);
         var _loc6_:Array = _params.split(StringConstants.SIGN);
         var _loc7_:Array = _loc6_[0].toString().split(StringConstants.TASK_PARAM_SIGN);
         var _loc8_:Array = _loc6_[1].toString().split(StringConstants.TASK_PARAM_SIGN);
         this._tollgateId = uint(_loc7_[0]);
         this._tollgateDifficulty = uint(_loc7_[1]);
         this._monsterID = uint(_loc8_[0]);
         this._monsterCount = uint(_loc8_[1]);
      }
      
      override protected function addListener() : void
      {
         var _loc1_:String = this.getParamStr();
         TasksManager.addActionListener(TaskActionEvent.TASK_DIFFICULTY_MONSTERWANTED,_loc1_,this.onMonsterUpdate);
      }
      
      private function getParamStr() : String
      {
         return this._tollgateId + StringConstants.SIGN + this._tollgateDifficulty + StringConstants.SIGN + this._monsterID;
      }
      
      private function onMonsterUpdate(param1:TaskActionEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:String = null;
         var _loc2_:ByteArray = TasksManager.getTaskProBytes(_taskID,_proID);
         if(_loc2_)
         {
            _loc2_.position = 1;
            _loc3_ = _loc2_.readUnsignedByte();
            if(_loc3_ < this._monsterCount)
            {
               _loc3_++;
               _loc2_.position = 1;
               _loc2_.writeByte(_loc3_);
               if(_loc3_ < this._monsterCount)
               {
                  TasksManager.setTaskProBytes(_taskID,_proID,_loc2_);
                  TextAlert.show(RoleXMLInfo.getName(this._monsterID) + " " + TextFormatUtil.getRedText(_loc3_.toString() + "/" + this._monsterCount.toString()));
               }
               else
               {
                  TasksManager.setTaskProBytes(_taskID,_proID,_loc2_,false);
                  TasksManager.taskProComplete(_taskID,_proID);
                  this.uninit();
                  TextAlert.show(RoleXMLInfo.getName(this._monsterID) + " " + TextFormatUtil.getRedText(_loc3_.toString() + "/" + this._monsterCount.toString()) + "(完成)");
               }
            }
            else
            {
               _loc4_ = Logger.createLogMsgByArr("数据异常强制完成",_taskID,_proID,_loc3_,this._monsterCount);
               Logger.info(this,_loc4_);
               TasksManager.taskProComplete(_taskID,_proID);
               this.uninit();
            }
         }
      }
      
      override public function uninit() : void
      {
         var _loc1_:String = this.getParamStr();
         TasksManager.addActionListener(TaskActionEvent.TASK_DIFFICULTY_MONSTERWANTED,_loc1_,this.onMonsterUpdate);
      }
      
      override public function get isComplete() : Boolean
      {
         return TasksManager.getTaskProStatus(_taskID,_proID) == TasksManager.STEP_COMPLETE;
      }
      
      override public function get procString() : String
      {
         if(TasksManager.isOutModedFinish(_taskID))
         {
            return this._monsterCount + "/" + this._monsterCount;
         }
         var _loc1_:ByteArray = TasksManager.getTaskProBytes(_taskID,_proID);
         _loc1_.position = 1;
         var _loc2_:uint = _loc1_.readUnsignedByte();
         return _loc2_.toString() + "/" + this._monsterCount.toString();
      }
   }
}

