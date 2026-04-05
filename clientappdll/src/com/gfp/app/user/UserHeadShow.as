package com.gfp.app.user
{
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.info.item.SingleEquipInfo;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.utils.EquipPart;
   import flash.display.Sprite;
   import flash.geom.Point;
   import org.taomee.ds.HashMap;
   import org.taomee.utils.DisplayUtil;
   
   public class UserHeadShow extends Sprite
   {
      
      private static const OFFSET_ARR:Array = [new Point(-42,-57),new Point(-47,-67),new Point(-32,-52),new Point(-50,-52),new Point(-40,-32),new Point(-20,-52),new Point(40,114),new Point(0,114)];
      
      private static const TURN_BACK_OFFSET:Array = [new Point(-4,117),new Point(-7,119),new Point(-3,121),new Point(-5,141),new Point(6,143),new Point(-12,114),new Point(40,130),new Point(0,114)];
      
      public static const PART_ARR:Array = [1,3,4,6];
      
      public static const FASHION_PART:Array = [21,22,23,25];
      
      private var _userShow:UserEquipmentShow;
      
      private var _showMask:Sprite;
      
      public function UserHeadShow()
      {
         super();
         this._userShow = new UserEquipmentShow();
         addChild(this._userShow);
         this._showMask = UIManager.getSprite("UI_HeadMask");
         if(this._showMask)
         {
            addChild(this._showMask);
            this._userShow.mask = this._showMask;
         }
      }
      
      public function setInfo(param1:UserInfo) : void
      {
         var defType:uint;
         var equipHash:HashMap;
         var arr:Vector.<SingleEquipInfo>;
         var tempEquipInfo:SingleEquipInfo = null;
         var part:uint = 0;
         var userInfo:UserInfo = param1;
         this._userShow.setRole(userInfo);
         if(userInfo.isTurnBack)
         {
            this._userShow.x = Point(TURN_BACK_OFFSET[userInfo.roleType - 1]).x;
            this._userShow.y = Point(TURN_BACK_OFFSET[userInfo.roleType - 1]).y;
         }
         else
         {
            this._userShow.x = Point(OFFSET_ARR[userInfo.roleType - 1]).x;
            this._userShow.y = Point(OFFSET_ARR[userInfo.roleType - 1]).y;
         }
         defType = uint(userInfo.defEquipType);
         equipHash = EquipPart.getDefItems(userInfo.roleType,defType);
         arr = userInfo.fashionClothes;
         for each(tempEquipInfo in arr)
         {
            part = uint(ItemXMLInfo.getEquipPart(tempEquipInfo.itemID));
            equipHash.add(part,tempEquipInfo.itemID);
         }
         equipHash.forEach(function(param1:uint, param2:uint):void
         {
            if(FASHION_PART.indexOf(param1) != -1)
            {
               _userShow.addEquipment(param2);
            }
         });
      }
      
      public function destroy() : void
      {
         this._userShow.mask = null;
         DisplayUtil.removeForParent(this._userShow);
         this._userShow.destroy();
         this._userShow = null;
         DisplayUtil.removeForParent(this._showMask);
         this._showMask = null;
      }
      
      public function get userShow() : UserEquipmentShow
      {
         return this._userShow;
      }
   }
}

