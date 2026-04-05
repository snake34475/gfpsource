package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.CheckForOpenFeather;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.sensemodels.SightModel;
   
   public class MapProcess_105 extends BaseMapProcess
   {
      
      private var _wuShengModel:SightModel;
      
      private var _birdShengModel:SightModel;
      
      private var _moduleOpen:CheckForOpenFeather;
      
      public function MapProcess_105()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         TasksManager.addListener(TaskEvent.ACCEPT,this.onTaskAccept);
         TasksManager.addListener(TaskEvent.COMPLETE,this.onTaskComplete);
         TasksManager.addListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
         this._wuShengModel = SightManager.getSightModel(10557);
         this._birdShengModel = SightManager.getSightModel(10558);
         this.checkModel();
         this._moduleOpen = new CheckForOpenFeather();
      }
      
      private function checkModel() : void
      {
         if(Boolean(TasksManager.isCompleted(2151)) && !TasksManager.isCompleted(2152))
         {
            if(this._wuShengModel)
            {
               this._wuShengModel.visible = true;
            }
         }
         else if(this._wuShengModel)
         {
            this._wuShengModel.visible = false;
         }
         if(Boolean(TasksManager.isAccepted(2152)) && Boolean(TasksManager.isTaskProComplete(2152,3)))
         {
            if(this._birdShengModel)
            {
               this._birdShengModel.visible = true;
            }
         }
         else if(this._birdShengModel)
         {
            this._birdShengModel.visible = false;
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         TasksManager.removeListener(TaskEvent.ACCEPT,this.onTaskAccept);
         TasksManager.removeListener(TaskEvent.COMPLETE,this.onTaskComplete);
         TasksManager.removeListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
         if(this._moduleOpen)
         {
            this._moduleOpen.destory();
            this._moduleOpen = null;
         }
      }
      
      private function onTaskAccept(param1:TaskEvent) : void
      {
         if(param1.taskID == 2152)
         {
            if(this._wuShengModel)
            {
               this._wuShengModel.visible = true;
            }
         }
      }
      
      private function onTaskComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 2152)
         {
            if(this._wuShengModel)
            {
               this._wuShengModel.visible = false;
            }
            if(this._birdShengModel)
            {
               this._birdShengModel.visible = false;
            }
         }
      }
      
      private function onTaskProComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 2152 && param1.proID == 3)
         {
            if(this._birdShengModel)
            {
               this._birdShengModel.visible = true;
            }
         }
      }
   }
}

