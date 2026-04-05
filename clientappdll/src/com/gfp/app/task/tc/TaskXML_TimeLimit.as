package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.app.toolBar.TimeCountDown;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.Logger;
   import com.gfp.core.utils.StringConstants;
   import com.gfp.core.utils.TextFormatUtil;
   import flash.events.Event;
   
   public class TaskXML_TimeLimit extends TaskXML_Base
   {
      
      private var _limitTime:uint;
      
      private var _limitProcID:uint;
      
      private var _prevProID:uint;
      
      private var _isOverTime:Boolean;
      
      public function TaskXML_TimeLimit()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         Logger.debug(this,"TaskXML_TimeLimit setup:" + _params + param1 + param2);
         var _loc5_:Array = _params.split(StringConstants.TASK_PARAM_SIGN);
         this._limitTime = uint(_loc5_[0]);
         this._prevProID = uint(_loc5_[1]);
         this._limitProcID = uint(_loc5_[2]);
         TasksManager.addListener(TaskEvent.PRO_COMPLETE,this.onProComplete);
         if(TasksManager.isProcess(_taskID,this._limitProcID))
         {
            Logger.debug(this,"重新登陆或掉线 限时任务需要重新开始！");
            this.rollbackTask();
         }
      }
      
      private function onProComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == _taskID)
         {
            if(param1.proID == this._prevProID)
            {
               this.startTimer();
            }
            else if(param1.proID == this._limitProcID)
            {
               if(this._isOverTime)
               {
                  this.rollbackTask();
               }
               else
               {
                  TasksManager.taskProComplete(_taskID,_proID);
               }
               TasksManager.removeListener(TaskEvent.PRO_COMPLETE,this.onProComplete);
               this.destroyTimer();
            }
         }
      }
      
      private function rollbackTask() : void
      {
         TextAlert.show(TextFormatUtil.getRedText(TasksXMLInfo.getName(_taskID) + " 已超过完成时间 你需要从新开始"));
         TasksManager.resetBufInfo(_taskID);
         TasksManager.removeBufInfo(_taskID,false);
         TasksManager.addBufInfo(_taskID);
      }
      
      private function onTimerComplete(param1:Event) : void
      {
         this._isOverTime = true;
         if(TasksManager.isProcess(_taskID,this._limitProcID))
         {
            this.rollbackTask();
         }
         this.destroyTimer();
      }
      
      private function startTimer() : void
      {
         this._isOverTime = false;
         TimeCountDown.instance.start(this._limitTime);
         TimeCountDown.instance.addEventListener(TimeCountDown.COUNT_DOWN_OVER,this.onTimerComplete);
      }
      
      private function destroyTimer() : void
      {
         TimeCountDown.instance.destroy();
      }
   }
}

