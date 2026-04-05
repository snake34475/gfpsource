package com.gfp.app.user
{
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.info.item.SingleEquipInfo;
   import com.gfp.core.utils.EquipPart;
   import flash.display.Sprite;
   import flash.geom.Point;
   import org.taomee.utils.DisplayUtil;
   
   public class UserShow extends Sprite
   {
      
      private static const OFFSET_ARR:Array = [new Point(-42,-57),new Point(-47,-67),new Point(-32,-52),new Point(-50,-52),new Point(-40,-32),new Point(-20,-52),new Point(-20,-52),new Point(-55,-74)];
      
      public static const PART_ARR:Array = [0,1,2,3,4,5,6,7,8];
      
      private var _userShow:UserEquipmentShow;
      
      public var userInfo:UserInfo;
      
      public function UserShow()
      {
         super();
         this._userShow = new UserEquipmentShow();
         addChild(this._userShow);
      }
      
      public function setInfo(param1:UserInfo) : void
      {
         var _loc4_:SingleEquipInfo = null;
         var _loc5_:uint = 0;
         var _loc6_:int = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         this.userInfo = param1;
         this._userShow.setRole(param1);
         this._userShow.x = Point(OFFSET_ARR[param1.roleType - 1]).x;
         this._userShow.y = Point(OFFSET_ARR[param1.roleType - 1]).y;
         var _loc2_:Vector.<SingleEquipInfo> = param1.fashionClothes;
         var _loc3_:Array = new Array();
         for each(_loc4_ in _loc2_)
         {
            _loc7_ = uint(ItemXMLInfo.getEquipPart(_loc4_.itemID));
            _loc3_.push(_loc7_);
            this._userShow.addEquipment(_loc4_.itemID);
         }
         _loc5_ = uint(param1.defEquipType);
         _loc6_ = int(EquipPart.FASHION_HEAD);
         while(_loc6_ <= EquipPart.FASHION_SHOES)
         {
            if(_loc6_ != EquipPart.FASHION_WING && _loc3_.indexOf(_loc6_) == -1)
            {
               _loc8_ = uint(EquipPart.getDefItemID(param1.roleType,_loc6_,_loc5_));
               this._userShow.addEquipment(_loc8_);
            }
            _loc6_++;
         }
      }
      
      public function destroy() : void
      {
         DisplayUtil.removeForParent(this._userShow);
         this._userShow.destroy();
         this._userShow = null;
      }
      
      public function get userShow() : UserEquipmentShow
      {
         return this._userShow;
      }
   }
}

