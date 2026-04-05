package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.Logger;
   
   public class TaskXML_TalkToNPCAndUserItem extends TaskXML_Base
   {
      
      private var _hasCompleteAlertStep:int = 0;
      
      private var itemIsUser:Boolean;
      
      public function TaskXML_TalkToNPCAndUserItem()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         this.itemIsUser = false;
         var _loc5_:String = Logger.createLogMsgByArr(_params,param1,param2);
         Logger.info(this,_loc5_);
      }
      
      private function onTalkToTaskNPC(param1:TaskActionEvent) : void
      {
         if(ItemManager.getItemCount(1300817) > 0)
         {
            ItemManager.useItem(1300817);
            this.itemIsUser = true;
            TasksManager.taskProComplete(_taskID,_proID);
            if(this._hasCompleteAlertStep == 1)
            {
               this._hasCompleteAlertStep = 2;
               TextAlert.show(this.getTaskProcName(_taskID,_proID) + " (完成)");
               ModuleManager.hideModule("TaskBookPanel");
            }
            this.uninit();
         }
         else
         {
            AlertManager.showSimpleAlarm("小侠士身上还没有南瓜怪人变身符，无法变身。");
         }
      }
      
      override protected function addListener() : void
      {
         if(this._hasCompleteAlertStep == 0)
         {
            this._hasCompleteAlertStep = 1;
         }
         TasksManager.addActionListener(TaskActionEvent.TASK_TALKTO,_params,this.onTalkToTaskNPC);
      }
      
      override public function uninit() : void
      {
         TasksManager.removeActionListener(TaskActionEvent.TASK_TALKTO,_params,this.onTalkToTaskNPC);
      }
      
      override public function get isComplete() : Boolean
      {
         if(TasksManager.getTaskProStatus(_taskID,_proID) == TasksManager.STEP_COMPLETE)
         {
            if(this._hasCompleteAlertStep == 1)
            {
               if(!this.itemIsUser)
               {
                  if(ItemManager.getItemCount(1300817) <= 0)
                  {
                     AlertManager.showSimpleAlarm("小侠士身上还没有南瓜怪人变身符，无法变身。");
                     return false;
                  }
                  ItemManager.useItem(1300817);
                  this.itemIsUser = true;
                  this._hasCompleteAlertStep = 2;
                  this.taskProComplete();
                  this.transferToSomePlace();
               }
               else
               {
                  this._hasCompleteAlertStep = 2;
                  this.taskProComplete();
                  this.transferToSomePlace();
               }
            }
            return true;
         }
         return false;
      }
      
      protected function taskProComplete() : void
      {
         TasksManager.taskProComplete(_taskID,_proID);
         TextAlert.show(this.getTaskProcName(_taskID,_proID) + " (完成)");
         ModuleManager.hideModule(ClientConfig.getAppModule("TaskBookPanel"));
      }
      
      protected function transferToSomePlace() : void
      {
         if(this._params)
         {
            CityMap.instance.tranChangeMapByStr(this._params);
         }
      }
      
      private function getTaskProcName(param1:uint, param2:uint) : String
      {
         return TasksXMLInfo.getProDoc(param1,param2);
      }
   }
}

