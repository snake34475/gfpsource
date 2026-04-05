package com.gfp.app.toolBar
{
   import com.gfp.core.controller.ToolBarQuickKey;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.UIManager;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class WuLinFightEntry
   {
      
      private static var _instance:WuLinFightEntry;
      
      private var _mainUI:SimpleButton;
      
      private var _up:MovieClip;
      
      private var _low:MovieClip;
      
      private var _unreadCount:int;
      
      public function WuLinFightEntry()
      {
         super();
         this._mainUI = UIManager.getButton("ToolBar_WuLinFight");
      }
      
      public static function get instance() : WuLinFightEntry
      {
         if(_instance == null)
         {
            _instance = new WuLinFightEntry();
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
      
      public function destroy() : void
      {
         this.hide();
         this._mainUI = null;
      }
      
      public function show() : void
      {
         if(MainManager.actorInfo.wulinID != 0)
         {
            if(this._mainUI)
            {
               ToolBarQuickKey.addTip(this._mainUI,17);
               this._mainUI.addEventListener(MouseEvent.CLICK,this.onShowWuLin);
               LayerManager.toolsLevel.addChild(this._mainUI);
               DisplayUtil.align(this._mainUI,null,AlignType.TOP_RIGHT,new Point(-245,75));
            }
         }
      }
      
      public function hide() : void
      {
         if(this._mainUI)
         {
            ToolBarQuickKey.removeTip(this._mainUI);
            DisplayUtil.removeForParent(this._mainUI,false);
         }
      }
      
      private function onShowWuLin(param1:MouseEvent) : void
      {
         if(MainManager.actorInfo.lv < 11)
         {
            AlertManager.showSimpleAlarm("对不起，小侠士，参加武林盛典需要达到至少11级。");
            return;
         }
         if(MainManager.actorInfo.wulinID == 0)
         {
            AlertManager.showSimpleAlarm("对不起，小侠士，你还没有报名参加武林盛典，无法看到对阵。你可以去比武会场的大会主持人处报名。");
            return;
         }
         ModuleManager.turnAppModule("WuLinFightMemberPanel","");
      }
   }
}

