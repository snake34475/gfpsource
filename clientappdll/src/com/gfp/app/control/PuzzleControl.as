package com.gfp.app.control
{
   import com.gfp.app.manager.FightGroupManager;
   import com.gfp.app.toolBar.Battery;
   import com.gfp.app.toolBar.MailSysEntry;
   import com.gfp.core.CommandID;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.MapModel;
   import com.gfp.core.model.sensemodels.TeleporterModel;
   import com.gfp.core.model.sensemodels.TollgateModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.ItemIconTip;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.FilterUtil;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class PuzzleControl extends EventDispatcher
   {
      
      private static var _instance:PuzzleControl;
      
      private const RIGHT_ITEM_ID:uint = 1500572;
      
      private var _totalRound:uint = 10;
      
      private var _isUseItem:Boolean;
      
      private var _roomID:uint;
      
      private var _round:uint;
      
      private var _rightTime:uint;
      
      private var _errorTime:uint;
      
      private var _currentPuzzleID:uint;
      
      private var _puzzleMsgUI:Sprite;
      
      private var _puzzleRightItemUI:Sprite;
      
      private var _puzzleTeamEnterUI:Sprite;
      
      private var _puzzlePassUI:Sprite;
      
      private var _puzzleHelpUI:Sprite;
      
      private var _puzzleWrongClearUI:Sprite;
      
      private var _puzzleRightTipUI:Sprite;
      
      private var _puzzleClearWrongTipUI:Sprite;
      
      public function PuzzleControl()
      {
         super();
      }
      
      public static function get instance() : PuzzleControl
      {
         if(_instance == null)
         {
            _instance = new PuzzleControl();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this.addMapEvents();
      }
      
      private function addMapEvents() : void
      {
         MapManager.addEventListener(MapEvent.MAP_SWITCH_OPEN,this.onMapSwitchOpen);
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onMapSwitchComplete);
         SocketConnection.addCmdListener(CommandID.PUZZLE_ALWAYSRIGHT_SET,this.onSetAlwaysRight);
      }
      
      private function onMapSwitchOpen(param1:MapEvent) : void
      {
         var _loc2_:MapModel = param1.mapModel;
         if(Boolean(_loc2_) && Boolean(_loc2_.info))
         {
            if(_loc2_.info.id < 43 || _loc2_.info.id > 52 && _loc2_.info.id < 1000)
            {
               this.puzzleMapUnLimit();
            }
         }
      }
      
      private function onMapSwitchComplete(param1:MapEvent) : void
      {
         this._isUseItem = false;
         var _loc2_:MapModel = param1.mapModel;
         if(_loc2_.info.id >= 43 && _loc2_.info.id <= 52)
         {
            if(ItemManager.getItemCount(1500572) > 0)
            {
               AlertManager.showSimpleAlert("答题过程中，你是否使用“陆半仙天书”？（点击“确定”，回答错误后将自动扣除“陆半仙天书”）",this.useItemConfirm);
            }
            this.puzzleMapLimit();
            this.showPuzzleUI();
         }
         else
         {
            this.destroyUI();
         }
      }
      
      private function useItemConfirm() : void
      {
         SocketConnection.send(CommandID.PUZZLE_ALWAYSRIGHT_SET);
      }
      
      private function onSetAlwaysRight(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         this._isUseItem = _loc2_.readUnsignedInt() == 1;
      }
      
      public function puzzleMapLimit() : void
      {
         MailSysEntry.instance.hide();
         Battery.instance.hide();
      }
      
      public function puzzleMapUnLimit() : void
      {
         MailSysEntry.instance.show();
         Battery.instance.show();
      }
      
      private function showPuzzleUI() : void
      {
         this._puzzleMsgUI = UIManager.getSprite("ToolBar_PuzzleMsgShow");
         LayerManager.topLevel.addChild(this._puzzleMsgUI);
         DisplayUtil.align(this._puzzleMsgUI,null,AlignType.TOP_LEFT);
         this._puzzleRightItemUI = UIManager.getSprite("ToolBar_PuzzleRightItem");
         LayerManager.topLevel.addChild(this._puzzleRightItemUI);
         DisplayUtil.align(this._puzzleRightItemUI,null,AlignType.BOTTOM_RIGHT);
         this.loadIcon();
      }
      
      public function showTeamEnterBar() : void
      {
         if(FightGroupManager.instance.hasFightGroup())
         {
            this._puzzleTeamEnterUI = UIManager.getSprite("UI_SWF_PuzzleTeamUI");
            LayerManager.topLevel.addChild(this._puzzleTeamEnterUI);
            DisplayUtil.align(this._puzzleTeamEnterUI,null,AlignType.MIDDLE_LEFT);
            this._puzzlePassUI = this._puzzleTeamEnterUI["puzzlePassUI"];
            ToolTipManager.add(this._puzzlePassUI,"可以抵消一次错误的回答，使用后消失");
            this._puzzleHelpUI = this._puzzleTeamEnterUI["puzzleHelpUI"];
            this._puzzleHelpUI.buttonMode = true;
            ToolTipManager.add(this._puzzleHelpUI,"求助场外队友");
            this._puzzleWrongClearUI = this._puzzleTeamEnterUI["puzzleWrongClearUI"];
            this._puzzleWrongClearUI.buttonMode = true;
            ToolTipManager.add(this._puzzleWrongClearUI,"去除两个错误答案");
            this._puzzleRightTipUI = this._puzzleTeamEnterUI["puzzleRightTipUI"];
            this._puzzleRightTipUI.visible = false;
            this._puzzleClearWrongTipUI = this._puzzleTeamEnterUI["puzzleClearWrongTipUI"];
            this._puzzleClearWrongTipUI.visible = false;
            this.addEventForTeamEnter();
         }
      }
      
      private function addEventForTeamEnter() : void
      {
         this._puzzleHelpUI.addEventListener(MouseEvent.CLICK,this.onPuzzleHelpClick);
         this._puzzleWrongClearUI.addEventListener(MouseEvent.CLICK,this.onPuzzleWrongClearClick);
         SocketConnection.addCmdListener(CommandID.PUZZLE_TEAM_REQUEST,this.onPuzzleTeamRequest);
         FightGroupManager.instance.ed.addEventListener(FightGroupManager.FIGHT_GROUP_QUIT,this.onFightGroupQuit);
      }
      
      private function removeEventForTeamEnter() : void
      {
         if(this._puzzleHelpUI)
         {
            this._puzzleHelpUI.removeEventListener(MouseEvent.CLICK,this.onPuzzleHelpClick);
         }
         if(this._puzzleWrongClearUI)
         {
            this._puzzleWrongClearUI.removeEventListener(MouseEvent.CLICK,this.onPuzzleWrongClearClick);
         }
         SocketConnection.removeCmdListener(CommandID.PUZZLE_TEAM_REQUEST,this.onPuzzleTeamRequest);
         FightGroupManager.instance.ed.removeEventListener(FightGroupManager.FIGHT_GROUP_QUIT,this.onFightGroupQuit);
      }
      
      private function onFightGroupQuit(param1:Event) : void
      {
         this.removeEventForTeamEnter();
         DisplayUtil.removeForParent(this._puzzleTeamEnterUI);
         this._puzzleTeamEnterUI = null;
         TextAlert.show("小侠士，你的队伍已解散。");
      }
      
      public function setTeamPass(param1:uint) : void
      {
         if(param1 == 1)
         {
            if(this._puzzlePassUI)
            {
               ToolTipManager.remove(this._puzzlePassUI);
               DisplayUtil.removeForParent(this._puzzlePassUI);
            }
         }
      }
      
      private function onPuzzleHelpClick(param1:Event) : void
      {
         if(this.currentPuzzleID != 0)
         {
            SocketConnection.send(CommandID.PUZZLE_TEAM_REQUEST,this.currentPuzzleID,1);
         }
      }
      
      private function onPuzzleWrongClearClick(param1:Event) : void
      {
         if(this.currentPuzzleID != 0)
         {
            SocketConnection.send(CommandID.PUZZLE_TEAM_REQUEST,this.currentPuzzleID,2);
         }
      }
      
      private function onPuzzleTeamRequest(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         if(_loc4_ == 1)
         {
            this._puzzleRightTipUI.visible = true;
            this._puzzleRightTipUI["answerTxt"].text = this.getChineseAnswer(_loc5_);
            this._puzzleHelpUI.mouseEnabled = false;
            this._puzzleHelpUI.filters = FilterUtil.GRAY_FILTER;
         }
         if(_loc4_ == 2)
         {
            this._puzzleClearWrongTipUI.visible = true;
            this.showClearWrongTip(_loc5_);
            this._puzzleWrongClearUI.mouseEnabled = false;
            this._puzzleWrongClearUI.filters = FilterUtil.GRAY_FILTER;
         }
      }
      
      private function getChineseAnswer(param1:uint) : String
      {
         switch(param1)
         {
            case 1:
               return "壹";
            case 2:
               return "贰";
            case 3:
               return "叁";
            case 4:
               return "肆";
            default:
               return "";
         }
      }
      
      private function showClearWrongTip(param1:uint) : void
      {
         var _loc2_:Array = [1,2,3,4];
         var _loc3_:int = _loc2_.indexOf(param1);
         if(_loc3_ != -1)
         {
            _loc2_.splice(_loc3_,1);
         }
         var _loc4_:int = _loc2_.splice(int(Math.random() * _loc2_.length),1);
         this._puzzleClearWrongTipUI["wrongFlag_" + _loc4_].visible = false;
         this._puzzleClearWrongTipUI["wrongFlag_" + param1].visible = false;
      }
      
      public function setTipVisible() : void
      {
         if(this._puzzleClearWrongTipUI)
         {
            this._puzzleClearWrongTipUI.visible = false;
         }
         if(this._puzzleRightTipUI)
         {
            this._puzzleRightTipUI.visible = false;
         }
      }
      
      private function loadIcon() : void
      {
         var _loc1_:ItemIconTip = new ItemIconTip();
         _loc1_.setID(this.RIGHT_ITEM_ID);
         _loc1_.x = _loc1_.y = 18;
         this._puzzleRightItemUI["iconHolder"].addChild(_loc1_);
         this._puzzleRightItemUI["numTxt"].text = ItemManager.getItemCount(this.RIGHT_ITEM_ID) + "个";
      }
      
      public function updatePuzzleMessage() : void
      {
         if(this._puzzleMsgUI)
         {
            this._puzzleMsgUI["roundTxt"].text = "目前为第" + this.round + "题";
            this._puzzleMsgUI["rightTxt"].text = "你答对的题数为：" + this.rightTime;
         }
      }
      
      private function updatePuzzleRightItemCount() : void
      {
         this._puzzleRightItemUI["numTxt"].text = ItemManager.getItemCount(this.RIGHT_ITEM_ID) + "个";
      }
      
      private function destroyUI() : void
      {
         DisplayUtil.removeForParent(this._puzzleMsgUI);
         this._puzzleMsgUI = null;
         DisplayUtil.removeForParent(this._puzzleRightItemUI);
         this._puzzleRightItemUI = null;
         this.removeEventForTeamEnter();
         DisplayUtil.removeForParent(this._puzzleTeamEnterUI);
         this._puzzleTeamEnterUI = null;
      }
      
      public function showSightModel() : void
      {
         var _loc1_:XML = <node id="1" src="101" name="传送虚幻空间" pos="1153,715" tip="虚幻空间">
					<materialInfo type="2" src="102"/>
					<funcInfo tollgateTo="978"/>
				</node>;
         var _loc2_:TollgateModel = new TollgateModel(978);
         _loc2_.initView();
         _loc2_.pos = new Point(1153,715);
         _loc2_.initTollgateEnter();
         MapManager.currentMap.contentLevel.addChild(_loc2_);
      }
      
      private function initGodRoom() : void
      {
         var _loc1_:XML = <node id="6" src="101" name="传送守护神阵地" pos="1653,715" tip="守护神阵地">
					<materialInfo type="2" src="102"/>
					<funcInfo mapTo="1002,0"/>
				</node>;
         var _loc2_:TeleporterModel = new TeleporterModel(_loc1_);
         _loc2_.initView();
         MapManager.currentMap.contentLevel.addChild(_loc2_);
      }
      
      public function get totalRound() : uint
      {
         return this._totalRound;
      }
      
      public function set totalRound(param1:uint) : void
      {
         this._totalRound = param1;
      }
      
      public function get round() : uint
      {
         return this._round;
      }
      
      public function set round(param1:uint) : void
      {
         this._round = param1;
         this.updatePuzzleMessage();
      }
      
      public function get rightTime() : uint
      {
         return this._rightTime;
      }
      
      public function set rightTime(param1:uint) : void
      {
         this._rightTime = param1;
         this.updatePuzzleMessage();
         this.updatePuzzleRightItemCount();
      }
      
      public function get errorTime() : uint
      {
         return this._errorTime;
      }
      
      public function set errorTime(param1:uint) : void
      {
         this._errorTime = param1;
      }
      
      public function get roomID() : uint
      {
         return this._roomID;
      }
      
      public function set roomID(param1:uint) : void
      {
         this._roomID = param1;
      }
      
      public function get isUseItem() : Boolean
      {
         return this._isUseItem;
      }
      
      public function set isUseItem(param1:Boolean) : void
      {
         this._isUseItem = param1;
      }
      
      public function get currentPuzzleID() : uint
      {
         return this._currentPuzzleID;
      }
      
      public function set currentPuzzleID(param1:uint) : void
      {
         this._currentPuzzleID = param1;
      }
   }
}

