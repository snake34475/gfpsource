package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.AdvancedManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.ui.alert.TextAlert;
   import flash.events.Event;
   
   public class TaskXML_Advance extends TaskXML_Base
   {
      
      private var mType:int;
      
      public function TaskXML_Advance()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         this.mType = uint(param3);
      }
      
      private function check() : void
      {
         if(this.mType == 1 && Boolean(MainManager.actorInfo.isAdvanced))
         {
            this.setComplete();
         }
         else if(this.mType == 3 && Boolean(MainManager.actorInfo.isSuperAdvc))
         {
            this.setComplete();
         }
         else if(this.mType == 4 && Boolean(MainManager.actorInfo.isTurnBack))
         {
            this.setComplete();
         }
      }
      
      override protected function addListener() : void
      {
         AdvancedManager.instance.addEventListener(AdvancedManager.ADVANCED,this.onAdvanceChange);
         AdvancedManager.instance.addEventListener(AdvancedManager.ADVANCED3,this.onAdvanceChange);
         UserManager.addEventListener(UserEvent.TURN_BACK,this.onAdvanceChange);
         this.check();
      }
      
      protected function onAdvanceChange(param1:Event) : void
      {
         if(param1.type == AdvancedManager.ADVANCED && this.mType == 1)
         {
            this.setComplete();
         }
         else if(param1.type == AdvancedManager.ADVANCED3 && this.mType == 3)
         {
            this.setComplete();
         }
         else if(param1.type == UserEvent.TURN_BACK && this.mType == 4)
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
         AdvancedManager.instance.removeEventListener(AdvancedManager.ADVANCED,this.onAdvanceChange);
         AdvancedManager.instance.removeEventListener(AdvancedManager.ADVANCED3,this.onAdvanceChange);
         UserManager.removeEventListener(UserEvent.TURN_BACK,this.onAdvanceChange);
      }
      
      override public function get isComplete() : Boolean
      {
         return TasksManager.getTaskProStatus(_taskID,_proID) == TasksManager.STEP_COMPLETE;
      }
   }
}

