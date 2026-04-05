package com.gfp.app.store
{
   import com.gfp.app.info.StoreInfo;
   import com.gfp.core.cache.SwfCache;
   import com.gfp.core.cache.SwfInfo;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.map.MapManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.TextField;
   import org.taomee.utils.DisplayUtil;
   
   public class StoreDisplay extends Sprite
   {
      
      public static const DEFAULT_DECORATE_ID:uint = 1190002;
      
      public static const STORE_STATUS_AVAILABLE:uint = 0;
      
      public static const STORE_STATUS_UNDER_CONSTRUCTION:uint = 1;
      
      public static const STORE_STATUS_IN_SERVICE:uint = 2;
      
      private var _storeSign:MovieClip;
      
      private var _storeInfo:StoreInfo;
      
      private var _avater:Sprite;
      
      private var _avaterUrl:String;
      
      private var _decorate:Sprite;
      
      private var _decorateUrl:String;
      
      public function StoreDisplay(param1:StoreInfo)
      {
         super();
         this._storeInfo = param1;
         this.initialize();
      }
      
      private function initialize() : void
      {
         this.createChildren();
      }
      
      private function createChildren() : void
      {
         this.createDecorateHolder();
         this.updateDisplay();
      }
      
      private function createDecorateHolder() : void
      {
         this._avater = new Sprite();
         addChild(this._avater);
         this._decorate = new Sprite();
         addChild(this._decorate);
      }
      
      private function loadAvater() : void
      {
         var _loc1_:uint = this._storeInfo.ownerRoleType;
         this._avaterUrl = ClientConfig.getStoreAvater(_loc1_);
         SwfCache.getSwfInfo(this._avaterUrl,this.onAvaterLoaded);
      }
      
      private function onAvaterLoaded(param1:SwfInfo) : void
      {
         var _loc2_:Sprite = param1.content as Sprite;
         _loc2_.cacheAsBitmap = true;
         this._avater.addChild(_loc2_);
      }
      
      public function updateInfo(param1:StoreInfo) : void
      {
         this._storeInfo = param1;
         this.updateDisplay();
      }
      
      private function updateDisplay() : void
      {
         this.removeDecorateItem();
         this.removeStoreSign();
         switch(this._storeInfo.status)
         {
            case STORE_STATUS_AVAILABLE:
               this.addStoreSign("storeAvailable");
               this._storeSign.addEventListener("click",this.onSetupStore);
               this._storeSign.buttonMode = true;
               break;
            case STORE_STATUS_UNDER_CONSTRUCTION:
               this.addStoreSign("storeUnderConstruction");
               break;
            case STORE_STATUS_IN_SERVICE:
               this.showDecorateItem();
               addEventListener("click",this.onStoreClick);
               this.buttonMode = true;
         }
      }
      
      private function addStoreSign(param1:String) : void
      {
         this._storeSign = MapManager.currentMap.libManager.getMovieClip(param1);
         this._storeSign.cacheAsBitmap = true;
         addChild(this._storeSign);
      }
      
      private function onSetupStore(param1:Event) : void
      {
         if(MainManager.actorInfo.lv < 40 && !MainManager.actorInfo.isTurnBack)
         {
            AlertManager.showSimpleAlarm("小侠士，满40级后才能进入万博会交易。");
            return;
         }
         if(this._storeInfo.status == 0 && MainManager.actorModel.visible == false)
         {
            AlertManager.showSimpleAlarm(AppLanguageDefine.STORE_CHARACTER_COLLECTION[0]);
            return;
         }
         ModuleManager.turnModule(ClientConfig.getAppModule("TradeSalePanel"),AppLanguageDefine.LOAD_MATTER_COLLECTION[14],{"info":this._storeInfo});
      }
      
      private function onStoreClick(param1:Event) : void
      {
         if(MainManager.actorInfo.lv < 40 && !MainManager.actorInfo.isTurnBack)
         {
            AlertManager.showSimpleAlarm("小侠士，满40级后才能进入万博会交易。");
            return;
         }
         ModuleManager.turnModule(ClientConfig.getAppModule("TradeSalePanel"),AppLanguageDefine.LOAD_MATTER_COLLECTION[14],{"info":this._storeInfo});
      }
      
      private function removeStoreSign() : void
      {
         if(this._storeSign)
         {
            DisplayUtil.removeForParent(this._storeSign);
            this._storeSign.removeEventListener("click",this.onStoreClick);
         }
         if(hasEventListener("click"))
         {
            removeEventListener("click",this.onStoreClick);
         }
      }
      
      private function showDecorateItem() : void
      {
         this.loadAvater();
         var _loc1_:uint = uint(this._storeInfo.decorateItemId);
         if(_loc1_ == 0)
         {
            _loc1_ = DEFAULT_DECORATE_ID;
         }
         this._decorateUrl = ClientConfig.getStoreDecorate(_loc1_);
         SwfCache.getSwfInfo(this._decorateUrl,this.onDecorateItemLoaded);
      }
      
      private function onDecorateItemLoaded(param1:SwfInfo) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:TextField = null;
         if(Boolean(param1) && Boolean(param1.content))
         {
            _loc2_ = param1.content as MovieClip;
            if(_loc2_)
            {
               _loc3_ = _loc2_["nameTxt"] as TextField;
               _loc3_.text = this._storeInfo.name;
               if(this._storeInfo.shopType == 1)
               {
                  _loc3_.text = "神秘商人威廉";
               }
               _loc2_.cacheAsBitmap = true;
               this._decorate.addChild(_loc2_);
            }
         }
      }
      
      private function removeDecorateItem() : void
      {
         if(this._decorate.numChildren > 0)
         {
            this._decorate.removeChildAt(0);
         }
         if(this._avater.numChildren > 0)
         {
            this._avater.removeChildAt(0);
         }
      }
      
      public function destroy() : void
      {
         this.removeDecorateItem();
         SwfCache.cancel(this._avaterUrl,this.onAvaterLoaded);
         SwfCache.cancel(this._decorateUrl,this.onDecorateItemLoaded);
      }
   }
}

