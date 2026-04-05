package com.gfp.app.mapProcess
{
   import com.gfp.app.cartoon.AnimatHeadString;
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.cartoon.event.AnimatEvent;
   import com.gfp.app.info.dialog.DialogInfoSimple;
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.action.mouse.MouseProcess;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.FocusManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.sensemodels.SightModel;
   import com.gfp.core.ui.alert.TextAlert;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.ui.Mouse;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_53 extends BaseMapProcess
   {
      
      private var _stoneList:Array;
      
      private var _waterList:Array;
      
      private var _waterEntryList:Array;
      
      private var _bucketMC:MovieClip;
      
      private var _poolMC:MovieClip;
      
      private var _cursor:Sprite;
      
      private var _stoneCount:int;
      
      private var _filledCount:uint;
      
      private var _prevPickStone:DisplayObject;
      
      public function MapProcess_53()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.addTaskManagerListener();
         this.initForTask75();
         this.checkForTask1903();
      }
      
      private function addTaskManagerListener() : void
      {
         TasksManager.addListener(TaskEvent.ACCEPT,this.onTaskAccept);
         TasksManager.addListener(TaskEvent.COMPLETE,this.onTaskComplete);
      }
      
      private function removeTaskManagerListener() : void
      {
         TasksManager.removeListener(TaskEvent.ACCEPT,this.onTaskAccept);
         TasksManager.addListener(TaskEvent.COMPLETE,this.onTaskComplete);
      }
      
      private function onTaskComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 1903)
         {
            this.checkForTask1903();
         }
      }
      
      private function onTaskAccept(param1:TaskEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:DialogInfoSimple = null;
         if(param1.taskID == 8001)
         {
            _loc2_ = AppLanguageDefine.NPC_DIALOG_MAP53[0];
            _loc3_ = new DialogInfoSimple([_loc2_],AppLanguageDefine.NPC_DIALOG_MAP53[1]);
            NpcDialogController.showForSimple(_loc3_,10161,this.onFightDialog);
         }
      }
      
      private function onFightDialog() : void
      {
         NpcDialogController.showForNpc(10161);
      }
      
      override public function destroy() : void
      {
         this.removeTaskManagerListener();
         this.removeUIEvent();
         this._filledCount = 0;
         this._stoneCount = 0;
         this.hideStoneCursor();
         ToolTipManager.remove(this._poolMC);
         this._poolMC = null;
         super.destroy();
      }
      
      private function initForTask75() : void
      {
         this._stoneList = [];
         this._waterList = [];
         this._waterEntryList = [];
         this._bucketMC = _mapModel.contentLevel["bucketMC"];
         this._bucketMC.visible = false;
         this._poolMC = _mapModel.contentLevel["poolMC"];
         this._poolMC.buttonMode = true;
         this._poolMC.visible = false;
         this._poolMC.filters = [];
         var _loc1_:uint = 1;
         while(_loc1_ <= 4)
         {
            this._stoneList.push(_mapModel.downLevel["stoneMC_" + _loc1_]);
            this._waterList.push(_mapModel.downLevel["waterMC_" + _loc1_]);
            this._waterEntryList.push(_mapModel.downLevel["hitAreaMC_" + _loc1_]);
            _loc1_++;
         }
         if(Boolean(TasksManager.isAccepted(79)) && !TasksManager.isCompleted(79))
         {
            if(Boolean(TasksManager.isTaskProComplete(79,1)) && !TasksManager.isTaskProComplete(79,2))
            {
               this.removeStone();
               this._bucketMC.visible = true;
               this._poolMC.visible = true;
            }
            else if(TasksManager.isTaskProComplete(79,2))
            {
               this.initUIHide();
            }
            this.initUIEvent();
         }
         else
         {
            this.initUIHide();
         }
      }
      
      private function checkForTask1903() : void
      {
         var _loc1_:SightModel = SightManager.getSightModel(13361);
         if(_loc1_)
         {
            if(Boolean(TasksManager.isAcceptable(1903)) || Boolean(TasksManager.isAccepted(1903)))
            {
               _loc1_.show();
            }
            else
            {
               _loc1_.hide();
            }
         }
      }
      
      private function removeStone() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this._stoneList.length)
         {
            DisplayUtil.removeForParent(this._stoneList[_loc1_]);
            DisplayUtil.removeForParent(this._waterList[_loc1_]);
            DisplayUtil.removeForParent(this._waterEntryList[_loc1_]);
            _loc1_++;
         }
         this._stoneList = [];
         this._waterList = [];
         this._waterEntryList = [];
      }
      
      private function initUIHide() : void
      {
         DisplayUtil.removeForParent(this._bucketMC);
         DisplayUtil.removeForParent(this._poolMC);
         this.removeStone();
      }
      
      private function initUIEvent() : void
      {
         var _loc2_:SimpleButton = null;
         var _loc3_:MovieClip = null;
         var _loc1_:uint = 0;
         while(_loc1_ < this._stoneList.length)
         {
            _loc2_ = this._stoneList[_loc1_] as SimpleButton;
            _loc3_ = this._waterEntryList[_loc1_] as MovieClip;
            _loc2_.addEventListener(MouseEvent.CLICK,this.onStoneClick);
            _loc3_.addEventListener(MouseEvent.CLICK,this.onEntryClick);
            ToolTipManager.add(_loc2_,"石头");
            ToolTipManager.add(_loc3_,"毒水源头");
            _loc1_++;
         }
         this._poolMC.addEventListener(MouseEvent.CLICK,this.onPoolClick);
      }
      
      private function removeUIEvent() : void
      {
         var _loc2_:SimpleButton = null;
         var _loc3_:MovieClip = null;
         var _loc1_:uint = 0;
         while(_loc1_ < this._stoneList.length)
         {
            _loc2_ = this._stoneList[_loc1_] as SimpleButton;
            _loc3_ = this._waterEntryList[_loc1_] as MovieClip;
            _loc2_.removeEventListener(MouseEvent.CLICK,this.onStoneClick);
            _loc3_.removeEventListener(MouseEvent.CLICK,this.onEntryClick);
            ToolTipManager.remove(_loc2_);
            ToolTipManager.remove(_loc3_);
            _loc1_++;
         }
         this._poolMC.removeEventListener(MouseEvent.CLICK,this.onPoolClick);
      }
      
      private function onStoneClick(param1:Event) : void
      {
         if(this._cursor != null)
         {
            TextAlert.show("小侠士，快用你手中的石头堵住毒水的源头。");
            return;
         }
         var _loc2_:SimpleButton = param1.currentTarget as SimpleButton;
         ++this._stoneCount;
         FocusManager.setDefaultFocus();
         TextAlert.show("小侠士，你搬起了一块大石头，快去堵住毒水源头。");
         this._cursor = this.creatStoneShap(_loc2_);
         this._prevPickStone = _loc2_;
         this._prevPickStone.visible = false;
         this.showStoneCursor();
      }
      
      private function showStoneCursor() : void
      {
         Mouse.hide();
         this._cursor.startDrag(true);
         LayerManager.stage.addEventListener(MouseEvent.MOUSE_DOWN,this.onStageMouseDonw);
      }
      
      protected function onStageMouseDonw(param1:MouseEvent) : void
      {
         var _loc4_:Sprite = null;
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         var _loc3_:uint = 0;
         while(_loc3_ < this._waterEntryList.length)
         {
            _loc4_ = this._waterEntryList[_loc3_] as Sprite;
            if(_loc4_.contains(_loc2_))
            {
               return;
            }
            _loc3_++;
         }
         this.hideStoneCursor();
         if(this._prevPickStone)
         {
            this._prevPickStone.visible = true;
            this._prevPickStone = null;
         }
      }
      
      private function hideStoneCursor() : void
      {
         Mouse.show();
         if(this._cursor)
         {
            this._cursor.stopDrag();
            DisplayUtil.removeForParent(this._cursor);
         }
         this._cursor = null;
         LayerManager.stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.onStageMouseDonw);
      }
      
      private function creatStoneShap(param1:SimpleButton) : Sprite
      {
         var _loc2_:Sprite = new Sprite();
         var _loc3_:BitmapData = new BitmapData(param1.width,param1.height,true,16777215);
         var _loc4_:Matrix = new Matrix();
         _loc4_.scale(param1.scaleX,param1.scaleY);
         var _loc5_:Rectangle = param1.getBounds(param1);
         _loc4_.tx = -_loc5_.x * param1.scaleX;
         _loc4_.ty = -_loc5_.y * param1.scaleY;
         _loc3_.draw(param1,_loc4_);
         var _loc6_:Bitmap = new Bitmap(_loc3_);
         _loc2_.addChild(_loc6_);
         _loc2_.scaleX = _loc2_.scaleY = 0.6;
         LayerManager.uiLevel.addChild(_loc2_);
         _loc2_.mouseEnabled = _loc2_.mouseChildren = false;
         return _loc2_;
      }
      
      private function onEntryClick(param1:Event) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         if(this._stoneCount > 0)
         {
            this.oneEntryFill(_loc2_);
         }
         else
         {
            TextAlert.show("小侠士，快用地上的大石头来堵住这个毒水源头吧。");
         }
      }
      
      private function oneEntryFill(param1:MovieClip) : void
      {
         var _loc2_:uint = 0;
         while(_loc2_ < 4)
         {
            if(param1 == this._waterEntryList[_loc2_])
            {
               param1.alpha = 1;
               param1.mouseEnabled = false;
               ToolTipManager.remove(param1);
               ++this._filledCount;
               --this._stoneCount;
               TextAlert.show("一个毒水源头被堵住了");
               this.hideStoneCursor();
               if(this._filledCount >= 4)
               {
                  AnimatPlay.addAnimatListener(AnimatEvent.ANIMAT_END,this.onAllEntryFilled);
                  AnimatPlay.startAnimat(AnimatHeadString.SCENCE,59,false,233,131);
               }
               break;
            }
            _loc2_++;
         }
      }
      
      private function onAllEntryFilled(param1:AnimatEvent) : void
      {
         AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onAllEntryFilled);
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_CUSTOM_FINISH,"79_1");
         this._bucketMC.visible = true;
         this._poolMC.visible = true;
         ToolTipManager.add(this._poolMC,"采集毒水");
         TextAlert.show("快去采集一点毒水交给药师爷爷看看。");
         MouseProcess.execRun(MainManager.actorModel,new Point(1063,607));
         var _loc2_:uint = 0;
         while(_loc2_ < this._waterList.length)
         {
            DisplayUtil.removeForParent(this._stoneList[_loc2_]);
            DisplayUtil.removeForParent(this._waterList[_loc2_]);
            DisplayUtil.removeForParent(this._waterEntryList[_loc2_]);
            _loc2_++;
         }
      }
      
      private function onPoolClick(param1:Event) : void
      {
         this._bucketMC.addEventListener(Event.ENTER_FRAME,this.onWatering);
         this._bucketMC.gotoAndPlay(1);
      }
      
      private function onWatering(param1:Event) : void
      {
         if(this._bucketMC.currentFrame == this._bucketMC.totalFrames)
         {
            this._bucketMC.removeEventListener(Event.ENTER_FRAME,this.onWatering);
            this._bucketMC.gotoAndStop(1);
            TasksManager.dispatchActionEvent(TaskActionEvent.TASK_CUSTOM_FINISH,"79_2");
            MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitched);
            CityMap.instance.changeMap(5,0,1,new Point(530,410));
         }
      }
      
      private function onMapSwitched(param1:MapEvent) : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitched);
         NpcDialogController.showForNpc(10002);
      }
   }
}

