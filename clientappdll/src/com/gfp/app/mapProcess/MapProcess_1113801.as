package com.gfp.app.mapProcess
{
   import com.gfp.core.CommandID;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MagicChangeManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.player.NumSprite;
   import com.gfp.core.ui.alert.TextAlert;
   import com.greensock.TweenMax;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.ByteArray;
   import flash.utils.setTimeout;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1113801 extends BaseMapProcess
   {
      
      private var _listMonsterMc:Vector.<MovieClip>;
      
      private var _txtWarnMc:MovieClip;
      
      private var _txtNumMc:MovieClip;
      
      private var _totalPmNum:int;
      
      private var _round:int;
      
      public function MapProcess_1113801()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.initEventListener();
         this._txtWarnMc = _mapModel.libManager.getMovieClip("UI_TxtWarn");
         this._txtNumMc = _mapModel.libManager.getMovieClip("UI_PingTxtNum");
         DisplayUtil.align(this._txtWarnMc,null,AlignType.MIDDLE_CENTER);
         LayerManager.topLevel.addChild(this._txtWarnMc);
         LayerManager.topLevel.addChild(this._txtNumMc);
         this.resizePos();
         TweenMax.to(this._txtWarnMc,5,{
            "alpha":0,
            "delay":2,
            "onComplete":this.warnMcTweenOver
         });
         StageResizeController.instance.register(this.resizePos);
         MagicChangeManager.instance.installBlockFilter(this.magicFilter);
         ItemManager.removeItem(1500580,20);
      }
      
      private function magicFilter() : Boolean
      {
         TextAlert.show("当前关卡不允许变身哦！",16711680);
         return true;
      }
      
      private function resizePos() : void
      {
         this._txtNumMc.y = 50;
         this._txtNumMc.x = LayerManager.stageWidth - this._txtNumMc.width - 50;
      }
      
      private function warnMcTweenOver() : void
      {
         TweenMax.killChildTweensOf(this._txtWarnMc);
         LayerManager.topLevel.removeChild(this._txtWarnMc);
      }
      
      private function initEventListener() : void
      {
         UserManager.addEventListener(UserEvent.BORN,this.onMonsterBorn);
         SocketConnection.addCmdListener(CommandID.STAGE_MONSTER_PRO_CHANGE,this.onStageProChange);
      }
      
      private function onStageProChange(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         this._round = _loc2_.readUnsignedInt() - 1;
         this._totalPmNum = _loc2_.readUnsignedInt();
         new NumSprite(this._txtNumMc,this._totalPmNum);
      }
      
      private function onMonsterBorn(param1:UserEvent) : void
      {
         var data:UserModel = null;
         var evt:UserEvent = param1;
         data = evt.data as UserModel;
         if(!this._listMonsterMc)
         {
            this._listMonsterMc = new Vector.<MovieClip>();
         }
         if(data.info.roleType == 14374 && this._round > 0)
         {
            data.visible = false;
            setTimeout(function():void
            {
               var _loc1_:MovieClip = _mapModel.libManager.getMovieClip("UI_MonsterBornMovie");
               _listMonsterMc.push(_loc1_);
               _loc1_.x = data.info.pos.x - 50;
               _loc1_.y = data.info.pos.y - 16;
               _loc1_.model = data;
               _mapModel.contentLevel.addChild(_loc1_);
               LayerManager.gameLevel.stage.addEventListener(Event.ENTER_FRAME,onFrameHandler);
            },3000);
         }
      }
      
      protected function onFrameHandler(param1:Event) : void
      {
         var _loc2_:MovieClip = null;
         for each(_loc2_ in this._listMonsterMc)
         {
            if(_loc2_.currentFrame == _loc2_.totalFrames)
            {
               _loc2_.stop();
               _loc2_.model.visible = true;
               DisplayUtil.removeForParent(_loc2_);
            }
         }
      }
      
      override public function destroy() : void
      {
         LayerManager.gameLevel.stage.removeEventListener(Event.ENTER_FRAME,this.onFrameHandler);
         UserManager.removeEventListener(UserEvent.BORN,this.onMonsterBorn);
         TweenMax.killChildTweensOf(this._txtWarnMc);
         DisplayUtil.removeForParent(this._txtWarnMc);
         DisplayUtil.removeForParent(this._txtNumMc);
         StageResizeController.instance.unregister(this.resizePos);
         SocketConnection.removeCmdListener(CommandID.STAGE_MONSTER_PRO_CHANGE,this.onStageProChange);
         MagicChangeManager.instance.uninstallBlockFilter(this.magicFilter);
      }
   }
}

