package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.config.xml.RoleXMLInfo;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.Logger;
   import com.gfp.core.utils.StringConstants;
   import com.gfp.core.utils.TextFormatUtil;
   import flash.utils.ByteArray;
   
   public class TaskXML_MultipleMonsterWanted extends TaskXML_Base
   {
      
      private var _monsters:Array;
      
      private var _monsterCount:uint;
      
      public function TaskXML_MultipleMonsterWanted()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:String = Logger.createLogMsgByArr(_params,param1,param2);
         Logger.info(this,_loc5_);
         var _loc6_:Array = _params.split(StringConstants.TASK_PARAM_SIGN);
         this._monsterCount = uint(_loc6_[1]);
         _loc6_ = String(_loc6_[0]).split("|");
         this._monsters = [];
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_.length)
         {
            this._monsters.push(int(_loc6_[_loc7_]));
            _loc7_++;
         }
      }
      
      override protected function addListener() : void
      {
         var _loc1_:int = int(this._monsters.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            TasksManager.addActionListener(TaskActionEvent.TASK_MONSTERWANTED,this._monsters[_loc2_].toString(),this.onMonsterUpdate);
            _loc2_++;
         }
      }
      
      private function onMonsterUpdate(param1:TaskActionEvent) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:String = null;
         var _loc2_:ByteArray = TasksManager.getTaskProBytes(_taskID,_proID);
         var _loc3_:int = int(param1.param);
         if(_loc2_)
         {
            _loc2_.position = 1;
            _loc4_ = uint(_loc2_.readShort());
            if(_loc4_ < this._monsterCount)
            {
               _loc4_++;
               _loc2_.position = 1;
               _loc2_.writeShort(_loc4_);
               if(_loc4_ < this._monsterCount)
               {
                  TasksManager.setTaskProBytes(_taskID,_proID,_loc2_);
                  TextAlert.show(RoleXMLInfo.getName(_loc3_) + " " + TextFormatUtil.getRedText(_loc4_.toString() + "/" + this._monsterCount.toString()));
               }
               else
               {
                  TasksManager.setTaskProBytes(_taskID,_proID,_loc2_,false);
                  TasksManager.taskProComplete(_taskID,_proID);
                  this.uninit();
                  TextAlert.show(RoleXMLInfo.getName(_loc3_) + " " + TextFormatUtil.getRedText(_loc4_.toString() + "/" + this._monsterCount.toString()) + "(完成)");
                  TextAlert.show(this.getTaskProcName(_taskID,_proID) + " (完成)");
               }
            }
            else
            {
               _loc5_ = Logger.createLogMsgByArr("数据异常强制完成：",_taskID,_proID,_loc4_,this._monsterCount);
               Logger.info(this,_loc5_);
               TasksManager.taskProComplete(_taskID,_proID);
               this.uninit();
            }
         }
      }
      
      override public function uninit() : void
      {
         var _loc1_:int = int(this._monsters.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            TasksManager.removeActionListener(TaskActionEvent.TASK_MONSTERWANTED,this._monsters[_loc2_].toString(),this.onMonsterUpdate);
            _loc2_++;
         }
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

