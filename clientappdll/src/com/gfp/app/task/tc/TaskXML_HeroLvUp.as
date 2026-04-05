package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.events.HeroSoulEvent;
   import com.gfp.core.info.HeroSoulInfo;
   import com.gfp.core.manager.HeroSoulManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.ui.alert.TextAlert;
   
   public class TaskXML_HeroLvUp extends TaskXML_Base
   {
      
      private var _soulType:int;
      
      private var _soulLvNeed:int;
      
      public function TaskXML_HeroLvUp()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:Array = param3.split(",");
         this._soulType = int(_loc5_[0]);
         this._soulLvNeed = int(_loc5_[1]);
      }
      
      override protected function addListener() : void
      {
         var _loc2_:HeroSoulInfo = null;
         HeroSoulManager.addEventListener(HeroSoulEvent.UPGRADE,this.responseUpgrade);
         var _loc1_:Array = HeroSoulManager.getActorHeroSoulInfo().soulList;
         for each(_loc2_ in _loc1_)
         {
            if((this._soulType == 0 || _loc2_.soulType == this._soulType) && _loc2_.lv >= this._soulLvNeed)
            {
               this.setComplete();
               break;
            }
         }
      }
      
      private function responseUpgrade(param1:HeroSoulEvent) : void
      {
         var _loc2_:HeroSoulInfo = param1.soulInfo;
         if((this._soulType == 0 || _loc2_.soulType == this._soulType) && _loc2_.lv >= this._soulLvNeed)
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
         HeroSoulManager.removeEventListener(HeroSoulEvent.UPGRADE,this.responseUpgrade);
      }
      
      override public function get isComplete() : Boolean
      {
         return TasksManager.getTaskProStatus(_taskID,_proID) == TasksManager.STEP_COMPLETE;
      }
   }
}

