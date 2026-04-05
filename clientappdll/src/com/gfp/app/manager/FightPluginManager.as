package com.gfp.app.manager
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.app.manager.fightPlugin.AutoFightManager;
   import com.gfp.app.manager.fightPlugin.AutoRecoverManager;
   import com.gfp.app.manager.fightPlugin.AutoTollgateTransManager;
   import com.gfp.app.toolBar.FightToolBar;
   import com.gfp.app.toolBar.QuickBarComponent;
   import com.gfp.core.controller.KeyController;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.TaskCommonEvent;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.FocusManager;
   import com.gfp.core.manager.FunctionManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.MapManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class FightPluginManager
   {
      
      private static var _instance:FightPluginManager;
      
      public static const FREE_TIMES:uint = 20;
      
      public static const PLUGIN_CHANGE:String = "Plugin_change";
      
      public static const PLUGIN_CANCEL:String = "plugin_cancel";
      
      public var baseHpPer:uint = 50;
      
      public var baseMpPer:uint = 50;
      
      public var baseSummonMp:uint = 50;
      
      public var isAutoSummonSkill:Boolean = true;
      
      public var isAutoPickItem:Boolean = true;
      
      public var isAutoRevive:Boolean = true;
      
      public var isAutoBuyRevive:Boolean = false;
      
      public var isAutoRepair:Boolean = true;
      
      private var _leftTime:int = 1;
      
      private var _isPluginRunning:Boolean;
      
      private var _fightFlag:Sprite;
      
      private var _isGameOver:Boolean;
      
      private var _ed:EventDispatcher = new EventDispatcher();
      
      private var _noSendPassIdList:Array = [1119401,1119501,1120001];
      
      public function FightPluginManager()
      {
         super();
      }
      
      public static function get instance() : FightPluginManager
      {
         if(_instance == null)
         {
            _instance = new FightPluginManager();
         }
         return _instance;
      }
      
      public static function addEventListener(param1:String, param2:Function) : void
      {
         instance._ed.addEventListener(param1,param2);
      }
      
      public static function removeEventListener(param1:String, param2:Function) : void
      {
         instance._ed.removeEventListener(param1,param2);
      }
      
      public function setup(param1:uint, param2:uint, param3:int) : void
      {
         this.leftTime = param3;
         FunctionManager.disabledFightAwardPanel = true;
         this._isPluginRunning = true;
         this._isGameOver = false;
         AutoFightManager.instance.setup();
         AutoRecoverManager.instance.setup();
         AutoTollgateTransManager.instance.setup();
         this._fightFlag = new UI_AutoFighting();
         LayerManager.topLevel.addChild(this._fightFlag);
         DisplayUtil.align(this._fightFlag,null,AlignType.MIDDLE_CENTER);
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         KeyController.addEventListener(KeyController.FUNCTION_KEY_DOWN,this.onKeyDown);
         FightToolBar.addEventListener(QuickBarComponent.FUNCTION_BTN_CLICK,this.onBtnClick);
         TasksManager.addCommonListener(TaskCommonEvent.TASK_BRUISE_LESSLIMIT,this.onTollgatePass);
         FightManager.instance.addEventListener(FightEvent.QUITE,this.onFightQuit);
      }
      
      private function removeEvent() : void
      {
         KeyController.removeEventListener(KeyController.FUNCTION_KEY_DOWN,this.onKeyDown);
         FightToolBar.removeEventListener(QuickBarComponent.FUNCTION_BTN_CLICK,this.onBtnClick);
         TasksManager.removeCommonListener(TaskCommonEvent.TASK_BRUISE_LESSLIMIT,this.onTollgatePass);
         FightManager.instance.removeEventListener(FightEvent.QUITE,this.onFightQuit);
         AutoTollgateTransManager.removeEventListener(AutoTollgateTransManager.ITEM_PICK_COMPLETE,this.refreshTollgate);
      }
      
      private function onKeyDown(param1:Event) : void
      {
         this.stop();
         this._ed.dispatchEvent(new Event(PLUGIN_CHANGE));
      }
      
      private function onBtnClick(param1:Event) : void
      {
         this.stop();
         this._ed.dispatchEvent(new Event(PLUGIN_CHANGE));
      }
      
      public function stop() : void
      {
         KeyController.removeEventListener(KeyController.FUNCTION_KEY_DOWN,this.onKeyDown);
         FightToolBar.removeEventListener(QuickBarComponent.FUNCTION_BTN_CLICK,this.onBtnClick);
         DisplayUtil.removeForParent(this._fightFlag);
         this._isPluginRunning = false;
         AutoFightManager.destroy();
         AutoRecoverManager.destroy();
         FunctionManager.disabledFightAwardPanel = false;
         FunctionManager.disabledFightRevive = false;
         FocusManager.setDefaultFocus();
         MainManager.actorModel.actionManager.clear();
         MainManager.actorModel.execStandAction();
      }
      
      public function goOn() : void
      {
         this.resetPlugin();
         if(this._isGameOver)
         {
            AutoTollgateTransManager.addEventListener(AutoTollgateTransManager.ITEM_PICK_COMPLETE,this.refreshTollgate);
            AutoTollgateTransManager.instance.enterNextRoom();
         }
         else
         {
            AutoFightManager.instance.aimTarget();
         }
      }
      
      private function resetPlugin() : void
      {
         if(this._fightFlag == null)
         {
            this._fightFlag = new UI_AutoFighting();
         }
         LayerManager.topLevel.addChild(this._fightFlag);
         DisplayUtil.align(this._fightFlag,null,AlignType.MIDDLE_CENTER);
         this._isPluginRunning = true;
         AutoFightManager.instance.setup();
         AutoRecoverManager.instance.setup();
         FunctionManager.disabledFightAwardPanel = true;
         this.addEvent();
      }
      
      private function sendPassBox() : void
      {
         if(this._noSendPassIdList.indexOf(MapManager.currentMap.info.id) != -1)
         {
            return;
         }
         this.selectBox(true);
         if(MainManager.actorInfo.isVip)
         {
            this.selectBox(false);
         }
      }
      
      private function selectBox(param1:Boolean) : void
      {
         var _loc2_:ByteArray = new ByteArray();
         if(param1)
         {
            _loc2_.writeByte(1);
            _loc2_.writeByte(0);
         }
         else
         {
            _loc2_.writeByte(2);
            _loc2_.writeByte(0);
         }
      }
      
      private function onTollgatePass(param1:TaskCommonEvent) : void
      {
         TasksManager.removeCommonListener(TaskCommonEvent.TASK_BRUISE_LESSLIMIT,this.onTollgatePass);
         this.sendPassBox();
         --this.leftTime;
         this._isGameOver = true;
         if(this._isPluginRunning)
         {
            AutoFightManager.destroy();
            AutoTollgateTransManager.addEventListener(AutoTollgateTransManager.ITEM_PICK_COMPLETE,this.refreshTollgate);
            AutoTollgateTransManager.instance.enterNextRoom();
         }
         else if(this.leftTime > 0)
         {
            AlertManager.showSimpleAlert("小侠士，你的自动战斗次数还剩" + this.leftTime + "次，是否继续使用？",this.refreshTollgate,this.destroy);
         }
         else
         {
            this.destroy();
         }
      }
      
      private function refreshTollgate(param1:Event = null) : void
      {
         AutoTollgateTransManager.removeEventListener(AutoTollgateTransManager.ITEM_PICK_COMPLETE,this.refreshTollgate);
         this._isGameOver = false;
         if(this.leftTime > 0)
         {
            this.resetPlugin();
            PveEntry.afreshTollgate();
            this._ed.dispatchEvent(new Event(PLUGIN_CHANGE));
         }
         else
         {
            this.destroy();
         }
      }
      
      private function onFightQuit(param1:FightEvent) : void
      {
         this.destroy();
      }
      
      public function set leftTime(param1:int) : void
      {
         param1 = param1 > 0 ? param1 : 0;
         if(param1 <= 1)
         {
            FunctionManager.disabledFightAwardPanel = false;
         }
         else
         {
            FunctionManager.disabledFightAwardPanel = true;
         }
         this._leftTime = param1;
      }
      
      public function get leftTime() : int
      {
         return this._leftTime;
      }
      
      public function get isPluginRunning() : Boolean
      {
         return this._isPluginRunning;
      }
      
      public function set isPluginRunning(param1:Boolean) : void
      {
         this._isPluginRunning = param1;
      }
      
      public function destroy() : void
      {
         this._isPluginRunning = false;
         FunctionManager.disabledFightAwardPanel = false;
         this.removeEvent();
         AutoFightManager.instance.destroy();
         AutoRecoverManager.destroy();
         AutoTollgateTransManager.destroy();
         DisplayUtil.removeForParent(this._fightFlag);
         this._fightFlag = null;
         this._ed.dispatchEvent(new Event(PLUGIN_CANCEL));
      }
   }
}

