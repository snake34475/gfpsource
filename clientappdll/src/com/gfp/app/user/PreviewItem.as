package com.gfp.app.user
{
   import com.gfp.core.info.item.SingleEquipInfo;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.ui.ItemIcon;
   import com.gfp.core.ui.ItemInfoTip;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import org.taomee.utils.DisplayUtil;
   
   public class PreviewItem extends Sprite
   {
      
      private var _info:SingleEquipInfo = null;
      
      private var _icon:ItemIcon;
      
      private var _con:MovieClip;
      
      public function PreviewItem()
      {
         super();
         this._con = new UI_PreviewItem();
         this._con.gotoAndStop(1);
         this.addChild(this._con);
         this._icon = new ItemIcon(true);
         this._icon.x = 1;
         this._icon.y = 1;
      }
      
      public function setInfo(param1:SingleEquipInfo) : void
      {
         this._info = param1;
         this._icon.setID(param1.itemID);
         this._con.gotoAndStop(2);
         this._con.addChild(this._icon);
         var _loc2_:uint = uint(this._info.strengthenLV);
         this._icon.setStrengthenFull(_loc2_);
         this._icon.addEventListener(MouseEvent.MOUSE_OVER,this.itemOverHandler);
         this._icon.addEventListener(MouseEvent.MOUSE_OUT,this.itemOutHandler);
      }
      
      private function itemOverHandler(param1:MouseEvent) : void
      {
         this.overFilter = true;
         ItemInfoTip.setEquipIntervalTip(this.info,MainManager.actorInfo);
      }
      
      private function itemOutHandler(param1:MouseEvent) : void
      {
         this.overFilter = false;
         ItemInfoTip.hide();
      }
      
      public function clear() : void
      {
         ItemInfoTip.hide();
         DisplayUtil.removeForParent(this._icon);
         this._icon.clear();
         this._info = null;
         this._con.filters = [];
         this._con.gotoAndStop(1);
         this._icon.removeEventListener(MouseEvent.MOUSE_OVER,this.itemOverHandler);
         this._icon.removeEventListener(MouseEvent.MOUSE_OUT,this.itemOutHandler);
      }
      
      private function set overFilter(param1:Boolean) : void
      {
         if(param1)
         {
            this._con.filters = [new GlowFilter(16711680)];
         }
         else
         {
            this._con.filters = [];
         }
      }
      
      public function get info() : SingleEquipInfo
      {
         return this._info;
      }
      
      public function destroy() : void
      {
         this.clear();
         this._icon.destroy();
         this._con = null;
      }
   }
}

