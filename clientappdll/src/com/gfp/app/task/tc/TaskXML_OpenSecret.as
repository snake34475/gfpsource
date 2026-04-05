package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.config.xml.RoleXMLInfo;
   import com.gfp.core.events.HiddenEvent;
   import com.gfp.core.manager.HiddenManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.model.HiddenModel;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.Logger;
   import com.gfp.core.utils.StringConstants;
   import com.gfp.core.utils.TextFormatUtil;
   import flash.utils.ByteArray;
   
   public class TaskXML_OpenSecret extends TaskXML_Base
   {
      
      private var _monsterID:uint;
      
      private var _monsterCount:uint;
      
      public function TaskXML_OpenSecret()
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
         HiddenManager.addEventListener(HiddenEvent.OPEN,this.onMonsterUpdate);
      }
      
      private function onMonsterUpdate(param1:HiddenEvent) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:String = null;
         var _loc2_:HiddenModel = param1.model;
         if(_loc2_.info.roleType != this._monsterID)
         {
            return;
         }
         var _loc3_:ByteArray = TasksManager.getTaskProBytes(_taskID,_proID);
         if(_loc3_)
         {
            _loc3_.position = 1;
            _loc4_ = _loc3_.readUnsignedByte();
            if(_loc4_ < this._monsterCount)
            {
               _loc4_++;
               _loc3_.position = 1;
               _loc3_.writeByte(_loc4_);
               if(_loc4_ < this._monsterCount)
               {
                  TasksManager.setTaskProBytes(_taskID,_proID,_loc3_);
                  TextAlert.show(RoleXMLInfo.getName(this._monsterID) + " " + TextFormatUtil.getRedText(_loc4_.toString() + "/" + this._monsterCount.toString()));
               }
               else
               {
                  TasksManager.setTaskProBytes(_taskID,_proID,_loc3_,false);
                  TasksManager.taskProComplete(_taskID,_proID);
                  this.uninit();
                  TextAlert.show(RoleXMLInfo.getName(this._monsterID) + " " + TextFormatUtil.getRedText(_loc4_.toString() + "/" + this._monsterCount.toString()) + "(完成)");
               }
            }
            else
            {
               _loc5_ = Logger.createLogMsgByArr("TaskXML_MonsterWanted数据异常强制完成：",_taskID,_proID,_loc4_,this._monsterCount);
               Logger.error(this,_loc5_);
               TasksManager.taskProComplete(_taskID,_proID);
               this.uninit();
            }
         }
      }
      
      override public function uninit() : void
      {
         HiddenManager.removeEventListener(HiddenEvent.OPEN,this.onMonsterUpdate);
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

