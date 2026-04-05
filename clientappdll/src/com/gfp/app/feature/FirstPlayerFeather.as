package com.gfp.app.feature
{
   import com.gfp.app.config.xml.DialogExXmlInfo;
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.info.dialogex.DialogExInfo;
   import com.gfp.app.npcDialog.DialogAdapter;
   import com.gfp.core.CommandID;
   import com.gfp.core.Constant;
   import com.gfp.core.action.ActionInfo;
   import com.gfp.core.action.normal.PosMoveAction;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.ActionXMLInfo;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.MoveEvent;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.info.KeyInfo;
   import com.gfp.core.manager.KeyManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.UILoader;
   import com.gfp.core.ui.controller.GuideAdapter;
   import com.gfp.core.ui.loading.LoadingType;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.utils.DisplayUtil;
   
   public class FirstPlayerFeather
   {
      
      private const NEW_PLAYER_STAGE_ID:int = 1045;
      
      private var _skillConfig:Array = [[100701,100702,100703],[200701,200702,200703],[300701,300702,300703],[400701,400702,400703],[500701,500702,500703],[600701,600702,600703],[700701,700702,700703],[800702,800703,800701]];
      
      private var _currentStepIndex:int = 0;
      
      private var _steps:Array = [0,0,0,0];
      
      private var _stepsMC:Array = ["","MAP_newTiitle0","MAP_newTiitle2","MAP_newTiitle3"];
      
      private var _stepsTip:Array = ["","","MAP_newTipInfo0","MAP_newTiipInfo1"];
      
      private const ARROW_POSITION:Point = new Point(462,655);
      
      private var _headMC:MovieClip;
      
      private var _titleMC:MovieClip;
      
      private var _storedSkillInfos:Vector.<KeyInfo>;
      
      private var _arrowMC:MovieClip;
      
      private var _loader:UILoader;
      
      private var _mainSWF:MovieClip;
      
      private var _background:Shape;
      
      public function FirstPlayerFeather()
      {
         super();
         this.init();
         this.addEvent();
      }
      
      public function setup() : void
      {
         this.showFrontMovie();
      }
      
      public function showFrontMovie() : void
      {
         MainManager.closeOperate();
         this.scrollComplete2();
      }
      
      private function scrollComplete() : void
      {
         var timer:int = 0;
         timer = int(setTimeout(function():void
         {
            clearTimeout(timer);
            if(Boolean(MapManager.currentMap) && Boolean(MapManager.currentMap.camera))
            {
               MapManager.currentMap.camera.scrollTo(0,800 - LayerManager.stageHeight,scrollComplete2);
            }
         },1000));
      }
      
      private function scrollComplete2() : void
      {
         var _loc1_:ActionInfo = ActionXMLInfo.getInfo(9002);
         var _loc2_:Point = new Point();
         _loc2_.x = MainManager.actorModel.pos.x + 200;
         _loc2_.y = MainManager.actorModel.pos.y + 200;
         MainManager.actorModel.addEventListener(MoveEvent.MOVE_END,this.onRunEnd);
         MainManager.actorModel.execAction(new PosMoveAction(_loc1_,_loc2_,true));
      }
      
      private function onRunEnd(param1:Event) : void
      {
         MainManager.actorModel.removeEventListener(MoveEvent.MOVE_END,this.onRunEnd);
         this.exeNext();
      }
      
      private function exeNext() : void
      {
         this.addHeadMovie();
         this.addTitleTips();
         switch(this._currentStepIndex)
         {
            case 0:
               this.exeStep0();
               break;
            case 1:
               this.exeStep1();
               break;
            case 2:
               this.exeStep2();
               break;
            case 3:
               this.exeStep3();
               break;
            case 4:
               this.completeNewPlayer();
         }
      }
      
      private function completeNewPlayer() : void
      {
         this._loader = new UILoader(ClientConfig.getCartoon("newhead"),LayerManager.topLevel,LoadingType.TITLE_AND_PERCENT,"正在加载片头动画...");
         this._loader.addEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this._loader.load();
      }
      
      private function onLoadComplete(param1:UILoadEvent) : void
      {
         this._background = new Shape();
         this._background.graphics.beginFill(0);
         this._background.graphics.drawRect(0,0,LayerManager.MAX_WIDTH,LayerManager.MAX_HEIGHT);
         this._loader.removeEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this._mainSWF = this._loader.content as MovieClip;
         LayerManager.topLevel.addChild(this._background);
         LayerManager.topLevel.addChild(this._mainSWF);
         this.layout();
         StageResizeController.instance.register(this.layout);
         this._mainSWF.addEventListener(Event.ENTER_FRAME,this.onMainEnter);
         this._mainSWF.gotoAndPlay(1);
      }
      
      private function onMainEnter(param1:Event) : void
      {
         if(this._mainSWF.currentFrame == this._mainSWF.totalFrames)
         {
            this._mainSWF.stop();
            this._mainSWF.removeEventListener(Event.ENTER_FRAME,this.onMainEnter);
            this.clearMainSwf();
            FightManager.quit();
         }
      }
      
      private function clearMainSwf() : void
      {
         if(this._mainSWF)
         {
            this._mainSWF.removeEventListener(Event.ENTER_FRAME,this.onMainEnter);
            DisplayUtil.removeForParent(this._background);
            DisplayUtil.removeForParent(this._mainSWF);
            this._mainSWF = null;
            StageResizeController.instance.unregister(this.layout);
         }
      }
      
      private function layout() : void
      {
         var _loc1_:Number = LayerManager.stageWidth / 960;
         var _loc2_:Number = LayerManager.stageHeight / 560;
         this._mainSWF.scaleX = _loc1_;
         this._mainSWF.scaleY = _loc2_;
      }
      
      private function exeStep0() : void
      {
         this.forbiddenSkill();
         this.showDialog();
      }
      
      private function showDialog() : void
      {
         var _loc1_:DialogExInfo = DialogExXmlInfo.getDialogInfoById(16001);
         var _loc2_:DialogAdapter = new DialogAdapter(MainManager.roleType,_loc1_,this.onDialogCallBack);
         _loc2_.show();
         var _loc3_:GuideAdapter = new GuideAdapter(12);
         _loc3_.show();
      }
      
      private function onDialogCallBack(param1:DialogExInfo) : void
      {
         if(param1.id == 16002)
         {
            this.completePro(0);
         }
      }
      
      private function completePro(param1:int) : void
      {
         this._steps[param1] = 1;
         if(param1 == 1)
         {
            MapManager.currentMap.camera.scrollTo(700,0);
            this.showArrow(false);
         }
         ++this._currentStepIndex;
         this.exeNext();
      }
      
      private function forbiddenSkill() : void
      {
         this._storedSkillInfos = KeyManager.getSkillKeys();
         KeyManager.upDateSkillQuickKeys(new Vector.<KeyInfo>());
      }
      
      private function resumeSkill() : void
      {
         var _loc3_:KeyInfo = null;
         var _loc1_:Array = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < 3)
         {
            _loc3_ = new KeyInfo();
            if(MainManager.roleType == Constant.ROLE_TYPE_WOLF && _loc2_ == 2)
            {
               _loc3_.funcID = KeyManager.skillQuickKeys[4];
            }
            else
            {
               _loc3_.funcID = KeyManager.skillQuickKeys[_loc2_];
            }
            _loc3_.dataID = this._skillConfig[MainManager.roleType - 1][_loc2_];
            _loc3_.lv = 20;
            _loc1_.push(_loc3_);
            _loc2_++;
         }
         KeyManager.setSkillQuickKeys(_loc1_,false);
      }
      
      private function exeStep1() : void
      {
         this.showArrow(true);
         this.startCatchMove();
      }
      
      private function startCatchMove() : void
      {
         MainManager.actorModel.addEventListener(MoveEvent.MOVE_ENTER,this.onMove);
      }
      
      private function onMove(param1:MoveEvent = null) : void
      {
         var _loc2_:Point = MainManager.actorModel.pos;
         var _loc3_:Number = Point.distance(_loc2_,this.ARROW_POSITION);
         if(_loc3_ < 50)
         {
            MainManager.actorModel.removeEventListener(MoveEvent.MOVE_ENTER,this.onMove);
            this.completePro(1);
         }
      }
      
      private function showArrow(param1:Boolean) : void
      {
         if(this._arrowMC)
         {
            DisplayUtil.removeForParent(this._arrowMC);
            this._arrowMC = null;
         }
         if(param1)
         {
            this._arrowMC = MapManager.currentMap.libManager.getMovieClip("MAP_newArray");
            this._arrowMC.x = this.ARROW_POSITION.x;
            this._arrowMC.y = this.ARROW_POSITION.y;
            MapManager.currentMap.contentLevel.addChild(this._arrowMC);
         }
      }
      
      private function exeStep2() : void
      {
         SocketConnection.send(CommandID.FIGHT_ACTIVITY_EFFECT,6,1,0);
         this.startCatchMonsterDie();
      }
      
      private function startCatchMonsterDie() : void
      {
         FightManager.instance.addEventListener(FightEvent.OGRE_CLEAR,this.onOgreClear);
      }
      
      private function onOgreClear(param1:Event) : void
      {
         FightManager.instance.removeEventListener(FightEvent.OGRE_CLEAR,this.onOgreClear);
         this.completePro(2);
      }
      
      private function exeStep3() : void
      {
         this.resumeSkill();
         SocketConnection.send(CommandID.FIGHT_ACTIVITY_EFFECT,6,2,0);
         TasksManager.addActionListener(TaskActionEvent.TASK_TOLLGATE_PASSED,String(this.NEW_PLAYER_STAGE_ID),this.onTollgatePassed);
      }
      
      private function removePKModel() : void
      {
         DisplayUtil.removeForParent(MapManager.currentMap.contentLevel["pkMC"]);
      }
      
      protected function onTollgatePassed(param1:TaskActionEvent) : void
      {
         TasksManager.removeActionListener(TaskActionEvent.TASK_TOLLGATE_PASSED,String(this.NEW_PLAYER_STAGE_ID),this.onTollgatePassed);
         this.completePro(3);
         this.hideHeadMovie();
         FightManager.outToMapID = 5;
      }
      
      private function addHeadMovie() : void
      {
         this.hideHeadMovie();
         if(Boolean(this._stepsMC) && Boolean(this._stepsMC[this._currentStepIndex]) && Boolean(MapManager.currentMap))
         {
            if(this._currentStepIndex == 3 && MainManager.roleType == Constant.ROLE_TYPE_WOLF)
            {
               this._headMC = MapManager.currentMap.libManager.getMovieClip("MAP_newTiitle3_8");
            }
            else
            {
               this._headMC = MapManager.currentMap.libManager.getMovieClip(this._stepsMC[this._currentStepIndex]);
            }
            this._headMC.x = 0;
            this._headMC.y = -MainManager.actorModel.height;
            MainManager.actorModel.addChild(this._headMC);
         }
      }
      
      private function hideHeadMovie() : void
      {
         if(this._headMC)
         {
            DisplayUtil.removeForParent(this._headMC);
            this._headMC = null;
         }
      }
      
      private function addTitleTips() : void
      {
         this.hideTitle();
         if(this._stepsTip[this._currentStepIndex])
         {
            this._titleMC = MapManager.currentMap.libManager.getMovieClip(this._stepsTip[this._currentStepIndex]);
            this._titleMC.x = LayerManager.stageWidth / 2;
            this._titleMC.y = LayerManager.stageHeight / 2 - 100;
            LayerManager.topLevel.addChild(this._titleMC);
            TweenLite.to(this._titleMC,5,{"alpha":0});
         }
      }
      
      private function hideTitle() : void
      {
         if(this._titleMC)
         {
            TweenLite.killTweensOf(this._titleMC);
            DisplayUtil.removeForParent(this._titleMC);
            this._titleMC = null;
         }
      }
      
      private function init() : void
      {
      }
      
      private function addEvent() : void
      {
         FightManager.instance.addEventListener(FightEvent.QUITE,this.onFightQuit);
      }
      
      private function removeEvent() : void
      {
         FightManager.instance.removeEventListener(FightEvent.OGRE_CLEAR,this.onOgreClear);
         MainManager.actorModel.removeEventListener(MoveEvent.MOVE_ENTER,this.onMove);
         TasksManager.removeActionListener(TaskActionEvent.TASK_TOLLGATE_PASSED,String(this.NEW_PLAYER_STAGE_ID),this.onTollgatePassed);
         MainManager.actorModel.removeEventListener(MoveEvent.MOVE_END,this.onRunEnd);
         FightManager.instance.removeEventListener(FightEvent.QUITE,this.onFightQuit);
      }
      
      private function onFightQuit(param1:Event) : void
      {
         this.resumeSkill();
      }
      
      public function destory() : void
      {
         this.removeEvent();
         this.hideTitle();
         this.hideHeadMovie();
         if(this._loader)
         {
            this._loader.destroy(true);
            this._loader = null;
         }
         this.clearMainSwf();
      }
   }
}

