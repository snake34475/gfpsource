package com.gfp.app.manager
{
   import com.gfp.core.CommandID;
   import com.gfp.core.net.SocketConnection;
   import flash.display.MovieClip;
   import flash.utils.ByteArray;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.net.SocketEvent;
   
   public class AccountSafeManager
   {
      
      private static var _instance:AccountSafeManager;
      
      private var _safeData:uint;
      
      private var _selfDefineAccount:Boolean;
      
      private var _func:Function;
      
      private var _t:uint;
      
      public function AccountSafeManager()
      {
         super();
      }
      
      public static function get instance() : AccountSafeManager
      {
         if(_instance == null)
         {
            _instance = new AccountSafeManager();
         }
         return _instance;
      }
      
      public function init(param1:Function = null) : void
      {
         this._func = param1;
         if(param1 != null)
         {
            SocketConnection.addCmdListener(8026,this.onGetSafeInfo);
            SocketConnection.send(8026,6,0,0);
         }
      }
      
      public function initTip(param1:MovieClip) : void
      {
         if(!param1)
         {
            return;
         }
         if(!this.allBind)
         {
            param1.visible = true;
         }
         else
         {
            param1.visible = false;
            param1.stop();
         }
      }
      
      private function onGetNameInfo(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.ACCOUNT_BINDING_STATUS,this.onGetNameInfo);
         clearTimeout(this._t);
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 8;
         var _loc3_:String = _loc2_.readUTFBytes(_loc2_.bytesAvailable);
         if(_loc3_ != "")
         {
            this._selfDefineAccount = true;
         }
         if(this._func != null)
         {
            this._func.apply();
            this._func = null;
         }
      }
      
      private function onGetSafeInfo(param1:SocketEvent) : void
      {
         var data:ByteArray;
         var e:SocketEvent = param1;
         SocketConnection.removeCmdListener(8026,this.onGetSafeInfo);
         data = e.data as ByteArray;
         this._safeData = data.readUnsignedShort();
         SocketConnection.addCmdListener(CommandID.ACCOUNT_BINDING_STATUS,this.onGetNameInfo);
         SocketConnection.send(CommandID.ACCOUNT_BINDING_STATUS,1,5,0);
         this._t = setTimeout(function():void
         {
            SocketConnection.removeCmdListener(CommandID.ACCOUNT_BINDING_STATUS,onGetNameInfo);
            clearTimeout(_t);
            if(_func != null)
            {
               _func.apply();
               _func = null;
            }
         },1000);
      }
      
      public function get selfDefineAccount() : Boolean
      {
         return this._selfDefineAccount;
      }
      
      public function get mailBind() : Boolean
      {
         return Boolean(this._safeData & 4);
      }
      
      public function get phoneBind() : Boolean
      {
         return Boolean(this._safeData & 8);
      }
      
      public function get passBind() : Boolean
      {
         return Boolean(this._safeData & 2);
      }
      
      public function get allBind() : Boolean
      {
         return this.selfDefineAccount && this.mailBind && this.phoneBind && this.passBind;
      }
      
      public function get safeArr() : Array
      {
         return [this.selfDefineAccount,this.mailBind,this.phoneBind,this.passBind];
      }
   }
}

