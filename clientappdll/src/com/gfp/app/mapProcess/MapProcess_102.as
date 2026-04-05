package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.CheckForOpenFeather;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.sensemodels.SightModel;
   
   public class MapProcess_102 extends BaseMapProcess
   {
      
      private var _moduleOpen:CheckForOpenFeather;
      
      public function MapProcess_102()
      {
         super();
      }
      
      override public function destroy() : void
      {
         super.destroy();
         TasksManager.removeListener(TaskEvent.PRO_COMPLETE,this.onProComplete);
         this._moduleOpen.destory();
         this._moduleOpen = null;
      }
      
      override protected function init() : void
      {
         super.init();
         this._moduleOpen = new CheckForOpenFeather();
         var _loc1_:SightModel = SightManager.getSightModel(10216);
         if(_loc1_)
         {
            _loc1_.visible = false;
         }
         TasksManager.addListener(TaskEvent.PRO_COMPLETE,this.onProComplete);
         var _loc2_:SightModel = SightManager.getSightModel(10539);
         var _loc3_:SightModel = SightManager.getSightModel(10540);
         if(!TasksManager.isCompleted(2124) && !TasksManager.isTaskProComplete(2124,1))
         {
            _loc2_.visible = true;
            _loc3_.visible = false;
         }
         else
         {
            _loc2_.visible = false;
            _loc3_.visible = true;
         }
      }
      
      private function onProComplete(param1:TaskEvent) : void
      {
         var _loc2_:SightModel = null;
         var _loc3_:SightModel = null;
         if(param1.taskID == 2124 && param1.proID == 1)
         {
            _loc2_ = SightManager.getSightModel(10539);
            _loc3_ = SightManager.getSightModel(10540);
            if(Boolean(_loc2_) && Boolean(_loc3_))
            {
               _loc2_.visible = false;
               _loc3_.visible = true;
            }
         }
      }
   }
}

