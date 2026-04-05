package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.CheckForOpenFeather;
   import com.gfp.core.events.MoveEvent;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.utils.StringConstants;
   import flash.geom.Point;
   
   public class MapProcess_74 extends BaseMapProcess
   {
      
      private var _moduleOpen:CheckForOpenFeather;
      
      public function MapProcess_74()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._moduleOpen = new CheckForOpenFeather();
         if(TasksManager.isCompleted(2500))
         {
            return;
         }
         var _loc1_:int = int(TasksManager.getTaskProStatus(2500,0));
         _loc1_ = int(TasksManager.getTaskProStatus(2500,1));
         _loc1_ = int(TasksManager.getTaskProStatus(2500,2));
         MainManager.actorModel.addEventListener(MoveEvent.MOVE,this.onMove);
      }
      
      private function onMove(param1:MoveEvent) : void
      {
         if(this.isInFog(param1.pos) && Boolean(TasksManager.isProcess(2500,1)))
         {
            MainManager.actorModel.removeEventListener(MoveEvent.MOVE,this.onMove);
            TasksManager.dispatchActionEvent(TaskActionEvent.TASK_GO_SOMEWHERE,"2500" + StringConstants.SIGN + "2");
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         MainManager.actorModel.removeEventListener(MoveEvent.MOVE,this.onMove);
         this._moduleOpen.destory();
         this._moduleOpen = null;
      }
      
      private function isInFog(param1:Point) : Boolean
      {
         if(param1.y > 210 && param1.y < 393 && param1.x > 1890 && param1.x < 2120)
         {
            return true;
         }
         if(param1.y > 210 && param1.y < 393 && param1.x > 1890 && param1.x < 2120)
         {
            return true;
         }
         return false;
      }
   }
}

