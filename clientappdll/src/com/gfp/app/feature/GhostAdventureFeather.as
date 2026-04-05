package com.gfp.app.feature
{
   import com.gfp.app.manager.GhostAdventureManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.model.CustomUserModel;
   import com.gfp.core.model.SummonModel;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class GhostAdventureFeather
   {
      
      private var _ghostModel:CustomUserModel;
      
      private var _mov:MovieClip;
      
      public function GhostAdventureFeather()
      {
         super();
         this.init();
         this.addEvent();
      }
      
      public function showMov(param1:MovieClip) : void
      {
         this.clearMov();
         this._mov = param1;
         this._mov.x = 20;
         this._mov.y = -100;
         if(this._ghostModel)
         {
            this._mov.gotoAndPlay(1);
            this._ghostModel.addChild(this._mov);
         }
      }
      
      public function clearMov() : void
      {
         if(this._mov)
         {
            DisplayUtil.removeForParent(this._mov);
            this._mov = null;
         }
      }
      
      public function destory() : void
      {
         this.removeEvent();
         if(this._ghostModel)
         {
            this._ghostModel.stopFollow();
            this._ghostModel.destroy();
         }
         if(this._mov)
         {
            DisplayUtil.removeForParent(this._mov);
            this._mov = null;
         }
      }
      
      private function init() : void
      {
         this._ghostModel = new CustomUserModel(1865);
         this._ghostModel.show(MainManager.actorModel.pos,null,true);
         var _loc1_:SummonModel = SummonManager.getUserSummonModel(MainManager.actorID);
         if(_loc1_)
         {
            this._ghostModel.exeFollow(_loc1_);
         }
         else
         {
            this._ghostModel.exeFollow(MainManager.actorModel);
         }
      }
      
      private function addEvent() : void
      {
         this._ghostModel.addEvent(MouseEvent.CLICK,this.onGhostClick);
      }
      
      private function removeEvent() : void
      {
         this._ghostModel.removeEvent(MouseEvent.CLICK,this.onGhostClick);
      }
      
      private function onGhostClick(param1:MouseEvent) : void
      {
         GhostAdventureManager.isShowMov1 = false;
         GhostAdventureManager.isShowMov2 = false;
         this.clearMov();
         ModuleManager.turnAppModule("GhostAdventurePanel");
      }
   }
}

