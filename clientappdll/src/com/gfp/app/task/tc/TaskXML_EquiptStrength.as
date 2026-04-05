package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.events.StrengthenEvent;
   import com.gfp.core.info.item.SingleEquipInfo;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.Logger;
   import com.gfp.core.utils.StringConstants;
   
   public class TaskXML_EquiptStrength extends TaskXML_Base
   {
      
      private var _strengthenLv:uint;
      
      private var _equipPart:uint;
      
      public function TaskXML_EquiptStrength()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:String = Logger.createLogMsgByArr(_params,param1,param2);
         Logger.info(this,_loc5_);
         var _loc6_:Array = param3.split(StringConstants.TASK_PARAM_SIGN);
         this._strengthenLv = uint(_loc6_[0]);
         this._equipPart = uint(_loc6_[1]);
      }
      
      override protected function addListener() : void
      {
         ItemManager.addListener(StrengthenEvent.EQUIPT_STRENGTHEN,this.onEquiptStengthen);
      }
      
      private function onEquiptStengthen(param1:StrengthenEvent) : void
      {
         var _loc2_:SingleEquipInfo = param1.info;
         if(param1.resultType == 2 && _loc2_.strengthenLV >= this._strengthenLv)
         {
            if(this._equipPart == 0)
            {
               this.setComplete();
            }
            else if(_loc2_.part == this._equipPart)
            {
               this.setComplete();
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
         ItemManager.removeListener(StrengthenEvent.EQUIPT_STRENGTHEN,this.onEquiptStengthen);
      }
      
      override public function get isComplete() : Boolean
      {
         return TasksManager.getTaskProStatus(_taskID,_proID) == TasksManager.STEP_COMPLETE;
      }
   }
}

