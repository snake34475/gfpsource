package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.FirstStageFeather;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   
   public class MapProcess_1000101 extends BaseMapProcess
   {
      
      private var _feather:FirstStageFeather;
      
      public function MapProcess_1000101()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         if(Boolean(TasksManager.isProcess(1650,0)) || Boolean(TasksManager.isProcess(521,0)))
         {
            this._feather = new FirstStageFeather();
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(this._feather)
         {
            this._feather.destory();
         }
      }
   }
}

