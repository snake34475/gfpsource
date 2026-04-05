package com.gfp.app.cityWar
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.toolBar.HeadSelfPanel;
   import com.gfp.core.CommandID;
   import com.gfp.core.buff.ActorOperateBuffManager;
   import com.gfp.core.buff.BuffInfo;
   import com.gfp.core.buff.IBuff;
   import com.gfp.core.buff.movie.IconBuff;
   import com.gfp.core.config.xml.RoleXMLInfo;
   import com.gfp.core.config.xml.SkillXMLInfo;
   import com.gfp.core.events.DataEvent;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.HiddenEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.MoveEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.info.fight.BuffConfigInfo;
   import com.gfp.core.manager.HiddenManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.KeyboardModel;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.HiddenState;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class CityWarBoxController extends EventDispatcher
   {
      
      private static var _instance:CityWarBoxController;
      
      public static const BOX_APPEARED:String = "box_appeared";
      
      public static const BOX_DISAPPEAR:String = "box_disappear";
      
      public static const BOX_ID_ARRAY:Array = [1,2];
      
      private const SPEED_UP_ID:uint = 10;
      
      private var _teamBuff:Array = [0,0];
      
      private var _boxList:Array;
      
      private var _buffIndex:uint;
      
      private var _originalSpeed:uint;
      
      public function CityWarBoxController()
      {
         super();
      }
      
      public static function get instance() : CityWarBoxController
      {
         if(_instance == null)
         {
            _instance = new CityWarBoxController();
         }
         return _instance;
      }
      
      public static function addEventListener(param1:String, param2:Function) : void
      {
         instance.addEventListener(param1,param2);
      }
      
      public static function removeEventListener(param1:String, param2:Function) : void
      {
         instance.removeEventListener(param1,param2);
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
         this._originalSpeed = MainManager.actorModel.speed;
         this._buffIndex = MainManager.actorInfo.overHeadState - 1;
         this._boxList = new Array();
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         SocketConnection.addCmdListener(CommandID.BOX_STATE_CHANGE,this.onBoxStateChange);
         SocketConnection.addCmdListener(CommandID.BOX_BUFF_CHANGE,this.onBoxBuffChange);
         HiddenManager.addEventListener(HiddenEvent.OPEN,this.onHidenOpen);
         FightManager.instance.addEventListener(FightEvent.BEGIN,this.onFightBegin);
         FightManager.instance.addEventListener(FightEvent.QUITE,this.onFightQuit);
         MapManager.addEventListener(MapEvent.MAP_DESTROY,this.onMapDestroy);
      }
      
      private function removeEvent() : void
      {
         SocketConnection.removeCmdListener(CommandID.BOX_STATE_CHANGE,this.onBoxStateChange);
         SocketConnection.removeCmdListener(CommandID.BOX_BUFF_CHANGE,this.onBoxBuffChange);
         MainManager.actorModel.removeEventListener(MoveEvent.MOVE_ENTER,this.onActorMove);
         HiddenManager.removeEventListener(HiddenEvent.OPEN,this.onHidenOpen);
         FightManager.instance.removeEventListener(FightEvent.BEGIN,this.onFightBegin);
         FightManager.instance.removeEventListener(FightEvent.QUITE,this.onFightQuit);
         MapManager.removeEventListener(MapEvent.MAP_DESTROY,this.onMapDestroy);
      }
      
      private function onBoxStateChange(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:Point = new Point(_loc2_.readUnsignedInt(),_loc2_.readUnsignedInt());
         var _loc5_:uint = _loc2_.readUnsignedInt();
         var _loc6_:int = this._boxList.indexOf(_loc3_);
         if(_loc5_ == 0)
         {
            this.creatBox(_loc3_,_loc4_);
            if(_loc6_ == -1)
            {
               this._boxList.push(_loc3_);
            }
            dispatchEvent(new DataEvent(BOX_APPEARED,_loc3_));
         }
         else
         {
            this.removeBox(_loc3_);
            if(_loc6_ != -1)
            {
               this._boxList.splice(_loc6_,1);
            }
            dispatchEvent(new DataEvent(BOX_DISAPPEAR,_loc3_));
         }
      }
      
      public function creatBox(param1:uint, param2:Point) : void
      {
         var _loc4_:UserInfo = null;
         var _loc5_:KeyboardModel = null;
         var _loc3_:uint = this.getBoxID(param1);
         if(_loc3_ != 0 && param1 == MapManager.mapInfo.id)
         {
            _loc4_ = new UserInfo();
            _loc4_.roleType = 30025;
            _loc4_.userID = _loc3_;
            _loc4_.pos = param2;
            _loc4_.nick = "城战神秘宝箱";
            _loc5_ = new KeyboardModel(_loc4_);
            UserManager.add(_loc4_.userID,_loc5_);
            HiddenManager.add(_loc4_.userID,_loc5_);
            MapManager.currentMap.contentLevel.addChild(_loc5_);
            MainManager.actorModel.addEventListener(MoveEvent.MOVE_ENTER,this.onActorMove);
         }
      }
      
      public function getBoxID(param1:uint) : uint
      {
         switch(param1)
         {
            case 1022:
               return 1;
            case 1032:
               return 2;
            default:
               return 0;
         }
      }
      
      public function getMapID(param1:uint) : uint
      {
         switch(param1)
         {
            case 1:
               return 1022;
            case 2:
               return 1032;
            default:
               return 0;
         }
      }
      
      private function removeBox(param1:uint) : void
      {
         var _loc3_:UserModel = null;
         var _loc2_:uint = this.getBoxID(param1);
         if(_loc2_ != 0 && param1 == MapManager.mapInfo.id)
         {
            _loc3_ = UserManager.remove(_loc2_);
            HiddenManager.remove(_loc2_);
            if(_loc3_)
            {
               _loc3_.destroy();
               _loc3_ = null;
            }
         }
      }
      
      private function onBoxBuffChange(param1:SocketEvent) : void
      {
         var team:uint = 0;
         var buffID:uint = 0;
         var isBuffed:Boolean = false;
         var userList:Array = null;
         var event:SocketEvent = param1;
         var data:ByteArray = event.data as ByteArray;
         var userID:uint = data.readUnsignedInt();
         team = data.readUnsignedInt();
         buffID = data.readUnsignedInt();
         isBuffed = data.readUnsignedInt() == 1;
         var teamName:String = TowerNameUtil.getTeamName(team);
         if(!isBuffed)
         {
            this._teamBuff[team - 1] = 0;
         }
         else
         {
            this._teamBuff[team - 1] = buffID;
            TextAlert.show("恭喜" + teamName + "获得了" + SkillXMLInfo.getBuffName(buffID) + "效果");
         }
         if(MapManager.isFightMap)
         {
            FightManager.instance.addEventListener(FightEvent.QUITE,this.onFightQuit);
         }
         else
         {
            if(MainManager.actorInfo.overHeadState == team)
            {
               if(!isBuffed)
               {
                  this.removeBuff(MainManager.actorModel,buffID);
               }
               else
               {
                  this.addBuff(MainManager.actorModel,buffID);
               }
            }
            userList = UserManager.getModels();
            userList.forEach(function(param1:UserModel, param2:int, param3:Array):void
            {
               if(param1.info.overHeadState == team)
               {
                  if(!isBuffed)
                  {
                     removeBuff(param1,buffID);
                  }
                  else
                  {
                     addBuff(param1,buffID);
                  }
               }
            });
         }
      }
      
      private function addBuff(param1:UserModel, param2:uint) : void
      {
         var _loc5_:IBuff = null;
         if(param2 == this.SPEED_UP_ID)
         {
            param1.speed = this._originalSpeed * 1.3;
         }
         var _loc3_:BuffConfigInfo = SkillXMLInfo.getBuffConfigInfo(param2);
         var _loc4_:BuffInfo = new BuffInfo();
         _loc4_.keyID = param2;
         _loc4_.view = _loc3_.buffViewID;
         _loc4_.layer = _loc3_.buffLayer;
         _loc4_.align = _loc3_.buffAlign;
         _loc4_.name = _loc3_.buffName;
         if(_loc3_.isIconBuff)
         {
            _loc5_ = new IconBuff(_loc4_,false);
            param1.execBuff(_loc5_);
         }
         if(param1.info.userID == MainManager.actorID)
         {
            HeadSelfPanel.instance.addBuffIcon(param2,param2);
            if(_loc3_.buffExec != "")
            {
               ActorOperateBuffManager.instance.execute(param2,_loc3_.buffExec);
            }
         }
      }
      
      private function removeBuff(param1:UserModel, param2:uint) : void
      {
         if(param2 == this.SPEED_UP_ID)
         {
            param1.speed = this._originalSpeed;
         }
         if(param1.info.userID == MainManager.actorID)
         {
            HeadSelfPanel.instance.removeBuffIcon(param2);
            ActorOperateBuffManager.instance.end(param2);
         }
         param1.endKeyBuff(param2);
      }
      
      public function checkPeopleBuff(param1:UserModel) : void
      {
         var _loc2_:uint = param1.info.overHeadState - 1;
         if(this._teamBuff[_loc2_] != 0)
         {
            this.addBuff(param1,this._teamBuff[_loc2_]);
         }
      }
      
      private function onActorMove(param1:MoveEvent) : void
      {
         var _loc2_:Array = HiddenManager.getKeyBoardOpenList();
         var _loc3_:uint = this.getBoxID(MapManager.mapInfo.id);
         var _loc4_:UserModel = UserManager.getModel(_loc3_);
         if(_loc4_)
         {
            if(_loc2_.indexOf(_loc4_) != -1)
            {
               _loc4_.showOverHeadSprite();
            }
            else
            {
               _loc4_.hideOverHeadSprite();
            }
         }
      }
      
      private function onHidenOpen(param1:HiddenEvent) : void
      {
         var _loc2_:uint = uint(param1.state);
         var _loc3_:UserModel = param1.model;
         if(Boolean(RoleXMLInfo.isKeyboardType(_loc3_.info.roleType)) && _loc2_ == HiddenState.STATE_OPEN)
         {
            SocketConnection.send(CommandID.BOX_BUFF_CHANGE,_loc3_.info.userID);
         }
      }
      
      private function onFightBegin(param1:FightEvent) : void
      {
         if(this._teamBuff[this._buffIndex] != 0)
         {
            this.removeBuff(MainManager.actorModel,this._teamBuff[this._buffIndex]);
         }
      }
      
      private function onFightQuit(param1:FightEvent) : void
      {
         if(this._teamBuff[this._buffIndex] != 0)
         {
            this.addBuff(MainManager.actorModel,this._teamBuff[this._buffIndex]);
         }
      }
      
      private function onMapDestroy(param1:MapEvent) : void
      {
         MainManager.actorModel.removeEventListener(MoveEvent.MOVE_ENTER,this.onActorMove);
      }
      
      public function get boxList() : Array
      {
         return this._boxList;
      }
      
      public function destroy() : void
      {
         this.removeEvent();
         MainManager.actorModel.speed = this._originalSpeed;
         if(this._teamBuff[this._buffIndex] != 0)
         {
            this.removeBuff(MainManager.actorModel,this._teamBuff[this._buffIndex]);
         }
      }
   }
}

