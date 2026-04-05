package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightGo;
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.miniMap.MiniMap;
   import com.gfp.app.toolBar.FightToolBar;
   import com.gfp.app.toolBar.HeadSummonPanel;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.info.KeyInfo;
   import com.gfp.core.manager.KeyManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.map.BaseMapProcess;
   
   public class MapProcess_1073401 extends BaseMapProcess
   {
      
      public static const SEVEN_CODE:uint = 55;
      
      public static const EIGHT_CODE:uint = 56;
      
      public static const NINE_CODE:uint = 57;
      
      public function MapProcess_1073401()
      {
         super();
      }
      
      override protected function init() : void
      {
         FightManager.instance.addEventListener(FightEvent.BEGIN,this.initKey);
      }
      
      override public function destroy() : void
      {
         MainManager.openOperate();
         FightToolBar.instance.enabledSkillQuickKeys();
         FightToolBar.instance.enabledBag();
         MiniMap.instance.show();
         FightGo.instance.enabledShow = true;
         KeyManager.upDateSkillQuickKeys(MainManager.actorInfo.skills);
         KeyManager.upDateItemQuickKeys(MainManager.actorInfo.items);
         FightToolBar.instance.enabledSkillQuickKeys();
         KeyManager.setItemQuickAutoAddable(true);
         HeadSummonPanel.instance.recoverStatus();
         FightManager.instance.removeEventListener(FightEvent.BEGIN,this.initKey);
         super.destroy();
      }
      
      private function initKey(param1:FightEvent) : void
      {
         var _loc4_:KeyInfo = null;
         MainManager.closeOperate(false,false);
         LayerManager.toolUiLevel.mouseChildren = true;
         var _loc2_:Vector.<KeyInfo> = new Vector.<KeyInfo>(5,true);
         var _loc3_:int = 0;
         while(_loc3_ < 5)
         {
            _loc4_ = new KeyInfo();
            _loc2_[_loc3_] = _loc4_;
            _loc3_++;
         }
         KeyManager.upDateItemQuickKeys(_loc2_);
         KeyManager.setItemQuickAutoAddable(false);
         FightToolBar.instance.disabledSkillQuickKeys();
         FightToolBar.instance.disabledBag();
         MiniMap.instance.hide();
         FightGo.instance.enabledShow = false;
         HeadSummonPanel.instance.setRaceStatus();
      }
   }
}

