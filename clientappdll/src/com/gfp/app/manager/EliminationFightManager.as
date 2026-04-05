package com.gfp.app.manager
{
   import com.gfp.app.fight.FourFightForPet;
   import com.gfp.core.info.FriendInviteInfo;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.FunctionManager;
   import com.gfp.core.map.CityMap;
   
   public class EliminationFightManager extends FourFightForPet
   {
      
      private static var _instance:EliminationFightManager;
      
      public function EliminationFightManager()
      {
         super();
      }
      
      public static function get instance() : EliminationFightManager
      {
         if(_instance == null)
         {
            _instance = new EliminationFightManager();
         }
         return _instance;
      }
      
      override protected function gameWin() : void
      {
         resetMouse();
         AlertManager.showSimpleAlarm("恭喜侠士本场称雄，大会主持人处继续参赛决战群雄吧！",function():void
         {
            CityMap.instance.changeMap(outMap);
         });
      }
      
      override protected function egoisticLimit(param1:Boolean) : void
      {
         super.egoisticLimit(param1);
         FunctionManager.disabledMap = param1;
      }
      
      override protected function showDetailEntry() : void
      {
      }
      
      override protected function hideDetailEntry() : void
      {
      }
      
      override protected function get pvpId() : int
      {
         return 4;
      }
      
      override protected function get roomMap() : int
      {
         return 1044;
      }
      
      override protected function get invitePvpId() : int
      {
         return FriendInviteInfo.ELIMINATION_FIGHT_PVP;
      }
      
      public function get firendInviteID() : int
      {
         return this.invitePvpId;
      }
      
      public function get quickPvpID() : int
      {
         return this.pvpId;
      }
   }
}

