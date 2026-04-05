package com.gfp.app.mapProcess
{
   import com.gfp.core.CommandID;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1119001 extends BaseMapProcess
   {
      
      private var _tipSp:Sprite;
      
      private var _barUI:Sprite;
      
      private const BOSS_ID:Vector.<uint> = new <uint>[14534,14535];
      
      private const BAR_MAX:Vector.<uint> = new <uint>[1000000,2000000];
      
      private var _damageSum:uint;
      
      private var _bossAlive:int = -1;
      
      public function MapProcess_1119001()
      {
         super();
         this.addListener();
      }
      
      override protected function init() : void
      {
         this._tipSp = _mapModel.libManager.getSprite("bossTip");
         this._barUI = _mapModel.libManager.getSprite("damageBar");
         this._tipSp.x = LayerManager.stageWidth - 30;
         this._tipSp.y = 15;
         LayerManager.uiLevel.addChild(this._tipSp);
      }
      
      private function addListener() : void
      {
         UserManager.addEventListener(UserEvent.BORN,this.onUserBorn);
         UserManager.addEventListener(UserEvent.DIE,this.onUserDie);
         SocketConnection.addCmdListener(CommandID.FIGHT_COMMON_NOTIFY,this.onGetDamage);
      }
      
      private function onGetDamage(param1:SocketEvent) : void
      {
         var _loc5_:uint = 0;
         if(this._bossAlive == -1)
         {
            return;
         }
         this._damageSum = 0;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:int = 0;
         while(_loc3_ < 15)
         {
            _loc5_ = _loc2_.readUnsignedInt();
            if(_loc3_ >= 5)
            {
               this._damageSum += _loc5_;
            }
            _loc3_++;
         }
         var _loc4_:int = 6 - int(this._damageSum / this.BAR_MAX[this._bossAlive] * 5);
         if(_loc4_ < 1)
         {
            _loc4_ = 1;
         }
         (this._barUI["bar"] as MovieClip).gotoAndStop(_loc4_);
      }
      
      private function onUserBorn(param1:UserEvent) : void
      {
         var _loc3_:UserModel = null;
         var _loc4_:int = 0;
         var _loc2_:Array = UserManager.getModels();
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = this.BOSS_ID.indexOf(_loc3_.info.roleType);
            if(_loc4_ != -1)
            {
               this.addBar(_loc3_);
               this._bossAlive = _loc4_;
               break;
            }
         }
      }
      
      private function addBar(param1:UserModel) : void
      {
         this._barUI.x = param1.width / 2 - 10;
         this._barUI.y = -param1.height - 10;
         this._barUI.scaleX = 0.3;
         this._barUI.scaleY = 0.6;
         (this._barUI["bar"] as MovieClip).gotoAndStop(6);
         param1.addChild(this._barUI);
      }
      
      private function removeBar() : void
      {
         DisplayUtil.removeForParent(this._barUI);
      }
      
      private function onUserDie(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         if(this.BOSS_ID.indexOf(_loc2_.info.roleType) != -1)
         {
            this._bossAlive = -1;
            this.removeBar();
         }
      }
      
      private function removeListener() : void
      {
         UserManager.removeEventListener(UserEvent.BORN,this.onUserBorn);
         UserManager.removeEventListener(UserEvent.DIE,this.onUserDie);
         SocketConnection.removeCmdListener(CommandID.FIGHT_COMMON_NOTIFY,this.onGetDamage);
      }
      
      override public function destroy() : void
      {
         this.removeListener();
         if(this._tipSp)
         {
            DisplayUtil.removeForParent(this._tipSp);
         }
         super.destroy();
      }
   }
}

