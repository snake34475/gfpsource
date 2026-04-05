package com.gfp.app.cartoon
{
   import com.gfp.app.toolBar.CityToolBar;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.ResEvent;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.ui.UILoader;
   import com.gfp.core.ui.loading.LoadingType;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import org.taomee.bean.BaseBean;
   import org.taomee.utils.DisplayUtil;
   
   public class StudySkillAnimat extends BaseBean
   {
      
      private const STUDY_SKILL_RES:String = "res/skill/study/";
      
      private var loader:UILoader;
      
      private var animat:MovieClip;
      
      public function StudySkillAnimat()
      {
         super();
      }
      
      override public function start() : void
      {
         ItemManager.addListener(ResEvent.USE_SKILLBOOK,this.onUseSkillBook);
         finish();
      }
      
      private function onUseSkillBook(param1:ResEvent) : void
      {
         this.playSkillAnimat(MainManager.roleType);
      }
      
      public function playSkillAnimat(param1:int) : void
      {
         if(this.animat == null)
         {
            this.loadMC(param1);
         }
         else
         {
            this.playAnimat();
         }
      }
      
      private function loadMC(param1:int) : void
      {
         this.loader = new UILoader(ClientConfig.getStudySkillAnimat(param1),LayerManager.stage,LoadingType.TITLE_AND_PERCENT,"正在技能动画");
         this.loader.closeEnabled = false;
         this.loader.addEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this.loader.addEventListener(IOErrorEvent.IO_ERROR,this.onIOErrorHandler);
         this.loader.load();
      }
      
      private function onLoadComplete(param1:UILoadEvent) : void
      {
         this.animat = (param1.uiloader.content as MovieClip)["animat"];
         this.loader.removeEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this.loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOErrorHandler);
         this.loader.close();
         this.loader = null;
         this.playAnimat();
      }
      
      private function playAnimat() : void
      {
         MainManager.closeOperate();
         this.animat.addEventListener(Event.ENTER_FRAME,this.animatEnterFrame);
         this.animat.gotoAndPlay(1);
         LayerManager.topLevel.addChild(this.animat);
         this.animat.x = 250;
         this.animat.y = -40;
      }
      
      private function animatEnterFrame(param1:Event) : void
      {
         if(this.animat == null)
         {
            return;
         }
         if(this.animat.currentFrame == this.animat.totalFrames)
         {
            this.animat.removeEventListener(Event.ENTER_FRAME,this.animatEnterFrame);
            MainManager.openOperate();
            DisplayUtil.removeForParent(this.animat);
            if(CityToolBar.isBatteryUse)
            {
               ModuleManager.showModule(ClientConfig.getAppModule("SkillBookPanel"),"正在加载功夫宝典...");
            }
            CityToolBar.isBatteryUse = false;
            this.checkSpecialTask();
         }
      }
      
      private function checkSpecialTask() : void
      {
         if(Boolean(TasksManager.isAccepted(3)) && Boolean(TasksManager.isProcess(3,1)) || Boolean(TasksManager.isAccepted(301)) && Boolean(TasksManager.isProcess(301,1)))
         {
            ModuleManager.closeAllModule();
            ModuleManager.turnAppModule("SkillBookPanel");
         }
      }
      
      private function onIOErrorHandler(param1:IOErrorEvent) : void
      {
      }
      
      public function destory() : void
      {
         DisplayUtil.removeForParent(this.animat);
         this.animat = null;
      }
   }
}

