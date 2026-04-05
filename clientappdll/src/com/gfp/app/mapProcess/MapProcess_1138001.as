package com.gfp.app.mapProcess
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.cartoon.event.AnimatEvent;
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.ui.compoment.McNumber;
   import com.gfp.core.CommandID;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.info.SummonInfo;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.net.SocketConnection;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1138001 extends BaseMapProcess
   {
      
      private var _dieCount:int = 0;
      
      private var _skillestCount:int = 0;
      
      private var _showMC:MovieClip;
      
      private var _skillBtn:SimpleButton;
      
      private var AllType:Array = [40851,40861,40801,40821];
      
      private var SKILL_ID:int = 11436;
      
      private var temp:int = 0;
      
      private var isDai:Boolean = false;
      
      private var dieNumber:McNumber;
      
      private var skillNumber:McNumber;
      
      public function MapProcess_1138001()
      {
         super();
      }
      
      override protected function init() : void
      {
         FightManager.instance.addEventListener(FightEvent.OGRE_DIE,this.onModelDied);
         this._showMC = _mapModel.libManager.getMovieClip("UI_skillCountMc");
         this._skillBtn = this._showMC["skill"];
         this.dieNumber = new McNumber(this._showMC["dieMC"]);
         this.skillNumber = new McNumber(this._showMC["skillMC"]);
         SocketConnection.addCmdListener(CommandID.BUFF_STATE,this.onAddBuff);
         SocketConnection.addCmdListener(CommandID.FIGHT_ACTIVITY_EFFECT,this.niHandler);
         StageResizeController.instance.register(this.resizePos);
         this.resizePos();
         LayerManager.topLevel.addChild(this._showMC);
         this.addEvent();
         this.xianshou();
         this.updateView();
      }
      
      private function xianshou() : void
      {
         var _loc1_:SummonInfo = null;
         var _loc2_:SummonInfo = null;
         var _loc3_:int = 0;
         while(_loc3_ < 4)
         {
            _loc1_ = SummonManager.getActorSummonInfo().getSummonInfoBySummonType(this.AllType[_loc3_]);
            _loc2_ = SummonManager.getActorSummonInfo().currentSummonInfo;
            if(Boolean(_loc2_) && Boolean(_loc1_))
            {
               if(_loc1_.uniqueID == _loc2_.uniqueID)
               {
                  this.isDai = true;
                  this.temp += 1;
               }
            }
            _loc3_++;
         }
      }
      
      private function addEvent() : void
      {
         ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this._exchangeCompleteHandler);
         this._skillBtn.addEventListener(MouseEvent.CLICK,this.skillHandler);
      }
      
      private function _exchangeCompleteHandler(param1:ExchangeEvent) : void
      {
         if(param1.info.id == this.SKILL_ID)
         {
            --this._skillestCount;
         }
         this.updateView();
      }
      
      private function skillHandler(param1:MouseEvent) : void
      {
         if(this._skillestCount > 0)
         {
            SocketConnection.send(CommandID.FIGHT_ACTIVITY_EFFECT,10,0,0);
            if(this.isDai)
            {
               this.isDai = false;
               --this.temp;
            }
            else
            {
               this._dieCount -= 100;
            }
            this.updateView();
         }
         else
         {
            AlertManager.showSimpleAlarm("小侠士，你当前还不能使用必杀技哦");
         }
      }
      
      private function playAnimation() : void
      {
         AnimatPlay.startAnimat("bishaji",-1,true);
         AnimatPlay.addAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimatEndHandle);
      }
      
      private function onAnimatEndHandle(param1:AnimatEvent) : void
      {
         AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimatEndHandle);
         AnimatPlay.destory();
      }
      
      private function resizePos() : void
      {
         this._showMC.x = LayerManager.stageWidth - 300;
         this._showMC.y = 300;
      }
      
      private function niHandler(param1:SocketEvent) : void
      {
         this._dieCount -= 100;
         this.updateView();
      }
      
      private function onAddBuff(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedShort();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         var _loc6_:Boolean = _loc2_.readUnsignedByte() == 1;
         if(_loc4_ == 3397)
         {
         }
      }
      
      private function onModelDied(param1:FightEvent) : void
      {
         ++this._dieCount;
         this.updateView();
      }
      
      private function updateView() : void
      {
         this._skillestCount = this._dieCount / 100 + this.temp;
         if(this._skillestCount <= 3)
         {
            this._skillestCount = this._skillestCount;
         }
         else
         {
            this._skillestCount = 3;
         }
         this.dieNumber.setValue(this._dieCount);
         this.skillNumber.setValue(this._skillestCount);
      }
      
      override public function destroy() : void
      {
         this._skillBtn.removeEventListener(MouseEvent.CLICK,this.skillHandler);
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this._exchangeCompleteHandler);
         SocketConnection.removeCmdListener(CommandID.BUFF_STATE,this.onAddBuff);
         StageResizeController.instance.unregister(this.resizePos);
         DisplayUtil.removeForParent(this._showMC);
      }
   }
}

