package com.gfp.app.mapProcess
{
   import com.gfp.app.manager.FightPluginManager;
   import com.gfp.app.manager.fightPlugin.AutoFightManager;
   import com.gfp.app.manager.fightPlugin.AutoRecoverManager;
   import com.gfp.app.manager.fightPlugin.AutoTollgateTransManager;
   import com.gfp.app.toolBar.FightToolBar;
   import com.gfp.core.CommandID;
   import com.gfp.core.info.KeyInfo;
   import com.gfp.core.info.fight.SkillInfo;
   import com.gfp.core.manager.KeyManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SkillManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.MapModel;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import org.taomee.net.SocketEvent;
   
   public class InfiniteBattleMapProcess extends BaseMapProcess
   {
      
      private var DEFAULT_SKILLS_FOR_ALL_CHAR:Array = [[100801,100802,100803,100804,100805,100806],[200801,200802,200803,200804,200805,200806],[300801,300802,300803,300804,300805,300806],[400801,400802,400803,400804,400805,400806],[500801,500802,500803,500804,500805,500806],[600801,600802,600803,600804,600805,600806],[700801,700802,700803,700804,700805,700806],[800802,800803,800804,800805,800806,800807,800808,800809]];
      
      private var _map:MapModel;
      
      public function InfiniteBattleMapProcess()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._initDefaultSkills();
         this._startAutoCombat();
         this._zoomOut();
      }
      
      private function _initDefaultSkills() : void
      {
         var _loc3_:int = 0;
         var _loc4_:SkillInfo = null;
         var _loc6_:KeyInfo = null;
         var _loc1_:Vector.<KeyInfo> = new Vector.<KeyInfo>();
         var _loc2_:int = int(MainManager.actorInfo.roleType);
         var _loc5_:int = 0;
         while(_loc5_ < 8)
         {
            _loc6_ = new KeyInfo();
            _loc6_.funcID = KeyManager.skillQuickKeys[_loc5_];
            _loc3_ = int(this.DEFAULT_SKILLS_FOR_ALL_CHAR[_loc2_ - 1][_loc5_]);
            _loc4_ = SkillManager.getSkillInfo(_loc3_);
            if(_loc4_)
            {
               _loc6_.dataID = _loc3_;
               _loc6_.lv = _loc4_.lv;
               _loc1_.push(_loc6_);
            }
            _loc5_++;
         }
         KeyManager.reset();
         KeyManager.upDateSkillQuickKeys(_loc1_);
      }
      
      private function _startAutoCombat() : void
      {
         FightToolBar.instance.disabledSkillQuickKeys();
         FightPluginManager.instance.isPluginRunning = true;
         SocketConnection.addCmdListener(CommandID.FIGHT_END,this.onEnd);
         AutoFightManager.instance.setup();
         AutoTollgateTransManager.instance.setup();
         AutoRecoverManager.instance.setup();
      }
      
      protected function onEnd(param1:SocketEvent) : void
      {
         FightPluginManager.instance.stop();
      }
      
      private function _zoomOut() : void
      {
         var _loc3_:UserModel = null;
         var _loc1_:Number = 0.8;
         var _loc2_:Array = UserManager.getModels();
         for each(_loc3_ in _loc2_)
         {
            _loc3_.changeScale(_loc1_);
         }
         MainManager.actorModel.changeScale(_loc1_);
         this._map = MapManager.currentMap;
         this._map.modelsScale = _loc1_;
      }
      
      private function _recoverZoom() : void
      {
         var _loc2_:UserModel = null;
         if(this._map)
         {
            this._map.modelsScale = 1;
         }
         this._map = null;
         var _loc1_:Array = UserManager.getModels();
         for each(_loc2_ in _loc1_)
         {
            _loc2_.recoverScale();
         }
         MainManager.actorModel.recoverScale();
      }
      
      override public function destroy() : void
      {
         super.destroy();
         KeyManager.reset();
         KeyManager.upDateSkillQuickKeys(MainManager.actorInfo.skills);
         KeyManager.upDateItemQuickKeys(MainManager.actorInfo.items);
         FightToolBar.instance.enabledSkillQuickKeys();
         FightPluginManager.instance.stop();
         AutoFightManager.destroy();
         AutoTollgateTransManager.destroy();
         AutoRecoverManager.destroy();
         this._recoverZoom();
      }
   }
}

