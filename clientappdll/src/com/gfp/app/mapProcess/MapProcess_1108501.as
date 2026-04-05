package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.ShowCartoonFeather;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.DialogBox;
   import com.gfp.core.utils.strength.SwfLoaderHelper;
   import com.greensock.TweenLite;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1108501 extends BaseMapProcess
   {
      
      private var _fire:Vector.<ShowCartoonFeather> = new Vector.<ShowCartoonFeather>();
      
      private var _firemc:Vector.<MovieClip> = new Vector.<MovieClip>();
      
      private var _pos:Vector.<Point> = new Vector.<Point>();
      
      private var _posboss:Point;
      
      private const STAR_MON_ID:int = 14257;
      
      private const BOSS_MON_ID:int = 14256;
      
      private const _StartNum:int = 6;
      
      private var _alive:Array = [1,1,1,1,1,1];
      
      private var _starposi:int = 0;
      
      private var _ffnum:int = 0;
      
      private var _dialogBox:DialogBox;
      
      public function MapProcess_1108501()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         var _loc1_:int = 0;
         var _loc2_:SwfLoaderHelper = new SwfLoaderHelper();
         _loc2_.loadFile(ClientConfig.getCartoon("sevenStarFire"),this.movieCallBack);
         UserManager.addEventListener(UserEvent.DIE,this.onDie);
         this.requestBossPos();
         this.requestStarPos();
         this.clearAlive();
         _loc1_ = 0;
         while(_loc1_ < this._StartNum)
         {
            this._pos.push(new Point(0,0));
            _loc1_++;
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         SocketConnection.removeCmdListener(CommandID.FIGHT_COMMON_NOTIFY,this.onFireFly);
         UserManager.removeEventListener(UserEvent.BORN,this.onMonsterBorn);
      }
      
      private function requestStarPos() : void
      {
         UserManager.addEventListener(UserEvent.BORN,this.onMonsterBorn);
      }
      
      private function requestBossPos() : void
      {
         SocketConnection.addCmdListener(CommandID.OGRE_MOVE,this.onGetBossPos);
      }
      
      private function clearAlive() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._StartNum)
         {
            this._alive[_loc1_] = 1;
            _loc1_++;
         }
      }
      
      private function movieCallBack(param1:Loader) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._StartNum)
         {
            this._firemc.push(param1.content["mc" + _loc2_]);
            LayerManager.topLevel.addChild(this._firemc[_loc2_]);
            this._firemc[_loc2_].visible = false;
            _loc2_++;
         }
      }
      
      private function onFireFly(param1:SocketEvent) : void
      {
         var i:int = 0;
         var event:SocketEvent = param1;
         SocketConnection.removeCmdListener(CommandID.FIGHT_COMMON_NOTIFY,this.onFireFly);
         this._ffnum = 0;
         i = 0;
         i = 0;
         while(i < this._StartNum)
         {
            if(this._alive[i] == 1)
            {
               this._firemc[i].x = MapManager.currentMap.camera.totalToView(this._pos[i]).x;
               this._firemc[i].y = MapManager.currentMap.camera.totalToView(this._pos[i]).y;
               this._firemc[i].visible = true;
               LayerManager.topLevel.addChild(this._firemc[i]);
               TweenLite.to(this._firemc[i],1,{
                  "x":MapManager.currentMap.camera.totalToView(this._posboss).x,
                  "y":MapManager.currentMap.camera.totalToView(this._posboss).y,
                  "onComplete":function():void
                  {
                     var _loc1_:* = 0;
                     while(_loc1_ < _StartNum)
                     {
                        DisplayUtil.removeForParent(_firemc[_loc1_]);
                        _loc1_++;
                     }
                  }
               });
            }
            i++;
         }
      }
      
      private function onGetBossPos(param1:SocketEvent) : void
      {
         var _loc3_:ByteArray = null;
         var _loc4_:Point = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc2_:uint = uint(param1.headInfo.userID);
         if(_loc2_ != MainManager.actorID)
         {
            _loc3_ = param1.data as ByteArray;
            _loc3_.position = 0;
            _loc4_ = new Point(_loc3_.readUnsignedInt(),_loc3_.readUnsignedInt());
            _loc5_ = _loc3_.readUnsignedInt();
            _loc6_ = _loc3_.readUnsignedByte();
            _loc7_ = _loc3_.readUnsignedByte();
            _loc8_ = _loc3_.readUnsignedShort();
            this._posboss = _loc4_;
         }
      }
      
      private function onMonsterBorn(param1:UserEvent) : void
      {
         var _loc4_:UserModel = null;
         var _loc5_:String = null;
         if(this._ffnum == 0)
         {
            SocketConnection.addCmdListener(CommandID.FIGHT_COMMON_NOTIFY,this.onFireFly);
            this._ffnum = 1;
         }
         var _loc2_:UserModel = param1.data as UserModel;
         var _loc3_:UserInfo = _loc2_.info;
         if(!_loc3_)
         {
            return;
         }
         if(_loc2_.info.roleType == 14257)
         {
            this.clearAlive();
            this._pos[this._starposi] = _loc3_.pos;
            ++this._starposi;
            _loc4_ = UserManager.getModelByRoleType(this.BOSS_MON_ID);
            _loc5_ = "大地之灵，来治疗我！宣判我的敌人吧！";
            this._dialogBox = new DialogBox();
            this._dialogBox.show(_loc5_,0,-_loc4_.height,_loc4_);
         }
      }
      
      private function onDie(param1:UserEvent) : void
      {
         var _loc4_:int = 0;
         this._starposi = 0;
         var _loc2_:UserModel = param1.data as UserModel;
         var _loc3_:UserInfo = _loc2_.info;
         if(_loc2_.info.roleType == 14257)
         {
            _loc4_ = 0;
            while(_loc4_ < this._StartNum)
            {
               if(_loc3_.pos == this._pos[_loc4_])
               {
                  this._alive[_loc4_] = 0;
               }
               _loc4_++;
            }
         }
      }
   }
}

