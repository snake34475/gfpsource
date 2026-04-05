package com.gfp.app.toolBar
{
   import com.gfp.core.CommandID;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.ActivitySuggestionXMLInfo;
   import com.gfp.core.controller.ToolBarQuickKey;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.manager.FunctionManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.ClientType;
   import com.gfp.core.utils.RoleDisplayUtil;
   import com.gfp.core.utils.StatisticsType;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class ActivitySuggestionEntry
   {
      
      private static var _instance:ActivitySuggestionEntry;
      
      private var _mainUI:InteractiveObject;
      
      private var _isPrepareEffect:Boolean = false;
      
      public function ActivitySuggestionEntry()
      {
         super();
      }
      
      public static function get instance() : ActivitySuggestionEntry
      {
         if(_instance == null)
         {
            _instance = new ActivitySuggestionEntry();
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
      
      public function show() : void
      {
         if(ActivitySuggestionXMLInfo.getActivityVecByLvl(0,MainManager.actorInfo.lv + 5).length > 0)
         {
            if(this.checkDate() && Boolean(RoleDisplayUtil.isRoleGraduate()))
            {
               this.showIcon();
            }
         }
      }
      
      private function checkDate() : Boolean
      {
         var _loc1_:int = int(MainManager.loginTimeInSecond);
         var _loc2_:Date = new Date();
         _loc2_.setTime(_loc1_ * 1000);
         var _loc3_:int = _loc2_.getMonth() + 1;
         var _loc4_:int = _loc2_.getDate();
         return true;
      }
      
      private function showIcon() : void
      {
         if(this._mainUI == null)
         {
            this._mainUI = UIManager.getSprite("ToolBar_activity");
         }
         ToolBarQuickKey.addTip(this._mainUI,5);
         ToolBarQuickKey.registQuickKey(5,this.onQuickKey);
         this._mainUI.addEventListener(MouseEvent.CLICK,this.onClick);
         LayerManager.toolsLevel.addChild(this._mainUI);
         DisplayUtil.align(this._mainUI,null,AlignType.TOP_RIGHT,new Point(-240,10));
         MapManager.addEventListener(MapEvent.USER_ENTER_TRADE_MAP,this.onEnterTradeMap);
         MapManager.addEventListener(MapEvent.USER_LEAVE_TRADE_MAP,this.onLeaveTradeMap);
      }
      
      private function onEnterTradeMap(param1:MapEvent) : void
      {
         this._mainUI.visible = false;
         ToolBarQuickKey.unRegistQuickKey(5);
      }
      
      private function onLeaveTradeMap(param1:MapEvent) : void
      {
         this._mainUI.visible = true;
         ToolBarQuickKey.registQuickKey(5,this.onQuickKey);
         if(ClientConfig.clientType == ClientType.KAIXIN)
         {
            this._mainUI.visible = false;
            ToolBarQuickKey.unRegistQuickKey(5);
         }
      }
      
      public function activityShowOrHide(param1:Boolean) : void
      {
         if(this._mainUI)
         {
            this._mainUI.visible = param1;
            if(ClientConfig.clientType == ClientType.KAIXIN)
            {
               this._mainUI.visible = false;
            }
            if(param1)
            {
               this.playEffect();
               ToolBarQuickKey.registQuickKey(5,this.onQuickKey);
            }
            else
            {
               ToolBarQuickKey.unRegistQuickKey(5);
            }
         }
      }
      
      public function destroy() : void
      {
         if(this._mainUI)
         {
            ToolBarQuickKey.removeTip(this._mainUI);
            ToolBarQuickKey.unRegistQuickKey(5);
            this._mainUI.removeEventListener(MouseEvent.CLICK,this.onClick);
            DisplayUtil.removeForParent(this._mainUI);
         }
      }
      
      private function onQuickKey() : void
      {
         this.onClick(new MouseEvent(MouseEvent.CLICK));
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(MapManager.currentMap.info.mapType == MapType.STAND)
         {
            if(FunctionManager.disabledActivityPanel)
            {
               FunctionManager.dispatchDisabledEvt();
            }
            else
            {
               ModuleManager.turnAppModule("WestLandActivityPanel","活动推荐...");
               SocketConnection.send(CommandID.STATISTICS,StatisticsType.CLICK_WINDMILL_NUM,1,1);
            }
         }
      }
      
      public function prepareEffect() : void
      {
         this._isPrepareEffect = true;
         this.playEffect();
      }
      
      private function playEffect() : void
      {
         var _loc1_:MovieClip = null;
         if(this._isPrepareEffect)
         {
            if(Boolean(this._mainUI) && this._mainUI.visible)
            {
               _loc1_ = this._mainUI["frame"] as MovieClip;
               if(_loc1_)
               {
                  _loc1_.addEventListener(Event.ENTER_FRAME,this.OnEffectOver);
                  _loc1_.gotoAndPlay(2);
               }
            }
         }
      }
      
      private function OnEffectOver(param1:Event) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         if(_loc2_.currentFrame == _loc2_.totalFrames)
         {
            _loc2_.removeEventListener(Event.ENTER_FRAME,this.OnEffectOver);
            this._isPrepareEffect = false;
         }
      }
   }
}

