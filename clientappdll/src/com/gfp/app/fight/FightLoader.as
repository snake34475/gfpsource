package com.gfp.app.fight
{
   import com.gfp.core.CommandID;
   import com.gfp.core.cache.ActionSpngInfo;
   import com.gfp.core.cache.CommonCache;
   import com.gfp.core.cache.EffectBitmapCache;
   import com.gfp.core.cache.SoundCache;
   import com.gfp.core.cache.SoundInfo;
   import com.gfp.core.cache.SpngInfo;
   import com.gfp.core.cache.SwfCache;
   import com.gfp.core.cache.SwfInfo;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.LoadingManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.loading.ILoading;
   import com.gfp.core.ui.loading.LoadingType;
   import com.gfp.core.ui.loading.MultiplayerLoading;
   import com.gfp.core.utils.ArrayUtilGFP;
   import com.gfp.core.utils.DisplayObjectFlashUtil;
   import com.gfp.core.utils.FightMode;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import flash.utils.getTimer;
   import org.taomee.net.SocketEvent;
   
   public class FightLoader extends EventDispatcher
   {
      
      protected var _waitList:Array;
      
      protected var _loading:ILoading;
      
      protected var _pvpLoading:MultiplayerLoading;
      
      protected var _total:int;
      
      protected var _currInfo:com.gfp.app.fight.WaitInfo;
      
      protected var _invTime:Number = 0;
      
      protected var _beginLoadTime:Number;
      
      protected var _endLoadTime:Number;
      
      protected var _isTeamLoadComplete:Boolean = false;
      
      protected var _isSelfLoadComplete:Boolean = false;
      
      protected var _fightReg:FightRes;
      
      protected var _isDispatchComplete:Boolean = false;
      
      protected var _peopleList:Array;
      
      protected var _ogreList:Array;
      
      protected var fightModel:uint;
      
      protected var pvpTransitionLoading:PvpTransitionLoading;
      
      private var _isExtraLoad:Boolean;
      
      private var _prepareToChange:int;
      
      protected var isLoading:Boolean = false;
      
      public function FightLoader()
      {
         super();
         this._waitList = [];
         this._fightReg = new FightRes();
      }
      
      public function addPeopleActions(param1:Vector.<uint>) : void
      {
         this._fightReg.addPeopleActions(param1);
      }
      
      public function addWinReaSound(param1:uint) : void
      {
         this._fightReg.addWinReaSound(param1);
      }
      
      public function destroy() : void
      {
         if(this._currInfo)
         {
            if(this._currInfo.type == FightRes.EQUIP)
            {
               CommonCache.cancelByUrl(this._currInfo.url,this.onEquipComplete);
            }
            else if(this._currInfo.type == FightRes.EFFECT)
            {
               EffectBitmapCache.cancel(ClientConfig.getEffectBmp(this._currInfo.itemID),this.onEffectComplete);
            }
            else if(this._currInfo.type == FightRes.NPC)
            {
               CommonCache.cancelByUrl(this._currInfo.url,this.onNpcComplete);
            }
            else if(this._currInfo.type == FightRes.SOUND)
            {
               SoundCache.cancel(this._currInfo.url,this.onSoundComplete);
            }
         }
         this.destroyLoading();
         this._waitList = null;
      }
      
      public function destroyLoading() : void
      {
         if(this._loading)
         {
            this._loading.destroy();
            this._loading = null;
         }
         if(this._pvpLoading)
         {
            SocketConnection.removeCmdListener(CommandID.FIGHT_LOADING_ACCEPT,this.onLoadingProgress);
            this._pvpLoading.removeEventListener(Event.CLOSE,this.onPvpClose);
            this._pvpLoading.destroy();
            this._pvpLoading = null;
         }
      }
      
      public function loadPvP(param1:Array, param2:Array = null) : void
      {
         this.fightModel = FightMode.PVP;
         this._waitList = this._fightReg.parseAll(param1,param2,true);
         var _loc3_:Array = this._fightReg.parseSoundAll(param1,param2);
         this._waitList = _loc3_.concat(this._waitList);
         this.pvpTransitionLoading = new PvpTransitionLoading(param1,LayerManager.topLevel,this.pvpTransitionOverHandler,2000 * param1.length);
         this.nextLoad();
      }
      
      protected function pvpTransitionOverHandler() : void
      {
         this.loadResourceComplete();
      }
      
      private function loadResourceComplete() : void
      {
         DisplayObjectFlashUtil.generalConvertMovieInfo(UIManager.getMovieClip("Add_SP_Turnback_animat"),"Add_SP_Turnback_animat");
         this.startChangeMap();
      }
      
      private function startChangeMap() : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function onLoadingProgress(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         var _loc4_:int = int(_loc2_.readUnsignedInt());
         if(this._pvpLoading)
         {
            this._pvpLoading.setEnemyPercent(_loc3_,_loc4_);
         }
         if(_loc4_ == 100)
         {
            this._isTeamLoadComplete = true;
            if(this._isSelfLoadComplete)
            {
               this.dispathComplete();
            }
         }
      }
      
      private function onPvpClose(param1:Event) : void
      {
      }
      
      private function addEffectWaitInfo(param1:uint) : void
      {
         var _loc2_:com.gfp.app.fight.WaitInfo = new com.gfp.app.fight.WaitInfo();
         _loc2_.type = FightRes.EFFECT;
         _loc2_.itemID = param1;
         _loc2_.priorityLevel = 6;
         this._waitList.push(_loc2_);
      }
      
      public function loadTollgate(param1:Array, param2:Array, param3:uint, param4:int = 5) : void
      {
         if(param3 == 1045)
         {
            param4 = int(LoadingType.TITLE_AND_PERCENT);
         }
         this._peopleList = param1;
         this._ogreList = param2;
         this._waitList = this._fightReg.parseSoundAll(param1);
         var _loc5_:Array = this._fightReg.parseAll(param1);
         this._waitList = this._waitList.concat(_loc5_);
         this._total = this._waitList.length;
         if(param4 == LoadingType.TOLLGATE)
         {
            if(FightManager.isTeamFight)
            {
               this._pvpLoading = new MultiplayerLoading(param1,MultiplayerLoading.PVE_TEAME_LOADING,LayerManager.topLevel,false);
               this._pvpLoading.show();
               this._pvpLoading.addEventListener(Event.CLOSE,this.onPvpClose);
               SocketConnection.addCmdListener(CommandID.FIGHT_LOADING_ACCEPT,this.onLoadingProgress);
            }
            SwfCache.getSwfInfo(ClientConfig.getLoadingPro(param3),this.onLoad,this.onError);
            this._invTime = getTimer();
         }
         else
         {
            if(param3 == 1045)
            {
               this._loading = LoadingManager.getLoading(param4,LayerManager.topLevel,"正在加载新手教程...");
            }
            else
            {
               this._loading = LoadingManager.getLoading(param4,LayerManager.topLevel,"加载战斗资源...");
            }
            this._loading.closeEnabled = false;
            this._loading.show();
            this.nextLoad();
         }
      }
      
      private function onLoad(param1:SwfInfo) : void
      {
         var _loc2_:Sprite = param1.content as Sprite;
         _loc2_.mouseChildren = false;
         _loc2_.cacheAsBitmap = true;
         this.initLoadingLogo(_loc2_);
         this._loading = LoadingManager.getFightLoading(_loc2_,LayerManager.topLevel,"加载战斗资源...");
         this._loading.show();
         if(this._pvpLoading)
         {
            this._pvpLoading.bringToTop();
         }
         this.nextLoad();
      }
      
      private function initLoadingLogo(param1:Sprite) : void
      {
         var _loc2_:MovieClip = null;
         if(param1["logoMC"])
         {
            _loc2_ = MovieClip(param1["logoMC"]);
            _loc2_.gotoAndStop(1);
         }
      }
      
      private function onError(param1:String) : void
      {
         SwfCache.getSwfInfo(ClientConfig.getLoadingPro(FightRes.DEFAULT_FIGHT_LOADING),this.onLoad,this.onError);
      }
      
      protected function nextLoad() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         var _loc4_:String = null;
         if(!this.isLoading)
         {
            _loc1_ = int(this._waitList.length);
            if(this._loading)
            {
               this._loading.setPercent(this._total - _loc1_,this._total);
            }
            if(this._pvpLoading)
            {
               _loc2_ = int((this._total - _loc1_) / this._total * 100);
               this._pvpLoading.setSelfPercent(_loc2_);
               _loc3_ = getTimer();
               if(_loc3_ - this._invTime > 2000)
               {
                  this._invTime = _loc3_;
                  SocketConnection.send(CommandID.FIGHT_LOADING_SEND,_loc2_);
               }
            }
            if(_loc1_ > 0)
            {
               this.isLoading = true;
               this._currInfo = this._waitList.pop();
               if(this._currInfo.type == FightRes.EQUIP)
               {
                  CommonCache.getSpngInfoByUrl(this._currInfo.url,this.onEquipComplete,this.onEquipError);
               }
               else if(this._currInfo.type == FightRes.EFFECT)
               {
                  _loc4_ = ClientConfig.getEffectBmp(this._currInfo.itemID);
                  if(_loc4_.indexOf("?") != -1)
                  {
                     EffectBitmapCache.getSpngInfoByUrl(_loc4_,this.onEffectComplete,this.onEffectError);
                  }
                  else
                  {
                     this.onEffectError(_loc4_);
                  }
               }
               else if(this._currInfo.type == FightRes.NPC)
               {
                  CommonCache.getSpngInfoByUrl(this._currInfo.url,this.onNpcComplete,this.onNpcError);
               }
               else if(this._currInfo.type == FightRes.SOUND)
               {
                  SoundCache.load(this._currInfo.url,this.onSoundComplete,this.onSoundError);
               }
            }
            else
            {
               this._isSelfLoadComplete = true;
               if(this.fightModel == FightMode.PVP)
               {
                  return;
               }
               if(this._pvpLoading)
               {
                  SocketConnection.send(CommandID.FIGHT_LOADING_SEND,100);
                  if(this._isTeamLoadComplete)
                  {
                     this.dispathComplete();
                  }
               }
               else
               {
                  this.dispathComplete();
                  if(FightManager.isTeamFight)
                  {
                     SocketConnection.send(CommandID.FIGHT_LOADING_SEND,100);
                  }
               }
            }
         }
      }
      
      private function dispathComplete() : void
      {
         if(!this._isDispatchComplete)
         {
            this._isDispatchComplete = true;
            this.loadResourceComplete();
         }
         if(this._isExtraLoad)
         {
            this._isExtraLoad = false;
            dispatchEvent(new FightEvent(FightEvent.RES_LOAD_COMPLETE));
         }
      }
      
      public function loaderOgreList(param1:Array, param2:Boolean = false) : void
      {
         var _loc3_:Array = null;
         if(this._waitList)
         {
            _loc3_ = this._fightReg.parseSoundAll([],param1);
            _loc3_ = _loc3_.concat(this._fightReg.parseAll([],param1));
            this._waitList = this._waitList.concat(_loc3_);
            this._total = this._waitList.length;
            ArrayUtilGFP.sortOnESC("priorityLevel",this._waitList);
            if(!this.isLoading && !param2)
            {
               this.nextLoad();
            }
         }
         else
         {
            this.dispathComplete();
         }
      }
      
      protected function onEquipComplete(param1:ActionSpngInfo) : void
      {
         this.traceLoaderInfo("装扮加载完成: res/item/swf/" + param1.actionArr[0] + "/" + param1.itemID + ".swf");
         this.isLoading = false;
         this.nextLoad();
      }
      
      protected function onEquipError(param1:String) : void
      {
         this.traceLoaderInfo("装扮加载失败: " + param1);
         this.isLoading = false;
         this.nextLoad();
      }
      
      protected function onEffectComplete(param1:SpngInfo) : void
      {
         this.traceLoaderInfo("特效加载完成: " + param1.url);
         this.isLoading = false;
         this.nextLoad();
      }
      
      protected function onEffectError(param1:String) : void
      {
         this.traceLoaderInfo("特效加载失败: " + param1);
         this.isLoading = false;
         this.nextLoad();
      }
      
      protected function onNpcComplete(param1:ActionSpngInfo) : void
      {
         this.traceLoaderInfo("NPC加载完成:  res/role/swf/" + param1.actionArr[0] + "/" + param1.itemID + ".swf");
         this.isLoading = false;
         this.nextLoad();
      }
      
      protected function onNpcError(param1:String) : void
      {
         this.traceLoaderInfo("NPC加载失败: " + param1);
         this.isLoading = false;
         this.nextLoad();
      }
      
      protected function onSoundComplete(param1:SoundInfo) : void
      {
         this.traceLoaderInfo("声音加载完成: " + param1.url);
         this.isLoading = false;
         this.nextLoad();
      }
      
      protected function onSoundError(param1:String) : void
      {
         this.traceLoaderInfo("声音加载失败: " + param1);
         this.isLoading = false;
         this.nextLoad();
      }
      
      private function traceLoaderInfo(param1:String) : void
      {
      }
      
      public function destroyPvpTransition() : void
      {
         if(this.pvpTransitionLoading)
         {
            this.pvpTransitionLoading.destory();
            this.pvpTransitionLoading = null;
         }
      }
   }
}

