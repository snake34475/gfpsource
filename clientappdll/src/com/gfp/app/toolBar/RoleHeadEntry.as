package com.gfp.app.toolBar
{
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.MoveEvent;
   import com.gfp.core.info.SummonInfo;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.ui.MonsterHeadIcon;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class RoleHeadEntry
   {
      
      private static var _instance:RoleHeadEntry;
      
      private var _mainUI:MovieClip;
      
      private var _headIcon:MonsterHeadIcon;
      
      private var _info:*;
      
      public function RoleHeadEntry()
      {
         super();
      }
      
      public static function get instance() : RoleHeadEntry
      {
         if(_instance == null)
         {
            _instance = new RoleHeadEntry();
         }
         return _instance;
      }
      
      public static function destroy() : void
      {
         if(_instance)
         {
            _instance.destroy();
            _instance = null;
         }
      }
      
      public static function hide() : void
      {
         if(_instance)
         {
            _instance.hide();
         }
      }
      
      private function addEvents() : void
      {
         this._mainUI.addEventListener(MouseEvent.CLICK,this.onUIClick);
         MainManager.actorModel.addEventListener(MoveEvent.MOVE_START,this.onMoveStart);
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
      }
      
      private function removeEvents() : void
      {
         this._mainUI.removeEventListener(MouseEvent.CLICK,this.onUIClick);
         MainManager.actorModel.removeEventListener(MoveEvent.MOVE_START,this.onMoveStart);
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
      }
      
      private function onUIClick(param1:Event) : void
      {
         var _loc2_:uint = 0;
         if(this._info is UserInfo)
         {
            _loc2_ = RoleItemMenu.TYPE_ROLE;
         }
         else if(this._info is SummonInfo)
         {
            _loc2_ = RoleItemMenu.TYPE_SUMMON;
         }
         RoleItemMenu.show(this._info,_loc2_,null,this._mainUI.x + 45,this._mainUI.y + 23);
      }
      
      private function onMoveStart(param1:MoveEvent) : void
      {
         this.hide();
      }
      
      private function onMapSwitchComplete(param1:MapEvent) : void
      {
         this.hide();
      }
      
      public function show(param1:*) : void
      {
         this._info = param1;
         RoleItemMenu.destory();
         if(this._mainUI == null)
         {
            this._mainUI = new Head_RoleInfo();
            this._mainUI.buttonMode = true;
            this._mainUI.cacheAsBitmap = true;
         }
         LayerManager.toolsLevel.addChild(this._mainUI);
         DisplayUtil.align(this._mainUI,null,AlignType.TOP_RIGHT,new Point(-550,8));
         this.setHeadInfo(param1);
         this.addEvents();
      }
      
      private function setHeadInfo(param1:*) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:String = "";
         if(param1 is UserInfo)
         {
            _loc2_ = uint(UserInfo(param1).roleType);
         }
         else if(param1 is SummonInfo)
         {
            _loc2_ = uint(SummonInfo(param1).roleID);
         }
         this._mainUI["nameTxt"].text = param1.nick;
         if(this._headIcon == null)
         {
            this._headIcon = new MonsterHeadIcon();
         }
         this._headIcon.destroy();
         this._headIcon.setRoleType(_loc2_,40);
         this._headIcon.x = 2;
         this._headIcon.y = 5;
         this._mainUI["iconHolder"].addChild(this._headIcon);
         this._headIcon.mask = this._mainUI["iconHolder"]["maskMC"];
      }
      
      public function hide() : void
      {
         this.removeEvents();
         if(this._mainUI)
         {
            DisplayUtil.removeForParent(this._mainUI,false);
         }
         if(this._headIcon)
         {
            this._headIcon.destroy();
         }
         DisplayUtil.removeForParent(this._headIcon);
         DisplayUtil.removeForParent(this._mainUI);
         RoleItemMenu.destory();
      }
      
      public function destroy() : void
      {
         this.hide();
         this._headIcon = null;
         this._mainUI = null;
      }
   }
}

