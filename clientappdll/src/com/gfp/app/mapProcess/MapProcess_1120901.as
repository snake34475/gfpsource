package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.LeftTimeTxtFeater;
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.CommandID;
   import com.gfp.core.cache.SwfCache;
   import com.gfp.core.cache.SwfInfo;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.HpMpInfo;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1120901 extends BaseMapProcess
   {
      
      private var _txtInfoMc:MovieClip;
      
      private var _feather:LeftTimeTxtFeater;
      
      private var _headIconList:Array;
      
      public function MapProcess_1120901()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._txtInfoMc = _mapModel.libManager.getMovieClip("UI_TxtInfo");
         FightManager.instance.addEventListener(FightEvent.OGRE_DIE,this.onModelDied);
         SocketConnection.addCmdListener(CommandID.INFORM_USER_HPMP,this.onRevive);
         UserManager.addEventListener(UserEvent.BORN,this.onPlayCreate);
         this._feather = new LeftTimeTxtFeater(1 * 60 * 1000,this._txtInfoMc["timeTxt"] as TextField,null);
         this._feather.start();
         StageResizeController.instance.register(this.resizePos);
         this.resizePos();
      }
      
      private function onEvent(param1:UserEvent) : void
      {
         var _loc2_:UserInfo = param1.data as UserInfo;
         var _loc3_:UserModel = UserManager.getModel(_loc2_.userID);
         if(_loc3_)
         {
            this.updateMonsterInfo(_loc3_);
         }
      }
      
      private function onRevive(param1:SocketEvent) : void
      {
         var _loc2_:HpMpInfo = param1.data as HpMpInfo;
         var _loc3_:int = 0;
         var _loc4_:UserModel = UserManager.getModelByRoleType(12380);
         if((Boolean(_loc4_)) && param1.headInfo.userID == _loc4_.info.userID)
         {
            this._txtInfoMc["barInfo0"].bloodTxt.text = _loc2_.hp.toString() + "/" + _loc4_.info.maxHp.toString();
            _loc3_ = _loc2_.hp / _loc4_.info.maxHp * 100;
            this._txtInfoMc["barInfo0"].gotoAndStop(_loc3_);
         }
         else if(!_loc4_)
         {
            this._txtInfoMc["barInfo0"].bloodTxt.text = "0/20000";
            _loc3_ = 1;
            this._txtInfoMc["barInfo0"].gotoAndStop(_loc3_);
         }
         _loc4_ = UserManager.getModelByRoleType(12381);
         if((Boolean(_loc4_)) && param1.headInfo.userID == _loc4_.info.userID)
         {
            this._txtInfoMc["barInfo1"].bloodTxt.text = _loc2_.hp.toString() + "/" + _loc4_.info.maxHp.toString();
            _loc3_ = _loc2_.hp / _loc4_.info.maxHp * 100;
            this._txtInfoMc["barInfo1"].gotoAndStop(_loc3_);
         }
         else if(!_loc4_)
         {
            this._txtInfoMc["barInfo1"].bloodTxt.text = "0/20000";
            _loc3_ = 1;
            this._txtInfoMc["barInfo1"].gotoAndStop(_loc3_);
         }
      }
      
      private function updateMonsterInfo(param1:UserModel) : void
      {
         var _loc2_:int = 0;
         if(param1.info.roleType == 12380)
         {
            this._txtInfoMc["barInfo0"].bloodTxt.text = param1.info.hp.toString() + "/" + param1.info.maxHp.toString();
            _loc2_ = param1.info.hp / param1.info.maxHp * 100;
            this._txtInfoMc["barInfo0"].gotoAndStop(_loc2_);
         }
         if(param1.info.roleType == 12381)
         {
            this._txtInfoMc["barInfo1"].bloodTxt.text = param1.info.hp.toString() + "/" + param1.info.maxHp.toString();
            _loc2_ = param1.info.hp / param1.info.maxHp * 100;
            this._txtInfoMc["barInfo1"].gotoAndStop(_loc2_);
         }
      }
      
      private function onModelDied(param1:FightEvent) : void
      {
         if(param1.data.roleType == 12382)
         {
         }
         if(param1.data.roleType == 12383)
         {
         }
      }
      
      private function playEnd() : void
      {
         this._txtInfoMc.notAttackMc.visible = false;
      }
      
      private function resizePos() : void
      {
         this._txtInfoMc.x = 335;
         this._txtInfoMc.y = 165;
         LayerManager.topLevel.addChild(this._txtInfoMc);
      }
      
      private function onPlayCreate(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         if(_loc2_.info.roleType == 12380)
         {
            SwfCache.getSwfInfo(ClientConfig.getRoleIcon(_loc2_.info.roleType),this.onLoad);
            this.updateMonsterInfo(_loc2_);
         }
         if(_loc2_.info.roleType == 12381)
         {
            SwfCache.getSwfInfo(ClientConfig.getRoleIcon(_loc2_.info.roleType),this.onLoad1);
            this.updateMonsterInfo(_loc2_);
         }
         if(_loc2_.info.roleType == 12382)
         {
            this._txtInfoMc["barInfo0"]["monsterTxt"].text = _loc2_.info.nick;
         }
         if(_loc2_.info.roleType == 12383)
         {
            this._txtInfoMc["barInfo1"]["monsterTxt"].text = _loc2_.info.nick;
         }
      }
      
      private function onLoad(param1:SwfInfo) : void
      {
         if(!this._headIconList)
         {
            this._headIconList = [];
         }
         var _loc2_:Sprite = param1.content as Sprite;
         this._headIconList.push(_loc2_);
         _loc2_.mouseChildren = false;
         _loc2_.mouseEnabled = false;
         _loc2_.cacheAsBitmap = true;
         this._txtInfoMc["barInfo0"].headCon.addChild(_loc2_);
      }
      
      private function onLoad1(param1:SwfInfo) : void
      {
         if(!this._headIconList)
         {
            this._headIconList = [];
         }
         var _loc2_:Sprite = param1.content as Sprite;
         this._headIconList.push(_loc2_);
         _loc2_.mouseChildren = false;
         _loc2_.mouseEnabled = false;
         _loc2_.cacheAsBitmap = true;
         this._txtInfoMc["barInfo1"].headCon.addChild(_loc2_);
      }
      
      private function clearHeadIcon() : void
      {
         var _loc1_:Sprite = null;
         if(this._headIconList)
         {
            for each(_loc1_ in this._headIconList)
            {
               _loc1_.cacheAsBitmap = false;
               DisplayUtil.removeForParent(_loc1_);
               _loc1_ = null;
            }
         }
      }
      
      override public function destroy() : void
      {
         this.clearHeadIcon();
         UserManager.removeEventListener(UserEvent.BORN,this.onPlayCreate);
         FightManager.instance.removeEventListener(FightEvent.OGRE_DIE,this.onModelDied);
         if(this._feather)
         {
            this._feather.destroy();
            this._feather = null;
         }
         DisplayUtil.removeForParent(this._txtInfoMc);
         this._txtInfoMc = null;
         StageResizeController.instance.unregister(this.resizePos);
         super.destroy();
         SocketConnection.removeCmdListener(CommandID.INFORM_USER_HPMP,this.onRevive);
      }
   }
}

