package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.events.StrengthenEvent;
   import com.gfp.core.info.EquipNewComposeInfo;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.ui.alert.TextAlert;
   
   public class TaskXML_ExtraCareer extends TaskXML_Base
   {
      
      private var mType:int;
      
      private var mTime:int;
      
      public function TaskXML_ExtraCareer()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:Array = param3.split(",");
         this.mType = _loc5_[0];
         if(_loc5_.length > 1)
         {
            this.mTime = _loc5_[1];
         }
         else
         {
            this.mTime = 1;
         }
      }
      
      override protected function addListener() : void
      {
         ItemManager.addListener(StrengthenEvent.EQUIPT_ExtraCareer,this.onEquiptExtraCareer);
      }
      
      private function onEquiptExtraCareer(param1:StrengthenEvent) : void
      {
         var _loc2_:EquipNewComposeInfo = param1.info;
         if(this.mType == 0)
         {
            --this.mTime;
         }
         else if(this.mType == 1 && _loc2_.methodID < 300000)
         {
            --this.mTime;
         }
         else if(this.mType == 2 && _loc2_.methodID > 300000)
         {
            --this.mTime;
         }
         else if(this.mType == _loc2_.methodID)
         {
            --this.mTime;
         }
         if(this.mTime <= 0)
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
         ItemManager.removeListener(StrengthenEvent.EQUIPT_ExtraCareer,this.onEquiptExtraCareer);
      }
      
      override public function get isComplete() : Boolean
      {
         return TasksManager.getTaskProStatus(_taskID,_proID) == TasksManager.STEP_COMPLETE;
      }
   }
}

