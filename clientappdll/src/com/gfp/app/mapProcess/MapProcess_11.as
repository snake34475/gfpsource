package com.gfp.app.mapProcess
{
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.utils.WallowUtil;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_11 extends BaseMapProcess
   {
      
      private static var npc10016Asked:Boolean = false;
      
      private var _productionCloseMC:MovieClip;
      
      private var _productionOpenBtn:SimpleButton;
      
      private var _strengthenOpenBtn:SimpleButton;
      
      public function MapProcess_11()
      {
         super();
      }
      
      override protected function init() : void
      {
         TasksManager.addListener(TaskEvent.COMPLETE,this.onTaskProComplete);
         TasksManager.addListener(TaskEvent.ACCEPT,this.onTaskAccept);
         this._productionCloseMC = _mapModel.downLevel["productionClose"];
         this._productionOpenBtn = _mapModel.downLevel["productionOpen"];
         this._strengthenOpenBtn = _mapModel.downLevel["strengthenOpen"];
         this._strengthenOpenBtn.addEventListener(MouseEvent.CLICK,this.onStrengthenOpen);
         ToolTipManager.add(this._strengthenOpenBtn,"  虚天炉\n装备强化");
         DisplayUtil.removeForParent(this._productionCloseMC);
         this._productionOpenBtn.addEventListener(MouseEvent.CLICK,this.onProductionOpen);
         ToolTipManager.add(this._productionOpenBtn,"  玄天炉\n装备分解");
      }
      
      private function onTaskProComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 24)
         {
            NpcDialogController.showForNpc(10016);
         }
      }
      
      private function onTaskAccept(param1:TaskEvent) : void
      {
         if(param1.taskID == 1105)
         {
            ModuleManager.turnModule(ClientConfig.getGameModule("MadeWeapon"),"正在加载游戏..");
         }
      }
      
      private function onProductionOpen(param1:MouseEvent) : void
      {
         if(WallowUtil.isWallow())
         {
            WallowUtil.showWallowMsg(AppLanguageDefine.WALLOW_MSG_ARR[3]);
            return;
         }
         ModuleManager.turnModule(ClientConfig.getAppModule("EquipCastingPanel"),"正在打开玄天炉...",3);
      }
      
      private function onStrengthenOpen(param1:MouseEvent) : void
      {
         if(WallowUtil.isWallow())
         {
            WallowUtil.showWallowMsg(AppLanguageDefine.WALLOW_MSG_ARR[4]);
            return;
         }
         ModuleManager.turnModule(ClientConfig.getAppModule("EquipCastingPanel"),"正在打开虚天鼎...",1);
      }
      
      override public function destroy() : void
      {
         TasksManager.removeListener(TaskEvent.COMPLETE,this.onTaskProComplete);
         TasksManager.removeListener(TaskEvent.ACCEPT,this.onTaskAccept);
         this._productionOpenBtn.removeEventListener(MouseEvent.CLICK,this.onProductionOpen);
         this._strengthenOpenBtn.removeEventListener(MouseEvent.CLICK,this.onStrengthenOpen);
         ToolTipManager.remove(this._strengthenOpenBtn);
         ToolTipManager.remove(this._productionOpenBtn);
      }
   }
}

