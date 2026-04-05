package com.gfp.app.mapProcess
{
   import com.gfp.core.CommandID;
   import com.gfp.core.controller.KeyController;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.HiddenManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.HiddenModel;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.player.NumSprite;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.ByteArray;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1121601 extends BaseMapProcess
   {
      
      private var BoxUId:Vector.<uint> = new Vector.<uint>();
      
      private var numMc:MovieClip;
      
      private var tipMc:MovieClip;
      
      private var ns:NumSprite;
      
      private var flying:Boolean = false;
      
      private var timer:uint;
      
      private var fireMc:MovieClip;
      
      private var timer2:uint;
      
      private var fanMc:MovieClip;
      
      private var timer3:uint;
      
      private var isFiring:Boolean = false;
      
      private var isTiao:Boolean = false;
      
      public function MapProcess_1121601()
      {
         super();
         SocketConnection.addCmdListener(CommandID.FIGHT_COMMON_NOTIFY,this.onNotity);
         UserManager.addEventListener(UserEvent.RECYCLE,this.onOpen);
         SocketConnection.addCmdListener(2460,this.boxSummonOver);
         UserManager.addEventListener(UserEvent.BORN,this.onMonsterBorn);
         this.getYuanJian();
      }
      
      private function onMonsterBorn(param1:UserEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:UserModel = param1.data as UserModel;
         if(!_loc3_)
         {
            return;
         }
         var _loc4_:UserInfo = _loc3_.info;
         if(int(_loc4_.roleType / 10000) == 3)
         {
            this.fanMc.visible = true;
         }
      }
      
      private function boxSummonOver(param1:Event) : void
      {
         this.timer = setTimeout(this.onOpen,14000,null);
         this.timer3 = setTimeout(this.fanGone,2000);
      }
      
      private function fanGone() : void
      {
         this.fanMc.visible = false;
      }
      
      private function fireMie() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.ns.max_live)
         {
            this.fireMc["f" + _loc1_].visible = false;
            _loc1_++;
         }
         this.isFiring = false;
      }
      
      private function getYuanJian() : void
      {
         this.numMc = _mapModel.libManager.getMovieClip("UI_NUM");
         this.tipMc = _mapModel.libManager.getMovieClip("UI_TIPS");
         this.fireMc = _mapModel.libManager.getMovieClip("UI_FIRE");
         this.fanMc = _mapModel.libManager.getMovieClip("UI_FAN");
         if(KeyController.currentControlType == 1)
         {
            this.tipMc["keyMc"].gotoAndStop(2);
         }
         else
         {
            this.tipMc["keyMc"].gotoAndStop(1);
         }
         this.ns = new NumSprite(this.numMc["numMc"],0,false);
         LayerManager.topLevel.addChild(this.numMc);
         LayerManager.topLevel.addChild(this.tipMc);
         LayerManager.topLevel.addChild(this.fireMc);
         LayerManager.topLevel.addChild(this.fanMc);
         this.fanMc.visible = false;
         this.fireMie();
         this.fireMc.x = this.numMc["numMc"].x + 750;
         this.fireMc.y = this.numMc["numMc"].y + 185;
         this.numMc.x = LayerManager.stageWidth - 450;
         this.numMc.y = 180;
         this.tipMc.x = LayerManager.stageWidth - 450;
         this.tipMc.y = 220;
         this.fanMc.x = (LayerManager.stageWidth - this.fanMc.width) / 2;
         this.fanMc.y = 220;
      }
      
      private function onNotity(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 8;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         if(this.ns)
         {
            this.ns.value = _loc3_;
            if(this.isFiring)
            {
               this.firing();
            }
         }
      }
      
      private function onOpen(param1:UserEvent) : void
      {
         var _loc3_:HiddenModel = null;
         this.isFiring = true;
         this.timer2 = setTimeout(this.fireMie,2000);
         this.firing();
         var _loc2_:Array = HiddenManager.getAllHiddenModule();
         for each(_loc3_ in _loc2_)
         {
            _loc3_.hideOverHeadSprite();
            DisplayUtil.removeForParent(_loc3_);
         }
         HiddenManager.clear();
      }
      
      private function firing() : void
      {
         var _loc1_:* = 0;
         var _loc2_:int = 0;
         _loc1_ = int(this.ns.max_live - 1);
         while(_loc1_ >= 0)
         {
            if(_loc2_ >= this.ns.getWei())
            {
               break;
            }
            _loc2_++;
            this.fireMc["f" + _loc1_].visible = true;
            this.fireMc["f" + _loc1_].gotoAndPlay(1);
            _loc1_--;
         }
         while(_loc1_ >= 0)
         {
            this.fireMc["f" + _loc1_].visible = false;
            _loc1_--;
         }
      }
      
      override public function destroy() : void
      {
         var _loc2_:HiddenModel = null;
         var _loc1_:Array = HiddenManager.getAllHiddenModule();
         for each(_loc2_ in _loc1_)
         {
            _loc2_.destroy();
         }
         clearTimeout(this.timer);
         SocketConnection.removeCmdListener(CommandID.FIGHT_COMMON_NOTIFY,this.onNotity);
         UserManager.removeEventListener(UserEvent.RECYCLE,this.onOpen);
         DisplayUtil.removeForParent(this.numMc);
         DisplayUtil.removeForParent(this.tipMc);
         DisplayUtil.removeForParent(this.fireMc);
         DisplayUtil.removeForParent(this.fanMc);
         super.destroy();
      }
   }
}

