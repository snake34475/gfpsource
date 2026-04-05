package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.config.xml.RoleXMLInfo;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.data.TaskActionEventParam;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.Logger;
   import com.gfp.core.utils.StringConstants;
   import com.gfp.core.utils.TextFormatUtil;
   import flash.utils.ByteArray;
   
   public class TaskXML_MonsterWanted extends TaskXML_Base
   {
      
      private var _monsterID:uint;
      
      private var _monsterCount:uint;
      
      public function TaskXML_MonsterWanted()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:String = Logger.createLogMsgByArr(_params,param1,param2);
         Logger.info(this,_loc5_);
         var _loc6_:Array = _params.split(StringConstants.TASK_PARAM_SIGN);
         this._monsterID = uint(_loc6_[0]);
         this._monsterCount = uint(_loc6_[1]);
      }
      
      override protected function addListener() : void
      {
         TasksManager.addActionListener(TaskActionEvent.TASK_MONSTERWANTED,this._monsterID.toString(),this.onMonsterUpdate);
         TasksManager.addActionListener(TaskActionEvent.TASK_AUTO_LOOT_MONSTER_WANTED,null,this.onMonsterUpdate);
      }
      
      private function onMonsterUpdate(param1:TaskActionEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:String = null;
         if(param1.type == TaskActionEvent.TASK_AUTO_LOOT_MONSTER_WANTED)
         {
            if(param1.param == null)
            {
               return;
            }
            if(param1.param.params[0] != this._monsterID)
            {
               return;
            }
         }
         var _loc2_:ByteArray = TasksManager.getTaskProBytes(_taskID,_proID);
         if(_loc2_)
         {
            _loc2_.position = 1;
            _loc3_ = _loc2_.readUnsignedByte();
            if(_loc3_ < this._monsterCount)
            {
               _loc3_ += this._getMonsterCount(param1.param);
               if(_loc3_ > this._monsterCount)
               {
                  _loc3_ = this._monsterCount;
               }
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
                  TextAlert.show(this.getTaskProcName(_taskID,_proID) + " (完成)");
               }
            }
            else
            {
               _loc4_ = Logger.createLogMsgByArr("数据异常强制完成：",_taskID,_proID,_loc3_,this._monsterCount);
               Logger.info(this,_loc4_);
               TasksManager.taskProComplete(_taskID,_proID);
               this.uninit();
            }
         }
      }
      
      private function _getMonsterCount(param1:Object) : uint
      {
         if(param1 == null || !(param1 is TaskActionEventParam))
         {
            return 1;
         }
         var _loc2_:TaskActionEventParam = param1 as TaskActionEventParam;
         if(_loc2_.params[0] == this._monsterID)
         {
            return _loc2_.params[1];
         }
         return 1;
      }
      
      override public function uninit() : void
      {
         TasksManager.removeActionListener(TaskActionEvent.TASK_MONSTERWANTED,this._monsterID.toString(),this.onMonsterUpdate);
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
      
      private function getTaskProcName(param1:uint, param2:uint) : String
      {
         return TasksXMLInfo.getProDoc(param1,param2);
      }
   }
}

