package com.gfp.app.mapProcess
{
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.sensemodels.SightModel;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.motion.TTween;
   import org.taomee.motion.TweenEvent;
   import org.taomee.motion.easing.Expo;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_17 extends MapProcessAnimat
   {
      
      private var _keyBoardMC:MovieClip;
      
      private var _keyBoardCloseBtn:SimpleButton;
      
      private var _jarMC:MovieClip;
      
      private var _bottleMC:MovieClip;
      
      private var _faceMC:MovieClip;
      
      private var _flagMC:MovieClip;
      
      private var _gogomc:MovieClip;
      
      private var _newGift:MovieClip;
      
      private var _newGiftClickMC:MovieClip;
      
      private var _infoPanel:MovieClip;
      
      private var _infoPanelCloseBtn:SimpleButton;
      
      private var giftMC_1:MovieClip;
      
      private var giftMC_2:MovieClip;
      
      private var giftMC_3:MovieClip;
      
      private var _npc10145:SightModel;
      
      public function MapProcess_17()
      {
         super();
      }
      
      override protected function init() : void
      {
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         this._jarMC = _mapModel.contentLevel["jarMC"];
         this._bottleMC = _mapModel.downLevel["bottleMC"];
         this._faceMC = _mapModel.contentLevel["faceMC"];
         this._flagMC = _mapModel.contentLevel["flagMC"];
         addFlagClickAnimat(this._flagMC);
         addFlagClickAnimat(this._bottleMC);
         addSimpleClickAnimat(this._jarMC);
         addSimpleClickAnimat(this._faceMC);
         TasksManager.addListener(TaskEvent.ACCEPT,this.onTaskAccept);
         TasksManager.addListener(TaskEvent.COMPLETE,this.onTaskComplete);
         TasksManager.addListener(TaskEvent.PRO_COMPLETE,this.onTaskProComplete);
         this.initTask1108();
         this.initTask1319();
      }
      
      private function onTaskComplete(param1:TaskEvent) : void
      {
         if(Boolean(TasksManager.isAcceptable(2)) && param1.taskID == 1108)
         {
         }
      }
      
      private function onTaskProComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 1319 && param1.proID == 1)
         {
            if(this._npc10145)
            {
               this._npc10145.visible = false;
            }
         }
      }
      
      private function onMapSwitchComplete(param1:MapEvent) : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
      }
      
      private function showGoGo() : void
      {
         var _loc1_:String = "gogomc";
         if(this._gogomc == null)
         {
            this._gogomc = MapManager.currentMap.libManager.getMovieClip(_loc1_);
         }
         LayerManager.topLevel.addChild(this._gogomc);
         this._gogomc.x = 440;
         this._gogomc.y = 60;
      }
      
      private function showKeyBoard() : void
      {
         var _loc1_:String = "Key_board_mc";
         this._keyBoardMC = MapManager.currentMap.libManager.getMovieClip(_loc1_);
         if(this._keyBoardMC)
         {
            this._keyBoardCloseBtn = this._keyBoardMC["closeBtn"];
            this._keyBoardCloseBtn.addEventListener(MouseEvent.CLICK,this.onCloseKeyBoard);
            LayerManager.root.addChild(this._keyBoardMC);
            DisplayUtil.align(this._keyBoardMC,null,AlignType.MIDDLE_CENTER);
         }
      }
      
      private function onCloseKeyBoard(param1:MouseEvent) : void
      {
         if(TasksManager.isCompleted(1108))
         {
            this.showGoGo();
         }
      }
      
      private function initTask1319() : void
      {
         this._npc10145 = SightManager.getSightModel(10145);
         if(this._npc10145)
         {
            if(Boolean(TasksManager.isTaskProComplete(1319,1)) || Boolean(TasksManager.isCompleted(1319)))
            {
               this._npc10145.visible = false;
            }
         }
      }
      
      private function onTaskAccept(param1:TaskEvent) : void
      {
         if(param1.taskID == 1108)
         {
            this.initTask1108();
         }
         if(param1.taskID == 1319)
         {
            NpcDialogController.showForNpc(10145);
         }
      }
      
      private function initTask1108() : void
      {
         if(Boolean(TasksManager.isAccepted(1108)) && !TasksManager.isReady(1108))
         {
            this.showGoGo();
         }
      }
      
      private function onNewGiftClick(param1:MouseEvent) : void
      {
         this._newGift.removeEventListener(MouseEvent.CLICK,this.onNewGiftClick);
         this._newGift["Arrow"].visible = false;
         MainManager.closeOperate();
         DisplayUtil.removeForParent(this._newGift);
         this._newGift.x = 540;
         this._newGift.y = 390;
         LayerManager.topLevel.addChild(this._newGift);
         this._newGift.addEventListener(Event.ENTER_FRAME,this.onNewGiftEnter);
         this._newGift.gotoAndPlay(2);
      }
      
      private function onNewGiftEnter(param1:Event) : void
      {
         if(this._newGift.currentFrame == this._newGift.totalFrames)
         {
            this._newGift.removeEventListener(Event.ENTER_FRAME,this.onNewGiftEnter);
            this._newGiftClickMC = this._newGift["clickMC"];
            this.giftMC_1 = this._newGiftClickMC["giftMC_1"];
            this.giftMC_2 = this._newGiftClickMC["giftMC_2"];
            this.giftMC_3 = this._newGiftClickMC["giftMC_3"];
            ToolTipManager.add(this.giftMC_1,AppLanguageDefine.NPC_DIALOG_MAP17[0]);
            ToolTipManager.add(this.giftMC_2,AppLanguageDefine.NPC_DIALOG_MAP17[1]);
            ToolTipManager.add(this.giftMC_3,AppLanguageDefine.NPC_DIALOG_MAP17[2]);
            this._newGiftClickMC.addEventListener(MouseEvent.CLICK,this.onClickMcClick);
         }
      }
      
      private function onClickMcClick(param1:MouseEvent) : void
      {
         this.showGoGo();
         ToolTipManager.remove(this.giftMC_1);
         ToolTipManager.remove(this.giftMC_2);
         ToolTipManager.remove(this.giftMC_3);
         this._newGiftClickMC.removeEventListener(MouseEvent.CLICK,this.onClickMcClick);
         if(!this.isBagFull())
         {
            DisplayUtil.removeForParent(this._newGift);
            param1.stopPropagation();
            this.initTask1108();
            AlertManager.showSimpleAlarm(AppLanguageDefine.NPC_DIALOG_MAP17[3]);
            MainManager.openOperate();
            return;
         }
         this.flyToBag(this._newGiftClickMC["giftMC_1"]);
      }
      
      private function isBagFull() : Boolean
      {
         var _loc1_:int = 0;
         if(ItemManager.getItemCount(1300101) == 0)
         {
            _loc1_ += 1;
         }
         if(ItemManager.getItemCount(1300001) == 0)
         {
            _loc1_ += 1;
         }
         var _loc2_:int = int(ItemManager.getItemAvailableCapacity());
         return _loc2_ >= _loc1_;
      }
      
      private function flyToBag(param1:MovieClip) : void
      {
         DisplayUtil.removeForParent(param1);
         param1.x = 535;
         param1.y = 187;
         LayerManager.topLevel.addChild(param1);
         var _loc2_:TTween = new TTween(param1);
         _loc2_.addEventListener(TweenEvent.MOTION_FINISH,this.onTweenEnd);
         _loc2_.init({
            "x":688,
            "y":530,
            "scaleX":0.6,
            "scaleY":0.6
         },{
            "y":Expo.easeIn,
            "x":Expo.easeIn,
            "scaleX":Expo.easeIn,
            "scaleY":Expo.easeIn
         },700);
         _loc2_.start();
      }
      
      private function onTweenEnd(param1:TweenEvent) : void
      {
         var _loc2_:TTween = param1.target as TTween;
         var _loc3_:MovieClip = _loc2_.target as MovieClip;
         var _loc4_:String = _loc3_.name;
         DisplayUtil.removeForParent(_loc3_);
         var _loc5_:int = int(_loc3_.name.substr(_loc4_.indexOf("_") + 1,1));
         if(_loc5_ < 3)
         {
            this.flyToBag(this._newGiftClickMC["giftMC_" + (_loc5_ + 1)]);
         }
         else
         {
            DisplayUtil.removeForParent(this._newGift);
            if(Boolean(TasksManager.isAccepted(1108)) && !TasksManager.isReady(1108))
            {
               TasksManager.taskComplete(1108);
            }
            MainManager.openOperate();
         }
         _loc2_.removeEventListener(TweenEvent.MOTION_FINISH,this.onTweenEnd);
         _loc2_.destroy();
         _loc3_ = null;
      }
      
      override public function destroy() : void
      {
         ToolTipManager.remove(this.giftMC_1);
         ToolTipManager.remove(this.giftMC_2);
         ToolTipManager.remove(this.giftMC_3);
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         TasksManager.removeListener(TaskEvent.ACCEPT,this.onTaskAccept);
         if(this._keyBoardMC)
         {
            this._keyBoardCloseBtn.removeEventListener(MouseEvent.CLICK,this.onCloseKeyBoard);
            this._keyBoardCloseBtn = null;
         }
         if(this._gogomc)
         {
            DisplayUtil.removeForParent(this._gogomc);
         }
         this._gogomc = null;
         this._keyBoardMC = null;
         if(this._newGift)
         {
            this._newGift.addEventListener(MouseEvent.CLICK,this.onNewGiftClick);
            DisplayUtil.removeForParent(this._newGift);
            this._newGift = null;
         }
         super.destroy();
         removeFlagClickAnimat(this._flagMC);
         removeFlagClickAnimat(this._bottleMC);
         removeSimpleClickAnimat(this._jarMC);
         removeSimpleClickAnimat(this._faceMC);
         this._jarMC = null;
         this._bottleMC = null;
         this._faceMC = null;
         this._flagMC = null;
         this._npc10145 = null;
      }
   }
}

