package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.controller.ToolBarQuickKey;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.manager.TasksManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   import org.taomee.utils.DisplayUtil;
   
   public class TaskButton extends BaseActivitySprite
   {
      
      private var _mcMove:MovieClip;
      
      public function TaskButton(param1:ActivityNodeInfo)
      {
         super(param1);
         this._mcMove = _sprite["mcMove"];
         this._mcMove.stop();
         DisplayUtil.removeForParent(this._mcMove,false);
      }
      
      override public function addEvent() : void
      {
         super.addEvent();
         TasksManager.addListener(TaskEvent.ACCEPT,this.onTaskAccept);
         ToolBarQuickKey.addTip(_sprite as MovieClip,4);
         ToolBarQuickKey.registQuickKey(4,this.onQuickKey);
      }
      
      override public function removeEvent() : void
      {
         super.removeEvent();
         TasksManager.removeListener(TaskEvent.ACCEPT,this.onTaskAccept);
         ToolBarQuickKey.removeTip(_sprite as MovieClip);
         ToolBarQuickKey.unRegistQuickKey(4);
      }
      
      private function onQuickKey() : void
      {
         doAction();
      }
      
      private function onTaskAccept(param1:TaskEvent) : void
      {
         var _loc2_:int = int(param1.taskID);
         var _loc3_:Boolean = Boolean(TasksXMLInfo.getShowAcceptAnimation(_loc2_));
         if(_loc3_)
         {
            this.playMove();
         }
      }
      
      public function playMove() : void
      {
         this._mcMove.addEventListener(Event.ENTER_FRAME,this.onTimeCome);
         (_sprite as MovieClip).addChild(this._mcMove);
         this._mcMove.gotoAndPlay(1);
      }
      
      private function onTimeCome(param1:Number) : void
      {
         if(this._mcMove.currentFrame == this._mcMove.totalFrames)
         {
            this.stopMove();
         }
      }
      
      private function stopMove() : void
      {
         this._mcMove.removeEventListener(Event.ENTER_FRAME,this.onTimeCome);
         DisplayUtil.removeForParent(this._mcMove,false);
      }
   }
}

