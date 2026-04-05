package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightGo;
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.miniMap.MiniMap;
   import com.gfp.core.config.xml.RoleXMLInfo;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.info.KeyInfo;
   import com.gfp.core.manager.KeyManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.map.BaseMapProcess;
   
   public class MapProcess_1080501 extends BaseMapProcess
   {
      
      public static const SKILL_ID:Vector.<uint> = Vector.<uint>([4120053,4120054,4120055]);
      
      public static const MONSTER_KING_ID:uint = 13218;
      
      public static const BUFF_ID:uint = 9006;
      
      public function MapProcess_1080501()
      {
         super();
      }
      
      override protected function init() : void
      {
         FightManager.instance.addEventListener(FightEvent.BEGIN,this.onFightBegin);
      }
      
      private function onFightBegin(param1:FightEvent) : void
      {
         var _loc4_:KeyInfo = null;
         var _loc2_:Vector.<KeyInfo> = new Vector.<KeyInfo>();
         var _loc3_:int = 0;
         while(_loc3_ < 3)
         {
            _loc4_ = new KeyInfo();
            _loc4_.funcID = KeyManager.skillQuickKeys[_loc3_];
            _loc4_.dataID = RoleXMLInfo.getMonsterSkills(MONSTER_KING_ID)[_loc3_].id;
            _loc2_.push(_loc4_);
            _loc3_++;
         }
         KeyManager.upDateSkillQuickKeys(_loc2_);
         MiniMap.instance.hide();
         FightGo.instance.enabledShow = false;
         MainManager.actorInfo.skillMonsterID = MONSTER_KING_ID;
         MainManager.actorModel.changeRoleView(MONSTER_KING_ID);
         MainManager.actorModel.endBuff(BUFF_ID);
         MainManager.actorModel.bloodBarH = -225;
      }
      
      override public function destroy() : void
      {
         FightManager.instance.removeEventListener(FightEvent.BEGIN,this.onFightBegin);
         KeyManager.upDateSkillQuickKeys(MainManager.actorInfo.skills);
         MiniMap.instance.show();
         FightGo.instance.enabledShow = true;
         MainManager.actorInfo.skillMonsterID = 0;
         MainManager.actorModel.resetRoleView();
         MainManager.actorModel.resetBloodBarH();
      }
   }
}

