package com.gfp.app.mapProcess
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.cartoon.event.AnimatEvent;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.ui.alert.TextAlert;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class MapProcess_24 extends MapProcessAnimat
   {
      
      public static const KING_TASK_ID:uint = 1801;
      
      public static const TOLLGATE_ID:uint = 805;
      
      private var _point:Point;
      
      private var _moveing:Boolean = false;
      
      private var _colorfullcloud:MovieClip;
      
      private var _colorCloudClickCount:uint = 0;
      
      public function MapProcess_24()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._colorfullcloud = _mapModel.contentLevel["colorfullcloud"];
         if(TasksManager.isProcess(1333,0))
         {
            this._colorfullcloud.buttonMode = true;
            this._point = new Point(this._colorfullcloud.x,this._colorfullcloud.y);
            this._colorfullcloud.addEventListener(MouseEvent.CLICK,this.onColorCloudClick);
         }
         else
         {
            this._colorfullcloud.visible = false;
         }
         TasksManager.addListener(TaskEvent.ACCEPT,this.onAcceptTask);
         TasksManager.addListener(TaskEvent.COMPLETE,this.onTaskComplete);
         AnimatPlay.addAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimatEnd);
      }
      
      private function onColorCloudClick(param1:MouseEvent) : void
      {
         var abs:int = 0;
         var e:MouseEvent = param1;
         if(!this._moveing)
         {
            ++this._colorCloudClickCount;
            this._moveing = true;
            abs = this._colorCloudClickCount % 2 != 0 ? -1 : 1;
            TweenLite.to(this._colorfullcloud,0.5,{
               "x":this._point.x + 20 * abs,
               "y":this._point.y + 10 * abs,
               "onComplete":function():void
               {
                  _moveing = false;
               }
            });
            if(this._colorCloudClickCount == 5)
            {
               this._moveing = false;
               this._colorCloudClickCount = 0;
               TextAlert.show("小侠士，任务完成去武圣爷爷那里交付吧！");
               this._colorfullcloud.visible = false;
               TasksManager.dispatchActionEvent(TaskActionEvent.TASK_MAPCOLLECT,"catchColorfullcloud");
            }
            else
            {
               TextAlert.show("再点击 " + (5 - this._colorCloudClickCount) + " 次就成功了！");
            }
         }
      }
      
      private function onAcceptTask(param1:TaskEvent) : void
      {
         if(param1.taskID == KING_TASK_ID)
         {
            AnimatPlay.startAnimat("task1801_1_",MainManager.roleType,false);
         }
      }
      
      private function onAnimatEnd(param1:AnimatEvent) : void
      {
         var _loc2_:String = param1.data as String;
         switch(_loc2_)
         {
            case "task1801_1_1":
            case "task1801_1_2":
            case "task1801_1_3":
            case "task1801_1_4":
               AnimatPlay.startAnimat("task1801_",2,false);
               break;
            case "task1801_2":
               PveEntry.enterTollgate(TOLLGATE_ID);
               break;
            case "task1801_3_1":
            case "task1801_3_2":
            case "task1801_3_3":
            case "task1801_3_4":
               AnimatPlay.startAnimat("task1801_",4,false);
               break;
            case "task1801_4":
               AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimatEnd);
         }
      }
      
      private function onTaskComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == KING_TASK_ID)
         {
            AnimatPlay.startAnimat("task1801_3_",MainManager.roleType,false);
         }
      }
      
      override public function destroy() : void
      {
         if(this._colorfullcloud)
         {
            this._colorfullcloud.removeEventListener(MouseEvent.CLICK,this.onColorCloudClick);
         }
         this._colorfullcloud = null;
         TasksManager.removeListener(TaskEvent.ACCEPT,this.onAcceptTask);
         TasksManager.removeListener(TaskEvent.COMPLETE,this.onTaskComplete);
         AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimatEnd);
      }
   }
}

