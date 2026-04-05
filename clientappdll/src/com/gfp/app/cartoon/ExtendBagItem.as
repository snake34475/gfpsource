package com.gfp.app.cartoon
{
   import com.gfp.core.cache.SwfCache;
   import com.gfp.core.cache.SwfInfo;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.info.item.SingleEquipInfo;
   import com.gfp.core.info.item.SingleItemInfo;
   import com.gfp.core.manager.IconQualityFrameManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.ui.ItemInfoTip;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import org.taomee.utils.DisplayUtil;
   
   public class ExtendBagItem extends Sprite
   {
      
      private var _itemID:uint;
      
      private var _url:String;
      
      private var _obj:Sprite;
      
      private var _bg:MovieClip;
      
      private var _label:MovieClip;
      
      private var _tfLabel:TextField;
      
      private var _isTips:Boolean;
      
      private var _isDrop:Boolean;
      
      private var equiptInfo:SingleEquipInfo;
      
      private var itemInfo:SingleItemInfo;
      
      public function ExtendBagItem(param1:int, param2:Boolean = true, param3:Boolean = true)
      {
         super();
         this._itemID = param1;
         this._isTips = param3;
         this._isDrop = param2;
         this.setID(this._itemID);
      }
      
      public function setID(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:TextFormat = null;
         if(param1 == 0)
         {
            return;
         }
         this._itemID = param1;
         if(ItemXMLInfo.getCatID(this.itemID) == ItemXMLInfo.SKILLBOOK_CAT)
         {
            this._url = ClientConfig.getItemTypeIcon(ItemXMLInfo.getSkillRole(this.itemID));
         }
         else
         {
            this._url = ClientConfig.getItemIcon(this.itemID);
         }
         SwfCache.getSwfInfo(this._url,this.onLoad);
         if(this._isDrop)
         {
            this._bg = UIManager.getMovieClip("ItemFloorBG");
            this._bg.x = -24;
            this._bg.y = -24;
            addChild(this._bg);
            this._label = UIManager.getMovieClip("DropItemLabel");
            this._tfLabel = this._label["_tfLabel"];
            _loc2_ = int(ItemXMLInfo.getQualityLevel(this._itemID));
            if(_loc2_ > 0 && _loc2_ < 8)
            {
               _loc3_ = ItemInfoTip.getFormats();
               _loc4_ = new TextFormat(null,12,TextFormat(_loc3_[_loc2_ - 1].format).color);
               this._tfLabel.defaultTextFormat = _loc4_;
               this._tfLabel.filters = _loc3_[_loc2_ - 1].filters;
            }
            this._tfLabel.text = ItemXMLInfo.getName(this._itemID);
            this._tfLabel.width = this._tfLabel.textWidth + 4;
            Sprite(this._label["_bgLabel"]).width = this._tfLabel.width + 5;
            this._label.x = -this._label.width / 2;
            this._label.y = -40;
            addChild(this._label);
         }
      }
      
      public function destroy() : void
      {
         this.removeEvent();
         if(this._obj)
         {
            IconQualityFrameManager.remove(this._obj);
         }
         if(this._url != "")
         {
            SwfCache.cancel(this._url,this.onLoad);
         }
         this.clearObj();
         this._bg = null;
         if(this._tfLabel)
         {
            this._tfLabel.filters = [];
         }
         this._tfLabel = null;
         this._label = null;
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseLeave);
      }
      
      private function clearObj() : void
      {
         if(this._obj)
         {
            this._obj.cacheAsBitmap = false;
            DisplayUtil.removeForParent(this._obj);
            this._obj = null;
         }
      }
      
      public function clear() : void
      {
         this.removeEvent();
         this._itemID = 0;
         if(this._obj)
         {
            this._obj.cacheAsBitmap = false;
            DisplayUtil.removeForParent(this._obj);
            this._obj = null;
         }
      }
      
      private function onLoad(param1:SwfInfo) : void
      {
         this.clearObj();
         this._obj = param1.content as Sprite;
         this._obj.x = -this._obj.width / 2;
         this._obj.y = -this._obj.height / 2;
         this._obj.cacheAsBitmap = true;
         addChildAt(this._obj,0);
         if(ItemXMLInfo.isEquipt(this._itemID))
         {
            IconQualityFrameManager.add(this._obj,this.itemID);
         }
         if(this._isTips)
         {
            addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
            addEventListener(MouseEvent.MOUSE_OUT,this.onMouseLeave);
         }
      }
      
      private function onMouseLeave(param1:MouseEvent) : void
      {
         ItemInfoTip.hide();
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         if(ItemXMLInfo.isEquipt(this.itemID))
         {
            if(this.equiptInfo == null)
            {
               this.equiptInfo = new SingleEquipInfo();
            }
            this.equiptInfo.itemID = this.itemID;
            ItemInfoTip.showEquip(this.equiptInfo);
         }
         else
         {
            if(this.itemInfo == null)
            {
               this.itemInfo = new SingleItemInfo();
            }
            this.itemInfo.itemID = this.itemID;
            ItemInfoTip.showItem(this.itemInfo);
         }
      }
      
      public function get itemID() : uint
      {
         return this._itemID;
      }
   }
}

