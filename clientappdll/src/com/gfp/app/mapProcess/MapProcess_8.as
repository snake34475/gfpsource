package com.gfp.app.mapProcess
{
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.TasksManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.ds.HashMap;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_8 extends MapProcessAnimat
   {
      
      private var _steamedBunMC:MovieClip;
      
      private var _jarMC:MovieClip;
      
      private var _jar1MC:MovieClip;
      
      private var _wolf:MovieClip;
      
      private var _wolfDan:MovieClip;
      
      private var _qirou:MovieClip;
      
      private var _invRou:uint;
      
      private var _isTaskClearUpInit:Boolean;
      
      private var defaultPointHS:HashMap;
      
      private var rightPointHS:HashMap;
      
      private var dragMC:Array;
      
      private var _distanicValue:int = 20;
      
      private var _readyHS:HashMap;
      
      private var _addrMC:MovieClip;
      
      private var _currentDrag:MovieClip;
      
      public function MapProcess_8()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._steamedBunMC = _mapModel.contentLevel["steamedBunMC"];
         this._jarMC = _mapModel.contentLevel["jarMC"];
         this._jarMC.buttonMode = true;
         this._jarMC.gotoAndStop(1);
         this._jarMC.addEventListener(MouseEvent.CLICK,this.onJarClick);
         this._jar1MC = _mapModel.contentLevel["jar1MC"];
         this._jar1MC.buttonMode = true;
         this._jar1MC.addEventListener(MouseEvent.CLICK,this.onJar1Click);
         this._jar1MC.gotoAndStop(1);
         addSimpleClickAnimat(this._steamedBunMC);
         if(Boolean(TasksManager.isProcess(1102,1)) || Boolean(TasksManager.isProcess(1102,2)))
         {
            this.initTaskClearUP();
         }
         else
         {
            this.setSingsAnimat();
         }
         this._wolf = _mapModel.contentLevel["wolf"];
         this._wolf.buttonMode = true;
         this._wolf.addEventListener(MouseEvent.CLICK,this.onWolfClick);
         this._wolf.gotoAndStop(1);
         this._qirou = _mapModel.upLevel["qirou"];
         this._qirou.buttonMode = true;
         this._qirou.addEventListener(MouseEvent.CLICK,this.onQirouClick);
         this._qirou.gotoAndStop(1);
         TasksManager.addListener(TaskEvent.PRO_COMPLETE,this.onTaskProComp);
         TasksManager.addListener(TaskEvent.ACCEPT,this.onTaskAccept);
      }
      
      override public function destroy() : void
      {
         this.setSingsAnimat(true);
         if(this._isTaskClearUpInit)
         {
            this.destroyTaskClearUp();
         }
         super.destroy();
         removeSimpleClickAnimat(this._steamedBunMC);
         removeSimpleClickAnimat(this._jarMC);
         if(this._wolfDan)
         {
            this._wolfDan.removeEventListener(Event.ENTER_FRAME,this.onWolfDan);
            this._wolfDan = null;
         }
         if(this._qirou)
         {
            this._qirou.removeEventListener(Event.ENTER_FRAME,this.onQirouClick);
            this._qirou = null;
         }
         clearTimeout(this._invRou);
         TasksManager.removeListener(TaskEvent.PRO_COMPLETE,this.onTaskProComp);
         TasksManager.removeListener(TaskEvent.ACCEPT,this.onTaskAccept);
         LayerManager.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onStageMouseUP);
      }
      
      private function onTaskAccept(param1:TaskEvent) : void
      {
      }
      
      private function onTaskProComp(param1:TaskEvent) : void
      {
         if(param1.taskID == 1102)
         {
            if(Boolean(TasksManager.isTaskProComplete(1102,0)) && !TasksManager.isReady(1102))
            {
               this.setSingsAnimat(true);
               this.initTaskClearUP();
            }
         }
      }
      
      private function onJarClick(param1:MouseEvent) : void
      {
         var _loc2_:int = this._jarMC.currentFrame == 2 ? 3 : 2;
         this._jarMC.gotoAndStop(_loc2_);
      }
      
      private function onJar1Click(param1:MouseEvent) : void
      {
         var _loc2_:int = this._jar1MC.currentFrame == 2 ? 3 : 2;
         this._jar1MC.gotoAndStop(_loc2_);
      }
      
      private function setSingsAnimat(param1:Boolean = false) : void
      {
         var _loc3_:MovieClip = null;
         var _loc2_:int = 1;
         while(_loc2_ <= 8)
         {
            _loc3_ = _mapModel.contentLevel["signMC" + _loc2_];
            if(param1)
            {
               removeSimpleClickAnimat(_loc3_);
            }
            else
            {
               addSimpleClickAnimat(_loc3_);
            }
            _loc2_++;
         }
      }
      
      private function onWolfClick(param1:MouseEvent) : void
      {
         var _loc2_:int = this._wolf.currentFrame == 2 ? 1 : 2;
         this._wolf.gotoAndStop(_loc2_);
         if(_loc2_ == 2)
         {
            if(TasksManager.isProcess(11,0))
            {
               if(ItemManager.getItemCount(1400006) > 0)
               {
                  this._wolfDan = _mapModel.libManager.getMovieClip("Wolf_Dan");
                  this._wolfDan.x = this._wolf.x;
                  this._wolfDan.y = this._wolf.y;
                  _mapModel.contentLevel.addChild(this._wolfDan);
                  this._wolfDan.addEventListener(Event.ENTER_FRAME,this.onWolfDan);
                  this._wolfDan.gotoAndPlay(1);
               }
            }
         }
      }
      
      private function onWolfDan(param1:Event) : void
      {
         if(this._wolfDan.currentFrame == this._wolfDan.totalFrames)
         {
            this._wolfDan.removeEventListener(Event.ENTER_FRAME,this.onWolfDan);
            DisplayUtil.removeForParent(this._wolfDan);
            this._wolfDan = null;
            ActivityExchangeCommander.exchange(2095);
         }
      }
      
      private function onQirouClick(param1:MouseEvent) : void
      {
         var _loc2_:int = this._qirou.currentFrame == 2 ? 1 : 2;
         this._qirou.gotoAndStop(_loc2_);
         if(_loc2_ == 2)
         {
            if(TasksManager.isProcess(11,0))
            {
               if(ItemManager.getItemCount(1400006) == 0)
               {
                  this._invRou = setTimeout(this.onRou,1000);
               }
            }
         }
      }
      
      private function onRou() : void
      {
         ItemManager.buyItem(1400006,false,1);
      }
      
      private function initTaskClearUP() : void
      {
         this._isTaskClearUpInit = true;
         this.initPoint();
         this.initially();
      }
      
      private function initially() : void
      {
         var _loc1_:String = null;
         var _loc2_:MovieClip = null;
         var _loc3_:Point = null;
         for each(_loc1_ in this.dragMC)
         {
            _loc2_ = _mapModel.contentLevel[_loc1_];
            _loc3_ = this.defaultPointHS.getValue(_loc1_);
            _loc3_.x -= 215;
            _loc3_.y -= 138;
            this.setMCPoint(_loc2_,_loc3_);
            this.setDragEvent(_loc2_);
         }
         this._addrMC = _mapModel.libManager.getMovieClip("addrMC");
         this._addrMC.x = 442;
         this._addrMC.y = 281;
         _mapModel.upLevel.addChild(this._addrMC);
         LayerManager.stage.addEventListener(MouseEvent.MOUSE_UP,this.onStageMouseUP);
      }
      
      private function setDragEvent(param1:MovieClip, param2:Boolean = false) : void
      {
         if(param1)
         {
            if(param2)
            {
               param1.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMCMouseDown);
            }
            else
            {
               param1.buttonMode = true;
               param1.addEventListener(MouseEvent.MOUSE_DOWN,this.onMCMouseDown);
               this._currentDrag = param1;
            }
         }
      }
      
      private function onMCMouseDown(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         if(_loc2_.name == "lunchBoxMC")
         {
            _loc2_.parent.setChildIndex(_loc2_,_loc2_.parent.numChildren - 1);
         }
         if(this.defaultPointHS.containsKey(_loc2_.name))
         {
            _loc2_.addEventListener(MouseEvent.MOUSE_UP,this.onMCMouseUp);
            _loc2_.startDrag();
         }
      }
      
      private function onStageMouseUP(param1:MouseEvent) : void
      {
         if(Boolean(TasksManager.isTaskProComplete(1102,0)) && !TasksManager.isReady(1102) && this._currentDrag != null)
         {
            this.onGragMCUp(this._currentDrag);
            this._currentDrag = null;
         }
      }
      
      private function onMCMouseUp(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         this.onGragMCUp(_loc2_);
      }
      
      private function onGragMCUp(param1:MovieClip) : void
      {
         param1.removeEventListener(MouseEvent.MOUSE_UP,this.onMCMouseUp);
         param1.stopDrag();
         if(this.defaultPointHS.containsKey(param1.name))
         {
            this.isDragRight(param1);
         }
      }
      
      private function isDragRight(param1:MovieClip) : void
      {
         var _loc4_:String = null;
         var _loc5_:Point = null;
         var _loc6_:Point = null;
         var _loc2_:Point = new Point(param1.x,param1.y);
         var _loc3_:Array = this.rightPointHS.getKeys();
         for each(_loc4_ in _loc3_)
         {
            _loc6_ = this.rightPointHS.getValue(_loc4_);
            if(Point.distance(_loc2_,_loc6_) <= this._distanicValue)
            {
               if(param1.name.substr(0,3) != _loc4_.substr(0,3))
               {
                  break;
               }
               if(this._readyHS.containsKey(_loc4_))
               {
                  break;
               }
               this._readyHS.add(_loc4_,"ready");
               this.setMCPoint(param1,_loc6_);
               param1.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMCMouseDown);
               param1.buttonMode = false;
               this.isPass();
               return;
            }
         }
         _loc5_ = this.defaultPointHS.getValue(param1.name);
         this.setMCPoint(param1,_loc5_);
      }
      
      private function isPass() : void
      {
         if(this._readyHS.getKeys().length >= this.dragMC.length)
         {
            if(TasksManager.isProcess(1102,2))
            {
               TasksManager.dispatchActionEvent(TaskActionEvent.TASK_MAPCOLLECT,"clearUp");
               NpcDialogController.showForNpc(10014);
            }
            DisplayUtil.removeForParent(this._addrMC);
         }
      }
      
      private function setMCPoint(param1:MovieClip, param2:Point) : void
      {
         param1.x = param2.x;
         param1.y = param2.y;
      }
      
      private function destroyTaskClearUp() : void
      {
         var _loc1_:String = null;
         var _loc2_:MovieClip = null;
         for each(_loc1_ in this.dragMC)
         {
            _loc2_ = _mapModel.contentLevel[_loc1_];
            this.setDragEvent(_loc2_,true);
         }
      }
      
      private function initPoint() : void
      {
         this.defaultPointHS = new HashMap();
         this.rightPointHS = new HashMap();
         this._readyHS = new HashMap();
         this.dragMC = ["signMC1","signMC2","signMC3","signMC4","signMC5","signMC6","signMC7","signMC8","cap1","cap2","lunchBoxMC","chair1","chair2"];
         this.defaultPointHS.add("signMC1",new Point(545,392));
         this.defaultPointHS.add("signMC2",new Point(490,418));
         this.defaultPointHS.add("signMC3",new Point(515,387));
         this.defaultPointHS.add("signMC4",new Point(517,350));
         this.defaultPointHS.add("signMC5",new Point(464,378));
         this.defaultPointHS.add("signMC6",new Point(441,366));
         this.defaultPointHS.add("signMC7",new Point(484,362));
         this.defaultPointHS.add("signMC8",new Point(471,349));
         this.defaultPointHS.add("lunchBoxMC",new Point(736,598));
         this.defaultPointHS.add("cap1",new Point(897,404));
         this.defaultPointHS.add("cap2",new Point(859,398));
         this.defaultPointHS.add("chair1",new Point(529,443));
         this.defaultPointHS.add("chair2",new Point(902,586));
         this.rightPointHS.add("signMC1",new Point(242,51));
         this.rightPointHS.add("signMC2",new Point(277,59));
         this.rightPointHS.add("signMC3",new Point(311,66));
         this.rightPointHS.add("signMC4",new Point(348,75));
         this.rightPointHS.add("signMC5",new Point(236,134));
         this.rightPointHS.add("signMC6",new Point(276,145));
         this.rightPointHS.add("signMC7",new Point(307,152));
         this.rightPointHS.add("signMC8",new Point(340,162));
         this.rightPointHS.add("lunchBoxMC",new Point(624,509));
         this.rightPointHS.add("cap1",new Point(653,176));
         this.rightPointHS.add("cap2",new Point(610,166));
         this.rightPointHS.add("chair1",new Point(294,400));
         this.rightPointHS.add("chair2",new Point(544,493));
      }
   }
}

