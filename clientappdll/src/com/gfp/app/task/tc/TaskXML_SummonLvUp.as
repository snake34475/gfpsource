package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.events.SummonEvent;
   import com.gfp.core.info.SummonInfo;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.ui.alert.TextAlert;
   
   public class TaskXML_SummonLvUp extends TaskXML_Base
   {
      
      private var _summonType:int;
      
      private var _summLvNeed:int;
      
      public function TaskXML_SummonLvUp()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:Array = param3.split(",");
         this._summonType = int(_loc5_[0]);
         this._summLvNeed = int(_loc5_[1]);
      }
      
      override protected function addListener() : void
      {
         var _loc2_:SummonInfo = null;
         SummonManager.addEventListener(SummonEvent.SUMMON_PRO_UPDATE,this.onProUpdateComplete);
         var _loc1_:Array = SummonManager.getActorSummonInfo().summonList;
         for each(_loc2_ in _loc1_)
         {
            if((this._summonType == 0 || _loc2_.summonType == this._summonType) && _loc2_.lv >= this._summLvNeed)
            {
               this.setComplete();
               break;
            }
         }
      }
      
      private function onProUpdateComplete(param1:SummonEvent) : void
      {
         var _loc3_:SummonInfo = null;
         var _loc2_:Array = SummonManager.getActorSummonInfo().summonList;
         for each(_loc3_ in _loc2_)
         {
            if((this._summonType == 0 || _loc3_.summonType == this._summonType) && _loc3_.lv >= this._summLvNeed)
            {
               this.setComplete();
               break;
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
         SummonManager.removeEventListener(SummonEvent.SUMMON_PRO_UPDATE,this.onProUpdateComplete);
      }
      
      override public function get isComplete() : Boolean
      {
         return TasksManager.getTaskProStatus(_taskID,_proID) == TasksManager.STEP_COMPLETE;
      }
   }
}

