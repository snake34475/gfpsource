package com.gfp.app.manager
{
   import com.gfp.app.info.Privilege_81_VO;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.net.SocketConnection;
   import com.taomee.plugins.versionManager.TaomeeVersionManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class Privilege_81_Manager extends EventDispatcher
   {
      
      private static var _instance:Privilege_81_Manager;
      
      private var urlStream:URLLoader;
      
      private var _xml:XML;
      
      private var _data:Array;
      
      public const completeRecordID1:int = 2790;
      
      public const completeRecordID2:int = 2791;
      
      public const completeRecordID3:int = 2792;
      
      private var totalRecordID:int = 2789;
      
      private var _currentPrivilege:Array;
      
      public function Privilege_81_Manager()
      {
         super();
      }
      
      public static function get instance() : Privilege_81_Manager
      {
         return _instance = _instance || new Privilege_81_Manager();
      }
      
      public function setup() : void
      {
         this.urlStream = new URLLoader();
         this.urlStream.addEventListener(Event.COMPLETE,this.onXMLLoaded);
         this.urlStream.load(new URLRequest(TaomeeVersionManager.getInstance().getVerURLByNameSpace(ClientConfig.getResPath("xml/privilege81.xml"))));
         SocketConnection.addCmdListener(CommandID.PRIVILEGE_81_INFO,this.requestInfoResult);
      }
      
      private function onXMLLoaded(param1:Event) : void
      {
         var _loc3_:XML = null;
         var _loc4_:int = 0;
         var _loc5_:XMLList = null;
         var _loc6_:Array = null;
         var _loc7_:XML = null;
         var _loc8_:Privilege_81_VO = null;
         this._xml = XML(this.urlStream.data);
         this._data = [];
         var _loc2_:XMLList = this._xml["class"];
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = int(_loc3_.@id);
            if(this._data[_loc4_] == null)
            {
               this._data[_loc4_] = [];
            }
            _loc5_ = _loc3_.item;
            _loc6_ = this._data[_loc4_];
            for each(_loc7_ in _loc5_)
            {
               _loc8_ = new Privilege_81_VO();
               _loc8_.classID = _loc4_;
               _loc8_.id = int(_loc7_.@id);
               _loc8_.action = int(_loc7_.@action);
               _loc8_.name = _loc7_.@name;
               _loc8_.moduleURL = _loc7_.@moduleURL;
               _loc8_.data = _loc7_.@data;
               _loc8_.desc = _loc7_.@desc;
               _loc6_.push(_loc8_);
            }
         }
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function requestInfoResult(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         this._currentPrivilege = [];
         this._currentPrivilege[0] = [];
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         var _loc4_:int = 0;
         while(_loc4_ < 27)
         {
            if(_loc3_ & 1 << _loc4_)
            {
               this._currentPrivilege[0].push(_loc4_ + 1);
            }
            _loc4_++;
         }
         this._currentPrivilege[1] = [];
         _loc3_ = int(_loc2_.readUnsignedInt());
         _loc4_ = 0;
         while(_loc4_ < 27)
         {
            if(_loc3_ & 1 << _loc4_)
            {
               this._currentPrivilege[1].push(_loc4_ + 1);
            }
            _loc4_++;
         }
         this._currentPrivilege[2] = [];
         _loc3_ = int(_loc2_.readUnsignedInt());
         _loc4_ = 0;
         while(_loc4_ < 27)
         {
            if(_loc3_ & 1 << _loc4_)
            {
               this._currentPrivilege[2].push(_loc4_ + 1);
            }
            _loc4_++;
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get currentPrivilege() : Array
      {
         return this._currentPrivilege;
      }
      
      public function getValue(param1:int, param2:int) : Privilege_81_VO
      {
         var _loc4_:Privilege_81_VO = null;
         var _loc3_:Array = this._data[param1];
         if(_loc3_)
         {
            for each(_loc4_ in _loc3_)
            {
               if(_loc4_.id == param2)
               {
                  return _loc4_;
               }
            }
         }
         return null;
      }
      
      public function setTodayGetedID(param1:int, param2:int) : void
      {
         var _loc3_:int = (1 << 26 + param1) + (1 << param2 - 1);
         ActivityExchangeTimesManager.updataTimes(this.totalRecordID,_loc3_);
         var _loc4_:int = int(this["completeRecordID" + param1]);
         _loc3_ = int(ActivityExchangeTimesManager.getTimes(_loc4_));
         _loc3_ |= 1 << param2 - 1;
         ActivityExchangeTimesManager.updataTimes(_loc4_,_loc3_);
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function todayGetedID() : int
      {
         var _loc1_:int = int(ActivityExchangeTimesManager.getTimes(this.totalRecordID));
         var _loc2_:int = 0;
         while(_loc2_ < 27)
         {
            if(_loc1_ & 1 << _loc2_)
            {
               return _loc2_ + 1;
            }
            _loc2_++;
         }
         return 0;
      }
      
      public function todayGetedClass() : int
      {
         var _loc1_:int = int(ActivityExchangeTimesManager.getTimes(this.totalRecordID));
         var _loc2_:int = 0;
         while(_loc2_ < 3)
         {
            if(_loc1_ & 1 << _loc2_ + 27)
            {
               return _loc2_ + 1;
            }
            _loc2_++;
         }
         return -1;
      }
      
      public function isGeted(param1:int, param2:int) : Boolean
      {
         var _loc5_:Boolean = false;
         var _loc3_:int = int(this["completeRecordID" + param1]);
         var _loc4_:int = int(ActivityExchangeTimesManager.getTimes(_loc3_));
         return (_loc4_ & 1 << param2 - 1) != 0;
      }
      
      public function destroy() : void
      {
         SocketConnection.removeCmdListener(CommandID.PRIVILEGE_81_INFO,this.requestInfoResult);
         _instance = null;
      }
   }
}

