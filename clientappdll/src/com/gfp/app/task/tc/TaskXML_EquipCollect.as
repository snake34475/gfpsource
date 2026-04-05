package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.utils.Logger;
   
   public class TaskXML_EquipCollect extends TaskXML_Base
   {
      
      protected var _itemID:uint;
      
      public function TaskXML_EquipCollect()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:String = Logger.createLogMsgByArr(param1,param2,param3);
         Logger.info(this,_loc5_);
         this._itemID = uint(_params);
         if(!this.isComplete)
         {
            TasksManager.addActionListener(TaskActionEvent.TASK_EQUIPCOLLECT,this._itemID.toString(),this.onEquipUpdate);
         }
      }
      
      private function onEquipUpdate(param1:TaskActionEvent) : void
      {
         TasksManager.removeActionListener(TaskActionEvent.TASK_EQUIPCOLLECT,this._itemID.toString(),this.onEquipUpdate);
         SightManager.refreshTaskSign();
      }
      
      override public function get isComplete() : Boolean
      {
         return ItemManager.hasEquip(this._itemID);
      }
   }
}

