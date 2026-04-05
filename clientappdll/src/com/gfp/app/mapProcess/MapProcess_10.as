package com.gfp.app.mapProcess
{
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_10 extends BaseMapProcess
   {
      
      private var _task27whereMC:MovieClip;
      
      private var _task27CloseBtn:SimpleButton;
      
      public function MapProcess_10()
      {
         super();
      }
      
      override protected function init() : void
      {
         TasksManager.addListener(TaskEvent.COMPLETE,this.onTaskProComplete);
         TasksManager.addListener(TaskEvent.ACCEPT,this.onTaskAccept);
      }
      
      private function onTaskProComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 26)
         {
            NpcDialogController.showForNpc(10017);
         }
      }
      
      private function onTaskAccept(param1:TaskEvent) : void
      {
         if(param1.taskID == 27)
         {
            this._task27whereMC = _mapModel.libManager.getMovieClip("task_27_where_mc");
            this._task27CloseBtn = this._task27whereMC["closeBtn"] as SimpleButton;
            this._task27CloseBtn.addEventListener(MouseEvent.CLICK,this.onTask27CloseBtn);
            LayerManager.topLevel.addChild(this._task27whereMC);
            DisplayUtil.align(this._task27whereMC,null,AlignType.MIDDLE_CENTER);
         }
      }
      
      private function onTask27CloseBtn(param1:MouseEvent) : void
      {
         this._task27CloseBtn.removeEventListener(MouseEvent.CLICK,this.onTask27CloseBtn);
         DisplayUtil.removeForParent(this._task27whereMC);
      }
      
      override public function destroy() : void
      {
         if(this._task27whereMC)
         {
            this._task27CloseBtn.removeEventListener(MouseEvent.CLICK,this.onTask27CloseBtn);
            this._task27CloseBtn = null;
            this._task27whereMC = null;
         }
         TasksManager.removeListener(TaskEvent.COMPLETE,this.onTaskProComplete);
         TasksManager.removeListener(TaskEvent.ACCEPT,this.onTaskAccept);
      }
   }
}

