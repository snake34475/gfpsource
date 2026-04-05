package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.Logger;
   import com.gfp.core.utils.StringConstants;
   import com.gfp.core.utils.TextFormatUtil;
   
   public class TaskXML_ItemCollectCount extends TaskXML_Base
   {
      
      protected var _itemArray:Array = [];
      
      public function TaskXML_ItemCollectCount()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:String = Logger.createLogMsgByArr(_params,param1,param2);
         Logger.info(this,_loc5_);
         var _loc6_:Array = _params.split(StringConstants.TASK_PARAM_SIGN);
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_.length)
         {
            this._itemArray.push(uint(_loc6_[_loc7_]));
            _loc7_++;
         }
      }
      
      override public function init(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._itemArray.length)
         {
            TasksManager.addActionListener(TaskActionEvent.TASK_COLLECT,this._itemArray[_loc2_].toString(),this.onItemUpdate);
            _loc2_++;
         }
      }
      
      private function onItemUpdate(param1:TaskActionEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         var _loc6_:uint = 0;
         var _loc7_:int = 0;
         var _loc3_:uint = uint(param1.type.substr(param1.type.length - 7,7));
         if(this.getCompleteCount() >= 5)
         {
            _loc4_ = 0;
            _loc5_ = 0;
            while(_loc5_ < this._itemArray.length)
            {
               _loc2_ = uint(ItemManager.getItemCount(this._itemArray[_loc5_]));
               if(_loc2_ >= 1)
               {
                  _loc4_++;
               }
               _loc5_++;
            }
            TextAlert.show(ItemXMLInfo.getName(_loc3_) + " " + TextFormatUtil.getRedText(this.redString) + "(完成)");
            TasksManager.taskProComplete(_taskID,_proID);
         }
         else
         {
            _loc6_ = 0;
            _loc7_ = 0;
            while(_loc7_ < this._itemArray.length)
            {
               _loc2_ = uint(ItemManager.getItemCount(this._itemArray[_loc7_]));
               if(_loc2_ >= 1)
               {
                  _loc6_++;
               }
               _loc7_++;
            }
            TextAlert.show(ItemXMLInfo.getName(_loc3_) + " " + TextFormatUtil.getRedText(this.redString));
         }
      }
      
      private function getCompleteCount() : uint
      {
         var _loc3_:uint = 0;
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this._itemArray.length)
         {
            _loc3_ = uint(ItemManager.getItemCount(this._itemArray[_loc2_]));
            if(_loc3_ >= 1)
            {
               _loc1_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      override public function uninit() : void
      {
         var _loc2_:uint = 0;
         var _loc1_:int = 0;
         while(_loc1_ < this._itemArray.length)
         {
            TasksManager.removeActionListener(TaskActionEvent.TASK_COLLECT,this._itemArray[_loc1_].toString(),this.onItemUpdate);
            _loc2_ = uint(ItemManager.getItemCount(this._itemArray[_loc1_]));
            ItemManager.removeItem(this._itemArray[_loc1_],_loc2_);
            _loc1_++;
         }
         TasksManager.removeActionListener(TaskActionEvent.TASK_COLLECT,"",this.onItemUpdate);
      }
      
      override public function taskComplete() : void
      {
         this.uninit();
      }
      
      override public function get isComplete() : Boolean
      {
         return this.getCompleteCount() >= 5;
      }
      
      private function get redString() : String
      {
         if(TasksManager.isOutModedFinish(_taskID))
         {
            return 1 + "/" + 1;
         }
         return Math.min(this.getCompleteCount(),1).toString() + "/" + "1";
      }
      
      override public function get procString() : String
      {
         if(TasksManager.isOutModedFinish(_taskID))
         {
            return 5 + "/" + 5;
         }
         return Math.min(this.getCompleteCount(),5).toString() + "/" + "5";
      }
   }
}

