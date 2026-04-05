package com.gfp.app.manager.fightPlugin
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.CommandID;
   import com.gfp.core.action.normal.AimMoveAction;
   import com.gfp.core.config.xml.ActionXMLInfo;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.UserItemEvent;
   import com.gfp.core.info.ItemFallInfo;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.sensemodels.SightModel;
   import com.gfp.core.model.sensemodels.StageTeleportModel;
   import com.gfp.core.net.SocketConnection;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class AutoTollgateTransManager
   {
      
      private static var _instance:AutoTollgateTransManager;
      
      public static const ITEM_PICK_COMPLETE:String = "item_pick_complete";
      
      private var _passRooms:Array;
      
      private var _ed:EventDispatcher = new EventDispatcher();
      
      public function AutoTollgateTransManager()
      {
         super();
      }
      
      public static function get instance() : AutoTollgateTransManager
      {
         if(_instance == null)
         {
            _instance = new AutoTollgateTransManager();
         }
         return _instance;
      }
      
      public static function addEventListener(param1:String, param2:Function) : void
      {
         instance._ed.addEventListener(param1,param2);
      }
      
      public static function removeEventListener(param1:String, param2:Function) : void
      {
         instance._ed.removeEventListener(param1,param2);
      }
      
      public static function destroy() : void
      {
         if(_instance)
         {
            _instance.destroy();
         }
         _instance = null;
      }
      
      public function setup(param1:Boolean = true) : void
      {
         if(param1)
         {
            this._passRooms = new Array();
         }
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         FightManager.instance.addEventListener(FightEvent.BEGIN,this.onFightBegin);
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComlete);
         MapManager.addEventListener(UserItemEvent.ITEM_DROP_COMPLETE,this.onItemDropComplete);
      }
      
      private function removeEvent() : void
      {
         FightManager.instance.removeEventListener(FightEvent.BEGIN,this.onFightBegin);
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComlete);
         MapManager.removeEventListener(UserItemEvent.ITEM_DROP_COMPLETE,this.onItemDropComplete);
      }
      
      private function onFightBegin(param1:FightEvent) : void
      {
         this._passRooms = new Array();
         this._passRooms.push(MapManager.mapInfo.id);
      }
      
      private function onMapSwitchComlete(param1:MapEvent) : void
      {
         var _loc2_:uint = uint(MapManager.mapInfo.id);
         if(Boolean(MapManager.isFightMap) && this._passRooms.indexOf(_loc2_) == -1)
         {
            this._passRooms.push(_loc2_);
         }
      }
      
      private function onItemDropComplete(param1:UserItemEvent) : void
      {
         var _loc2_:ItemFallInfo = param1.param as ItemFallInfo;
         if(Boolean(_loc2_.onlyID) && Boolean(ItemManager.getItemCount(_loc2_.itemID) < 9999) && ItemManager.getItemAvailableCapacity() > 0)
         {
            if(!MainManager.actorInfo.isVip)
            {
               SocketConnection.send(CommandID.ITEM_PICKUP,_loc2_.onlyID,0);
            }
         }
      }
      
      public function enterNextRoom() : void
      {
         var _loc1_:StageTeleportModel = null;
         this._ed.dispatchEvent(new Event(ITEM_PICK_COMPLETE));
         if(this._passRooms)
         {
            _loc1_ = this.getTeleport();
            if(Boolean(_loc1_) && Boolean(_loc1_.visible) && Boolean(_loc1_.parent))
            {
               MainManager.actorModel.actionManager.clear();
               MainManager.actorModel.execAction(new AimMoveAction(ActionXMLInfo.getInfo(10003),_loc1_.pos));
            }
         }
      }
      
      private function getTeleport() : StageTeleportModel
      {
         var _loc3_:SightModel = null;
         var _loc4_:uint = 0;
         var _loc6_:StageTeleportModel = null;
         var _loc8_:uint = 0;
         var _loc9_:StageTeleportModel = null;
         var _loc1_:Array = SightManager.getSightModelList();
         var _loc2_:Array = new Array();
         for each(_loc3_ in _loc1_)
         {
            if(_loc3_ is StageTeleportModel && Boolean(_loc3_.visible) && Boolean(_loc3_.parent))
            {
               _loc8_ = uint(StageTeleportModel(_loc3_).stageTo);
               if(this._passRooms.indexOf(_loc8_) == -1)
               {
                  return _loc3_ as StageTeleportModel;
               }
               _loc2_.push(_loc3_);
            }
         }
         _loc4_ = _loc2_.length;
         if(_loc4_ == 0)
         {
            return null;
         }
         var _loc5_:int = -1;
         var _loc7_:int = 0;
         while(_loc7_ < _loc4_)
         {
            _loc9_ = _loc2_[_loc7_] as StageTeleportModel;
            _loc8_ = uint(_loc9_.stageTo);
            if(this._passRooms.indexOf(_loc8_) > _loc5_)
            {
               _loc6_ = _loc9_;
            }
            _loc7_++;
         }
         return _loc6_;
      }
      
      public function destroy() : void
      {
         this.removeEvent();
         this._passRooms = null;
      }
   }
}

