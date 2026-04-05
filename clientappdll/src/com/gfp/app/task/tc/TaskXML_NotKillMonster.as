package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.StringConstants;
   import com.gfp.core.utils.TextFormatUtil;
   
   public class TaskXML_NotKillMonster extends TaskXML_Base
   {
      
      private var _monstersID:Array;
      
      private var _monstersCount:Array;
      
      private var _countArr:Array;
      
      private var _count:uint;
      
      private var _bossID:uint;
      
      public function TaskXML_NotKillMonster()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,false);
         var _loc5_:Array = _params.split(StringConstants.TASK_PARAM_SIGN);
         var _loc6_:uint = _loc5_.length;
         this._bossID = uint(_loc5_[_loc6_ - 1]);
         _loc6_--;
         this._monstersID = new Array();
         this._monstersCount = new Array();
         var _loc7_:uint = 0;
         while(_loc7_ < _loc6_)
         {
            this._monstersID.push(uint(_loc5_[_loc7_]));
            _loc7_++;
            this._monstersCount.push(uint(_loc5_[_loc7_]));
            _loc7_++;
         }
         this._count = this._monstersID.length;
      }
      
      override protected function addListener() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this._count)
         {
            TasksManager.addActionListener(TaskActionEvent.TASK_MONSTERWANTED,this._monstersID[_loc1_].toString(),this.onKillMonsters);
            _loc1_++;
         }
         TasksManager.addActionListener(TaskActionEvent.TASK_MONSTERWANTED,this._bossID.toString(),this.onMonsterUpdate);
      }
      
      private function onKillMonsters(param1:TaskActionEvent) : void
      {
         TextAlert.show(TextFormatUtil.getRedText(TasksXMLInfo.getProDoc(_taskID,_proID)) + " 失败");
      }
      
      private function onMonsterUpdate(param1:TaskActionEvent) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:UserModel = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc2_:Array = UserManager.getModels();
         var _loc3_:uint = _loc2_.length;
         this._countArr = new Array();
         _loc4_ = 0;
         while(_loc4_ < this._count)
         {
            this._countArr.push(0);
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc4_] as UserModel;
            _loc6_ = uint(_loc5_.info.roleType);
            _loc7_ = uint(this._monstersID.indexOf(_loc6_));
            if(_loc7_ != -1)
            {
               this._countArr[_loc7_] += 1;
            }
            _loc4_++;
         }
         if(this.checkComplete())
         {
            TasksManager.taskProComplete(_taskID,_proID);
            TextAlert.show(TextFormatUtil.getRedText(TasksXMLInfo.getProDoc(_taskID,_proID)) + " 完成");
            this.uninit();
         }
         else
         {
            TextAlert.show(TextFormatUtil.getRedText(TasksXMLInfo.getProDoc(_taskID,_proID)) + " 失败");
         }
      }
      
      private function checkComplete() : Boolean
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this._count)
         {
            if(this._countArr[_loc1_] < this._monstersCount[_loc1_])
            {
               return false;
            }
            _loc1_++;
         }
         return true;
      }
      
      override public function uninit() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this._count)
         {
            TasksManager.removeActionListener(TaskActionEvent.TASK_MONSTERWANTED,this._monstersID[_loc1_].toString(),this.onKillMonsters);
            _loc1_++;
         }
         TasksManager.removeActionListener(TaskActionEvent.TASK_MONSTERWANTED,this._bossID.toString(),this.onMonsterUpdate);
      }
      
      override public function get isComplete() : Boolean
      {
         return TasksManager.getTaskProStatus(_taskID,_proID) == TasksManager.STEP_COMPLETE;
      }
   }
}

