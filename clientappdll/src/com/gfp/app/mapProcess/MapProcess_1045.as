package com.gfp.app.mapProcess
{
   import com.gfp.app.manager.TeamTaskManager;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.sensemodels.SightModel;
   import flash.display.MovieClip;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1045 extends BaseMapProcess
   {
      
      protected var _signFlag:MovieClip;
      
      public function MapProcess_1045()
      {
         super();
      }
      
      override protected function init() : void
      {
         if(TasksManager.isReady(TeamTaskManager.instance.taskID))
         {
            this.addSignFlag(10504);
         }
         this.initTaskEvent();
      }
      
      protected function initTaskEvent() : void
      {
         TasksManager.addListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
         TasksManager.addListener(TaskEvent.COMPLETE,this.onTaskComplete);
      }
      
      private function removeTaskEvent() : void
      {
         TasksManager.removeListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
         TasksManager.removeListener(TaskEvent.COMPLETE,this.onTaskComplete);
      }
      
      protected function onTaskProComplete(param1:TaskEvent) : void
      {
         var _loc2_:uint = uint(param1.taskID);
         if(TasksXMLInfo.getType(_loc2_) == 13 && Boolean(TasksManager.isReady(_loc2_)))
         {
            this.addSignFlag(10504);
         }
      }
      
      protected function addSignFlag(param1:uint) : void
      {
         var _loc2_:SightModel = SightManager.getSightModel(param1);
         if(this._signFlag == null)
         {
            this._signFlag = new TaskSign_Ready();
         }
         this._signFlag.y = -(_loc2_.height + 30);
         _loc2_.addChild(this._signFlag);
      }
      
      private function onTaskComplete(param1:TaskEvent) : void
      {
         var _loc2_:uint = uint(param1.taskID);
         if(TasksXMLInfo.getType(_loc2_) == 13)
         {
            this.removeSignFlag();
         }
      }
      
      private function removeSignFlag() : void
      {
         if(this._signFlag)
         {
            DisplayUtil.removeForParent(this._signFlag);
            this._signFlag = null;
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.removeTaskEvent();
         this.removeSignFlag();
      }
   }
}

