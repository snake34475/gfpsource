package com.gfp.app.cartoon
{
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.events.UserItemEvent;
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
   
   public class GetSkillStoneAnimat extends BaseBean
   {
      
      private const STUDY_SKILL_RES:String = "res/skill/stone/";
      
      private var loader:UILoader;
      
      private var animat:MovieClip;
      
      public function GetSkillStoneAnimat()
      {
         super();
      }
      
      override public function start() : void
      {
         ItemManager.addListener(UserItemEvent.SORT_ITEM_GET,this.onUseGetSkillStone);
         finish();
      }
      
      private function onUseGetSkillStone(param1:UserItemEvent) : void
      {
         if(param1.param == ItemXMLInfo.SKILLBOOK_CAT)
         {
            this.playSkillAnimat(MainManager.roleType);
         }
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
         this.loader = new UILoader(ClientConfig.getStoneSkillAnimat(param1),LayerManager.stage,LoadingType.TITLE_AND_PERCENT,"正在技能动画");
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
            this.animat.stop();
            DisplayUtil.removeForParent(this.animat);
            this.checkSpecialTask();
         }
      }
      
      private function checkSpecialTask() : void
      {
         if(Boolean(TasksManager.isAccepted(3)) || Boolean(TasksManager.isAccepted(301)))
         {
            ModuleManager.closeAllModule();
            ModuleManager.turnAppModule("BagPanel","正在加载...","2");
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

