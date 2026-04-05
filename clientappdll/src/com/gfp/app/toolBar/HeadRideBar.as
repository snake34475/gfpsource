package com.gfp.app.toolBar
{
   import com.gfp.core.manager.FunctionManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.RideManager;
   import com.gfp.core.ui.alert.TextAlert;
   import flash.display.DisplayObject;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.DisplayUtil;
   
   public class HeadRideBar extends Sprite
   {
      
      private static var _instance:HeadRideBar;
      
      private var _mainUI:Sprite;
      
      private var _rideBtn:SimpleButton;
      
      private var _onRide:Boolean;
      
      private var _btnArr:Array;
      
      public function HeadRideBar()
      {
         super();
         this._mainUI = new UI_SWF_RideBar();
         this._rideBtn = this._mainUI["rideBtn"];
         this._mainUI.x = 2;
         this._mainUI.y = 95;
         addChild(this._mainUI);
         this._btnArr = new Array();
         this._btnArr.push(this._rideBtn);
         this.updateLayout();
      }
      
      public static function get instance() : HeadRideBar
      {
         if(_instance == null)
         {
            _instance = new HeadRideBar();
         }
         return _instance;
      }
      
      public static function showRide() : void
      {
         instance.showRide();
      }
      
      public static function hideRide() : void
      {
         instance.hideRide();
      }
      
      public static function check() : void
      {
         instance.check();
      }
      
      private function addEvent() : void
      {
         this._rideBtn.addEventListener(MouseEvent.CLICK,this.onChangeRide);
      }
      
      private function removeEvent() : void
      {
         this._rideBtn.removeEventListener(MouseEvent.CLICK,this.onChangeRide);
      }
      
      private function onChangeRide(param1:Event) : void
      {
         if(FunctionManager.disabledRide)
         {
            FunctionManager.dispatchDisabledEvt();
            return;
         }
         if(MainManager.actorInfo.monsterID != 0)
         {
            TextAlert.show("小侠士，变身状态下无法切换坐骑");
            return;
         }
         var _loc2_:uint = RideManager.isOnRide ? 0 : uint(RideManager.callRideID);
         RideManager.changeRide(_loc2_);
      }
      
      public function updateTips() : void
      {
         ToolTipManager.add(this._rideBtn,RideManager.isOnRide ? "卸下坐骑" : "坐骑");
         this.updateLayout();
      }
      
      public function showRide() : void
      {
         addChild(this._mainUI);
         this.addEvent();
         this.updateTips();
      }
      
      public function hideRide() : void
      {
         this.removeEvent();
         DisplayUtil.removeForParent(this._mainUI,false);
      }
      
      public function check() : void
      {
         this.showRide();
      }
      
      private function updateLayout() : void
      {
         var _loc4_:DisplayObject = null;
         var _loc1_:int = int(this._btnArr.length);
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            _loc4_ = this._btnArr[_loc3_] as DisplayObject;
            if(Boolean(_loc4_.parent) && Boolean(this._mainUI.parent))
            {
               _loc4_.x = _loc2_ * _loc4_.width;
               _loc2_++;
            }
            _loc3_++;
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function getLength() : uint
      {
         var _loc3_:DisplayObject = null;
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this._btnArr.length)
         {
            _loc3_ = this._btnArr[_loc2_] as DisplayObject;
            if(Boolean(_loc3_.parent) && Boolean(this._mainUI.parent))
            {
               _loc1_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
   }
}

