package com.gfp.app.task.tc
{
   import com.gfp.app.fight.PveEntry;
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.utils.Logger;
   
   public class TaskXML_OpenStage extends TaskXML_Base
   {
      
      private var _stageId:uint;
      
      public function TaskXML_OpenStage()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:String = Logger.createLogMsgByArr("TaskXML_OpenStage setup:",_params,param1,param2);
         Logger.info(this,_loc5_);
         this._stageId = uint(_params);
      }
      
      override public function init(param1:Boolean) : void
      {
         super.init(param1);
         PveEntry.enterTollgate(this._stageId);
      }
      
      override public function get isComplete() : Boolean
      {
         return true;
      }
   }
}

