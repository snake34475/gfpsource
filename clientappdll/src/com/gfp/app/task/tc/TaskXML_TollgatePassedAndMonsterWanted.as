package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.config.xml.RoleXMLInfo;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.config.xml.TollgateXMLInfo;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.Logger;
   import com.gfp.core.utils.StringConstants;
   import com.gfp.core.utils.TextFormatUtil;
   import flash.utils.ByteArray;
   
   public class TaskXML_TollgatePassedAndMonsterWanted extends TaskXML_Base
   {
      
      private var _tollgateId:int;
      
      private var _tollgateDifficulty:int;
      
      private var _monsterID:uint;
      
      private var _monsterCount:uint;
      
      private var _isPassedStage:Boolean = false;
      
      public function TaskXML_TollgatePassedAndMonsterWanted()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:String = Logger.createLogMsgByArr(_params,param1,param2);
         Logger.info(this,_loc5_);
         var _loc6_:Array = _params.split(StringConstants.TASK_PARAM_SIGN);
         this._tollgateId = uint(_loc6_[0]);
         this._tollgateDifficulty = uint(_loc6_[1]);
         this._monsterID = uint(_loc6_[2]);
         this._monsterCount = uint(_loc6_[3]);
      }
      
      override protected function addListener() : void
      {
         TasksManager.addActionListener(TaskActionEvent.TASK_TOLLGATE_DIFFICLTY,this._tollgateId + StringConstants.SIGN + this._tollgateDifficulty,this.onTollgateWin);
         TasksManager.addActionListener(TaskActionEvent.TASK_MONSTERWANTED,this._monsterID.toString(),this.onMonsterUpdate);
      }
      
      private function onTollgateWin(param1:TaskActionEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc2_:ByteArray = TasksManager.getTaskProBytes(_taskID,_proID);
         if(_loc2_)
         {
            _loc2_.position = 2;
            _loc2_.writeByte(1);
            TasksManager.setTaskProBytes(_taskID,_proID,_loc2_);
            TextAlert.show(TextFormatUtil.getRedText(TollgateXMLInfo.getName(this._tollgateId) + " " + this.getDifficultyText()) + "(通过)");
            _loc2_.position = 1;
            _loc3_ = _loc2_.readUnsignedByte();
            if(_loc3_ >= this._monsterCount)
            {
               TasksManager.taskProComplete(_taskID,_proID);
               TextAlert.show(this.getTaskProcName(_taskID,_proID) + " (完成)");
               this.uninit();
            }
         }
      }
      
      private function onMonsterUpdate(param1:TaskActionEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:Boolean = false;
         var _loc2_:ByteArray = TasksManager.getTaskProBytes(_taskID,_proID);
         if(_loc2_)
         {
            _loc2_.position = 1;
            _loc3_ = _loc2_.readUnsignedByte();
            _loc2_.position = 2;
            _loc4_ = Boolean(_loc2_.readUnsignedByte());
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
                  TasksManager.setTaskProBytes(_taskID,_proID,_loc2_,true);
                  TextAlert.show(RoleXMLInfo.getName(this._monsterID) + " " + TextFormatUtil.getRedText(_loc3_.toString() + "/" + this._monsterCount.toString()));
                  if(_loc4_)
                  {
                     TasksManager.taskProComplete(_taskID,_proID);
                     TextAlert.show(this.getTaskProcName(_taskID,_proID) + " (完成)");
                     this.uninit();
                  }
               }
            }
         }
      }
      
      override public function uninit() : void
      {
         TasksManager.removeActionListener(TaskActionEvent.TASK_TOLLGATE_DIFFICLTY,this._tollgateId + StringConstants.SIGN + this._tollgateDifficulty,this.onTollgateWin);
         TasksManager.removeActionListener(TaskActionEvent.TASK_MONSTERWANTED,this._monsterID.toString(),this.onMonsterUpdate);
      }
      
      override public function get isComplete() : Boolean
      {
         return TasksManager.getTaskProStatus(_taskID,_proID) == TasksManager.STEP_COMPLETE;
      }
      
      private function getTaskProcName(param1:uint, param2:uint) : String
      {
         return TasksXMLInfo.getProDoc(param1,param2);
      }
      
      private function getDifficultyText() : String
      {
         switch(this._tollgateDifficulty)
         {
            case 1:
               return AppLanguageDefine.SIMPLE;
            case 2:
               return AppLanguageDefine.GENERAL;
            case 3:
               return AppLanguageDefine.DIFFICULT;
            case 4:
               return AppLanguageDefine.ELITE;
            case 5:
               return AppLanguageDefine.HERO;
            case 6:
               return AppLanguageDefine.EPIC;
            default:
               return "";
         }
      }
   }
}

