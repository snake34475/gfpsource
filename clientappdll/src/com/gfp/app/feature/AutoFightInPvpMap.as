package com.gfp.app.feature
{
   import com.gfp.app.fight.PvpEntry;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   import com.gfp.core.model.PeopleModel;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.TimeUtil;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class AutoFightInPvpMap
   {
      
      public var isStart:Boolean;
      
      private var _timer:uint;
      
      private var _time:int = 180000;
      
      private var _pvpId:int;
      
      public function AutoFightInPvpMap(param1:int)
      {
         super();
         this._pvpId = param1;
      }
      
      public function start() : void
      {
         if(!this.isStart)
         {
            this.isStart = true;
            clearTimeout(this._timer);
            this._timer = setTimeout(this.callAutoFight,this.time);
         }
      }
      
      private function callAutoFight() : void
      {
         var _loc1_:UserInfo = null;
         var _loc3_:UserModel = null;
         var _loc4_:Date = null;
         var _loc5_:Date = null;
         clearTimeout(this._timer);
         var _loc2_:Array = UserManager.getModels();
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_ is PeopleModel)
            {
               _loc1_ = _loc3_.info;
               if(Boolean(_loc1_ && _loc1_.side != 0 && MainManager.actorInfo.side != 0) && Boolean(_loc1_.side != MainManager.actorInfo.side) && _loc1_.lv >= 65)
               {
                  break;
               }
            }
         }
         if(MapManager.currentMap.info.mapType == MapType.STAND && !MainManager.isCloseOprate)
         {
            if(_loc1_)
            {
               PvpEntry.instance.fightWithEnter(this._pvpId,_loc1_.userID,_loc1_.createTime);
               TextAlert.show("小侠士在此凶险之地遭到其他侠士的攻击！");
               this.isStart = false;
            }
            else
            {
               _loc4_ = new Date(2014,1,25);
               _loc5_ = TimeUtil.getSeverDateObject();
               if(_loc5_ > _loc4_)
               {
                  PvpEntry.instance.fightWithEnter(this._pvpId,0,0);
                  TextAlert.show("小侠士在此凶险之地遭到其他侠士的攻击！");
                  this.isStart = false;
               }
               else
               {
                  this._timer = setTimeout(this.callAutoFight,this.time);
               }
            }
         }
         else
         {
            this._timer = setTimeout(this.callAutoFight,this.time);
         }
      }
      
      public function stop() : void
      {
         if(this.isStart)
         {
            this.isStart = false;
            clearTimeout(this._timer);
         }
      }
      
      public function get time() : int
      {
         return this._time;
      }
      
      public function set time(param1:int) : void
      {
         this._time = param1;
      }
   }
}

