package com.gfp.app.systems
{
   import com.gfp.core.cache.ActionSpngInfo;
   import com.gfp.core.cache.CommonCache;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.ActionXMLInfo;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.info.item.SingleEquipInfo;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.LoadingManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.ui.loading.ILoading;
   import com.gfp.core.ui.loading.LoadingType;
   import com.gfp.core.utils.EquipPart;
   import com.gfp.core.utils.Logger;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.net.URLRequest;
   import flash.net.URLStream;
   import flash.utils.ByteArray;
   
   public class DefEquipLoader extends EventDispatcher
   {
      
      private const NAME_DEFEQUIP:String = "defEquip";
      
      private var _waitList:Array;
      
      private var _loading:ILoading;
      
      private var _total:int;
      
      private var _currInfo:WaitInfo;
      
      private var _defInfo:DefWaitInfo;
      
      private var _defLoader:URLStream;
      
      public function DefEquipLoader()
      {
         super();
      }
      
      public function destroy() : void
      {
         if(this._currInfo)
         {
            CommonCache.cancelByUrl(this._currInfo.url,this.onEquipComplete);
            this._currInfo = null;
         }
         if(this._loading)
         {
            this._loading.destroy();
            this._loading = null;
         }
         if(this._defLoader)
         {
            this.removeEvent();
            if(this._defLoader.connected)
            {
               this._defLoader.close();
            }
            this._defLoader = null;
         }
         this._defInfo = null;
         this._waitList = null;
      }
      
      public function load() : void
      {
         this._defLoader = new URLStream();
         this._defLoader.addEventListener(Event.COMPLETE,this.onDefComplete);
         this._defLoader.addEventListener(ProgressEvent.PROGRESS,this.onDefProgress);
         this._defLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onDefIoError);
         this._defLoader.load(new URLRequest(ClientConfig.getUI(this.NAME_DEFEQUIP)));
         this._loading = LoadingManager.getLoading(LoadingType.TITLE_AND_PERCENT,LayerManager.stage,"加载装扮资源");
         this._loading.closeEnabled = false;
         this._loading.show();
      }
      
      private function removeEvent() : void
      {
         this._defLoader.removeEventListener(Event.COMPLETE,this.onDefComplete);
         this._defLoader.removeEventListener(ProgressEvent.PROGRESS,this.onDefProgress);
         this._defLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onDefIoError);
      }
      
      private function onDefComplete(param1:Event) : void
      {
         var _loc3_:DefWaitInfo = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         this.removeEvent();
         this._waitList = [];
         var _loc2_:ByteArray = new ByteArray();
         this._defLoader.readBytes(_loc2_);
         _loc2_.position = 0;
         while(_loc2_.bytesAvailable >= 12)
         {
            _loc3_ = new DefWaitInfo();
            _loc5_ = _loc2_.readUnsignedInt();
            _loc6_ = _loc2_.readUnsignedInt();
            _loc3_.url = ItemXMLInfo.getItemActionPath(_loc5_,_loc6_);
            _loc4_ = _loc2_.readUnsignedInt();
            _loc3_.data = new ByteArray();
            _loc2_.readBytes(_loc3_.data,0,_loc4_);
            this._waitList.push(_loc3_);
         }
         this._total = this._waitList.length;
         this.defNextLoad();
      }
      
      private function onDefProgress(param1:ProgressEvent) : void
      {
         this._loading.setPercent(param1.bytesLoaded,param1.bytesTotal);
      }
      
      private function onDefIoError(param1:IOErrorEvent) : void
      {
         this.removeEvent();
         Logger.error(this,param1.text);
      }
      
      private function defNextLoad() : void
      {
         var _loc1_:int = int(this._waitList.length);
         this._loading.setPercent(this._total - _loc1_,this._total);
         if(_loc1_ > 0)
         {
            this._defInfo = this._waitList.pop();
            CommonCache.addBytesByUrl(this._defInfo.url,this.onDefEquipComplete,this.onDefEquipError,this._defInfo.data);
         }
         else
         {
            this.loadEquip();
         }
      }
      
      private function onDefEquipComplete(param1:ActionSpngInfo) : void
      {
         Logger.info(this,"默认装扮加载完成: actionID:" + param1.actionArr[0] + "resID:" + param1.itemID);
         this.defNextLoad();
      }
      
      private function onDefEquipError(param1:uint, param2:uint) : void
      {
         Logger.error(this,"默认装扮加载失败: actionID:" + param1 + "resID:" + param2);
         this.defNextLoad();
      }
      
      private function loadEquip() : void
      {
         var _loc5_:SingleEquipInfo = null;
         var _loc6_:WaitInfo = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         this._waitList.length = 0;
         var _loc1_:Array = [];
         var _loc2_:Vector.<uint> = ActionXMLInfo.defLoads;
         var _loc3_:Vector.<SingleEquipInfo> = MainManager.actorInfo.fashionClothes;
         var _loc4_:int = 0;
         for each(_loc5_ in _loc3_)
         {
            _loc4_ = int(ItemXMLInfo.getEquipPart(_loc5_.itemID));
            if(_loc1_.indexOf(_loc5_.itemID) == -1 && Boolean(EquipPart.isView(_loc4_)))
            {
               _loc1_.push(_loc5_.itemID);
            }
         }
         for each(_loc7_ in _loc2_)
         {
            for each(_loc8_ in _loc1_)
            {
               _loc6_ = new WaitInfo();
               _loc6_.url = ItemXMLInfo.getItemActionPath(_loc7_,_loc8_);
               this._waitList.push(_loc6_);
            }
         }
         this._total = this._waitList.length;
         this.nextLoad();
      }
      
      private function nextLoad() : void
      {
         var _loc1_:int = int(this._waitList.length);
         this._loading.setPercent(this._total - _loc1_,this._total);
         if(_loc1_ > 0)
         {
            this._currInfo = this._waitList.pop();
            CommonCache.getSpngInfoByUrl(this._currInfo.url,this.onEquipComplete,this.onEquipError);
         }
         else
         {
            this._loading.destroy();
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
      
      private function onEquipComplete(param1:ActionSpngInfo) : void
      {
         Logger.info(this,"默认装扮加载完成: actionID:" + param1.actionArr[0] + "resID:" + param1.itemID);
         this.nextLoad();
      }
      
      private function onEquipError(param1:uint, param2:uint) : void
      {
         Logger.error(this,"默认装扮加载失败: actionID:" + param1 + "resID:" + param2);
         this.nextLoad();
      }
   }
}

import flash.utils.ByteArray;

class WaitInfo
{
   
   public var isDef:Boolean;
   
   public var itemID:uint;
   
   public var actionID:uint;
   
   public var url:String;
   
   public function WaitInfo()
   {
      super();
   }
}

class DefWaitInfo
{
   
   public var data:ByteArray;
   
   public var itemID:uint;
   
   public var actionID:uint;
   
   public var url:String;
   
   public function DefWaitInfo()
   {
      super();
   }
}
