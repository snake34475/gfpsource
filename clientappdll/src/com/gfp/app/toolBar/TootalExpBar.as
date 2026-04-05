package com.gfp.app.toolBar
{
   import com.gfp.app.toolBar.chat.MultiChatPanel;
   import com.gfp.core.config.AttributeConfig;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import flash.display.Sprite;
   import flash.text.TextField;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.DisplayUtil;
   
   public class TootalExpBar
   {
      
      private static var _instance:TootalExpBar;
      
      private var _mainUI:UI_SWF_TootalExpBae;
      
      private var _expBar:Sprite;
      
      private var _expTxt:TextField;
      
      public function TootalExpBar()
      {
         super();
         this._mainUI = new UI_SWF_TootalExpBae();
         this._mainUI.width = LayerManager.stageWidth;
         this._expBar = this._mainUI.expBar;
         this._expTxt = this._mainUI["expTxt"];
         this._expTxt.mouseEnabled = false;
         this._expTxt.mouseWheelEnabled = false;
         this.refreshExpBar();
         MainManager.actorModel.addEventListener(UserEvent.GROW_CHANGE,this.onInfoChange);
         StageResizeController.instance.register(this.onStageResize);
      }
      
      public static function get instance() : TootalExpBar
      {
         if(_instance == null)
         {
            _instance = new TootalExpBar();
         }
         return _instance;
      }
      
      public static function destroy() : void
      {
         if(_instance)
         {
            _instance = null;
         }
      }
      
      public static function show() : void
      {
         instance.show();
      }
      
      public static function hide() : void
      {
         instance.hide();
      }
      
      public static function refreshExpBar() : void
      {
         instance.refreshExpBar();
      }
      
      private function onStageResize() : void
      {
         this._mainUI.width = LayerManager.stageWidth;
         this.refreshExpBar();
         this._mainUI.y = LayerManager.stageHeight - 14;
      }
      
      private function onInfoChange(param1:UserEvent) : void
      {
         this.refreshExpBar();
      }
      
      public function refreshExpBar() : void
      {
         var _loc1_:UserInfo = MainManager.actorInfo;
         var _loc2_:Number = _loc1_.exp - AttributeConfig.calcTotalLvExp(_loc1_.roleType,_loc1_.lv,_loc1_.isTurnBack);
         var _loc3_:Number = Number(AttributeConfig.calcCurrentLvExp(_loc1_.roleType,_loc1_.lv + 1,_loc1_.isTurnBack));
         var _loc4_:Number = _loc2_ / _loc3_;
         _loc4_ = _loc4_ < 0 ? 0 : _loc4_;
         _loc4_ = _loc4_ > 1 ? 1 : _loc4_;
         this._expBar.scaleX = _loc4_;
         this._expTxt.text = (_loc4_ * 100).toFixed(2) + "%";
         ToolTipManager.add(this._mainUI,_loc2_.toString() + "/" + _loc3_.toString() + "升级还需要:" + (_loc3_ - _loc2_) + "点经验值",300);
      }
      
      public function show() : void
      {
         this._mainUI.y = LayerManager.stageHeight - 14;
         LayerManager.toolsLevel.addChildAt(this._mainUI,0);
         MultiChatPanel.instance.view.x = 0;
         MultiChatPanel.instance.view.y = 0;
         LayerManager.toolsLevel.addChild(MultiChatPanel.instance.view);
         MultiChatPanel.instance.noLayout = false;
      }
      
      public function hide() : void
      {
         DisplayUtil.removeForParent(this._mainUI);
      }
   }
}

