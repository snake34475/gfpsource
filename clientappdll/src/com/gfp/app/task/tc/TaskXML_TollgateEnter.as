package com.gfp.app.task.tc
{
   import com.gfp.app.fight.PveEntry;
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.Logger;
   import org.taomee.net.SocketEvent;
   
   public class TaskXML_TollgateEnter extends TaskXML_Base
   {
      
      protected var _tollgateIDs:Array;
      
      public function TaskXML_TollgateEnter()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:String = Logger.createLogMsgByArr("TaskXML_TollgatePassed setup:",_params,param1,param2);
         Logger.info(this,_loc5_);
         this._tollgateIDs = [];
         var _loc6_:Array = param3.split(",");
         var _loc7_:int = int(_loc6_.length);
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_)
         {
            this._tollgateIDs.push(int(_loc6_[_loc8_]));
            _loc8_++;
         }
      }
      
      override protected function addListener() : void
      {
         SocketConnection.addCmdListener(CommandID.FIGHT_BEGIN,this.onEntryStage);
      }
      
      override public function uninit() : void
      {
         SocketConnection.removeCmdListener(CommandID.FIGHT_BEGIN,this.onEntryStage);
      }
      
      private function onEntryStage(param1:SocketEvent) : void
      {
         if(this._tollgateIDs.indexOf(PveEntry.instance.getStageID()) != -1)
         {
            TasksManager.taskProComplete(_taskID,_proID);
            TextAlert.show(this.getTaskProcName(_taskID,_proID) + " (完成)");
            this.uninit();
         }
      }
      
      override public function get isComplete() : Boolean
      {
         return TasksManager.getTaskProStatus(_taskID,_proID) == TasksManager.STEP_COMPLETE;
      }
      
      protected function getTaskProcName(param1:uint, param2:uint) : String
      {
         return TasksXMLInfo.getProDoc(param1,param2);
      }
   }
}

