package com.gfp.app.user
{
   import com.gfp.core.cache.ClassPreviewCache;
   import com.gfp.core.cache.SwfCache;
   import com.gfp.core.cache.SwfInfo;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.config.xml.RoleXMLInfo;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.info.item.SingleEquipInfo;
   import com.gfp.core.player.PlayerType;
   import com.gfp.core.utils.EquipPart;
   import flash.display.Sprite;
   import flash.events.Event;
   import org.taomee.ds.HashMap;
   
   public class UserEquipmentShow extends Sprite
   {
      
      private static var MAX_LEVEL:uint = 10;
      
      private var _role:int;
      
      private var _userID:int;
      
      private var _nick:String;
      
      private var _defType:uint;
      
      private var _isTurnBack:Boolean;
      
      private var _info:UserInfo;
      
      private var _spBody:Sprite = new Sprite();
      
      private var _spContainer:Sprite = new Sprite();
      
      private var _defEquip:HashMap;
      
      public function UserEquipmentShow()
      {
         super();
         addChild(this._spBody);
         addChild(this._spContainer);
         this.initContainer();
      }
      
      private function onAddToStage(param1:Event) : void
      {
         if(Boolean(this._info.isTurnBack) || this._info.roleType >= 7)
         {
            this.x += this.width / 2 + 44;
            this.y += this.height + 180;
            this.scaleX = this.scaleY = 1.2;
         }
      }
      
      public function setRole(param1:UserInfo, param2:int = 0, param3:String = "", param4:uint = 0) : void
      {
         this._info = param1;
         this._role = param1.roleType;
         this._userID = param1.userID;
         this._nick = param1.nick;
         this._defType = param1.defEquipType;
         this._isTurnBack = param1.isTurnBack;
         this._defEquip = EquipPart.getDefFashionItems(this._role,this._defType);
         if(param1.equipPlayerType == PlayerType.DIVIDED_EQUIP_TYPE)
         {
            this.LoadBody();
         }
         else
         {
            this.addDefEquip();
         }
      }
      
      public function get userID() : int
      {
         return this._userID;
      }
      
      public function get nick() : String
      {
         return this._nick;
      }
      
      public function get isTurnBack() : Boolean
      {
         return this._isTurnBack;
      }
      
      public function addEquipment(param1:uint, param2:Boolean = false) : void
      {
         if(param1 == 0 || this._role == 0)
         {
            return;
         }
         var _loc3_:uint = uint(ItemXMLInfo.getEquipPart(param1));
         if(Boolean(EquipPart.isView(_loc3_)) || param2)
         {
            ClassPreviewCache.getDefinedData(this._role,param1,this.itemLoad);
         }
      }
      
      public function addEquips(param1:Array) : void
      {
         var clothes:Array = param1;
         if(this._role != 0)
         {
            clothes.forEach(function(param1:Object, param2:int, param3:Array):void
            {
               if(param1 is SingleEquipInfo)
               {
                  addEquipment(param1.itemID);
               }
            });
         }
      }
      
      public function removeEquipment(param1:uint) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:uint = 0;
         var _loc8_:Sprite = null;
         var _loc2_:uint = uint(ItemXMLInfo.getEquipPart(param1));
         if(!EquipPart.isView(_loc2_))
         {
            return;
         }
         if(Boolean(this._defEquip.containsKey(_loc2_)) && this._defEquip.getValue(_loc2_) != 0)
         {
            this.addEquipment(this._defEquip.getValue(_loc2_));
         }
         else
         {
            if(this._isTurnBack)
            {
               _loc5_ = RoleXMLInfo.getTurnBackViewLv(this._role);
               switch(_loc2_)
               {
                  case EquipPart.FASHION_WEAPON:
                     _loc7_ = 0;
                     break;
                  case EquipPart.FASHION_CLOTH:
                     _loc7_ = 1;
               }
               _loc6_ = String(_loc5_[_loc2_]).split("|");
            }
            else
            {
               _loc5_ = RoleXMLInfo.getFashionViewLv(this._role);
               _loc6_ = String(_loc5_[_loc2_ - 21]).split("|");
            }
            _loc3_ = int(_loc6_.length);
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               if(int(_loc6_[_loc4_]) >= 0)
               {
                  _loc8_ = this._spContainer.getChildAt(int(_loc6_[_loc4_])) as Sprite;
                  while(_loc8_.numChildren > 0)
                  {
                     _loc8_.removeChildAt(0);
                  }
               }
               _loc4_++;
            }
         }
      }
      
      public function clear(param1:Boolean = true) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         if(param1)
         {
            SwfCache.cancel(ClientConfig.getRolePrev(this._role),this.bodyLoad);
            while(Boolean(this._spBody) && this._spBody.numChildren > 0)
            {
               this._spBody.removeChildAt(0);
            }
         }
         if(this._spContainer)
         {
            _loc2_ = 0;
            while(_loc2_ < this._spContainer.numChildren)
            {
               _loc3_ = this._spContainer.getChildAt(_loc2_) as Sprite;
               while(_loc3_.numChildren > 0)
               {
                  _loc3_.removeChildAt(0);
               }
               _loc2_++;
            }
         }
      }
      
      public function destroy() : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddToStage);
         this.clear();
         removeChild(this._spBody);
         this._spBody = null;
         while(this._spContainer.numChildren > 0)
         {
            this._spContainer.removeChildAt(0);
         }
         removeChild(this._spContainer);
         this._spContainer = null;
      }
      
      private function initContainer() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < MAX_LEVEL)
         {
            this._spContainer.addChild(new Sprite());
            _loc1_++;
         }
      }
      
      private function LoadBody() : void
      {
         if(this._spBody.numChildren == 0)
         {
            SwfCache.getSwfInfo(ClientConfig.getRolePrev(this._role),this.bodyLoad);
         }
      }
      
      private function bodyLoad(param1:SwfInfo) : void
      {
         this._spBody.addChild(param1.content as Sprite);
         this.addDefEquip();
      }
      
      private function addDefEquip() : void
      {
         var _loc2_:uint = 0;
         var _loc1_:Array = this._defEquip.getValues();
         for each(_loc2_ in _loc1_)
         {
            this.addEquipment(_loc2_);
         }
      }
      
      private function itemLoad(param1:Array) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:Class = null;
         var _loc6_:Sprite = null;
         if(this._spContainer == null)
         {
            return;
         }
         var _loc2_:int = int(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = uint(param1[_loc3_].level);
            _loc5_ = param1[_loc3_].iclass;
            _loc6_ = this._spContainer.getChildAt(_loc4_) as Sprite;
            if(_loc6_ != null)
            {
               while(_loc6_.numChildren > 0)
               {
                  _loc6_.removeChildAt(0);
               }
               if(_loc5_)
               {
                  _loc6_.addChild(new _loc5_() as Sprite);
               }
            }
            _loc3_++;
         }
      }
   }
}

