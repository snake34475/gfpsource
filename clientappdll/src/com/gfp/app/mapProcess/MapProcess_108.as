package com.gfp.app.mapProcess
{
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.model.sensemodels.SightModel;
   
   public class MapProcess_108 extends MapProcessAnimat
   {
      
      private var _qingQiuModel:SightModel;
      
      private var _swkModel1:SightModel;
      
      private var _swkModel2:SightModel;
      
      private var _nmwModel1:SightModel;
      
      private var _nmwModel2:SightModel;
      
      public function MapProcess_108()
      {
         _mangoType = 1;
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         _mangoType = 1;
         TasksManager.addListener(TaskEvent.COMPLETE,this.onTaskComplete);
         TasksManager.addListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
         this._qingQiuModel = SightManager.getSightModel(10565);
         this._swkModel1 = SightManager.getSightModel(10564);
         this._swkModel2 = SightManager.getSightModel(10566);
         this._nmwModel1 = SightManager.getSightModel(10561);
         this._nmwModel2 = SightManager.getSightModel(10567);
         this.checkModel();
      }
      
      private function checkModel() : void
      {
         if(Boolean(TasksManager.isCompleted(2156)) && !TasksManager.isCompleted(2157))
         {
            if(this._qingQiuModel)
            {
               this._qingQiuModel.visible = true;
            }
         }
         else if(this._qingQiuModel)
         {
            this._qingQiuModel.visible = false;
         }
         if(Boolean(TasksManager.isCompleted(2158)) && !TasksManager.isCompleted(2159))
         {
            if(this._nmwModel1)
            {
               this._nmwModel1.visible = true;
            }
            if(this._nmwModel2)
            {
               this._nmwModel2.visible = false;
            }
            if(this._swkModel2)
            {
               this._swkModel2.visible = false;
            }
         }
         else if(!TasksManager.isCompleted(2158) && !TasksManager.isCompleted(2159))
         {
            if(this._nmwModel1)
            {
               this._nmwModel1.visible = false;
            }
            if(this._nmwModel2)
            {
               this._nmwModel2.visible = false;
            }
            if(this._swkModel2)
            {
               this._swkModel2.visible = false;
            }
         }
         if(Boolean(TasksManager.getTaskProBytes(2159,1)) || Boolean(TasksManager.isCompleted(2159)))
         {
            this._nmwModel1.visible = false;
            this._swkModel1.visible = false;
            this._swkModel2.visible = true;
            this._nmwModel2.visible = true;
         }
         if(TasksManager.isCompleted(2160))
         {
            this._nmwModel1.visible = true;
            this._swkModel1.visible = true;
            this._swkModel2.visible = false;
            this._nmwModel2.visible = false;
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         TasksManager.removeListener(TaskEvent.COMPLETE,this.onTaskComplete);
      }
      
      private function onTaskComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 2157)
         {
            if(this._qingQiuModel)
            {
               this._qingQiuModel.visible = false;
            }
         }
         if(param1.taskID == 2156)
         {
            if(this._qingQiuModel)
            {
               this._qingQiuModel.visible = true;
            }
         }
         if(param1.taskID == 2159)
         {
            this._nmwModel1.visible = false;
            this._swkModel1.visible = false;
            this._swkModel2.visible = true;
            this._nmwModel2.visible = true;
         }
         if(param1.taskID == 2160)
         {
            this._nmwModel1.visible = true;
            this._swkModel1.visible = true;
            this._swkModel2.visible = false;
            this._nmwModel2.visible = false;
         }
      }
      
      private function onTaskProComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 2158 && param1.proID == 1)
         {
            this._nmwModel1.visible = true;
         }
         if(param1.taskID == 2159 && param1.proID == 1)
         {
            this._nmwModel1.visible = false;
            this._swkModel1.visible = false;
            this._swkModel2.visible = true;
            this._nmwModel2.visible = true;
         }
         if(param1.taskID == 2160 && param1.proID == 5)
         {
            this._nmwModel1.visible = true;
            this._swkModel1.visible = true;
            this._swkModel2.visible = false;
            this._nmwModel2.visible = false;
         }
      }
   }
}

