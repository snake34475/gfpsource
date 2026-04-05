package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.info.GuideInfo;
   import com.gfp.core.info.GuideNodeInfo;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.ui.controller.GuideAdapter;
   
   public class TaskXML_Guide extends TaskXML_Base
   {
      
      protected var _guideID:int;
      
      protected var _guide:GuideAdapter;
      
      public function TaskXML_Guide()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         this._guideID = int(param3);
         if(TasksManager.isProcess(param1,param2))
         {
            this._guide = new GuideAdapter(this._guideID,this.onGuideComplete);
            this._guide.show();
         }
      }
      
      override protected function addListener() : void
      {
         if(Boolean(TasksManager.isProcess(_taskID,_proID)) && this._guide == null)
         {
            this._guide = new GuideAdapter(this._guideID,this.onGuideComplete);
            this._guide.show();
         }
      }
      
      override public function get isComplete() : Boolean
      {
         return TasksManager.getTaskProStatus(_taskID,_proID) == TasksManager.STEP_COMPLETE;
      }
      
      private function onGuideComplete(param1:GuideNodeInfo, param2:GuideInfo) : void
      {
         if(param2.nextInfo == null)
         {
            TasksManager.taskProComplete(_taskID,_proID);
         }
      }
   }
}

