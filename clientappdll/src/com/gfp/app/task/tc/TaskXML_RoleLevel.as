package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.manager.UserInfoManager;
   import com.gfp.core.ui.alert.TextAlert;
   import flash.events.Event;
   
   public class TaskXML_RoleLevel extends TaskXML_Base
   {
      
      private var mRoleLeve:uint;
      
      public function TaskXML_RoleLevel()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         this.mRoleLeve = uint(param3);
      }
      
      override protected function addListener() : void
      {
         UserInfoManager.ed.addEventListener(UserEvent.LVL_CHANGE,this.onLevelChange);
      }
      
      protected function onLevelChange(param1:Event = null) : void
      {
         if(MainManager.actorInfo.lv >= this.mRoleLeve)
         {
            this.setComplete();
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
         UserInfoManager.ed.removeEventListener(UserEvent.LVL_CHANGE,this.onLevelChange);
      }
      
      override public function get isComplete() : Boolean
      {
         if(TasksManager.getTaskProStatus(_taskID,_proID) != TasksManager.STEP_COMPLETE && MainManager.actorInfo.lv >= this.mRoleLeve)
         {
            TasksManager.setTaskProStatus(_taskID,_proID,TasksManager.STEP_COMPLETE);
         }
         return TasksManager.getTaskProStatus(_taskID,_proID) == TasksManager.STEP_COMPLETE;
      }
   }
}

