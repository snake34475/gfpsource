package com.gfp.app.mapProcess
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.cartoon.event.AnimatEvent;
   import com.gfp.app.control.SystemTimeController;
   import com.gfp.core.CommandID;
   import com.gfp.core.cache.SoundCache;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.CommEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.NumberManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.sound.SoundManager;
   import com.gfp.core.ui.FightBloodBar;
   import com.gfp.core.ui.UINumber;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.StringConstants;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_56 extends MapProcessAnimat
   {
      
      private static const BIG_FOOT_OGRE_TASK_ID:uint = 1761;
      
      private static const DESTROY_DOOR_TO_WEST_TASK_ID:uint = 1787;
      
      private var footMc:SimpleButton;
      
      private var oneWayNpcPoints:Array = [new Point(744,619),new Point(755,550),new Point(728,753),new Point(236,520)];
      
      private var oneWaySwapIds:Array = [1830,1831,1832];
      
      private var oneWayModels:Array = [];
      
      private var oneWayDecHps:Array = [1,10,100];
      
      private var oneWayDoor:UserModel;
      
      private var doorMc:MovieClip;
      
      private var steleMc:MovieClip;
      
      private var totalHp:uint = 1;
      
      private var MAX_HP:uint = 4000000000;
      
      private var doSoundArr:Array = ["oneway_shi.mp3","oneway_tou.mp3","oneway_tong.mp3","oneway_door_over.mp3"];
      
      private var tempDecHpArr:Array = [0,0,0];
      
      private var bloodBar:FightBloodBar;
      
      public function MapProcess_56()
      {
         _mangoType = 1;
         super();
      }
      
      override protected function init() : void
      {
         _mangoType = 1;
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.swtichCompleteHandler);
      }
      
      private function swtichCompleteHandler(param1:MapEvent) : void
      {
         this.footMc = super._mapModel.contentLevel.getChildByName("foot_mc") as SimpleButton;
         this.footMc.visible = false;
         var _loc2_:uint = uint(TasksManager.getTaskProStatus(BIG_FOOT_OGRE_TASK_ID,0));
         if(Boolean(TasksManager.isAccepted(BIG_FOOT_OGRE_TASK_ID)) && _loc2_ == 0)
         {
            this.footMc.visible = true;
            this.footMc.addEventListener(MouseEvent.CLICK,this.clickBigFootHandler);
         }
         this.unloadMapRes();
      }
      
      private function unloadMapRes() : void
      {
         this.doorMc = super._mapModel.contentLevel.getChildByName("onewayDoor_mc") as MovieClip;
         DisplayUtil.removeForParent(this.doorMc);
         this.steleMc = super._mapModel.contentLevel.getChildByName("oneWayWestStele_mc") as MovieClip;
         DisplayUtil.removeForParent(this.steleMc);
      }
      
      private function initOneWayToWest() : void
      {
         if(SystemTimeController.instance.checkSysTimeAchieve(63))
         {
            this.MAX_HP = 80000000;
         }
         if(this.totalHp == 1)
         {
            this.totalHp = this.MAX_HP;
         }
         this.loadResCompleteHandler();
         var _loc1_:uint = uint(TasksManager.getTaskProStatus(DESTROY_DOOR_TO_WEST_TASK_ID,0));
         if(Boolean(TasksManager.isAccepted(DESTROY_DOOR_TO_WEST_TASK_ID)) && _loc1_ == 0)
         {
            AnimatPlay.startAnimat("task1787_",0);
            AnimatPlay.addAnimatListener(AnimatEvent.ANIMAT_END,this.animatCompleteHandler);
         }
      }
      
      private function animatCompleteHandler(param1:AnimatEvent) : void
      {
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_CUSTOM_FINISH,"1787_0");
      }
      
      private function loadResCompleteHandler() : void
      {
         var _loc1_:UserInfo = null;
         var _loc2_:String = null;
         _loc1_ = new UserInfo();
         _loc1_.roleType = 10001;
         _loc1_.pos = this.oneWayNpcPoints[3];
         this.oneWayDoor = new UserModel(_loc1_);
         this.oneWayDoor.buttonMode = true;
         MapManager.currentMap.addUser(10001,this.oneWayDoor);
         this.doorMc = super._mapModel.contentLevel.getChildByName("onewayDoor_mc") as MovieClip;
         DisplayUtil.removeForParent(this.doorMc);
         this.steleMc = super._mapModel.contentLevel.getChildByName("oneWayWestStele_mc") as MovieClip;
         DisplayUtil.removeForParent(this.steleMc);
         SocketConnection.addCmdListener(CommandID.ONE_WAY_WEST,this.oneWayWestHpChangeHandler);
         for each(_loc2_ in this.doSoundArr)
         {
            SoundCache.load(ClientConfig.getSoundOther(_loc2_),null,null);
         }
         this.bloodBar = new FightBloodBar(FightBloodBar.COLOR_ENEMY);
         this.bloodBar.init(this.MAX_HP);
         this.bloodBar.bloodCurrent = this.totalHp;
         this.bloodBar.x = 150;
         this.bloodBar.y = 565;
         super._mapModel.contentLevel.addChild(this.bloodBar);
      }
      
      private function oneWayWestStatusHandler(param1:CommEvent) : void
      {
         if(param1.data == 0)
         {
            if(this.doorMc)
            {
               this.doorMc.gotoAndStop(1);
            }
         }
         else
         {
            if(this.doorMc)
            {
               this.doorMc.gotoAndStop(4);
            }
            this.totalHp = 0;
            this.bloodBar.bloodCurrent = this.totalHp;
         }
      }
      
      private function clickOneWayDoorHandler(param1:MouseEvent) : void
      {
         ModuleManager.turnAppModule("OneWayWestTowPanel","正在加载......",this.totalHp);
      }
      
      private function clickOneWaySteleHandler(param1:MouseEvent) : void
      {
         ModuleManager.turnAppModule("OneWayWestIntrPanel","正在加载......");
      }
      
      private function oneWayWestHpChangeHandler(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         if(_loc4_ == 0)
         {
            this.doorMc.gotoAndStop(4);
            SoundManager.playSound(ClientConfig.getSoundOther(this.doSoundArr[3]));
            AnimatPlay.startAnimat("task1787_",1,false,233,131);
         }
         else if(this.totalHp - _loc4_ > 0)
         {
            this.reduceHp(this.totalHp - _loc4_,false);
            if(_loc4_ / this.MAX_HP <= 0.5)
            {
               this.doorMc.gotoAndStop(3);
            }
            else
            {
               this.doorMc.gotoAndStop(2);
            }
         }
         this.totalHp = _loc4_;
         this.bloodBar.bloodCurrent = _loc4_;
         _loc2_.position = 0;
      }
      
      private function reduceHp(param1:uint, param2:Boolean = true) : void
      {
         if(param2)
         {
            NumberManager.showSub(this.oneWayDoor,param1,UINumber.RED);
         }
      }
      
      private function destroyOneWay() : void
      {
         this.oneWayModels = null;
         this.doorMc = null;
         this.steleMc = null;
         this.bloodBar = null;
      }
      
      private function clickBigFootHandler(param1:MouseEvent) : void
      {
         TextAlert.show("哇好大的脚印啊，看起来是一种大型的动物，回去问问琳达。");
         this.footMc.removeEventListener(MouseEvent.CLICK,this.clickBigFootHandler);
         TasksManager.dispatchActionEvent(TaskActionEvent.TASK_CUSTOM_FINISH,BIG_FOOT_OGRE_TASK_ID + StringConstants.SIGN + "0");
      }
      
      override public function destroy() : void
      {
         this.footMc.removeEventListener(MouseEvent.CLICK,this.clickBigFootHandler);
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.swtichCompleteHandler);
         super.destroy();
      }
   }
}

