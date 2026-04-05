package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.config.xml.RoleXMLInfo;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.Logger;
   import com.gfp.core.utils.StringConstants;
   import com.gfp.core.utils.TextFormatUtil;
   import flash.utils.ByteArray;
   
   public class TaskXML_MonsterWeakened extends TaskXML_Base
   {
      
      private var _monstersID:uint;
      
      private var _monstersHP:uint;
      
      private var _monstersCount:uint;
      
      private var _bossID:uint;
      
      public function TaskXML_MonsterWeakened()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,false);
         var _loc5_:Array = _params.split(StringConstants.TASK_PARAM_SIGN);
         this._bossID = uint(_loc5_[3]);
         this._monstersID = uint(_loc5_[0]);
         this._monstersHP = uint(_loc5_[1]);
         this._monstersCount = uint(_loc5_[2]);
      }
      
      override protected function addListener() : void
      {
         TasksManager.addActionListener(TaskActionEvent.TASK_MONSTERWANTED,this._bossID.toString(),this.onMonsterUpdate);
      }
      
      private function onKillMonsters(param1:TaskActionEvent) : void
      {
         TextAlert.show(TextFormatUtil.getRedText(AppLanguageDefine.FIGHT_CHARACTER_COLLECTION[7]));
      }
      
      private function onMonsterUpdate(param1:TaskActionEvent) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:UserModel = null;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:String = null;
         var _loc2_:Array = UserManager.getModels();
         var _loc3_:uint = _loc2_.length;
         var _loc4_:ByteArray = TasksManager.getTaskProBytes(_taskID,_proID);
         if(_loc4_)
         {
            _loc4_.position = 1;
            _loc5_ = _loc4_.readUnsignedByte();
            if(_loc5_ < this._monstersCount)
            {
               _loc6_ = 0;
               while(_loc6_ < _loc3_)
               {
                  _loc7_ = _loc2_[_loc6_] as UserModel;
                  _loc8_ = uint(_loc7_.info.roleType);
                  if(_loc8_ == this._monstersID)
                  {
                     _loc9_ = uint(_loc7_.getHP() * 100 / _loc7_.getTotalHP());
                     if(this._monstersHP >= _loc9_)
                     {
                        _loc5_++;
                     }
                  }
                  _loc6_++;
               }
               _loc4_.position = 1;
               _loc4_.writeByte(_loc5_);
               if(_loc5_ < this._monstersCount)
               {
                  TasksManager.setTaskProBytes(_taskID,_proID,_loc4_);
                  TextAlert.show(RoleXMLInfo.getName(this._monstersID) + " " + TextFormatUtil.getRedText(_loc5_.toString() + "/" + this._monstersCount.toString()));
               }
               else
               {
                  TasksManager.setTaskProBytes(_taskID,_proID,_loc4_,false);
                  TasksManager.taskProComplete(_taskID,_proID);
                  this.uninit();
                  TextAlert.show(RoleXMLInfo.getName(this._monstersID) + " " + TextFormatUtil.getRedText(this._monstersCount.toString() + "/" + this._monstersCount.toString()) + AppLanguageDefine.COMPLETE);
               }
            }
            else
            {
               _loc10_ = Logger.createLogMsgByArr("数据异常强制完成：",_taskID,_proID,_loc5_,this._monstersCount);
               Logger.info(this,_loc10_);
               TasksManager.taskProComplete(_taskID,_proID);
               this.uninit();
            }
         }
      }
      
      override public function uninit() : void
      {
         TasksManager.removeActionListener(TaskActionEvent.TASK_MONSTERWANTED,this._bossID.toString(),this.onMonsterUpdate);
      }
      
      override public function get isComplete() : Boolean
      {
         return TasksManager.getTaskProStatus(_taskID,_proID) == TasksManager.STEP_COMPLETE;
      }
      
      override public function get procString() : String
      {
         if(TasksManager.isOutModedFinish(_taskID))
         {
            return this._monstersCount + "/" + this._monstersCount;
         }
         var _loc1_:ByteArray = TasksManager.getTaskProBytes(_taskID,_proID);
         _loc1_.position = 1;
         var _loc2_:uint = _loc1_.readUnsignedByte();
         if(_loc2_ > this._monstersCount)
         {
            _loc2_ = this._monstersCount;
         }
         return _loc2_.toString() + "/" + this._monstersCount.toString();
      }
   }
}

