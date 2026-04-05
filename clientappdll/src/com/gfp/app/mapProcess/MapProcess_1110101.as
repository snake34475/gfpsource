package com.gfp.app.mapProcess
{
   import com.gfp.app.toolBar.HeadSelfPanel;
   import com.gfp.core.CommandID;
   import com.gfp.core.cache.SoundCache;
   import com.gfp.core.cache.SoundInfo;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.player.NumSprite;
   import com.gfp.core.sound.SoundManager;
   import com.gfp.core.utils.strength.SwfLoaderHelper;
   import com.greensock.TweenLite;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.ByteArray;
   import flash.utils.clearTimeout;
   import flash.utils.getTimer;
   import flash.utils.setInterval;
   import org.taomee.net.SocketEvent;
   
   public class MapProcess_1110101 extends BaseMapProcess
   {
      
      private var mc:MovieClip;
      
      private var playermod:UserModel;
      
      private var nummc:MovieClip;
      
      private var numns:NumSprite;
      
      private var _startTime:int;
      
      private var _totalTime:int = 60;
      
      private var timer:int;
      
      public function MapProcess_1110101()
      {
         super();
         SocketConnection.addCmdListener(CommandID.BUFF_STATE,this.onDeath);
         var _loc1_:SwfLoaderHelper = new SwfLoaderHelper();
         _loc1_.loadFile(ClientConfig.getCartoon("KAI_YANG_DEATH"),this.movieCallBack);
         var _loc2_:int = int(MainManager.actorInfo.fightPower);
         var _loc3_:int = int(ActivityExchangeTimesManager.getTimes(6819));
         var _loc4_:int = int(ActivityExchangeTimesManager.getTimes(6820));
         var _loc5_:int = int(ActivityExchangeTimesManager.getTimes(6821));
         HeadSelfPanel.instance.updatePower(_loc2_ + (_loc3_ + _loc4_ + _loc5_) * 5000);
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
      
      private function movieCallBack(param1:Loader) : void
      {
         this.playermod = MainManager.actorModel;
         this.nummc = param1.content["nummc"];
         this.nummc.x = 0;
         this.nummc.y = -20 - this.playermod.height;
         this.numns = new NumSprite(this.nummc,60);
         this.nummc.visible = false;
         this.mc = param1.content["mc"];
         this.mc.x = 0 - this.playermod.width;
         this.mc.y = 0 - this.playermod.height;
         this.playermod.addChild(this.mc);
         this.playermod.addChild(this.nummc);
         this.mc.gotoAndStop(1);
         this.mc.visible = false;
      }
      
      private function onDeath(param1:SocketEvent) : void
      {
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
         if(_loc4_ == 2597)
         {
            SocketConnection.removeCmdListener(CommandID.BUFF_STATE,this.onDeath);
            this.mc.visible = true;
            this.mc.gotoAndStop(1);
            this.nummc.visible = true;
            this._startTime = getTimer();
            this.timer = setInterval(this.dao,1000);
         }
      }
      
      private function dao() : void
      {
         var _loc1_:int = getTimer() - this._startTime;
         var _loc2_:Date = new Date();
         var _loc3_:int = this._totalTime - _loc1_;
         _loc2_.time = _loc3_;
         if(this.numns.value > 0)
         {
            this.numns.value = _loc2_.secondsUTC;
         }
         if(this.numns.value == 1)
         {
            this.mc.play();
            TweenLite.to(this.mc,1,{
               "x":0,
               "y":0,
               "width":1200,
               "height":660,
               "alpha":0.5
            });
            LayerManager.stage.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
         if(this.numns.value <= 6 && this.numns.value > 1)
         {
            this.playSound("timecountdown5s.mp3");
         }
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         if(this.mc.currentFrame == this.mc.totalFrames)
         {
            this.mc.visible = false;
            LayerManager.stage.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         LayerManager.stage.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         SocketConnection.removeCmdListener(CommandID.BUFF_STATE,this.onDeath);
         this.playermod.removeChild(this.mc);
         this.playermod.removeChild(this.nummc);
         this.mc = null;
         this.nummc = null;
         clearTimeout(this.timer);
         HeadSelfPanel.instance.updatePower(MainManager.actorInfo.fightPower);
      }
   }
}

