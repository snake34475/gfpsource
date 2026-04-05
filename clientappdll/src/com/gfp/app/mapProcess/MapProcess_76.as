package com.gfp.app.mapProcess
{
   import com.gfp.app.config.xml.SystemTimeXMLInfo;
   import com.gfp.app.feature.SystimeComeFeather;
   import com.gfp.app.fight.FightAdded;
   import com.gfp.app.info.SystemTimeInfo;
   import com.gfp.app.time.SystimeEvent;
   import com.gfp.app.toolBar.CityToolBar;
   import com.gfp.app.toolBar.DynamicActivityEntry;
   import com.gfp.core.CommandID;
   import com.gfp.core.controller.KeyController;
   import com.gfp.core.events.MoveEvent;
   import com.gfp.core.events.SummonEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.RankInfo;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.model.SummonModel;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.TimeUtil;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import flash.utils.ByteArray;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_76 extends BaseMapProcess
   {
      
      private static const DISTANCE:uint = 50;
      
      private var _items:Vector.<MY_ITEM>;
      
      private var _willAwardItem:MY_ITEM;
      
      private var _progressbar:My_ProgressBar;
      
      private var _overHeadSprite:Sprite;
      
      private var _rankInfos:Array;
      
      private var _rankPanel:Sprite;
      
      private var _feather:SystimeComeFeather;
      
      private var _timer:int;
      
      private var _countDownEndSeconds:int;
      
      public function MapProcess_76()
      {
         super();
      }
      
      override protected function init() : void
      {
         var _loc3_:Array = null;
         var _loc4_:Date = null;
         FightAdded.hideToolbar();
         CityToolBar.instance.hide();
         DynamicActivityEntry.instance.hide();
         this._items = new Vector.<MY_ITEM>();
         this._rankInfos = [];
         this._feather = new SystimeComeFeather([215]);
         SummonManager.addUserListener(SummonEvent.SUMMON_UPDATE,MainManager.actorID,this.onSummonUpdate);
         UserManager.addEventListener(UserEvent.BORN,this.onUserChange);
         MainManager.actorModel.addEventListener(MoveEvent.MOVE_ENTER,this.onActorMove);
         SocketConnection.addCmdListener(CommandID.FENG_KUANG_DUO_BAO_LIST,this.responseList);
         SocketConnection.addCmdListener(CommandID.FENG_KUANG_DUO_BAO_AWARD,this.responseAward);
         LayerManager.stage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyDown);
         SocketConnection.send(CommandID.FENG_KUANG_DUO_BAO_LIST);
         this._feather.addEventListener(SystimeEvent.TIME_COME,this.onTimeCome);
         if(this._overHeadSprite == null)
         {
            if(KeyController.currentControlType == 1)
            {
               this._overHeadSprite = UIManager.getMovieClip("Fight_UI_Z");
            }
            else
            {
               this._overHeadSprite = UIManager.getMovieClip("Fight_UI_L");
            }
            _mapModel.upLevel.addChild(this._overHeadSprite);
            this._overHeadSprite.visible = false;
         }
         this._rankPanel = _mapModel.libManager.getSprite("UI_RankPanel");
         LayerManager.topLevel.addChild(this._rankPanel);
         this._rankPanel.y = 200;
         this.updateRankPanel();
         var _loc1_:SystemTimeInfo = SystemTimeXMLInfo.getSystemTimeInfoById(215);
         var _loc2_:int = _loc1_.checkTimeIndex();
         if(_loc2_ != -1)
         {
            _loc3_ = _loc1_.endTime[_loc2_];
            _loc4_ = new Date(_loc3_[0],_loc3_[1] - 1,_loc3_[2],_loc3_[3],_loc3_[4],0,0);
            this._countDownEndSeconds = _loc4_.time * 0.001;
            this._timer = setInterval(this.onTimer,1000);
            this.onTimer();
         }
      }
      
      private function onSummonUpdate(param1:Event) : void
      {
         var _loc2_:SummonModel = SummonManager.getUserSummonModel(MainManager.actorID);
         if(_loc2_)
         {
            _loc2_.hide();
         }
      }
      
      private function onUserChange(param1:UserEvent) : void
      {
         var _loc3_:UserInfo = null;
         var _loc4_:SummonModel = null;
         var _loc2_:UserModel = param1.data as UserModel;
         if(_loc2_)
         {
            _loc3_ = _loc2_.info;
            _loc4_ = SummonManager.getUserSummonModel(_loc3_.userID);
            if(_loc4_)
            {
               _loc4_.hide();
            }
         }
      }
      
      private function responseList(param1:SocketEvent) : void
      {
         var _loc5_:TreasuredVO = null;
         var _loc6_:MY_ITEM = null;
         var _loc7_:RankInfo = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = new TreasuredVO();
            _loc5_.x = _loc2_.readUnsignedInt();
            _loc5_.y = _loc2_.readUnsignedInt();
            _loc5_.itemID = _loc2_.readUnsignedInt();
            _loc5_.itemCount = _loc2_.readUnsignedInt();
            _loc6_ = new MY_ITEM(_mapModel.libManager.getSprite("UI_Icon_Bg"));
            _loc6_.info = _loc5_;
            this._items.push(_loc6_);
            _mapModel.downLevel.addChild(_loc6_);
            _loc4_++;
         }
         _loc3_ = int(_loc2_.readUnsignedInt());
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc7_ = new RankInfo();
            _loc7_.userID = _loc2_.readUnsignedInt();
            _loc7_.nick = _loc2_.readUTFBytes(16);
            _loc7_.socre = _loc2_.readInt();
            this._rankInfos.push(_loc7_);
            _loc4_++;
         }
         this.updateRankPanel();
      }
      
      private function onTimer() : void
      {
         var _loc1_:int = this._countDownEndSeconds - TimeUtil.getSeverDateObject().time * 0.001;
         this._rankPanel["timeLabel"].text = TimeUtil.formatSeconds(Math.max(0,_loc1_));
      }
      
      protected function onTimeCome(param1:SystimeEvent) : void
      {
         if(param1.isStart == false)
         {
            AlertManager.showSimpleAlarm("本次夺宝已结束！");
            CityMap.instance.changeMap(7);
         }
      }
      
      private function updateRankPanel() : void
      {
         this._rankInfos.sortOn("socre",Array.NUMERIC | Array.DESCENDING);
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            if(_loc1_ < this._rankInfos.length)
            {
               this._rankPanel["item" + _loc1_].visible = true;
               this._rankPanel["item" + _loc1_]["rankLabel"].text = _loc1_ + 1 + "";
               this._rankPanel["item" + _loc1_]["nickLabel"].text = this._rankInfos[_loc1_].nick + "";
               this._rankPanel["item" + _loc1_]["scoreLabel"].text = this._rankInfos[_loc1_].socre + "";
            }
            else
            {
               this._rankPanel["item" + _loc1_].visible = false;
            }
            _loc1_++;
         }
      }
      
      private function onActorMove(param1:MoveEvent) : void
      {
         var _loc4_:int = 0;
         var _loc7_:MY_ITEM = null;
         var _loc2_:int = int.MAX_VALUE;
         var _loc3_:MY_ITEM = null;
         var _loc5_:Point = new Point();
         var _loc6_:int = 0;
         while(_loc6_ < this._items.length)
         {
            _loc7_ = this._items[_loc6_];
            _loc5_.x = _loc7_.x;
            _loc5_.y = _loc7_.y;
            _loc4_ = Point.distance(param1.pos,_loc5_);
            if(_loc4_ <= DISTANCE && _loc4_ < _loc2_)
            {
               _loc2_ = _loc4_;
               _loc3_ = _loc7_;
            }
            this._overHeadSprite.visible = false;
            _loc6_++;
         }
         if(_loc3_)
         {
            this._overHeadSprite.visible = true;
            this._overHeadSprite.x = _loc3_.x + 25;
            this._overHeadSprite.y = _loc3_.y - 5;
         }
         this._willAwardItem = _loc3_;
         if(this._progressbar)
         {
            this._progressbar.stop();
         }
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         if(this._willAwardItem)
         {
            if(KeyController.currentControlType == 1 && param1.keyCode == Keyboard.Z || KeyController.currentControlType == 2 && param1.keyCode == Keyboard.L)
            {
               if(this._progressbar == null)
               {
                  this._progressbar = new My_ProgressBar();
                  _mapModel.upLevel.addChild(this._progressbar);
                  this._progressbar.addEventListener(Event.COMPLETE,this.onProgressEndHandle);
               }
               this._progressbar.x = MainManager.actorModel.x - this._progressbar.width * 0.5;
               this._progressbar.y = MainManager.actorModel.y - MainManager.actorModel.height;
               this._progressbar.play(5);
            }
         }
      }
      
      private function onProgressEndHandle(param1:Event) : void
      {
         if(this._willAwardItem)
         {
            SocketConnection.send(CommandID.FENG_KUANG_DUO_BAO_AWARD,this._willAwardItem.info.x,this._willAwardItem.info.y,this._willAwardItem.info.itemID);
            this._willAwardItem = null;
         }
      }
      
      private function responseAward(param1:SocketEvent) : void
      {
         var _loc6_:Boolean = false;
         var _loc9_:RankInfo = null;
         var _loc10_:MY_ITEM = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         var _loc4_:String = _loc2_.readUTFBytes(16);
         var _loc5_:TreasuredVO = new TreasuredVO();
         _loc5_.x = _loc2_.readUnsignedInt();
         _loc5_.y = _loc2_.readUnsignedInt();
         _loc5_.itemID = _loc2_.readUnsignedInt();
         var _loc7_:int = 0;
         while(_loc7_ < this._rankInfos.length)
         {
            _loc9_ = this._rankInfos[_loc7_];
            if(_loc9_.userID == _loc3_)
            {
               _loc6_ = true;
               ++_loc9_.socre;
            }
            _loc7_++;
         }
         if(!_loc6_)
         {
            _loc9_ = new RankInfo();
            _loc9_.userID = _loc3_;
            _loc9_.nick = _loc4_;
            _loc9_.socre = 1;
            this._rankInfos.push(_loc9_);
         }
         var _loc8_:int = 0;
         while(_loc8_ < this._items.length)
         {
            _loc10_ = this._items[_loc8_];
            if(_loc10_.info.id == _loc5_.id)
            {
               DisplayUtil.removeForParent(_loc10_);
               this._items.splice(_loc8_,1);
               _loc10_.destroy();
               break;
            }
            _loc8_++;
         }
         this.updateRankPanel();
      }
      
      override public function destroy() : void
      {
         while(this._items.length)
         {
            this._items.pop().destroy();
         }
         DisplayUtil.removeForParent(this._rankPanel);
         FightAdded.showToolbar();
         CityToolBar.instance.show();
         DynamicActivityEntry.instance.show();
         if(this._progressbar)
         {
            this._progressbar.removeEventListener(Event.COMPLETE,this.onProgressEndHandle);
            this._progressbar.stop();
         }
         SummonManager.removeUserListener(SummonEvent.SUMMON_UPDATE,MainManager.actorID,this.onSummonUpdate);
         UserManager.removeEventListener(UserEvent.BORN,this.onUserChange);
         clearInterval(this._timer);
         this._feather.removeEventListener(SystimeEvent.TIME_COME,this.onTimeCome);
         LayerManager.stage.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyDown);
         MainManager.actorModel.removeEventListener(MoveEvent.MOVE_ENTER,this.onActorMove);
         SocketConnection.removeCmdListener(CommandID.FENG_KUANG_DUO_BAO_LIST,this.responseList);
         SocketConnection.removeCmdListener(CommandID.FENG_KUANG_DUO_BAO_AWARD,this.responseAward);
         this._feather.destroy();
         super.destroy();
      }
   }
}

import com.gfp.core.ui.ItemIconNum;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import org.taomee.utils.Tick;

class TreasuredVO
{
   
   public var x:int;
   
   public var y:int;
   
   public var itemID:int;
   
   public var itemCount:int;
   
   public function TreasuredVO()
   {
      super();
   }
   
   public function get id() : String
   {
      return this.x + "_" + this.y + "_" + this.itemID;
   }
}

class MY_ITEM extends ItemIconNum
{
   
   private var _info:TreasuredVO;
   
   public function MY_ITEM(param1:Sprite)
   {
      super();
      addChildAt(param1,0);
      param1.x = -10;
      param1.y = 10;
   }
   
   public function set info(param1:TreasuredVO) : void
   {
      this._info = param1;
      setID(param1.itemID);
      setItemCountStr("×" + param1.itemCount);
      removeBg();
      x = param1.x;
      y = param1.y;
   }
   
   public function get info() : TreasuredVO
   {
      return this._info;
   }
   
   override public function destroy() : void
   {
      super.destroy();
   }
}

class My_ProgressBar extends Sprite
{
   
   private var _movie:MovieClip;
   
   private var _totalMilSeconds:int;
   
   private var _currentMilSeconds:int;
   
   public function My_ProgressBar()
   {
      super();
      this._movie = new ToolBar_MiniLoading();
      this.stop();
      addChild(this._movie);
   }
   
   public function stop() : void
   {
      this._movie.stop();
      this._movie.visible = false;
      Tick.instance.removeCallback(this.onTick);
   }
   
   public function play(param1:int) : void
   {
      this._movie.gotoAndStop(1);
      this._movie.visible = true;
      this._totalMilSeconds = param1 * 1000;
      this._currentMilSeconds = 0;
      Tick.instance.addCallback(this.onTick);
   }
   
   private function onTick(param1:int) : void
   {
      this._currentMilSeconds += param1;
      if(this._currentMilSeconds >= this._totalMilSeconds)
      {
         dispatchEvent(new Event(Event.COMPLETE));
         this.stop();
      }
      else
      {
         this._movie.gotoAndStop(int(this._currentMilSeconds / this._totalMilSeconds * this._movie.totalFrames));
      }
   }
}
