package com.gfp.app.plugins
{
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.app.toolBar.TaskTrackPanel;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.info.RectInfo;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   import com.gfp.core.ui.controller.GuideAdapter;
   import com.gfp.core.ui.events.UIEvent;
   import com.gfp.core.xmlconfig.GuideXmlInfo;
   import flash.events.Event;
   import flash.geom.Rectangle;
   
   public class TaskTrackGuidePlugin extends BasePlugin
   {
      
      private var _needGuideTasks:Array = [531,521];
      
      private var _guide:GuideAdapter;
      
      public function TaskTrackGuidePlugin()
      {
         super();
      }
      
      override public function install() : void
      {
         if(this.allTaskComplete())
         {
            PluginManager.instance.uninstallPlugin("TaskTrackGuidePlugin");
         }
         else
         {
            super.install();
            MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onSwitchComplete);
            ModuleManager.event.addEventListener(UIEvent.CLOSE_MODULE,this.moduleCloseHandle);
            TasksManager.addListener(TaskEvent.PRO_COMPLETE,this.taskProCompleteHandle);
            TasksManager.addListener(TaskEvent.COMPLETE,this.taskCompleteHandle);
         }
      }
      
      private function taskProCompleteHandle(param1:TaskEvent) : void
      {
         this.reset();
      }
      
      private function moduleCloseHandle(param1:Event) : void
      {
         this.reset();
      }
      
      private function taskCompleteHandle(param1:TaskEvent) : void
      {
         if(this._needGuideTasks.indexOf(param1.taskID) != -1)
         {
            this.reset();
         }
         if(this.allTaskComplete())
         {
            PluginManager.instance.uninstallPlugin("TaskTrackGuidePlugin");
         }
      }
      
      private function allTaskComplete() : Boolean
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._needGuideTasks.length)
         {
            if(TasksManager.isCompleted(this._needGuideTasks[_loc1_]) == false)
            {
               return false;
            }
            _loc1_++;
         }
         return true;
      }
      
      private function onSwitchComplete(param1:MapEvent) : void
      {
         if(this._guide)
         {
            this._guide.destory();
            this._guide = null;
         }
         if(param1.mapModel.info.mapType == MapType.STAND)
         {
            this.reset();
         }
      }
      
      private function reset() : void
      {
         var _loc2_:Rectangle = null;
         var _loc3_:RectInfo = null;
         if(this._guide)
         {
            this._guide.destory();
            this._guide = null;
         }
         if(MainManager.actorInfo.lv > 80 || MapManager.mapInfo == null || MapManager.mapInfo.mapType != MapType.STAND || ModuleManager.getShowModuleCount() > 0 || NpcDialogController.panel.mainUI.stage != null)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this._needGuideTasks.length)
         {
            if(TasksManager.isReady(this._needGuideTasks[_loc1_]))
            {
               _loc2_ = TaskTrackPanel.instance.getTaskArea(this._needGuideTasks[_loc1_]);
               if(_loc2_)
               {
                  _loc3_ = new RectInfo();
                  _loc3_.left = _loc2_.x;
                  _loc3_.top = _loc2_.y;
                  _loc3_.width = _loc2_.width;
                  _loc3_.height = _loc2_.height;
                  GuideXmlInfo.setInfoRect(8,1,_loc3_);
                  this._guide = new GuideAdapter(8);
                  this._guide.show();
               }
               return;
            }
            _loc1_++;
         }
      }
      
      override public function uninstall() : void
      {
         super.uninstall();
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onSwitchComplete);
         ModuleManager.event.removeEventListener(UIEvent.CLOSE_MODULE,this.moduleCloseHandle);
         TasksManager.removeListener(TaskEvent.PRO_COMPLETE,this.taskProCompleteHandle);
         TasksManager.removeListener(TaskEvent.COMPLETE,this.taskCompleteHandle);
      }
   }
}

