package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.ShowCartoonFeather;
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.utils.strength.SwfLoaderHelper;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class MapProcess_1108901 extends BaseMapProcess
   {
      
      private var _pos:Point;
      
      private var mc:MovieClip;
      
      private var _firemc:ShowCartoonFeather;
      
      public function MapProcess_1108901()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         var _loc1_:int = 0;
         this._firemc = null;
         FightManager.instance.addEventListener(FightEvent.OGRE_DIE,this.onMonsterDie);
         UserManager.addEventListener(UserEvent.DIE,this.onDie);
      }
      
      private function movieCallBack(param1:Loader) : void
      {
         this.mc = param1.content["mc"];
         this.mc.x = this._pos.x;
         this.mc.y = this._pos.y + 100;
         MapManager.currentMap.root.addChild(this.mc);
      }
      
      private function onDie(param1:UserEvent) : void
      {
         var _loc4_:SwfLoaderHelper = null;
         var _loc2_:UserModel = param1.data as UserModel;
         var _loc3_:UserInfo = _loc2_.info;
         if(_loc2_.info.roleType == 14260)
         {
            UserManager.removeEventListener(UserEvent.DIE,this.onDie);
            _loc4_ = new SwfLoaderHelper();
            _loc4_.loadFile(ClientConfig.getCartoon("Tian_Ji_Light"),this.movieCallBack);
            this._firemc = new ShowCartoonFeather("Tian_Ji",5000);
            UserManager.addEventListener(UserEvent.BORN,this.onMonsterBorn);
         }
      }
      
      private function onMonsterBorn(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         var _loc3_:UserInfo = _loc2_.info;
         if(!_loc3_)
         {
            return;
         }
         if(_loc2_.info.roleType == 14261)
         {
            UserManager.removeEventListener(UserEvent.BORN,this.onMonsterBorn);
            this.mc.visible = false;
            this.mc = null;
         }
      }
      
      private function onMonsterDie(param1:FightEvent) : void
      {
         var _loc2_:UserInfo = param1.data as UserInfo;
         if(_loc2_.roleType == 14260)
         {
            this._pos = _loc2_.pos;
            FightManager.instance.removeEventListener(FightEvent.OGRE_DIE,this.onMonsterDie);
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(this._firemc)
         {
            this._firemc.destroy();
         }
         if(this.mc)
         {
            this.mc = null;
         }
         FightManager.instance.removeEventListener(FightEvent.OGRE_DIE,this.onMonsterDie);
         UserManager.removeEventListener(UserEvent.DIE,this.onDie);
         UserManager.removeEventListener(UserEvent.BORN,this.onMonsterBorn);
      }
   }
}

