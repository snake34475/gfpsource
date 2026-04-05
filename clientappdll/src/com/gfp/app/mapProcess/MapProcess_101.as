package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.CheckForOpenFeather;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.model.sensemodels.SightModel;
   
   public class MapProcess_101 extends MapProcessAnimat
   {
      
      private var _moduleOpen:CheckForOpenFeather;
      
      public function MapProcess_101()
      {
         _mangoType = 1;
         super();
      }
      
      override public function destroy() : void
      {
         super.destroy();
         TasksManager.removeListener(TaskEvent.PRO_COMPLETE,this.onProComplete);
         TasksManager.removeListener(TaskEvent.COMPLETE,this.onTaskComplete);
         if(this._moduleOpen)
         {
            this._moduleOpen.destory();
            this._moduleOpen = null;
         }
      }
      
      override protected function init() : void
      {
         _mangoType = 1;
         super.init();
         TasksManager.addListener(TaskEvent.PRO_COMPLETE,this.onProComplete);
         TasksManager.addListener(TaskEvent.COMPLETE,this.onTaskComplete);
         if(!(!TasksManager.isTaskProComplete(2091,1) && !TasksManager.isCompleted(2091)))
         {
            if(!TasksManager.isTaskProComplete(2091,2) && Boolean(TasksManager.isAccepted(2091)))
            {
               CityMap.instance.tranToNpc(10538);
            }
         }
         this.checkTask2133();
         this.checkTask2144();
         this._moduleOpen = new CheckForOpenFeather();
      }
      
      private function checkTask2133() : void
      {
         if(TasksManager.isCompleted(2133))
         {
            this.showTask2133Model(true);
         }
         else
         {
            this.showTask2133Model(false);
         }
      }
      
      private function showTask2133Model(param1:Boolean) : void
      {
         var _loc2_:SightModel = SightManager.getSightModel(10543);
         var _loc3_:SightModel = SightManager.getSightModel(10544);
         if(_loc2_)
         {
            _loc2_.visible = param1;
         }
         if(_loc3_)
         {
            _loc3_.visible = param1;
         }
      }
      
      private function checkTask2144() : void
      {
         if(Boolean(TasksManager.isCompleted(2144)) || Boolean(TasksManager.isTaskProComplete(2144,0)))
         {
            this.showTask2144Model(true);
         }
         else
         {
            this.showTask2144Model(false);
         }
      }
      
      private function showTask2144Model(param1:Boolean) : void
      {
         var _loc2_:SightModel = SightManager.getSightModel(10543);
         var _loc3_:SightModel = SightManager.getSightModel(10554);
         _loc2_.visible = !param1;
         _loc3_.visible = param1;
      }
      
      private function onTaskComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 2133)
         {
            this.showTask2133Model(true);
         }
      }
      
      private function onProComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 2144 && param1.proID == 0)
         {
            this.showTask2144Model(true);
         }
      }
   }
}

