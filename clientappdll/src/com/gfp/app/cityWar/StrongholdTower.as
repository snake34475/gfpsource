package com.gfp.app.cityWar
{
   import com.gfp.app.fight.PveEntry;
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.CommandID;
   import com.gfp.core.events.MoveEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class StrongholdTower extends Sprite
   {
      
      private var _mainUI:Sprite;
      
      private var _info:TowerInfo;
      
      private var _bloodBar:TowerBloodBar;
      
      private var _defaultY:Number;
      
      private var _fireMC:Sprite;
      
      public function StrongholdTower(param1:Sprite, param2:TowerInfo)
      {
         super();
         this._info = param2;
         this._mainUI = param1;
         this._fireMC = UIManager.getSprite("Fight_UI_Fire");
         this._mainUI.buttonMode = true;
         this._mainUI.addEventListener(MouseEvent.CLICK,this.onTowerClick);
         if(param2.towerID != 13 && param2.towerID != 14)
         {
            MainManager.actorModel.addEventListener(MoveEvent.MOVE_END,this.onMoveEnd);
         }
         SocketConnection.addCmdListener(CommandID.ATTACK_TOWER,this.onAttackTower);
         var _loc3_:uint = MainManager.actorInfo.overHeadState == this._info.team ? 2 : 1;
         this._bloodBar = new TowerBloodBar(_loc3_);
         if(this._info.towerID == 3 || this._info.towerID == 4)
         {
            this._bloodBar.scaleX = -1;
            this._bloodBar.x = this._bloodBar.width / 2;
         }
         else
         {
            this._bloodBar.x = -this._bloodBar.width / 2;
         }
         this._bloodBar.bloodTotal = 6;
         this.setHp(this._info.hp);
         if(this._info.towerID == 13 || this._info.towerID == 14)
         {
            this._defaultY = -this._mainUI.height - 50;
         }
         else
         {
            this._defaultY = -this._mainUI.height / 2 + 50;
         }
         this._bloodBar.y = this._defaultY;
         this._mainUI.addChild(this._bloodBar);
      }
      
      private function onTowerClick(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         if(CityWarPkController.tollgateDis)
         {
            return;
         }
         if(this._info.team != MainManager.actorInfo.overHeadState)
         {
            if(this._info.towerID > 12)
            {
               NpcDialogController.hide();
               _loc2_ = this.getTollgateID(this._info.towerID);
               PveEntry.enterTollgate(_loc2_,1,0,this._info.towerID + 10000);
            }
            else
            {
               SocketConnection.send(CommandID.ATTACK_TOWER,this._info.towerID);
            }
         }
         else if(this._info.towerID <= 12)
         {
            ModuleManager.turnAppModule("TowerUpdatePanel","正在加载。。。。",this._info.towerID);
         }
      }
      
      private function onMoveEnd(param1:MoveEvent) : void
      {
         var _loc2_:Number = Number(MapManager.currentMap.camera.viewToTotal(new Point()).y);
         var _loc3_:Number = this._defaultY + this._mainUI.y;
         var _loc4_:Number = _loc2_ - _loc3_;
         if(_loc4_ > 0)
         {
            this._bloodBar.y = this._defaultY + _loc4_ + 50;
         }
         else
         {
            this._bloodBar.y = this._defaultY;
         }
         var _loc5_:TowerInfo = TowerController.instance.getTowerInfo(this._info.towerID);
         if(_loc5_.getDefUserList().indexOf(MainManager.actorID) != -1)
         {
            if(!MapManager.currentMap.isBlock(MainManager.actorModel.pos))
            {
               TowerController.instance.putUserModel(MainManager.actorModel);
               MainManager.actorModel.execStandAction();
            }
         }
      }
      
      private function onAttackTower(param1:SocketEvent) : void
      {
         var _loc5_:uint = 0;
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         if(_loc3_ == 0)
         {
            TextAlert.show("此据点还不能攻打！");
            return;
         }
         if(_loc4_ == this._info.towerID && _loc3_ == 2)
         {
            _loc5_ = this.getTollgateID(_loc4_);
            PveEntry.enterTollgate(_loc5_,1,0,this._info.towerID + 10000);
         }
      }
      
      private function getTollgateID(param1:uint) : uint
      {
         var _loc2_:Boolean = this._info.team == 1;
         if(param1 > 12)
         {
            return _loc2_ ? 687 : 689;
         }
         if(param1 >= 5 && param1 <= 8)
         {
            return _loc2_ ? 698 : 699;
         }
         return _loc2_ ? 686 : 688;
      }
      
      public function setHp(param1:uint) : void
      {
         this._bloodBar.bloodCurrent = param1;
         this._info.hp = param1;
         if(this._info.towerID == 13 || this._info.towerID == 14)
         {
            return;
         }
         if(param1 < 5)
         {
            this._mainUI.addChild(this._fireMC);
            return;
         }
         if(param1 < 3)
         {
            this._fireMC.scaleY = this._fireMC.scaleX = 2;
            this._fireMC.y = -this._fireMC.height / 4;
            this._mainUI.addChild(this._fireMC);
         }
      }
      
      public function getPosX() : Number
      {
         return this._mainUI.x;
      }
      
      public function getPosY() : Number
      {
         return this._mainUI.y;
      }
      
      public function getTowerH() : Number
      {
         return this._mainUI.height;
      }
      
      public function hide() : void
      {
         DisplayUtil.removeForParent(this._mainUI);
      }
      
      public function destroy() : void
      {
         this.hide();
         this._bloodBar.destroy();
         this._bloodBar = null;
         this._fireMC = null;
         this._mainUI.removeEventListener(MouseEvent.CLICK,this.onTowerClick);
         SocketConnection.removeCmdListener(CommandID.ATTACK_TOWER,this.onAttackTower);
         MainManager.actorModel.removeEventListener(MoveEvent.MOVE_END,this.onMoveEnd);
         this._mainUI = null;
      }
   }
}

