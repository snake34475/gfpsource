package com.gfp.app.mapProcess
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.manager.EscortManager;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.RideManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.utils.WallowUtil;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.ui.Mouse;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_57 extends BaseMapProcess
   {
      
      public static const SEAL_POWER_TASK_ID:uint = 88;
      
      private var iceMc:InteractiveObject;
      
      private var TIME_MAYDAY:int = 36;
      
      private var tempMouse:MovieClip;
      
      private var _loading:MovieClip;
      
      public function MapProcess_57()
      {
         super();
      }
      
      private function hideMouse(param1:MouseEvent) : void
      {
         Mouse.hide();
         LayerManager.topLevel.addChild(this.tempMouse);
         this.iceMc.addEventListener(MouseEvent.MOUSE_MOVE,this.onMove);
      }
      
      private function onMove(param1:MouseEvent) : void
      {
         this.tempMouse.mouseChildren = false;
         this.tempMouse.mouseEnabled = false;
         this.tempMouse.x = LayerManager.topLevel.mouseX;
         this.tempMouse.y = LayerManager.topLevel.mouseY;
      }
      
      private function showMouse(param1:MouseEvent) : void
      {
         Mouse.show();
         LayerManager.topLevel.removeChild(this.tempMouse);
         this.iceMc.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMove);
      }
      
      private function getIce(param1:MouseEvent) : void
      {
         if(ActivityExchangeTimesManager.getTimes(9350) >= 5)
         {
            AlertManager.showSimpleAlarm("小侠士，今天运冰块次数已达上限，请明日再来！");
            return;
         }
         if(RideManager.isOnRide)
         {
            AlertManager.showSimpleAlarm("小侠士，在押镖途中无法乘坐坐骑哦。");
            return;
         }
         this.iceMc.removeEventListener(MouseEvent.ROLL_OVER,this.hideMouse);
         this.iceMc.removeEventListener(MouseEvent.ROLL_OUT,this.showMouse);
         this.iceMc.removeEventListener(MouseEvent.CLICK,this.getIce);
         this._loading = new ToolBar_MiniLoading();
         this._loading.x = this.iceMc.x;
         this._loading.y = this.iceMc.y - 300;
         MapManager.currentMap.upLevel.addChild(this._loading);
         this._loading.gotoAndPlay(1);
         this._loading.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         if(this._loading.currentFrame == this._loading.totalFrames)
         {
            this.iceMc.addEventListener(MouseEvent.CLICK,this.getIce);
            this._loading.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            DisplayUtil.removeForParent(this._loading);
            this._loading = null;
            MainManager.openOperate();
            if(MainManager.actorInfo.lv < 30)
            {
               AlertManager.showSimpleAlarm("此处神冰仙气太重，小侠士的实力似乎还不够撼动此仙家之物，修炼到30级再来试试吧！");
            }
            else if(!this.checkLimit())
            {
               this.iceMc.removeEventListener(MouseEvent.CLICK,this.getIce);
               EscortManager.instance.selectEscortType(0,4);
            }
         }
      }
      
      private function checkLimit() : Boolean
      {
         if(WallowUtil.isWallow())
         {
            WallowUtil.showWallowMsg(AppLanguageDefine.WALLOW_MSG_ARR[18]);
            return true;
         }
         if(EscortManager.instance.escortPathId > 0)
         {
            AlertManager.showSimpleAlarm("小侠士你当前正在押镖中");
            return true;
         }
         if(MainManager.actorInfo.changeClothID > 0)
         {
            AlertManager.showSimpleAlarm("小侠士你当前在变身状态下，不能押镖，请先取消变身状态");
            return true;
         }
         if(MainManager.actorInfo.wulinID > 0)
         {
            AlertManager.showSimpleAlarm("小侠士你当前已报名了武林盛典，无法押镖");
            return true;
         }
         return false;
      }
      
      override protected function init() : void
      {
         TasksManager.addListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
      }
      
      private function onTaskProComplete(param1:TaskEvent) : void
      {
         if(TasksManager.isTaskProComplete(SEAL_POWER_TASK_ID,2))
         {
            TasksManager.removeListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
            AnimatPlay.startAnimat("task88_",1,false);
         }
      }
      
      override public function destroy() : void
      {
         TasksManager.removeListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
         if(this._loading)
         {
            this._loading.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            DisplayUtil.removeForParent(this._loading);
            this._loading = null;
         }
         super.destroy();
      }
   }
}

