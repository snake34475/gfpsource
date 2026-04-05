package com.gfp.app.mapProcess
{
   import com.gfp.app.toolBar.HeadSelfPanel;
   import com.gfp.core.CommandID;
   import com.gfp.core.cache.SoundCache;
   import com.gfp.core.cache.SoundInfo;
   import com.gfp.core.cache.SwfCache;
   import com.gfp.core.cache.SwfInfo;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.player.NumSprite;
   import com.gfp.core.sound.SoundManager;
   import com.gfp.core.ui.DialogBox;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   import flash.utils.clearTimeout;
   import flash.utils.getTimer;
   import flash.utils.setInterval;
   import org.taomee.net.SocketEvent;
   
   public class MapProcess_1110201 extends BaseMapProcess
   {
      
      private const BOSS_MON_ID:int = 14373;
      
      private var _dialogBox:DialogBox;
      
      private var _zongmc:MovieClip;
      
      private var _biaomc:MovieClip;
      
      private var _fullmc:MovieClip;
      
      private var _firemc1:MovieClip;
      
      private var _dou:Vector.<MovieClip> = new Vector.<MovieClip>();
      
      private var _mask:Vector.<MovieClip> = new Vector.<MovieClip>();
      
      private var _angre:int = 0;
      
      private var dindex:int = 0;
      
      private var lastd:int = 0;
      
      private var maskpos:Number = 0;
      
      private var _maskfire:MovieClip;
      
      private var mcky:MovieClip;
      
      private var playermod:UserModel;
      
      private var nummc:MovieClip;
      
      private var numns:NumSprite;
      
      private var _startTime:int;
      
      private var _totalTime:int = 120;
      
      private var timer:int;
      
      private var _dialogBoxk:DialogBox;
      
      private var effect:MovieClip;
      
      private var _starListen:Boolean = false;
      
      public function MapProcess_1110201()
      {
         super();
         UserManager.addEventListener(UserEvent.BORN,this.onMonsterBorn);
         var _loc1_:int = 0;
         SwfCache.getSwfInfo(ClientConfig.getCartoon("yao_guang"),this.movieCallBack1);
         SocketConnection.addCmdListener(CommandID.BUFF_STATE,this.onDeath);
         SwfCache.getSwfInfo(ClientConfig.getCartoon("yao_guang"),this.movieCallBack2);
         SwfCache.getSwfInfo(ClientConfig.getCartoon("yao_guang_effect"),this.movieCallBacknb);
         var _loc2_:int = int(MainManager.actorInfo.fightPower);
         var _loc3_:int = int(ActivityExchangeTimesManager.getTimes(6819));
         var _loc4_:int = int(ActivityExchangeTimesManager.getTimes(6820));
         var _loc5_:int = int(ActivityExchangeTimesManager.getTimes(6821));
         HeadSelfPanel.instance.updatePower(_loc2_ + (_loc3_ + _loc4_ + _loc5_) * 5000);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         UserManager.removeEventListener(UserEvent.BORN,this.onMonsterBorn);
         LayerManager.stage.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         if(Boolean(this._biaomc) && this._biaomc.parent == LayerManager.topLevel)
         {
            LayerManager.topLevel.removeChild(this._biaomc);
         }
         if(Boolean(this._fullmc) && this._fullmc.parent == LayerManager.topLevel)
         {
            LayerManager.topLevel.removeChild(this._fullmc);
         }
         if(Boolean(this._firemc1) && this._firemc1.parent == LayerManager.topLevel)
         {
            LayerManager.topLevel.removeChild(this._firemc1);
         }
         var _loc1_:int = 0;
         while(_loc1_ < 10)
         {
            this._dou[_loc1_] = null;
            this._mask[_loc1_] = null;
            _loc1_++;
         }
         this._biaomc = null;
         this._fullmc = null;
         this._firemc1 = null;
         SocketConnection.removeCmdListener(CommandID.FIGHT_COMMON_NOTIFY,this.onFireRise);
         LayerManager.stage.removeEventListener(Event.ENTER_FRAME,this.onEnterFramek);
         LayerManager.stage.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         SocketConnection.removeCmdListener(CommandID.BUFF_STATE,this.onDeath);
         SocketConnection.removeCmdListener(2460,this.playEffect);
         if(Boolean(this.mcky) && this.mcky.parent == this.playermod)
         {
            this.playermod.removeChild(this.mcky);
         }
         if(Boolean(this.nummc) && this.nummc.parent == this.playermod)
         {
            this.playermod.removeChild(this.nummc);
         }
         this.mcky = null;
         this.nummc = null;
         clearTimeout(this.timer);
         HeadSelfPanel.instance.updatePower(MainManager.actorInfo.fightPower);
      }
      
      private function onMonsterBorn(param1:UserEvent) : void
      {
         var _loc4_:UserModel = null;
         var _loc5_:String = null;
         var _loc2_:UserModel = param1.data as UserModel;
         var _loc3_:UserInfo = _loc2_.info;
         if(!_loc3_)
         {
            return;
         }
         if(_loc2_.info.roleType == 14257)
         {
            _loc4_ = UserManager.getModelByRoleType(this.BOSS_MON_ID);
            _loc5_ = "大地之灵，来治疗我！宣判我的敌人吧！";
            this._dialogBox = new DialogBox();
            this._dialogBox.show(_loc5_,0,-_loc4_.height,_loc4_);
         }
      }
      
      private function movieCallBack1(param1:SwfInfo) : void
      {
         var _loc2_:MovieClip = param1.content as MovieClip;
         this._zongmc = _loc2_["nuqi"];
         this._biaomc = _loc2_["nuqi"]["biao"];
         this._fullmc = _loc2_["nuqi"]["full"];
         this._firemc1 = _loc2_["nuqi"]["fire"];
         var _loc3_:int = 0;
         while(_loc3_ < 10)
         {
            this._dou.push(this._biaomc["dou" + _loc3_]);
            this._mask.push(this._dou[_loc3_]["mask"]);
            this._mask[_loc3_].y = 18;
            _loc3_++;
         }
         this._biaomc.x = 850;
         this._biaomc.y = 50;
         this._maskfire = this._firemc1["maskfire"];
         this._maskfire.y = 330;
         this._fullmc.x = this._biaomc.x + 35;
         this._biaomc.addEventListener(MouseEvent.MOUSE_DOWN,this.downHandle);
         this._fullmc.visible = false;
         this._fullmc.stop();
         SocketConnection.addCmdListener(CommandID.FIGHT_COMMON_NOTIFY,this.onFireRise);
         LayerManager.stage.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function downHandle(param1:MouseEvent) : void
      {
         this._biaomc.removeEventListener(MouseEvent.MOUSE_DOWN,this.downHandle);
         LayerManager.stage.addEventListener(MouseEvent.MOUSE_UP,this.upHandle);
         LayerManager.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.dragHandle);
      }
      
      private function upHandle(param1:MouseEvent) : void
      {
         this._biaomc.addEventListener(MouseEvent.MOUSE_DOWN,this.downHandle);
         LayerManager.stage.removeEventListener(MouseEvent.MOUSE_UP,this.upHandle);
         LayerManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.dragHandle);
      }
      
      private function dragHandle(param1:MouseEvent) : void
      {
         if(LayerManager.stage.mouseX > 50 && LayerManager.stage.mouseX < LayerManager.stageWidth - 100 && LayerManager.stage.mouseY >= 30 && LayerManager.stage.mouseY < LayerManager.stageHeight - 100)
         {
            this._biaomc.x = LayerManager.stage.mouseX - 50;
            this._biaomc.y = LayerManager.stage.mouseY - 50;
            this._fullmc.x = this._biaomc.x + 35;
            this._firemc1.x = this._biaomc.x;
         }
         else
         {
            this._biaomc.addEventListener(MouseEvent.MOUSE_DOWN,this.downHandle);
            LayerManager.stage.removeEventListener(MouseEvent.MOUSE_UP,this.upHandle);
            LayerManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.dragHandle);
         }
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.dindex)
         {
            this._mask[_loc2_].y = 0;
            _loc2_++;
         }
         _loc2_ = this.dindex + 1;
         while(_loc2_ < 10)
         {
            this._mask[_loc2_].y = 18;
            _loc2_++;
         }
      }
      
      private function onFireRise(param1:SocketEvent) : void
      {
         var _loc3_:int = 0;
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         this._angre = _loc2_.readUnsignedInt();
         this._angre = _loc2_.readUnsignedInt();
         this._angre = _loc2_.readUnsignedInt();
         this._angre = _loc2_.readUnsignedInt();
         this._angre = _loc2_.readUnsignedInt();
         this._angre = _loc2_.readUnsignedInt();
         this._angre = _loc2_.readUnsignedInt();
         if(this._angre < 100 && this._angre >= 0)
         {
            LayerManager.topLevel.addChild(this._biaomc);
            LayerManager.topLevel.addChild(this._fullmc);
            LayerManager.topLevel.addChild(this._firemc1);
            this.maskpos = 18 - this.ge(this._angre) * 1.8;
            this.dindex = this.shi(this._angre);
            TweenLite.to(this._mask[this.dindex],0.5,{"y":this.maskpos});
            _loc3_ = 0;
            while(_loc3_ < this.dindex)
            {
               this._mask[_loc3_].y = 0;
               this._fullmc.y = this._biaomc.y + 285 - 25 * (this.dindex - 1);
               _loc3_++;
            }
            if(this.dindex > this.lastd)
            {
               _loc3_ = 0;
               while(_loc3_ < this.dindex)
               {
                  this._mask[_loc3_].y = 0;
                  this._fullmc.y = this._biaomc.y + 285 - 25 * (this.dindex - 1);
                  this._fullmc.visible = true;
                  this._fullmc.play();
                  _loc3_++;
               }
            }
         }
         else
         {
            _loc3_ = 0;
            while(_loc3_ < 10)
            {
               TweenLite.to(this._mask[_loc3_],0.5,{"y":18});
               _loc3_++;
            }
            this._firemc1.x = this._biaomc.x;
            this._firemc1.y = this._biaomc.y - 30;
            TweenLite.to(this._maskfire,2,{
               "y":0,
               "onComplete":this.hideFire
            });
            this._angre -= 100;
         }
         this.lastd = this.dindex;
      }
      
      private function hideFire() : void
      {
         this._maskfire.y = 330;
      }
      
      private function shi(param1:int = 0) : int
      {
         return int(param1 / 10);
      }
      
      private function ge(param1:int = 0) : int
      {
         return int(param1 % 10);
      }
      
      private function playSound(param1:String) : void
      {
         if(SoundManager.isMusicEnable)
         {
            SoundCache.load(ClientConfig.getSoundOther(param1),this.onSoundComplete,null);
         }
      }
      
      private function onSoundComplete(param1:SoundInfo) : void
      {
         SoundManager.playSound(param1.url,0,false,0.6);
      }
      
      private function movieCallBack2(param1:SwfInfo) : void
      {
         this.playermod = MainManager.actorModel;
         this.nummc = param1.content["nummc"];
         this.nummc.x = 0;
         this.nummc.y = -20 - this.playermod.height;
         this.numns = new NumSprite(this.nummc,120);
         this.nummc.visible = false;
         this.mcky = param1.content["mc"];
         this.mcky.x = 0 - this.playermod.width;
         this.mcky.y = 0 - this.playermod.height;
         this.playermod.addChild(this.mcky);
         this.playermod.addChild(this.nummc);
         this.mcky.gotoAndStop(1);
         this.mcky.visible = false;
      }
      
      private function movieCallBacknb(param1:SwfInfo) : void
      {
         this.effect = param1.content as MovieClip;
         LayerManager.topLevel.addChild(this.effect);
         this.effect.gotoAndStop(1);
         this.effect.visible = false;
      }
      
      private function onDeath(param1:SocketEvent) : void
      {
         var _loc7_:UserModel = null;
         var _loc8_:String = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedShort();
         var _loc5_:uint = _loc2_.readUnsignedByte();
         var _loc6_:Boolean = _loc2_.readUnsignedByte() == 1;
         if(_loc4_ == 2656)
         {
            _loc7_ = UserManager.getModelByRoleType(this.BOSS_MON_ID);
            _loc8_ = "这是最后的机会了，在120秒内努力打败我吧！";
            this._dialogBox = new DialogBox();
            this._dialogBox.show(_loc8_,0,-_loc7_.height,_loc7_);
            SocketConnection.removeCmdListener(CommandID.FIGHT_COMMON_NOTIFY,this.onFireRise);
            if(Boolean(this._biaomc) && this._biaomc.parent == LayerManager.topLevel)
            {
               LayerManager.topLevel.removeChild(this._biaomc);
            }
            if(Boolean(this._fullmc) && this._fullmc.parent == LayerManager.topLevel)
            {
               LayerManager.topLevel.removeChild(this._fullmc);
            }
            if(Boolean(this._firemc1) && this._firemc1.parent == LayerManager.topLevel)
            {
               LayerManager.topLevel.removeChild(this._firemc1);
            }
            SocketConnection.removeCmdListener(CommandID.BUFF_STATE,this.onDeath);
            if(this.mcky)
            {
               this.mcky.visible = true;
               this.mcky.gotoAndStop(1);
            }
            if(this.nummc)
            {
               this.nummc.visible = true;
            }
            this._startTime = getTimer();
            this.timer = setInterval(this.dao,1000);
            SocketConnection.addCmdListener(2460,this.playEffect);
            this._starListen = true;
         }
      }
      
      private function playEffect(param1:SocketEvent) : void
      {
         this.effect.x = 525;
         this.effect.y = 445;
         this.effect.visible = true;
         this.effect.play();
         LayerManager.stage.addEventListener(Event.ENTER_FRAME,this.onEnterFramenb);
      }
      
      private function onEnterFramenb(param1:Event) : void
      {
         if(this.effect.currentFrame == this.effect.totalFrames)
         {
            LayerManager.stage.removeEventListener(Event.ENTER_FRAME,this.onEnterFramenb);
            this.effect.visible = false;
         }
      }
      
      private function dao() : void
      {
         var _loc1_:int = getTimer() - this._startTime;
         var _loc2_:Date = new Date();
         var _loc3_:int = this._totalTime - _loc1_;
         _loc2_.time = _loc3_;
         if(this.numns.value >= 60)
         {
            this.numns.value = _loc2_.secondsUTC + _loc2_.minutesUTC;
         }
         else
         {
            this.numns.value = _loc2_.secondsUTC;
         }
         if(this.numns.value == 1)
         {
            if(Boolean(this.nummc) && this.nummc.parent == this.playermod)
            {
               this.playermod.removeChild(this.nummc);
            }
            this.mcky.play();
            TweenLite.to(this.mcky,1,{
               "x":0,
               "y":0,
               "width":1200,
               "height":660,
               "alpha":0.5
            });
            LayerManager.stage.addEventListener(Event.ENTER_FRAME,this.onEnterFramek);
         }
         if(this.numns.value <= 6 && this.numns.value > 1)
         {
            this.playSound("timecountdown5s.mp3");
         }
      }
      
      private function onEnterFramek(param1:Event) : void
      {
         if(this.mcky.currentFrame == this.mcky.totalFrames)
         {
            this.mcky.visible = false;
            LayerManager.stage.removeEventListener(Event.ENTER_FRAME,this.onEnterFramek);
         }
      }
   }
}

