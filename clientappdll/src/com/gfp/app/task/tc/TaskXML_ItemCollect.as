package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.Logger;
   import com.gfp.core.utils.StringConstants;
   import com.gfp.core.utils.TextFormatUtil;
   
   public class TaskXML_ItemCollect extends TaskXML_Base
   {
      
      private static var objArray:Array = [];
      
      protected var _itemID:uint;
      
      protected var _itemCount:uint;
      
      public function TaskXML_ItemCollect()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:String = Logger.createLogMsgByArr(_params,param1,param2);
         Logger.info(this,_loc5_);
         var _loc6_:Array = _params.split(StringConstants.TASK_PARAM_SIGN);
         this._itemID = uint(_loc6_[0]);
         this._itemCount = uint(_loc6_[1]);
         _taskID = param1;
         _proID = param2;
         TasksManager.addActionListener(TaskActionEvent.TASK_COLLECT,this._itemID.toString(),this.onItemUpdate);
      }
      
      private function onItemUpdate(param1:TaskActionEvent) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc2_:uint = uint(ItemManager.getItemCount(this._itemID));
         if(_loc2_ >= this._itemCount)
         {
            _loc3_ = true;
            _loc4_ = 0;
            while(_loc4_ < objArray.length)
            {
               if(_taskID == objArray[_loc4_].taskID && _proID == objArray[_loc4_].proID && Boolean(objArray[_loc4_].itemComplete))
               {
                  _loc3_ = false;
               }
               _loc4_++;
            }
            if(_loc3_)
            {
               TextAlert.show(ItemXMLInfo.getName(this._itemID) + " " + TextFormatUtil.getRedText(this.procString) + "(完成)");
               _loc5_ = new Object();
               _loc5_.taskID = _taskID;
               _loc5_.proID = _proID;
               _loc5_.itemComplete = true;
               objArray.push(_loc5_);
               TasksManager.taskProComplete(_taskID,_proID);
            }
         }
         else if(_loc2_ < this._itemCount)
         {
            TextAlert.show(ItemXMLInfo.getName(this._itemID) + " " + TextFormatUtil.getRedText(this.procString));
            TasksManager.dispatchEvent(TaskEvent.PRO_CHANGE,_taskID,_proID);
         }
      }
      
      override public function uninit() : void
      {
         TasksManager.removeActionListener(TaskActionEvent.TASK_COLLECT,this._itemID.toString(),this.onItemUpdate);
      }
      
      override public function taskComplete() : void
      {
         this.uninit();
      }
      
      override public function get isComplete() : Boolean
      {
         var _loc1_:Boolean = ItemManager.getItemCount(this._itemID) >= this._itemCount;
         if(_loc1_ && Boolean(TasksManager.isAccepted(_taskID)))
         {
            TasksManager.taskProComplete(_taskID,_proID);
         }
         return _loc1_;
      }
      
      override public function get procString() : String
      {
         if(TasksManager.isOutModedFinish(_taskID))
         {
            return this._itemCount + "/" + this._itemCount;
         }
         return Math.min(ItemManager.getItemCount(this._itemID),this._itemCount).toString() + "/" + this._itemCount.toString();
      }
   }
}

