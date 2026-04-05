package com.gfp.app.manager
{
   import com.gfp.app.toolBar.BuffIconBar;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.xml.SkillXMLInfo;
   import com.gfp.core.net.SocketConnection;
   import flash.events.TimerEvent;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import org.taomee.net.SocketEvent;
   
   public class SceneBuffManager
   {
      
      public static const NEEDED:Array = [312,224,225,226,227];
      
      private var _list:Array = [];
      
      private var _timer:Timer;
      
      private var _iconbar:BuffIconBar;
      
      public function SceneBuffManager(param1:BuffIconBar)
      {
         super();
         this._timer = new Timer(5000);
         this._timer.addEventListener(TimerEvent.TIMER,this.onLoop);
         this._iconbar = param1;
      }
      
      public function initBuff() : void
      {
         SocketConnection.addCmdListener(CommandID.GET_BUFF_TIME,this.OnGetBuff);
         SocketConnection.send(CommandID.GET_BUFF_TIME);
         this._timer.reset();
         this._timer.start();
      }
      
      private function OnGetBuff(param1:SocketEvent) : void
      {
         var _loc5_:Object = null;
         if(this._list)
         {
            while(this._list.length)
            {
               this.removeBuff(this._list.pop().id);
            }
         }
         this._list = [];
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = {};
            _loc5_.id = _loc2_.readUnsignedInt();
            _loc5_.id = _loc2_.readUnsignedInt();
            _loc5_.duration = _loc2_.readUnsignedInt();
            this._list.push(_loc5_);
            _loc4_++;
         }
         this.handleBuffs();
         this.onLoop(null);
      }
      
      private function handleBuffs() : void
      {
         var _loc1_:Object = null;
         for each(_loc1_ in this._list)
         {
            this.addBuff(_loc1_.id);
         }
      }
      
      private function onLoop(param1:TimerEvent) : void
      {
         var _loc2_:Object = null;
         if(this._list == null)
         {
            return;
         }
         var _loc3_:* = 0;
         while(_loc3_ < this._list.length)
         {
            _loc2_ = this._list[_loc3_];
            _loc2_.duration -= 5;
            if(_loc2_.duration <= 0)
            {
               this.removeBuff(_loc2_.id);
               this._list.splice(_loc3_,1);
               _loc3_--;
            }
            _loc3_++;
         }
      }
      
      private function updateBuffDesc(param1:Object) : void
      {
      }
      
      public function checkBuff(param1:int) : Boolean
      {
         var _loc2_:Object = null;
         for each(_loc2_ in this._list)
         {
            if(_loc2_)
            {
               if(_loc2_.id == param1 && _loc2_.duration > 0)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function hasBuff(param1:int) : Boolean
      {
         var _loc2_:Object = null;
         for each(_loc2_ in this._list)
         {
            if(_loc2_)
            {
               if(_loc2_.id == param1)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      private function addBuff(param1:int) : void
      {
         if(SkillXMLInfo.getBaseBuffInfo(param1))
         {
            this._iconbar.addBaseBuff(param1);
         }
         else
         {
            this._iconbar.addBuff(param1);
         }
      }
      
      private function removeBuff(param1:int) : void
      {
         if(SkillXMLInfo.getBaseBuffInfo(param1))
         {
            this._iconbar.removeBaseBuff(param1);
         }
         else
         {
            this._iconbar.removeBuff(param1);
         }
      }
   }
}

