package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.events.StrengthenEvent;
   import com.gfp.core.info.EquipNewComposeInfo;
   import com.gfp.core.info.item.SingleEquipInfo;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.StringConstants;
   
   public class TaskXML_EquiptLvUp extends TaskXML_Base
   {
      
      private var _equiptPart:int;
      
      private var _levelNeed:int;
      
      public function TaskXML_EquiptLvUp()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:Array = param3.split(StringConstants.TASK_PARAM_SIGN);
         this._equiptPart = _loc5_[0];
         this._levelNeed = _loc5_[1];
      }
      
      override protected function addListener() : void
      {
         var _loc2_:SingleEquipInfo = null;
         ItemManager.addListener(StrengthenEvent.EQUIPT_ExtraCareer,this.responseUpgrade);
         var _loc1_:Array = ItemManager.getPropertyEquipList();
         for each(_loc2_ in _loc1_)
         {
            if((this._equiptPart == 0 || _loc2_.part == this._equiptPart) && _loc2_.level >= this._levelNeed)
            {
               this.setComplete();
               break;
            }
         }
      }
      
      private function responseUpgrade(param1:StrengthenEvent) : void
      {
         var _loc3_:SingleEquipInfo = null;
         var _loc2_:EquipNewComposeInfo = param1.info as EquipNewComposeInfo;
         if(_loc2_.equipInfos.length > 0)
         {
            _loc3_ = _loc2_.equipInfos[0];
            if(this._equiptPart == 0 || _loc3_.part == this._equiptPart)
            {
               if(_loc3_.level >= this._levelNeed)
               {
                  this.setComplete();
               }
            }
         }
      }
      
      private function setComplete() : void
      {
         TasksManager.taskProComplete(_taskID,_proID);
         TextAlert.show(this.getTaskProcName(_taskID,_proID) + " (完成)");
         this.uninit();
      }
      
      private function getTaskProcName(param1:uint, param2:uint) : String
      {
         return TasksXMLInfo.getProDoc(param1,param2);
      }
      
      override public function uninit() : void
      {
         ItemManager.removeListener(StrengthenEvent.EQUIPT_ExtraCareer,this.responseUpgrade);
      }
      
      override public function get isComplete() : Boolean
      {
         return TasksManager.getTaskProStatus(_taskID,_proID) == TasksManager.STEP_COMPLETE;
      }
   }
}

