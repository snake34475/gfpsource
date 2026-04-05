package com.gfp.app.mapProcess
{
   import com.gfp.app.toolBar.CityToolBar;
   import com.gfp.core.CommandID;
   import com.gfp.core.action.mouse.MouseProcess;
   import com.gfp.core.action.summon.EvolveAction;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.config.xml.SummonXMLInfo;
   import com.gfp.core.events.SummonEvent;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.info.SummonInfo;
   import com.gfp.core.info.SummonSkillInfo;
   import com.gfp.core.info.UserSummonInfos;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.SummonEvolveManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.model.SummonModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.UILoader;
   import com.gfp.core.ui.loading.LoadingType;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import flash.utils.setTimeout;
   import org.taomee.ds.HashMap;
   import org.taomee.motion.easing.Quad;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_23 extends MapProcessAnimat
   {
      
      private static var stoneItemIDMap:HashMap = new HashMap();
      
      public static var beastOffsetMap:HashMap = new HashMap();
      
      stoneItemIDMap.add(1,1400114);
      stoneItemIDMap.add(2,1400115);
      stoneItemIDMap.add(3,1400116);
      beastOffsetMap.add(1400047,[1220,-80]);
      beastOffsetMap.add(1400067,[1463,95]);
      beastOffsetMap.add(1400075,[1491,130]);
      beastOffsetMap.add(1400113,[1491,100]);
      beastOffsetMap.add(1410002,[1461,70]);
      beastOffsetMap.add(1410003,[1421,12]);
      beastOffsetMap.add(1410004,[1451,100]);
      beastOffsetMap.add(1410005,[1430,45]);
      beastOffsetMap.add(1410009,[1461,100]);
      beastOffsetMap.add(1410010,[1450,-25]);
      beastOffsetMap.add(1410014,[1430,115]);
      
      private const CAMERA_TARGET_Y:Number = 10;
      
      private var _glowMC:MovieClip;
      
      private var _collarMC:MovieClip;
      
      private var _callBeastMC:MovieClip;
      
      private var _beastEvolveMC:MovieClip;
      
      private var _cameraX:Number;
      
      private var _cameraY:Number;
      
      private var _hatchId:int;
      
      private var _summonEntery:MovieClip;
      
      private var _task1125MC:MovieClip;
      
      private var _task1125CloseBtn:SimpleButton;
      
      private var _loader:UILoader;
      
      public function MapProcess_23()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._glowMC = _mapModel.libManager.getMovieClip("glow");
         this._collarMC = _mapModel.libManager.getMovieClip("collar");
         this._beastEvolveMC = _mapModel.libManager.getMovieClip("beast_evolve");
         this.initTaskEvent();
         this.initGlow();
         this.initSecretStone();
      }
      
      private function initTaskEvent() : void
      {
         TasksManager.addListener(TaskEvent.COMPLETE,this.onTaskComplete);
      }
      
      private function onTaskComplete(param1:TaskEvent) : void
      {
         if(param1.taskID == 1255)
         {
            SightManager.getSightModel(1090901).visible = true;
         }
      }
      
      private function initGlow() : void
      {
         this._hatchId = SummonManager.getCanHatchID();
         if(this._hatchId != 0)
         {
            if(ItemManager.getItemCount(this._hatchId) > 0)
            {
               _mapModel.contentLevel.addChild(this._glowMC);
               this._glowMC.x = 1460;
               this._glowMC.y = 91;
               this._glowMC.buttonMode = true;
               this._glowMC.addEventListener(MouseEvent.CLICK,this.onGlowClick);
            }
         }
         else
         {
            DisplayUtil.removeForParent(this._glowMC);
            this._glowMC.removeEventListener(MouseEvent.CLICK,this.onGlowClick);
         }
         var _loc1_:SummonInfo = SummonManager.getActorSummonInfo().currentSummonInfo;
         if(Boolean(_loc1_) && Boolean(SummonEvolveManager.isCurrentSummonEvolveAble()))
         {
            _mapModel.contentLevel.addChild(this._glowMC);
            this._glowMC.x = 1460;
            this._glowMC.y = 91;
            this._glowMC.buttonMode = true;
            this._glowMC.addEventListener(MouseEvent.CLICK,this.onEvolveClick);
         }
      }
      
      private function initSecretStone() : void
      {
         var _loc2_:MovieClip = null;
         var _loc4_:int = 0;
         if(!TasksManager.isCompleted(1255))
         {
            SightManager.getSightModel(1090901).visible = false;
         }
         var _loc1_:int = 3;
         var _loc3_:int = 1;
         while(_loc3_ <= _loc1_)
         {
            _loc4_ = int(stoneItemIDMap.getValue(_loc3_));
            _loc2_ = _mapModel.upLevel["secretStone_" + _loc3_];
            if(!TasksManager.isTaskProComplete(1255,0))
            {
               DisplayUtil.removeForParent(_loc2_);
            }
            else if(ItemManager.getItemCount(_loc4_) <= 0)
            {
               if(TasksManager.isTaskProComplete(1255,0))
               {
                  _loc2_.buttonMode = true;
                  _loc2_.addEventListener(MouseEvent.CLICK,this.onSecretStoneClick);
               }
            }
            else
            {
               DisplayUtil.removeForParent(_loc2_);
            }
            _loc3_++;
         }
         if(TasksManager.isTaskProComplete(1255,0))
         {
            if(this._summonEntery == null)
            {
               this._summonEntery = _mapModel.downLevel["summonEntery"];
            }
            this._summonEntery.addEventListener(MouseEvent.CLICK,this.onEnterSummonMap);
            this._summonEntery.buttonMode = true;
         }
      }
      
      private function onEnterSummonMap(param1:MouseEvent) : void
      {
         if(ItemManager.getItemCount(1400114) < 1 || ItemManager.getItemCount(1400115) < 1 || ItemManager.getItemCount(1400116) < 1)
         {
            this.showStonPoor();
            return;
         }
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_MAPCOLLECT,"openSecretStone");
      }
      
      private function showStonPoor() : void
      {
         if(this._task1125MC == null)
         {
            this._task1125MC = _mapModel.libManager.getMovieClip("task1125UI");
         }
         DisplayUtil.removeForParent(this._task1125MC);
         LayerManager.topLevel.addChild(this._task1125MC);
         DisplayUtil.align(this._task1125MC,null,AlignType.MIDDLE_CENTER);
         this._task1125CloseBtn = this._task1125MC["closeBtn"];
         this._task1125CloseBtn.addEventListener(MouseEvent.CLICK,this.onTask1125Close);
      }
      
      private function onTask1125Close(param1:MouseEvent) : void
      {
         this._task1125CloseBtn.removeEventListener(MouseEvent.CLICK,this.onTask1125Close);
         DisplayUtil.removeForParent(this._task1125MC);
         AlertManager.showSimpleAlarm(AppLanguageDefine.NPC_DIALOG_MAP23[0]);
      }
      
      private function onSecretStoneClick(param1:MouseEvent) : void
      {
         var _loc2_:int = this.getItemIdByStonName(param1.target.name);
         if(ItemManager.getItemCount(_loc2_) <= 0)
         {
            this.playStoneToBag(param1.target as MovieClip);
         }
         var _loc3_:MovieClip = param1.target as MovieClip;
         _loc3_.removeEventListener(MouseEvent.CLICK,this.onSecretStoneClick);
         _loc3_.buttonMode = false;
      }
      
      private function playStoneToBag(param1:MovieClip) : void
      {
         DisplayUtil.removeForParent(param1);
         LayerManager.topLevel.addChild(param1);
         DisplayUtil.align(param1,null,AlignType.MIDDLE_CENTER);
         TweenLite.to(param1,1,{
            "x":670,
            "y":520,
            "ease":Quad.easeIn,
            "onComplete":this.onStoneToBag,
            "onCompleteParams":[param1]
         });
      }
      
      private function onStoneToBag(param1:MovieClip) : void
      {
         var _loc2_:int = this.getItemIdByStonName(param1.name);
         if(ItemManager.getItemCount(_loc2_) <= 0)
         {
            ItemManager.buyItem(_loc2_,false,1);
         }
         DisplayUtil.removeForParent(param1);
      }
      
      private function getItemIdByStonName(param1:String) : int
      {
         var _loc2_:int = param1.indexOf("_") + 1;
         var _loc3_:int = int(param1.substr(_loc2_,param1.length - _loc2_));
         return stoneItemIDMap.getValue(_loc3_);
      }
      
      private function checkNeedMonster(param1:uint) : Boolean
      {
         var _loc2_:int = int(SummonXMLInfo.getHatchNeedMonster(param1));
         if(_loc2_ <= 0)
         {
            return true;
         }
         return SummonManager.getActorSummonInfo().isHaveSummonByType(_loc2_);
      }
      
      private function onGlowClick(param1:MouseEvent) : void
      {
         var _loc2_:UserSummonInfos = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         if(ItemManager.getItemCount(this._hatchId) > 0)
         {
            _loc2_ = SummonManager.getActorSummonInfo();
            if(SummonManager.getActorSummonInfo().selectedSummonInfo == null)
            {
               _loc3_ = int(SummonManager.getCanHatchID());
               if(_loc3_ > 0)
               {
                  _loc4_ = int(SummonXMLInfo.getHatchSummon(_loc3_));
                  _loc5_ = SummonXMLInfo.getName(_loc4_);
                  AlertManager.showSimpleAlert("小侠士，你当前没有可用仙兽！" + _loc5_ + "已可以孵化，是否孵化",this.toHatch);
               }
               else
               {
                  AlertManager.showSimpleAlarm(AppLanguageDefine.CITYTOOLBAR_CHARACTER_COLLECTION[6]);
               }
               return;
            }
            MouseProcess.execWalk(MainManager.actorModel,new Point(1521,317));
            AlertManager.showSimpleAlert("小侠士，你现在可以在仙兽面板中直接孵化或者进化你的仙兽了。",this.hatchSummon);
         }
      }
      
      private function toHatch() : void
      {
         var _loc1_:int = int(SummonManager.getCanHatchID());
         SummonManager.hatchSummon(_loc1_);
      }
      
      private function hatchSummon() : void
      {
         ModuleManager.turnAppModule("NewSummonInfoPanel","加载仙兽信息面板");
      }
      
      private function playCollarToAltar() : void
      {
         var _loc1_:Number = Number(MainManager.actorModel.x);
         var _loc2_:Number = MainManager.actorModel.y - MainManager.actorModel.height / 2;
         _mapModel.contentLevel.addChild(this._collarMC);
         this._collarMC.x = _loc1_;
         this._collarMC.y = _loc2_;
         TweenLite.to(this._collarMC,1,{
            "x":1460,
            "y":80,
            "ease":Quad.easeIn,
            "onComplete":this.onFinishToAltar
         });
      }
      
      private function onFinishToAltar() : void
      {
         DisplayUtil.removeForParent(this._collarMC);
         this.playCallBeast();
      }
      
      private function playCallBeast() : void
      {
         this._loader = new UILoader(ClientConfig.getCartoon("call_beast_" + this._hatchId),LayerManager.topLevel,LoadingType.TITLE_AND_PERCENT,"正在加载任务动画...");
         this._loader.addEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this._loader.load();
      }
      
      private function onLoadComplete(param1:UILoadEvent) : void
      {
         this._loader.removeEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
         this._callBeastMC = param1.uiloader.loader.content as MovieClip;
         this.playToCallBeast();
      }
      
      private function playToCallBeast() : void
      {
         this._callBeastMC.addEventListener(Event.ENTER_FRAME,this.onCallBeastEnter);
         _mapModel.contentLevel.addChild(this._callBeastMC);
         var _loc1_:Array = beastOffsetMap.getValue(this._hatchId);
         if(_loc1_ == null)
         {
            this._callBeastMC.x = 1491;
            this._callBeastMC.y = 130;
         }
         else
         {
            this._callBeastMC.x = _loc1_[0];
            this._callBeastMC.y = _loc1_[1];
         }
         this._callBeastMC.gotoAndPlay(1);
      }
      
      private function onCallBeastEnter(param1:Event) : void
      {
         if(this._callBeastMC.currentFrame == this._callBeastMC.totalFrames)
         {
            this._callBeastMC.removeEventListener(Event.ENTER_FRAME,this.onCallBeastEnter);
            DisplayUtil.removeForParent(this._callBeastMC);
            if(this._hatchId == 1400047)
            {
               this.playBeastToBag();
            }
            else
            {
               this.onFinishToBag();
            }
         }
      }
      
      private function playBeastToBag() : void
      {
         var _loc1_:Number = Number(MainManager.actorModel.x);
         var _loc2_:Number = MainManager.actorModel.y - MainManager.actorModel.height / 2;
         LayerManager.topLevel.addChild(this._collarMC);
         this._collarMC.x = 784;
         this._collarMC.y = 155;
         TweenLite.to(this._collarMC,1,{
            "x":710,
            "y":520,
            "ease":Quad.easeIn,
            "onComplete":this.onFinishToBag
         });
      }
      
      private function onFinishToBag() : void
      {
         DisplayUtil.removeForParent(this._collarMC);
         SummonManager.addEventListener(SummonEvent.SUMMON_HATCH,this.onSummonHatch);
         SummonManager.hatchSummon(this._hatchId);
      }
      
      private function onSummonHatch(param1:SummonEvent) : void
      {
         this.initGlow();
      }
      
      private function onEvolveClick(param1:MouseEvent) : void
      {
         AlertManager.showSimpleAlert("小侠士，你现在可以在仙兽面板中直接孵化或者进化你的仙兽了。",this.hatchSummon);
      }
      
      private function isHaveNeedItem(param1:SummonInfo) : Boolean
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc2_:int = int(SummonXMLInfo.getNeedItem(param1.roleID + 1));
         if(ItemManager.getItemCount(_loc2_) > 0 || _loc2_ == 0)
         {
            return true;
         }
         _loc3_ = SummonXMLInfo.getName(param1.roleID + 1);
         _loc4_ = ItemXMLInfo.getName(_loc2_);
         AlertManager.showSimpleAlarm(AppLanguageDefine.NPC_DIALOG_MAP23[3] + _loc3_ + AppLanguageDefine.NPC_DIALOG_MAP23[4] + _loc4_ + AppLanguageDefine.NPC_DIALOG_MAP23[5]);
         return false;
      }
      
      private function playBeastEvolve() : void
      {
         this._beastEvolveMC.addEventListener(Event.ENTER_FRAME,this.onBeastEvolveEnter);
         _mapModel.contentLevel.addChild(this._beastEvolveMC);
         this._beastEvolveMC.x = 1465;
         this._beastEvolveMC.y = 41;
         this._beastEvolveMC.gotoAndPlay(1);
      }
      
      private function onBeastEvolveEnter(param1:Event) : void
      {
         if(this._beastEvolveMC.currentFrame == this._beastEvolveMC.totalFrames)
         {
            this._beastEvolveMC.removeEventListener(Event.ENTER_FRAME,this.onBeastEvolveEnter);
            DisplayUtil.removeForParent(this._beastEvolveMC);
            this.sendToServerEvolve();
         }
      }
      
      private function sendToServerEvolve() : void
      {
         var _loc1_:SummonInfo = SummonManager.getActorSummonInfo().currentSummonInfo;
         SocketConnection.addCmdListener(CommandID.SUMMON_EVOLVE,this.onSummonEvolve);
         SocketConnection.send(CommandID.SUMMON_EVOLVE,_loc1_.uniqueID);
      }
      
      private function onSummonEvolve(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.SUMMON_EVOLVE,this.onSummonEvolve);
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:Array = [];
         var _loc6_:uint = _loc2_.readUnsignedInt();
         var _loc7_:uint = 0;
         while(_loc7_ < _loc6_)
         {
            _loc5_.push(new SummonSkillInfo(_loc2_));
            _loc7_++;
         }
         this.costLevelUpItem(_loc4_);
         SummonManager.summonEvolveUpdate(_loc3_,_loc4_,_loc5_);
         var _loc8_:SummonModel = SummonManager.getUserSummonModel(MainManager.actorID);
         if(_loc8_)
         {
            _loc8_.execAction(new EvolveAction());
            setTimeout(SummonManager.updateSummonView,2000,MainManager.actorID);
         }
         CityToolBar.instance.updateSummonEvolveState();
      }
      
      private function costLevelUpItem(param1:int) : void
      {
         var _loc2_:int = int(SummonXMLInfo.getNeedItem(param1));
         ItemManager.removeItem(_loc2_,1);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(this._loader != null)
         {
            this._loader.addEventListener(UILoadEvent.COMPLETE,this.onLoadComplete);
            this._loader.destroy();
            this._loader = null;
         }
         if(this._task1125MC != null)
         {
            this._task1125MC = null;
            this._task1125CloseBtn.removeEventListener(MouseEvent.CLICK,this.onTask1125Close);
            this._task1125CloseBtn = null;
         }
         TasksManager.removeListener(TaskEvent.COMPLETE,this.onTaskComplete);
         this._glowMC.removeEventListener(MouseEvent.CLICK,this.onGlowClick);
         if(this._callBeastMC)
         {
            this._callBeastMC.stop();
            this._callBeastMC.removeEventListener(Event.ENTER_FRAME,this.onCallBeastEnter);
         }
         this._beastEvolveMC.stop();
         this._beastEvolveMC.removeEventListener(Event.ENTER_FRAME,this.onBeastEvolveEnter);
         SocketConnection.removeCmdListener(CommandID.SUMMON_HATCH,this.onSummonHatch);
      }
   }
}

