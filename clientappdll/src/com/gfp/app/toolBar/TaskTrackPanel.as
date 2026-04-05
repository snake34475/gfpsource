package com.gfp.app.toolBar
{
   import com.gfp.app.toolBar.taskTrack.ActivityTrackPanel;
   import com.gfp.app.toolBar.taskTrack.TaskAcceptedPanel;
   import com.gfp.app.toolBar.taskTrack.TaskBasePreviewPanel;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.manager.UserInfoManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.utils.FilterUtil;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.DisplayUtil;
   
   public class TaskTrackPanel
   {
      
      private static var _instance:TaskTrackPanel;
      
      private var _mainUI:Sprite;
      
      private var _minUI:Sprite;
      
      private var _minExpandBtn:MovieClip;
      
      private var _minTitle:MovieClip;
      
      private var _expandBtn:MovieClip;
      
      private var _detailBtn:MovieClip;
      
      private var _container:Sprite;
      
      private var _taskPanel:TaskBasePreviewPanel;
      
      private var _bg:Sprite;
      
      private var _currentPage:int = -1;
      
      private var _pageBtns:Vector.<MovieClip>;
      
      private var _acceptedPanel:TaskAcceptedPanel;
      
      private var _activityPanel:ActivityTrackPanel;
      
      private var _title:MovieClip;
      
      private var _isMin:Boolean;
      
      private var MAIN_UI_HEIGHT:int = 250;
      
      public function TaskTrackPanel()
      {
         super();
         this._mainUI = UIManager.getMovieClip("UI_TaskTrackPanel");
         this._mainUI.x = LayerManager.stageWidth - this._mainUI.width;
         this._mainUI.y = 140;
         this._title = this._mainUI["title"];
         this._title.buttonMode = true;
         this._title.useHandCursor = true;
         ToolTipManager.add(this._title,"按住鼠标可拖动");
         this._expandBtn = this._mainUI["expandBtn"];
         this._expandBtn.gotoAndStop(1);
         ToolTipManager.remove(this._expandBtn);
         ToolTipManager.add(this._expandBtn,"收起下拉框");
         this._detailBtn = this._mainUI["detailBtn"];
         this._detailBtn.buttonMode = true;
         this._pageBtns = new Vector.<MovieClip>();
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            this._pageBtns.push(this._mainUI["page_" + _loc1_]);
            this._pageBtns[_loc1_].buttonMode = true;
            _loc1_++;
         }
         this._pageBtns[1].visible = false;
         this.resetBtnState();
         this._container = new Sprite();
         this._container.x = 15;
         this._container.y = 35;
         this._mainUI.addChild(this._container);
         this._bg = this._mainUI["mcMask"];
         this._bg.alpha = 0;
         TasksManager.addListener(TaskEvent.COMPLETE,this.onTaskComplete);
      }
      
      public static function get instance() : TaskTrackPanel
      {
         if(_instance == null)
         {
            _instance = new TaskTrackPanel();
         }
         return _instance;
      }
      
      public static function destroy() : void
      {
         if(_instance)
         {
            _instance.destroy();
         }
         _instance = null;
      }
      
      public function getTaskArea(param1:int) : Rectangle
      {
         if(!this._isMin)
         {
            return this._acceptedPanel.getTaskArea(param1);
         }
         return null;
      }
      
      private function showMiniPanel() : void
      {
         if(this._minUI == null)
         {
            this._minUI = UIManager.getMovieClip("UI_TaskTrackMinPanel");
            this._minExpandBtn = this._minUI["expandBtn"];
            this._minExpandBtn.gotoAndStop(2);
            this._minTitle = this._minUI["title"];
            ToolTipManager.add(this._minExpandBtn,"打开下拉框");
         }
         this._minUI.x = this._mainUI.x;
         this._minUI.y = this._mainUI.y;
         this._minExpandBtn.addEventListener(MouseEvent.CLICK,this.onMinExpandClick);
         this._minTitle.addEventListener(MouseEvent.MOUSE_DOWN,this.onTitleDown);
         LayerManager.stage.addEventListener(MouseEvent.MOUSE_UP,this.onTitleUp);
         LayerManager.toolsLevel.addChild(this._minUI);
      }
      
      private function hideMiniPanel() : void
      {
         if(this._minUI)
         {
            if(this._minUI.parent)
            {
               this._minUI.parent.removeChild(this._minUI);
            }
            this._mainUI.x = this._minUI.x;
            this._mainUI.y = this._minUI.y;
            this._minExpandBtn.removeEventListener(MouseEvent.CLICK,this.onMinExpandClick);
            this._minTitle.removeEventListener(MouseEvent.MOUSE_DOWN,this.onTitleDown);
            LayerManager.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onTitleUp);
         }
      }
      
      private function onMinExpandClick(param1:MouseEvent) : void
      {
         this.onExpandClick();
         if(this._mainUI.x < 0 && this._mainUI.y + this.MAIN_UI_HEIGHT > LayerManager.stageHeight)
         {
            TweenLite.to(this._mainUI,0.2,{
               "x":0,
               "y":LayerManager.stageHeight - this.MAIN_UI_HEIGHT
            });
         }
         else if(this._mainUI.x < 0)
         {
            TweenLite.to(this._mainUI,0.2,{"x":0});
         }
         else if(this._mainUI.y + this.MAIN_UI_HEIGHT > LayerManager.stageHeight)
         {
            TweenLite.to(this._mainUI,0.2,{"y":LayerManager.stageHeight - this.MAIN_UI_HEIGHT});
         }
      }
      
      public function setup() : void
      {
         this.showForPage(0);
         if(this._taskPanel is TaskAcceptedPanel && (this._taskPanel as TaskAcceptedPanel).getTraceTasks().length != 0)
         {
            this.showForPage(0);
         }
         else
         {
            this.showForPage(2);
         }
         this.showAndExpand();
      }
      
      private function addEvent() : void
      {
         this._title.addEventListener(MouseEvent.MOUSE_DOWN,this.onTitleDown);
         LayerManager.stage.addEventListener(MouseEvent.MOUSE_UP,this.onTitleUp);
         this._mainUI.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         this._mainUI.addEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            this._pageBtns[_loc1_].addEventListener(MouseEvent.CLICK,this.onPageClick);
            _loc1_++;
         }
         this._detailBtn.addEventListener(MouseEvent.CLICK,this.onDetailClick);
         this._expandBtn.addEventListener(MouseEvent.CLICK,this.onExpandClick);
         MapManager.addEventListener(MapEvent.USER_ENTER_TRADE_MAP,this.onEnterTradeMap);
         MapManager.addEventListener(MapEvent.USER_LEAVE_TRADE_MAP,this.onLeaveTradeMap);
         StageResizeController.instance.register(this.layout);
         UserInfoManager.ed.addEventListener(UserEvent.LVL_CHANGE,this.resetBtnState);
      }
      
      private function resetBtnState(param1:Event = null) : void
      {
         this._pageBtns[2].filters = MainManager.actorInfo.lv >= 80 ? [] : FilterUtil.GRAY_FILTER;
      }
      
      private function onTitleDown(param1:MouseEvent) : void
      {
         var _loc2_:Rectangle = new Rectangle();
         if(this._isMin)
         {
            _loc2_.x = -122;
            _loc2_.width = LayerManager.stageWidth - 110;
            _loc2_.height = LayerManager.stageHeight - this._minUI.height;
            this._minUI.startDrag(false,_loc2_);
         }
         else
         {
            _loc2_.width = LayerManager.stageWidth - 230;
            _loc2_.height = LayerManager.stageHeight - this.MAIN_UI_HEIGHT;
            this._mainUI.startDrag(false,_loc2_);
         }
      }
      
      private function onTitleUp(param1:MouseEvent) : void
      {
         this._mainUI.stopDrag();
         if(this._minUI)
         {
            this._minUI.stopDrag();
         }
      }
      
      private function removeEvent() : void
      {
         this._title.removeEventListener(MouseEvent.MOUSE_DOWN,this.onTitleDown);
         LayerManager.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onTitleUp);
         this._mainUI.removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         this._mainUI.removeEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            this._pageBtns[_loc1_].removeEventListener(MouseEvent.CLICK,this.onPageClick);
            _loc1_++;
         }
         this._detailBtn.removeEventListener(MouseEvent.CLICK,this.onDetailClick);
         this._expandBtn.removeEventListener(MouseEvent.CLICK,this.onExpandClick);
         MapManager.removeEventListener(MapEvent.USER_ENTER_TRADE_MAP,this.onEnterTradeMap);
         MapManager.removeEventListener(MapEvent.USER_LEAVE_TRADE_MAP,this.onLeaveTradeMap);
         StageResizeController.instance.unregister(this.layout);
         UserInfoManager.ed.removeEventListener(UserEvent.LVL_CHANGE,this.resetBtnState);
      }
      
      private function showForPage(param1:int) : void
      {
         if(this._currentPage == param1)
         {
            return;
         }
         this._currentPage = param1;
         this.setPageBtnStat(param1);
         DisplayUtil.removeAllChild(this._container);
         switch(param1)
         {
            case 0:
               this._taskPanel = this.acceptedPanel;
               break;
            case 2:
               this._taskPanel = this.activityPanel;
               break;
            default:
               this._taskPanel = this.acceptedPanel;
               return;
         }
         this._container.addChild(this._taskPanel);
         this._taskPanel.isExpanded = true;
         this.detailBtnOff();
         this._taskPanel.showScroll(false);
      }
      
      private function setPageBtnStat(param1:int) : void
      {
         var _loc3_:MovieClip = null;
         var _loc2_:int = 0;
         while(_loc2_ < 3)
         {
            _loc3_ = this._pageBtns[_loc2_];
            if(_loc2_ == param1)
            {
               _loc3_.gotoAndStop(2);
            }
            else
            {
               _loc3_.gotoAndStop(1);
            }
            _loc2_++;
         }
      }
      
      private function onTaskComplete(param1:TaskEvent) : void
      {
         var _loc2_:uint = uint(param1.taskID);
         if(_loc2_ == 302)
         {
            this.showAndExpand();
         }
      }
      
      private function get acceptedPanel() : TaskAcceptedPanel
      {
         if(this._acceptedPanel == null)
         {
            this._acceptedPanel = new TaskAcceptedPanel();
         }
         return this._acceptedPanel;
      }
      
      private function get activityPanel() : ActivityTrackPanel
      {
         if(this._activityPanel == null)
         {
            this._activityPanel = new ActivityTrackPanel();
         }
         return this._activityPanel;
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         TweenLite.killTweensOf(this._bg);
         TweenLite.to(this._bg,1,{"alpha":0});
         this._taskPanel.showScroll(false);
         if(this._taskPanel is TaskAcceptedPanel)
         {
            (this._taskPanel as TaskAcceptedPanel).hideBack();
         }
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         TweenLite.killTweensOf(this._bg);
         TweenLite.to(this._bg,1,{"alpha":1});
         this._taskPanel.showScroll(true);
      }
      
      private function onPageClick(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         var _loc3_:int = this._pageBtns.indexOf(_loc2_);
         if(_loc3_ == 2 && MainManager.actorInfo.lv < 80)
         {
            AlertManager.showSimpleAlarm("快捷功能将在80级之后开放哦，快快升级吧~");
            return;
         }
         this.showForPage(_loc3_);
      }
      
      public function showAndExpand() : void
      {
         this.show();
      }
      
      private function expandFun() : void
      {
         DisplayUtil.removeForParent(this._container);
         this._expandBtn.gotoAndStop(2);
         this._bg.visible = false;
         ToolTipManager.remove(this._expandBtn);
         ToolTipManager.add(this._expandBtn,"弹出下拉框");
         if(this._currentPage != 2)
         {
            this.detailBtnOn();
            this._taskPanel.isExpanded = false;
         }
      }
      
      private function layout() : void
      {
      }
      
      private function onDetailClick(param1:MouseEvent) : void
      {
         if(this._currentPage == 2)
         {
            return;
         }
         if(this._taskPanel.isExpanded)
         {
            this.detailBtnOn();
            this._taskPanel.isExpanded = false;
         }
         else
         {
            this.detailBtnOff();
            this._taskPanel.isExpanded = true;
         }
      }
      
      private function detailBtnOn() : void
      {
         this._detailBtn.gotoAndStop(1);
         ToolTipManager.add(this._detailBtn,"展开所有单项");
      }
      
      private function detailBtnOff() : void
      {
         this._detailBtn.gotoAndStop(2);
         ToolTipManager.add(this._detailBtn,"收起所有单项");
      }
      
      private function refresh() : void
      {
         if(this._isMin)
         {
            this.hideMain();
            this.showMiniPanel();
         }
         else
         {
            this.hideMiniPanel();
            this.showMain();
         }
      }
      
      private function onExpandClick(param1:MouseEvent = null) : void
      {
         this._isMin = !this._isMin;
         this.refresh();
      }
      
      private function onEnterTradeMap(param1:MapEvent) : void
      {
         this._mainUI.visible = false;
      }
      
      private function onLeaveTradeMap(param1:MapEvent) : void
      {
         this._mainUI.visible = true;
      }
      
      public function show() : void
      {
         this.refresh();
      }
      
      private function showMain() : void
      {
         LayerManager.toolsLevel.addChild(this._mainUI);
         this.addEvent();
      }
      
      private function hideMain() : void
      {
         DisplayUtil.removeForParent(this._mainUI,false);
         this.removeEvent();
      }
      
      public function hide() : void
      {
         this.hideMain();
         this.hideMiniPanel();
      }
      
      public function destroy() : void
      {
         this.removeEvent();
         this._pageBtns = null;
         this._container = null;
         if(this._acceptedPanel)
         {
            this._acceptedPanel.destroy();
            this._acceptedPanel = null;
         }
         if(this._activityPanel)
         {
            this._activityPanel.destroy();
            this._activityPanel = null;
         }
         DisplayUtil.removeForParent(this._mainUI);
         ToolTipManager.remove(this._title);
         this._mainUI = null;
      }
   }
}

