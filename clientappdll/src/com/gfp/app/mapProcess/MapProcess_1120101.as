package com.gfp.app.mapProcess
{
   import com.gfp.core.events.DataEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.player.NumSprite;
   import flash.display.Sprite;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1120101 extends BaseMapProcess
   {
      
      private var _scoreTip:Sprite;
      
      private var _scoreNS:NumSprite;
      
      private var _needNS:NumSprite;
      
      private const ITEM_ID:int = 8038;
      
      private const NEED_SCORE:int = 500;
      
      private const NOR_TYPEs:Vector.<uint> = new <uint>[14565,14566,14567,14568,14570,14569];
      
      private var _itemNum:int;
      
      public function MapProcess_1120101()
      {
         super();
         this.addListener();
      }
      
      protected function get itemNum() : int
      {
         return this._itemNum;
      }
      
      protected function set itemNum(param1:int) : void
      {
         this._itemNum = param1;
         this._scoreNS.value = param1;
      }
      
      override protected function init() : void
      {
         this._scoreTip = _mapModel.libManager.getSprite("scoreTip");
         this._scoreTip.x = LayerManager.stageWidth - 180;
         this._scoreTip.y = 90;
         LayerManager.uiLevel.addChild(this._scoreTip);
         this._scoreNS = new NumSprite(this._scoreTip["score"]);
         this._needNS = new NumSprite(this._scoreTip["need"],500);
         this.itemNum = 0;
         ActivityExchangeTimesManager.getActiviteTimeInfo(this.ITEM_ID);
      }
      
      private function onSwapBack(param1:DataEvent) : void
      {
         if(param1.data.dailyID == this.ITEM_ID)
         {
            this.itemNum += ActivityExchangeTimesManager.getTimes(this.ITEM_ID);
         }
      }
      
      private function addListener() : void
      {
         ActivityExchangeTimesManager.addEventListener(this.ITEM_ID,this.onSwapBack);
         UserManager.addEventListener(UserEvent.DIE,this.onUserDie);
      }
      
      private function onUserDie(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         var _loc3_:int = this.NOR_TYPEs.indexOf(_loc2_.info.roleType);
         if(_loc3_ != -1)
         {
            ++this.itemNum;
         }
      }
      
      private function removeListener() : void
      {
         ActivityExchangeTimesManager.removeEventListener(this.ITEM_ID,this.onSwapBack);
         UserManager.removeEventListener(UserEvent.DIE,this.onUserDie);
      }
      
      override public function destroy() : void
      {
         this.removeListener();
         if(this._scoreTip)
         {
            DisplayUtil.removeForParent(this._scoreTip);
         }
         super.destroy();
      }
   }
}

