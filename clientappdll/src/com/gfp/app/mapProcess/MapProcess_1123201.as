package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.fight.BruiseInfo;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.FunctionManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.net.SocketConnection;
   import flash.display.MovieClip;
   import flash.utils.ByteArray;
   import flash.utils.setTimeout;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1123201 extends BaseMapProcess
   {
      
      private var _txtInfoMc:MovieClip;
      
      private var _playerTotalHurtV:int;
      
      private var _itemPickList:Array = [];
      
      private var _isSended:Boolean = true;
      
      private var _timeId:int = 0;
      
      public function MapProcess_1123201()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._txtInfoMc = _mapModel.libManager.getMovieClip("UI_TxtInfo");
         StageResizeController.instance.register(this.resizePos);
         FunctionManager.disabledFightAwardPanel = true;
         SocketConnection.addCmdListener(CommandID.ITEM_QUICK_PICKUP,this.whenQuickPickUpHandler);
         SocketConnection.addCmdListener(CommandID.FIGHT_ACTIVITY_EFFECT,this.activityEffect);
         this.resizePos();
      }
      
      private function activityEffect(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         this._playerTotalHurtV = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:String = Math.floor(this._playerTotalHurtV / 10000).toString() + "万";
         this._txtInfoMc.hurtTxt.text = _loc5_;
      }
      
      private function whenQuickPickUpHandler(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         var _loc6_:uint = _loc2_.readUnsignedInt();
         if(_loc3_ == MainManager.actorID)
         {
            this._itemPickList.push({
               "itemid":_loc4_,
               "cnt":_loc6_
            });
         }
         if(this._isSended)
         {
            this._isSended = false;
            setTimeout(this.showAwardAlert,1000);
         }
      }
      
      private function showAwardAlert() : void
      {
         var i:int;
         var nick:String = null;
         if(this._playerTotalHurtV < 10000)
         {
            nick = "小侠士，你对战斗醒狮造成微量伤害，获得了";
         }
         else
         {
            nick = "小侠士，你对战斗醒狮造成" + Math.floor(this._playerTotalHurtV / 10000) + "万点伤害，获得了";
         }
         i = 0;
         while(i < this._itemPickList.length)
         {
            nick = nick + "<font color=\'#ff0000\'>" + ItemXMLInfo.getName(this._itemPickList[i].itemid) + "</font>*" + this._itemPickList[i].cnt.toString();
            i++;
         }
         AlertManager.showSimpleAlarm(nick,function():void
         {
            FightManager.quit();
         });
      }
      
      private function resizePos() : void
      {
         this._txtInfoMc.x = LayerManager.stageWidth - this._txtInfoMc.width - 335;
         this._txtInfoMc.y = 458;
         LayerManager.topLevel.addChild(this._txtInfoMc);
      }
      
      private function onDpsHit(param1:UserEvent) : void
      {
         var _loc3_:String = null;
         var _loc2_:BruiseInfo = param1.data as BruiseInfo;
         if(_loc2_.atkerID == MainManager.actorID)
         {
            this._playerTotalHurtV += _loc2_.decHP;
            _loc3_ = Math.floor(this._playerTotalHurtV / 10000).toString() + "万";
            this._txtInfoMc.hurtTxt.text = _loc3_;
         }
      }
      
      override public function destroy() : void
      {
         SocketConnection.removeCmdListener(CommandID.FIGHT_ACTIVITY_EFFECT,this.activityEffect);
         SocketConnection.removeCmdListener(CommandID.ITEM_QUICK_PICKUP,this.whenQuickPickUpHandler);
         DisplayUtil.removeForParent(this._txtInfoMc);
         this._txtInfoMc = null;
         FunctionManager.disabledFightAwardPanel = false;
         StageResizeController.instance.unregister(this.resizePos);
      }
   }
}

