package com.gfp.app.cityWar
{
   import com.gfp.app.manager.CityWarManager;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.xml.MapXMLInfo;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.MapModel;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.StringConstants;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import org.taomee.ds.HashMap;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.GeomUtil;
   
   public class TowerController
   {
      
      private static var _instance:TowerController;
      
      public static const TOWER_INFO_CHANGE:String = "tower_info_change";
      
      public static const TOWER_WAS_ATTACKED:String = "tower_was_attacked";
      
      public static const TOWER_SAFE:String = "tower_safe";
      
      public static const TOWER_MAPS:Array = [1020,1021,1023,1024,1025,1026,1028,1029,1030,1031,1033,1034];
      
      private var _towerInfoHash:HashMap;
      
      private var _towerHash:HashMap;
      
      private var _towerModel:StrongholdTower;
      
      private var _ed:EventDispatcher;
      
      private var _towerCentre:Point;
      
      private var _defDistance:Number;
      
      public function TowerController()
      {
         super();
      }
      
      public static function get instance() : TowerController
      {
         if(_instance == null)
         {
            _instance = new TowerController();
         }
         return _instance;
      }
      
      public static function addEventListner(param1:String, param2:Function) : void
      {
         instance.addEventListner(param1,param2);
      }
      
      public static function removeEventListner(param1:String, param2:Function) : void
      {
         instance.removeEventListner(param1,param2);
      }
      
      public static function destroy() : void
      {
         if(_instance)
         {
            _instance.destroy();
         }
         _instance = null;
      }
      
      public function setup() : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TowerInfo = null;
         var _loc5_:uint = 0;
         this._towerInfoHash = new HashMap();
         var _loc1_:int = 0;
         while(_loc1_ < 12)
         {
            _loc2_ = _loc1_ % 4;
            if(_loc2_ < 2)
            {
               _loc5_ = 1;
            }
            else
            {
               _loc5_ = 2;
            }
            _loc3_ = uint(TOWER_MAPS[_loc1_]);
            _loc4_ = new TowerInfo(_loc1_ + 1,_loc5_,_loc3_);
            this._towerInfoHash.add(_loc1_ + 1,_loc4_);
            _loc1_++;
         }
         this._towerInfoHash.add(13,new TowerInfo(13,1,CityWarManager.RED_BASE_MAP));
         this._towerInfoHash.add(14,new TowerInfo(14,2,CityWarManager.BLUE_BASE_MAP));
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         SocketConnection.addCmdListener(CommandID.TOWER_STATE_CHANGE,this.onTowerStateChange);
      }
      
      private function removeEvent() : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         SocketConnection.removeCmdListener(CommandID.TOWER_STATE_CHANGE,this.onTowerStateChange);
      }
      
      private function onMapSwitchComplete(param1:MapEvent) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:Sprite = null;
         var _loc8_:TowerInfo = null;
         var _loc9_:Number = NaN;
         var _loc10_:int = 0;
         var _loc11_:Number = NaN;
         var _loc2_:MapModel = param1.mapModel;
         var _loc3_:uint = uint(_loc2_.info.id);
         if(this._towerModel)
         {
            this._towerModel.destroy();
            this._towerModel = null;
         }
         var _loc4_:int = TOWER_MAPS.indexOf(_loc3_);
         if(_loc4_ != -1)
         {
            _loc5_ = _loc4_ + 1;
            _loc6_ = uint(MainManager.actorInfo.overHeadState);
            _loc7_ = _loc2_.contentLevel["towerMC"];
            if(this._towerInfoHash.containsKey(_loc5_))
            {
               _loc8_ = this._towerInfoHash.getValue(_loc5_);
               this._towerModel = new StrongholdTower(_loc7_,_loc8_);
               _loc9_ = this._towerModel.getPosX();
               if(_loc8_.team == 2 && _loc6_ == 1)
               {
                  _loc2_.updatePathData(_loc9_ - 100,0,250,_loc2_.height,false);
               }
               else if(_loc8_.team == 1 && _loc6_ == 2)
               {
                  _loc2_.updatePathData(_loc9_ - 150,0,250,_loc2_.height,false);
               }
               if(_loc8_.team == MainManager.actorInfo.overHeadState)
               {
                  this.setDefPoint(_loc5_,_loc9_);
                  if(_loc8_.getDefUserList().indexOf(MainManager.actorID) != -1)
                  {
                     MapManager.currentMap.upLevel.addChild(MainManager.actorModel);
                  }
               }
            }
            else
            {
               _loc7_.visible = false;
               MainManager.actorModel.pos = MapManager.mapInfo.gotoPos;
            }
         }
         else if(_loc3_ == CityWarManager.RED_BASE_MAP || _loc3_ == CityWarManager.BLUE_BASE_MAP)
         {
            _loc10_ = _loc3_ - CityWarManager.RED_BASE_MAP;
            _loc7_ = SightManager.getSightModel(10439 + _loc10_);
            _loc8_ = this._towerInfoHash.getValue(13 + _loc10_);
            if(_loc8_)
            {
               this._towerModel = new StrongholdTower(_loc7_,_loc8_);
               if(_loc8_.team != MainManager.actorInfo.overHeadState)
               {
                  _loc11_ = (_loc8_.team - 1) * 10 + 165;
                  _loc2_.updatePathData(_loc7_.x - _loc11_,500,_loc11_ * 2,250,false);
               }
            }
         }
      }
      
      private function setDefPoint(param1:uint, param2:Number) : void
      {
         if(param1 >= 5 && param1 <= 8)
         {
            this._defDistance = 120;
         }
         else
         {
            this._defDistance = 60;
         }
         this._towerCentre = new Point(param2,MapManager.currentMap.height - this._defDistance);
      }
      
      private function onTowerStateChange(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         var _loc6_:uint = _loc2_.readUnsignedInt();
         var _loc7_:TowerInfo = this._towerInfoHash.getValue(_loc3_);
         if(_loc7_.hp > _loc5_ && _loc4_ == MainManager.actorInfo.overHeadState)
         {
            this.showTowerAlert(_loc7_,_loc5_);
         }
         _loc7_.hp = _loc5_;
         var _loc8_:Boolean = true;
         if(MapManager.currentMap == null || MapManager.mapInfo.id != _loc7_.mapID)
         {
            _loc8_ = false;
         }
         this.updateDefUser(_loc2_,_loc6_,_loc3_,_loc8_);
         if(_loc8_)
         {
            this.updateTowerModel(_loc5_,_loc3_);
         }
         if(_loc5_ <= 0)
         {
            this._towerInfoHash.remove(_loc3_);
         }
      }
      
      private function showTowerAlert(param1:TowerInfo, param2:uint = 6, param3:String = "") : void
      {
         var _loc4_:String = TowerNameUtil.getTeamName(param1.team);
         var _loc5_:String = TowerNameUtil.getLoadName(param1.towerID);
         var _loc6_:String = TowerNameUtil.getTowerName(param1.towerID);
         if(param3 != "")
         {
            TextAlert.show(_loc4_ + _loc5_ + _loc6_ + "正遭到敌方" + param3 + "攻击！");
            return;
         }
         if(param2 == 0)
         {
            if(param1.towerID < 12)
            {
               TextAlert.show(_loc4_ + _loc5_ + _loc6_ + "已被攻陷。");
            }
            else
            {
               TextAlert.show(_loc4_ + _loc6_ + "已被杀死，" + _loc4_ + "失败。");
            }
         }
         else
         {
            TextAlert.show(_loc4_ + _loc5_ + _loc6_ + "扣除一滴血，注意回防！");
         }
      }
      
      private function updateDefUser(param1:ByteArray, param2:uint, param3:uint, param4:Boolean) : void
      {
         var towerInfo:TowerInfo = null;
         var userList:Array = null;
         var userID:uint = 0;
         var model:UserModel = null;
         var byteArr:ByteArray = param1;
         var defNum:uint = param2;
         var towerID:uint = param3;
         var liveShow:Boolean = param4;
         towerInfo = this.getTowerInfo(towerID);
         var defList:Array = towerInfo.getDefUserList();
         userList = new Array();
         var i:int = 0;
         while(i < defNum)
         {
            userID = byteArr.readUnsignedInt();
            if(liveShow && defList.indexOf(userID) == -1 && userID != MainManager.actorID)
            {
               model = UserManager.getModel(userID);
               this.putUserModel(model);
            }
            userList.push(userID);
            i++;
         }
         defList.forEach(function(param1:uint, param2:int, param3:Array):void
         {
            var _loc4_:UserModel = null;
            if(userList.indexOf(param1) == -1)
            {
               if(liveShow && param1 != MainManager.actorID)
               {
                  _loc4_ = UserManager.getModel(param1);
                  if(_loc4_)
                  {
                     _loc4_.pos = MapXMLInfo.getDefaultPos(MapManager.mapInfo.id);
                     MapManager.currentMap.contentLevel.addChild(_loc4_);
                  }
               }
               towerInfo.removeDefUser(param1);
            }
         });
         userList.forEach(function(param1:uint, param2:int, param3:Array):void
         {
            var _loc4_:UserInfo = CityWarManager.instance.getUserInfo(param1);
            towerInfo.addDefUser(_loc4_);
         });
      }
      
      public function updateAtkUser(param1:uint, param2:uint, param3:uint, param4:uint) : void
      {
         var _loc5_:TowerInfo = this.getTowerInfo(param1);
         if(_loc5_ == null)
         {
            return;
         }
         var _loc6_:UserInfo = CityWarManager.instance.getUserInfo(param2);
         if(param4 == 1)
         {
            _loc5_.addAtkUser(_loc6_);
            if(_loc5_.getAtkUserList().length == 1)
            {
               this.dispatchEvent(new Event(TOWER_WAS_ATTACKED + StringConstants.SIGN + param1.toString()));
            }
            if(param3 == 2 && _loc5_.team == MainManager.actorInfo.overHeadState)
            {
               this.showTowerAlert(_loc5_,6,_loc6_.nick);
            }
         }
         else
         {
            _loc5_.removeAtkUser(_loc6_);
            if(_loc5_.getAtkUserList().length == 0)
            {
               this.dispatchEvent(new Event(TOWER_SAFE + StringConstants.SIGN + param1.toString()));
            }
         }
      }
      
      private function updateTowerModel(param1:int, param2:uint) : void
      {
         this._towerModel.setHp(param1);
         if(param1 <= 0)
         {
            this.removeTower(param2);
         }
      }
      
      public function putUserModel(param1:UserModel) : void
      {
         var _loc2_:Point = GeomUtil.getCirclePoint(this._towerCentre,Math.random() * 360,this._defDistance);
         while(!MapManager.currentMap.isBlock(_loc2_))
         {
            _loc2_ = GeomUtil.getCirclePoint(this._towerCentre,Math.random() * 360,this._defDistance);
         }
         param1.pos = _loc2_;
         MapManager.currentMap.upLevel.addChild(param1);
      }
      
      public function resetModelPos(param1:UserModel) : void
      {
         param1.pos = MapXMLInfo.getDefaultPos(MapManager.mapInfo.id);
         MapManager.currentMap.contentLevel.addChild(param1);
         param1.execStandAction();
      }
      
      private function removeTower(param1:uint) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc2_:TowerInfo = this._towerInfoHash.getValue(param1);
         if(this._towerModel)
         {
            if(_loc2_.team != MainManager.actorInfo.overHeadState)
            {
               _loc3_ = this._towerModel.getPosX();
               if(_loc2_.team == 1)
               {
                  _loc4_ = _loc3_ - 150;
               }
               else
               {
                  _loc4_ = _loc3_ - 100;
               }
               MapManager.currentMap.recoverPathData(_loc4_,0,250,560);
            }
            else if(_loc2_.getDefUserList().indexOf(MainManager.actorID) != -1)
            {
               this.resetModelPos(MainManager.actorModel);
            }
            this._towerModel.destroy();
            this._towerModel = null;
         }
      }
      
      public function getTowerInfo(param1:uint) : TowerInfo
      {
         if(this._towerInfoHash.containsKey(param1))
         {
            return this._towerInfoHash.getValue(param1);
         }
         return null;
      }
      
      public function getTowerModel() : StrongholdTower
      {
         return this._towerModel;
      }
      
      public function get towerInfoList() : Array
      {
         return this._towerInfoHash.getValues();
      }
      
      public function addEventListner(param1:String, param2:Function) : void
      {
         this.ed.addEventListener(param1,param2);
      }
      
      public function removeEventListner(param1:String, param2:Function) : void
      {
         this.ed.removeEventListener(param1,param2);
      }
      
      public function dispatchEvent(param1:Event) : void
      {
         this.ed.dispatchEvent(param1);
      }
      
      private function get ed() : EventDispatcher
      {
         if(this._ed == null)
         {
            this._ed = new EventDispatcher();
         }
         return this._ed;
      }
      
      public function destroy() : void
      {
         this.removeEvent();
         if(this._towerModel)
         {
            this._towerModel.destroy();
            this._towerModel = null;
         }
         this._towerInfoHash.clear();
         this._towerInfoHash = null;
      }
   }
}

