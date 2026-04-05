package com.gfp.app.mapProcess
{
   import com.gfp.core.CommandID;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1119101 extends BaseMapProcess
   {
      
      private var _killSp:Sprite;
      
      private var _barUI:MovieClip;
      
      private const SPC_TYPEs:Vector.<uint> = new <uint>[12321,12322,12323,12324];
      
      private const NOR_TYPEs:Vector.<uint> = new <uint>[12315,12316,12317,12318,12319,12320,14536,12324];
      
      private const EXP_LIST:Vector.<int> = new <int>[5500,5500,5500,5500,5500,5500,150000,40000];
      
      private var _killNum:int;
      
      private var _expNum:int;
      
      public function MapProcess_1119101()
      {
         super();
         this.addListener();
      }
      
      private function get killNum() : int
      {
         return this._killNum;
      }
      
      private function set killNum(param1:int) : void
      {
         this._killSp["mc"]["killNum"].text = param1.toString();
         this._killNum = param1;
      }
      
      private function get expNum() : int
      {
         return this._expNum;
      }
      
      private function set expNum(param1:int) : void
      {
         this._killSp["mc"]["expNum"].text = param1.toString();
         this._expNum = param1;
      }
      
      override protected function init() : void
      {
         this._killSp = _mapModel.libManager.getSprite("kill");
         this._killSp.x = LayerManager.stageWidth - 20;
         this._killSp.y = 220;
         LayerManager.uiLevel.addChild(this._killSp);
      }
      
      private function addListener() : void
      {
         UserManager.addEventListener(UserEvent.BORN,this.onUserBorn);
         UserManager.addEventListener(UserEvent.DIE,this.onUserDie);
         SocketConnection.addCmdListener(CommandID.FIGHT_COMMON_NOTIFY,this.onKill);
      }
      
      private function onKill(param1:SocketEvent) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:int = 0;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         if(_loc3_ == 1191)
         {
            _loc6_ = 1;
            while(_loc6_ < 15)
            {
               _loc3_ = _loc2_.readUnsignedInt();
               if(_loc6_ == 8)
               {
                  _loc4_ = _loc2_.readUnsignedInt();
               }
               if(_loc6_ == 9)
               {
                  _loc5_ = _loc2_.readUnsignedInt();
               }
               _loc6_++;
            }
            this.killNum += _loc4_;
         }
      }
      
      private function onUserBorn(param1:UserEvent) : void
      {
         var sp:Sprite = null;
         var e:UserEvent = param1;
         var model:UserModel = e.data as UserModel;
         var index:int = this.SPC_TYPEs.indexOf(model.info.roleType);
         if(index >= 0 && index <= 3)
         {
            sp = _mapModel.libManager.getSprite("tip" + index);
            sp.x = LayerManager.stageWidth / 2;
            sp.y = LayerManager.stageHeight / 3;
            sp.alpha = 0;
            LayerManager.topLevel.addChild(sp);
            TweenLite.to(sp,0.3,{"alpha":1});
            TweenLite.delayedCall(6,function():void
            {
               DisplayUtil.removeForParent(sp);
            });
         }
      }
      
      private function onUserDie(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         var _loc3_:int = this.NOR_TYPEs.indexOf(_loc2_.info.roleType);
         if(_loc3_ != -1)
         {
            ++this.killNum;
            this.expNum += this.EXP_LIST[_loc3_];
         }
      }
      
      private function removeListener() : void
      {
         UserManager.removeEventListener(UserEvent.BORN,this.onUserBorn);
         UserManager.removeEventListener(UserEvent.DIE,this.onUserDie);
         SocketConnection.removeCmdListener(CommandID.FIGHT_COMMON_NOTIFY,this.onKill);
      }
      
      override public function destroy() : void
      {
         this.removeListener();
         DisplayUtil.removeForParent(this._killSp);
         super.destroy();
      }
   }
}

