package com.gfp.app.cmdl
{
   import com.gfp.core.CommandID;
   import com.gfp.core.events.UserItemEvent;
   import com.gfp.core.info.ItemFallInfo;
   import com.gfp.core.info.ItemFallListInfo;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.ItemDropModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.Logger;
   import flash.geom.Point;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.GeomUtil;
   
   public class ItemFallCmdListener extends BaseBean
   {
      
      public static const ITEMS_DISTANCE:uint = 50;
      
      public static const OFFSET_DISTANCE:uint = 50;
      
      public function ItemFallCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.MONSTER_DROP,this.onMonsterFall);
         MapManager.addEventListener(UserItemEvent.ITEM_DROP_COMPLETE,this.onItemDropComplete);
         finish();
      }
      
      private function onMonsterFall(param1:SocketEvent) : void
      {
         var _loc7_:ItemFallInfo = null;
         var _loc8_:String = null;
         var _loc9_:ItemDropModel = null;
         var _loc10_:Point = null;
         var _loc2_:Point = new Point();
         var _loc3_:Point = new Point();
         var _loc4_:ItemFallListInfo = param1.data as ItemFallListInfo;
         var _loc5_:int = int(_loc4_.list.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = _loc4_.list[_loc6_] as ItemFallInfo;
            _loc3_.x = _loc7_.posX;
            _loc3_.y = _loc7_.posY;
            if(_loc6_ > 0)
            {
               if(Point.distance(_loc3_,_loc2_) < ITEMS_DISTANCE)
               {
                  if(!MapManager.currentMap.isBlockXY(_loc2_.x + ITEMS_DISTANCE,_loc2_.y))
                  {
                     _loc7_.posX = _loc2_.x + ITEMS_DISTANCE;
                  }
                  else if(!MapManager.currentMap.isBlockXY(_loc2_.x,_loc2_.y - ITEMS_DISTANCE))
                  {
                     _loc7_.posY = _loc2_.y - ITEMS_DISTANCE;
                  }
               }
            }
            else
            {
               _loc10_ = GeomUtil.getCirclePoint(_loc3_,int(Math.random() * 360),OFFSET_DISTANCE);
               if(!MapManager.currentMap.isBlock(_loc10_))
               {
                  _loc7_.posX = _loc10_.x;
                  _loc7_.posY = _loc10_.y;
               }
            }
            _loc8_ = Logger.createLogMsgByArr("物品掉落：",_loc7_.onlyID,_loc7_.itemID,_loc7_.posX,_loc7_.posY);
            Logger.info(this,_loc8_);
            _loc9_ = new ItemDropModel(_loc7_);
            MapManager.currentMap.addItem(_loc9_,_loc3_);
            _loc2_.x = _loc7_.posX;
            _loc2_.y = _loc7_.posY;
            _loc6_++;
         }
      }
      
      private function onItemDropComplete(param1:UserItemEvent) : void
      {
         var _loc2_:ItemFallInfo = null;
         if(MainManager.actorInfo.carrierID != 0)
         {
            _loc2_ = param1.param as ItemFallInfo;
            if(Boolean(_loc2_.onlyID) && Boolean(ItemManager.getItemCount(_loc2_.itemID) < 999) && ItemManager.getItemAvailableCapacity() > 0)
            {
               SocketConnection.send(CommandID.ITEM_PICKUP,_loc2_.onlyID,0);
            }
         }
      }
   }
}

