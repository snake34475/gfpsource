package com.gfp.app.feature
{
   import com.gfp.core.action.ActionInfo;
   import com.gfp.core.action.normal.PosMoveAction;
   import com.gfp.core.config.xml.ActionXMLInfo;
   import com.gfp.core.events.MoveEvent;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.CustomSightModel;
   import com.gfp.core.model.CustomUserModel;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.TimeComeCallOut;
   import com.gfp.core.utils.TimeUtil;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.taomee.utils.DisplayUtil;
   
   public class PvpSideGodGrilComeFeater extends EventDispatcher
   {
      
      public static const TIME_OUT_EVENT:String = "sideTimeOutEvent";
      
      private var _path:Array;
      
      private var _startDate:Date;
      
      private var _endDate:Date;
      
      private var _destoryDate:Date;
      
      private var _lastTime:Number;
      
      private var _godModel:CustomUserModel;
      
      private var _currentPathIndex:int = 0;
      
      private var _boxPositions:Array;
      
      private var _boxs:Vector.<CustomSightModel>;
      
      private var _timeOut:TimeComeCallOut = new TimeComeCallOut();
      
      private var _isGo:Boolean = true;
      
      private var _side:int;
      
      private var _process:MovieClip;
      
      private var _index:int = -1;
      
      public function PvpSideGodGrilComeFeater(param1:Array, param2:Array, param3:Date, param4:Date, param5:Date, param6:int)
      {
         super();
         this._path = param1;
         this._startDate = param3;
         this._endDate = param4;
         this._destoryDate = param5;
         this._boxPositions = param2;
         this._side = param6;
         this.init();
         this.addEvent();
      }
      
      private function addEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
      }
      
      public function init() : void
      {
         this.checkTime();
      }
      
      private function checkTime() : void
      {
         var _loc3_:int = 0;
         var _loc1_:Date = TimeUtil.getSeverDateObject();
         var _loc2_:int = int(TimeUtil.isDateInSpecialTween(TimeUtil.getSeverDateObject(),this._startDate,this._endDate));
         if(_loc2_ == 0)
         {
            this.godTimeCome();
         }
         else if(_loc2_ == 1)
         {
            this.destoryGod();
            _loc3_ = int(TimeUtil.isDateInSpecialTween(TimeUtil.getSeverDateObject(),this._startDate,this._destoryDate));
            if(_loc3_ == 0)
            {
               this.initBox();
               this._timeOut.checkTimeCallBack(this._destoryDate,this.timeOutBack);
            }
         }
         else if(_loc2_ == -1)
         {
            this._timeOut.checkTimeCallBack(this._startDate,this.godTimeCome);
         }
      }
      
      private function godTimeCome() : void
      {
         this.initGod();
         this.initBox();
         this._timeOut.checkTimeCallBack(this._endDate,this.godEndTimeCome);
      }
      
      private function godEndTimeCome() : void
      {
         this.destoryGod();
         this._timeOut.checkTimeCallBack(this._destoryDate,this.timeOutBack);
      }
      
      private function timeOutBack() : void
      {
         dispatchEvent(new Event(TIME_OUT_EVENT));
         this.destory();
      }
      
      private function destoryGod() : void
      {
         if(this._godModel)
         {
            this._godModel.removeEvent(MoveEvent.MOVE_END,this.onGodMoveEnd);
            this._godModel.destroy();
         }
      }
      
      private function destoryAllBox() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:CustomSightModel = null;
         if(this._boxs)
         {
            _loc1_ = int(this._boxs.length);
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               _loc3_ = this._boxs[_loc2_];
               _loc3_.removeEventListener(MouseEvent.CLICK,this.onBoxClick);
               _loc3_.destroy();
               _loc2_++;
            }
            this._boxs = null;
         }
      }
      
      private function initBox() : void
      {
         var _loc3_:CustomSightModel = null;
         this._boxs = new Vector.<CustomSightModel>();
         var _loc1_:int = int(this._boxPositions.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = new CustomSightModel();
            _loc3_.roleType = 19186;
            _loc3_.pos = this._boxPositions[_loc2_];
            _loc3_.modelName = "女神宝箱";
            _loc3_.id = _loc2_;
            _loc3_.show();
            _loc3_.addEventListener(MouseEvent.CLICK,this.onBoxClick);
            this._boxs.push(_loc3_);
            _loc2_++;
         }
      }
      
      private function onBoxClick(param1:MouseEvent) : void
      {
         this._index = this._boxs.indexOf(param1.currentTarget as CustomSightModel);
         if(Boolean(this._process) && this._process.isPlaying)
         {
            return;
         }
         var _loc2_:Point = (param1.currentTarget as CustomSightModel).pos;
         this.showProcess(_loc2_.x,_loc2_.y - 50);
      }
      
      private function showProcess(param1:int, param2:int) : void
      {
         if(!this._process)
         {
            this._process = new ReapProcess();
         }
         this._process.x = param1;
         this._process.y = param2;
         this._process.addEventListener(Event.ENTER_FRAME,this.onProcessEnterFrame);
         this._process.gotoAndPlay(1);
         MapManager.currentMap.contentLevel.addChild(this._process);
      }
      
      private function onProcessEnterFrame(param1:Event) : void
      {
         if(this._process.currentFrame == this._process.totalFrames)
         {
            this._process.removeEventListener(Event.ENTER_FRAME,this.onProcessEnterFrame);
            this._process.stop();
            DisplayUtil.removeForParent(this._process,false);
            this.openBox(this._index);
         }
      }
      
      private function openBox(param1:int) : void
      {
         var index:int = param1;
         if(index != -1)
         {
            if(MainManager.actorInfo.side == 0)
            {
               AlertManager.showSimpleAlert("小侠士，必须加入阵营才能打开该宝箱哦，是否打开阵营加入面板？",function():void
               {
                  ModuleManager.turnAppModule("JoinPvpSidePanel");
               });
               return;
            }
            if(ActivityExchangeTimesManager.getTimes(3849) >= 20)
            {
               AlertManager.showSimpleAlarm("小侠士，每天只能开启20次女神宝箱。");
               return;
            }
            ActivityExchangeCommander.exchange(3849);
            TextAlert.show("恭喜小侠士在女神降临活动中幸运的打开了女神宝箱。");
            this._boxs[index].destroy();
         }
      }
      
      private function initGod() : void
      {
         if(this._side == 1)
         {
            this._godModel = new CustomUserModel(10536,"冰雪女王");
         }
         else
         {
            this._godModel = new CustomUserModel(10543,"迷之少女");
         }
         var _loc1_:Point = this.getCurrentPoint();
         this._godModel.show(_loc1_);
         ++this._currentPathIndex;
         this.startMovie();
         this._godModel.addEvent(MoveEvent.MOVE_END,this.onGodMoveEnd);
      }
      
      private function onGodMoveEnd(param1:MoveEvent) : void
      {
         if(this._currentPathIndex == this._path.length - 1)
         {
            this._isGo = false;
         }
         else if(this._currentPathIndex == 0)
         {
            this._isGo = true;
         }
         if(this._isGo)
         {
            ++this._currentPathIndex;
         }
         else
         {
            --this._currentPathIndex;
         }
         this.startMovie();
      }
      
      private function startMovie() : void
      {
         var _loc1_:ActionInfo = ActionXMLInfo.getInfo(10002);
         var _loc2_:Point = this.getCurrentPoint();
         var _loc3_:PosMoveAction = new PosMoveAction(_loc1_,_loc2_,false);
         this._godModel.exeAction(_loc3_);
      }
      
      private function getCurrentPoint() : Point
      {
         return this._path[this._currentPathIndex];
      }
      
      public function destory() : void
      {
         this.destoryGod();
         this.destoryAllBox();
         this.removeEvent();
         this._timeOut.destory();
         if(this._process)
         {
            this._process.stop();
            this._process.removeEventListener(Event.ENTER_FRAME,this.onProcessEnterFrame);
            DisplayUtil.removeForParent(this._process);
            this._process = null;
         }
      }
   }
}

