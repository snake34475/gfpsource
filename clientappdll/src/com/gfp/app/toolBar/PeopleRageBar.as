package com.gfp.app.toolBar
{
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.manager.UserInfoManager;
   import flash.display.Sprite;
   import flash.geom.Point;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class PeopleRageBar extends GFFitStageItem
   {
      
      private static var _instance:PeopleRageBar;
      
      private var _mainUI:Sprite;
      
      private var _bar:Sprite;
      
      private var _barWidth:Number;
      
      private var _fullFlag:Sprite;
      
      public function PeopleRageBar()
      {
         super();
         this._mainUI = new UI_PeopleRageBar();
         this._bar = this._mainUI["rageBar"];
         this._barWidth = this._bar.width;
         this._fullFlag = this._mainUI["rageFlag"];
      }
      
      public static function get instance() : PeopleRageBar
      {
         if(_instance == null)
         {
            _instance = new PeopleRageBar();
         }
         return _instance;
      }
      
      public static function show() : void
      {
         instance.show();
      }
      
      public static function hide() : void
      {
         if(_instance)
         {
            _instance.hide();
         }
      }
      
      public static function destroy() : void
      {
         if(_instance)
         {
            _instance.destroy();
         }
         _instance = null;
      }
      
      override public function show() : void
      {
         super.show();
         if(TasksManager.isCompleted(2062))
         {
            this.addEvent();
            LayerManager.toolsLevel.addChild(this._mainUI);
            this.layout();
            this.onRageChange();
         }
      }
      
      override protected function layout() : void
      {
         DisplayUtil.align(this._mainUI,null,AlignType.TOP_RIGHT,new Point(-100,40));
      }
      
      private function addEvent() : void
      {
         UserInfoManager.ed.addEventListener(UserEvent.FIGHT_RAGE_CHANGED,this.onRageChange);
      }
      
      private function removeEvent() : void
      {
         UserInfoManager.ed.removeEventListener(UserEvent.FIGHT_RAGE_CHANGED,this.onRageChange);
      }
      
      private function onRageChange(param1:UserEvent = null) : void
      {
         this.barWidth = MainManager.actorInfo.fightRage;
      }
      
      private function set barWidth(param1:uint) : void
      {
         if(param1 < 100)
         {
            this._bar.width = param1 / 100 * this._barWidth;
            this._fullFlag.visible = false;
         }
         else
         {
            this._bar.width = this._barWidth;
            this._fullFlag.visible = true;
         }
      }
      
      override public function hide() : void
      {
         super.hide();
         this.removeEvent();
         DisplayUtil.removeForParent(this._mainUI);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.hide();
         this._mainUI = null;
      }
   }
}

