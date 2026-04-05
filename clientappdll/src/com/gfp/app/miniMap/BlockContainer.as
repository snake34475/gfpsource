package com.gfp.app.miniMap
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.utils.Direction;
   import com.gfp.core.utils.StringConstants;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import org.taomee.ds.HashMap;
   import org.taomee.utils.DisplayUtil;
   
   public class BlockContainer extends Sprite
   {
      
      public static const k1_left:String = "MiniMap_k_1_left";
      
      public static const k1_right:String = "MiniMap_k_1_right";
      
      public static const k1_up:String = "MiniMap_k_1_up";
      
      public static const k1_down:String = "MiniMap_k_1_down";
      
      public static const k2_left_right:String = "MiniMap_k_2_left_right";
      
      public static const k2_up_down:String = "MiniMap_k_2_up_down";
      
      public static const k2_left_up:String = "MiniMap_k_2_left_up";
      
      public static const k2_left_down:String = "MiniMap_k_2_left_down";
      
      public static const k2_right_up:String = "MiniMap_k_2_right_up";
      
      public static const k2_right_down:String = "MiniMap_k_2_right_down";
      
      public static const k3_left_right_up:String = "MiniMap_k_3_left_right_up";
      
      public static const k3_left_right_down:String = "MiniMap_k_3_left_right_down";
      
      public static const k3_up_down_left:String = "MiniMap_k_3_up_down_left";
      
      public static const k3_up_down_right:String = "MiniMap_k_3_up_down_right";
      
      public static const k4_cross:String = "MiniMap_k_4_cross";
      
      private static const iconSize:int = 20;
      
      private static const B_W:int = 80;
      
      private static const B_H:int = 80;
      
      public static var mapBlockArray:Array = [];
      
      private var _xmlMap:HashMap;
      
      private var _beginMapID:uint;
      
      private var _blockMap:HashMap;
      
      private var _currentBlock:BlockIcon;
      
      private var _teammateBlock:BlockIcon;
      
      private var _centerPos:Point = new Point();
      
      private var _container:Sprite;
      
      public function BlockContainer()
      {
         super();
         scrollRect = new Rectangle(0,0,B_W,B_H);
         this._container = new Sprite();
         addChild(this._container);
         this._centerPos.x = B_W / 2 - iconSize / 2;
         this._centerPos.y = B_H / 2 - iconSize / 2;
         this._container.x = this._centerPos.x;
         this._container.y = this._centerPos.y;
      }
      
      public function destroy() : void
      {
         if(this._blockMap)
         {
            this._blockMap.eachValue(function(param1:BlockIcon):void
            {
               param1.destroy();
            });
         }
         this._blockMap = null;
         this._xmlMap = null;
         this._currentBlock = null;
         this._teammateBlock = null;
         this._centerPos = null;
         this._container = null;
      }
      
      public function init(param1:XML) : void
      {
         var _loc3_:XML = null;
         this._beginMapID = uint(param1.@begin);
         this._xmlMap = new HashMap();
         this._blockMap = new HashMap();
         var _loc2_:XMLList = param1.elements("Map");
         for each(_loc3_ in _loc2_)
         {
            this._xmlMap.add(uint(_loc3_.@ID),_loc3_);
         }
         DisplayUtil.removeAllChild(this._container);
         this.initMiniICon(this._beginMapID);
         this.changeMap(this._beginMapID);
         if(FightManager.isTeamFight)
         {
            this.teammateChangeMap(this._beginMapID);
         }
      }
      
      private function initMiniICon(param1:int, param2:String = null, param3:BlockIcon = null, param4:int = 0) : void
      {
         var _loc10_:XML = null;
         if(this._blockMap.containsKey(param1))
         {
            if(param3 != null)
            {
               param3.addChildren(this._blockMap.getValue(param1));
            }
            return;
         }
         var _loc5_:XML = this._xmlMap.getValue(param1);
         if(_loc5_ == null)
         {
            return;
         }
         var _loc6_:XMLList = _loc5_.elements("ToMaps");
         _loc6_ = _loc6_.elements("Map");
         var _loc7_:String = this.getIconName(_loc6_);
         var _loc8_:Boolean = _loc5_.@boss == "true" ? true : false;
         var _loc9_:BlockIcon = new BlockIcon(param1,_loc7_,_loc8_,param3);
         this._blockMap.add(param1,_loc9_);
         if(param3)
         {
            param3.addChildren(_loc9_);
         }
         if(param2 == null || param2 == "")
         {
            _loc9_.x = 0;
            _loc9_.y = 0;
         }
         else if(param2 == Direction.RIGHT)
         {
            _loc9_.x = param3.x + iconSize;
            _loc9_.y = param3.y;
         }
         else if(param2 == Direction.LEFT)
         {
            _loc9_.x = param3.x - iconSize;
            _loc9_.y = param3.y;
         }
         else if(param2 == Direction.UP)
         {
            _loc9_.y = param3.y - iconSize;
            _loc9_.x = param3.x;
         }
         else if(param2 == Direction.DOWN)
         {
            _loc9_.y = param3.y + iconSize;
            _loc9_.x = param3.x;
         }
         this._container.addChild(_loc9_);
         _loc9_.showPath();
         for each(_loc10_ in _loc6_)
         {
            this.initMiniICon(uint(_loc10_.@ID),String(_loc10_.@dir),_loc9_,_loc10_.parent().parent().@ID);
         }
      }
      
      private function ontet(param1:MouseEvent) : void
      {
         this.changeMap(BlockIcon(param1.currentTarget).mapID);
      }
      
      public function getIconName(param1:XMLList) : String
      {
         var _loc2_:int = param1.length();
         if(_loc2_ == 4)
         {
            return k4_cross;
         }
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_.push(String(param1[_loc4_].@dir));
            _loc4_++;
         }
         _loc3_.sort();
         return "MiniMap_k_" + _loc2_ + StringConstants.SIGN + _loc3_.join(StringConstants.SIGN);
      }
      
      public function changeMap(param1:uint) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < BlockContainer.mapBlockArray.length)
         {
            if(BlockContainer.mapBlockArray[_loc2_].numChildren > 1)
            {
               BlockContainer.mapBlockArray[_loc2_].removeChildAt(1);
            }
            _loc2_++;
         }
         BlockContainer.mapBlockArray = [];
         if(this._currentBlock)
         {
            this._currentBlock.showPath();
         }
         var _loc3_:BlockIcon = this._blockMap.getValue(param1);
         if(_loc3_)
         {
            _loc3_.showIn();
            _loc3_.showChildren();
            this._currentBlock = _loc3_;
            this._container.x = this._centerPos.x - this._currentBlock.x;
            this._container.y = this._centerPos.y - this._currentBlock.y;
         }
         if(this._teammateBlock)
         {
            this.teammateChangeMap(this._teammateBlock.mapID);
         }
      }
      
      public function teammateChangeMap(param1:uint) : void
      {
         var _loc2_:BlockIcon = null;
         if(Boolean(this._teammateBlock) && this._teammateBlock.mapID != this._currentBlock.mapID)
         {
            this._teammateBlock.showPath();
         }
         if(param1 != 0)
         {
            _loc2_ = this._blockMap.getValue(param1);
            if(_loc2_)
            {
               this._teammateBlock = _loc2_;
               if(this._teammateBlock != this._currentBlock)
               {
                  this._teammateBlock.showTeammateIn();
               }
            }
         }
         else
         {
            this._teammateBlock = null;
         }
      }
      
      public function reset() : void
      {
         if(this._blockMap)
         {
            this._blockMap.eachValue(function(param1:BlockIcon):void
            {
               param1.reset();
            });
            this.changeMap(this._beginMapID);
            if(this._teammateBlock)
            {
               this.teammateChangeMap(this._beginMapID);
            }
         }
      }
   }
}

