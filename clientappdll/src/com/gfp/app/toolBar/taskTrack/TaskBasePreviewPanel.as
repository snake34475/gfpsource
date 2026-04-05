package com.gfp.app.toolBar.taskTrack
{
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.uic.UIScrollBar;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class TaskBasePreviewPanel extends Sprite
   {
      
      protected var _mainUI:Sprite;
      
      protected var _container:Sprite;
      
      private var _scrollBar:UIScrollBar;
      
      private var _posY:Number = 0;
      
      private var _isExpanded:Boolean;
      
      protected var _list:Array;
      
      public function TaskBasePreviewPanel()
      {
         super();
         this._isExpanded = false;
         this.setMainUI();
      }
      
      protected function setMainUI() : void
      {
         this._mainUI = UIManager.getMovieClip("UI_TaskBasePreviewPanel");
         this._mainUI["back"].visible = false;
         addChild(this._mainUI);
         this._container = new Sprite();
         this._mainUI.addChild(this._container);
         this._container.mask = this._mainUI["mcMask"];
         this._list = new Array();
         this._scrollBar = new UIScrollBar(this._mainUI);
         this._scrollBar.pageSize = this._mainUI["mcMask"].height;
         this._scrollBar.wheelObject = this;
         this._scrollBar.addEventListener(MouseEvent.MOUSE_MOVE,this.onScrollMove);
      }
      
      private function onScrollMove(param1:MouseEvent) : void
      {
         this._container.y = -this._scrollBar.scrollPosition;
         this._posY = this._scrollBar.scrollPosition;
      }
      
      protected function clearContainer() : void
      {
         DisplayUtil.removeAllChild(this._container);
      }
      
      public function showScroll(param1:Boolean) : void
      {
         this._scrollBar.visible = param1;
      }
      
      protected function updateListShow() : void
      {
         var _loc4_:Sprite = null;
         var _loc1_:int = 0;
         var _loc2_:int = int(this._list.length);
         this.clearContainer();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._list[_loc3_] as Sprite;
            _loc4_.y = _loc1_;
            _loc4_.x = 2;
            _loc1_ = _loc4_.y + _loc4_.height;
            this._container.addChild(_loc4_);
            _loc3_++;
         }
         this._scrollBar.maxScrollPosition = this._container.height;
         if(this._container.y + this._container.height < this._scrollBar.pageSize)
         {
            this._scrollBar.scrollPosition = 0;
         }
         else
         {
            this._scrollBar.scrollPosition = Math.min(this._posY,this._container.height);
         }
      }
      
      protected function getDailyTasks() : Array
      {
         var _loc1_:Array = [];
         if(MainManager.actorInfo.lv >= 30)
         {
            _loc1_ = TasksXMLInfo.getAllDailyTask();
         }
         return _loc1_;
      }
      
      protected function removeEvent() : void
      {
         this._scrollBar.removeEventListener(MouseEvent.MOUSE_MOVE,this.onScrollMove);
      }
      
      public function get isExpanded() : Boolean
      {
         return this._isExpanded;
      }
      
      public function set isExpanded(param1:Boolean) : void
      {
         this._isExpanded = param1;
      }
      
      public function destroy() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         this.removeEvent();
         if(this._list)
         {
            _loc1_ = this._list.length;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               if(this._list[_loc2_])
               {
                  this._list[_loc2_].destroy();
                  this._list[_loc2_] = null;
               }
               _loc2_++;
            }
            this._list = null;
         }
         this._scrollBar.destroy();
         this._scrollBar = null;
         DisplayUtil.removeForParent(this._mainUI);
         this._mainUI = null;
      }
   }
}

