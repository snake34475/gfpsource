package com.gfp.app.miniMap
{
   import com.gfp.core.manager.UIManager;
   import flash.display.Sprite;
   import org.taomee.ds.HashSet;
   import org.taomee.utils.DisplayUtil;
   
   public class BlockIcon extends Sprite
   {
      
      private var _iconName:String;
      
      private var _mapID:int;
      
      private var _isBoss:Boolean = false;
      
      private var _pathIcon:Sprite;
      
      private var _questIcon:Sprite;
      
      private var _currentIcon:Sprite;
      
      private var _teammateIcon:Sprite;
      
      private var _parentBlock:BlockIcon;
      
      private var _state:int;
      
      private var _isHistory:Boolean = false;
      
      private var _childrens:HashSet = new HashSet();
      
      public function BlockIcon(param1:int, param2:String, param3:Boolean, param4:BlockIcon)
      {
         super();
         this._mapID = param1;
         this._iconName = param2;
         this._isBoss = param3;
         this._parentBlock = param4;
         visible = false;
      }
      
      public function get isHistory() : Boolean
      {
         return this._isHistory;
      }
      
      public function destroy() : void
      {
         this._childrens = null;
         this._pathIcon = null;
         this._questIcon = null;
         this._currentIcon = null;
         this._teammateIcon = null;
      }
      
      public function reset() : void
      {
         this._isHistory = false;
         this.showPath();
      }
      
      public function addChildren(param1:BlockIcon) : void
      {
         this._childrens.add(param1);
      }
      
      public function showChildren() : void
      {
         this._childrens.forEach(function(param1:BlockIcon):void
         {
            param1.showPath();
         });
      }
      
      public function showPath() : void
      {
         if(this._isHistory)
         {
            this.displayPathIcon();
            visible = true;
         }
         else if(Boolean(this._parentBlock) && this._parentBlock.isHistory)
         {
            this.displayQuestIcon();
            visible = true;
         }
      }
      
      public function showIn() : void
      {
         this._isHistory = true;
         this.displayCurrentIcon();
         visible = true;
      }
      
      public function showTeammateIn() : void
      {
         this._isHistory = true;
         this.displayTeammateCurrentIcon();
         visible = true;
      }
      
      private function displayQuestIcon() : void
      {
         if(this._questIcon == null)
         {
            this._questIcon = UIManager.getSprite("MiniMap_quest_icon");
         }
         DisplayUtil.removeAllChild(this);
         addChild(this._questIcon);
         BlockContainer.mapBlockArray.push(this._questIcon);
      }
      
      private function displayPathIcon() : void
      {
         if(this._pathIcon == null)
         {
            this._pathIcon = UIManager.getSprite(this._iconName);
         }
         DisplayUtil.removeAllChild(this);
         if(this._pathIcon)
         {
            addChild(this._pathIcon);
         }
      }
      
      private function displayCurrentIcon() : void
      {
         if(this._currentIcon == null)
         {
            this._currentIcon = UIManager.getSprite("MiniMap_current_map");
         }
         this.displayPathIcon();
         addChild(this._currentIcon);
      }
      
      private function displayTeammateCurrentIcon() : void
      {
         if(this._teammateIcon == null)
         {
            this._teammateIcon = UIManager.getSprite("MiniMap_Teammate_map");
         }
         this.displayPathIcon();
         addChild(this._teammateIcon);
      }
      
      public function get mapID() : int
      {
         return this._mapID;
      }
   }
}

