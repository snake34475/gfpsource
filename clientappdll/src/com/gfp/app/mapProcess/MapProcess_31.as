package com.gfp.app.mapProcess
{
   import com.gfp.app.config.xml.LvInformXMLInfo;
   import com.gfp.app.toolBar.ActivitySuggestionEntry;
   import com.gfp.app.toolBar.AmbassadorEntry;
   import com.gfp.app.toolBar.CityToolBar;
   import com.gfp.app.toolBar.EverydaySignEntry;
   import com.gfp.app.toolBar.MailSysEntry;
   import com.gfp.app.toolBar.MallEntry;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.info.SysMsgInfo;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SystemMessageManager;
   import com.gfp.core.manager.TasksManager;
   
   public class MapProcess_31 extends MapProcessAnimat
   {
      
      public function MapProcess_31()
      {
         _mangoType = 1;
         super();
      }
      
      override protected function init() : void
      {
         _mangoType = 1;
         this.initTaskListener();
         if(MainManager.isDragonFirstLogin)
         {
            MainManager.isDragonFirstLogin = false;
         }
      }
      
      private function initTaskListener() : void
      {
         TasksManager.addListener(TaskEvent.COMPLETE,this.onTaskComplete);
      }
      
      private function onTaskComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 46)
         {
            CityToolBar.instance.showSkillBtn();
         }
         if(param1.taskID == 47)
         {
            this.updateDragonIcons();
         }
      }
      
      private function updateDragonIcons() : void
      {
         MailSysEntry.instance.show();
         ActivitySuggestionEntry.instance.show();
         CityToolBar.instance.setDragonIcons();
         EverydaySignEntry.instance.show();
         MallEntry.instance.show();
         AmbassadorEntry.instance.show();
         var _loc1_:SysMsgInfo = new SysMsgInfo();
         _loc1_.npcID = LvInformXMLInfo.getNpcID(5);
         _loc1_.msg = LvInformXMLInfo.getMsg(5);
         SystemMessageManager.addInfo(_loc1_);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         TasksManager.removeListener(TaskEvent.COMPLETE,this.onTaskComplete);
      }
   }
}

