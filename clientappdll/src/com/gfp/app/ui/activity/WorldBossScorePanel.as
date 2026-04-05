package com.gfp.app.ui.activity
{
   import com.gfp.app.feature.WorldBossFeather;
   import com.gfp.app.info.rank.BaseRankInfo;
   import com.gfp.core.CommandID;
   import com.gfp.core.events.DataEvent;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.RankType;
   import com.gfp.core.utils.TextUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class WorldBossScorePanel extends Sprite
   {
      
      private var dataSource:Vector.<BaseRankInfo> = new Vector.<BaseRankInfo>();
      
      private var mainUI:MovieClip;
      
      private var rankItems:Vector.<MovieClip>;
      
      private var ownTxt:TextField;
      
      private var isMorning:Boolean;
      
      private var _ownPoint:int;
      
      public function WorldBossScorePanel()
      {
         super();
         this.init();
         this.addEvent();
      }
      
      private function init() : void
      {
         this.mainUI = UIManager.getMovieClip("UI_BossHitRank");
         addChild(this.mainUI);
         this.ownTxt = this.mainUI["ownTxt"];
         this.ownTxt.text = "0";
         this.rankItems = new Vector.<MovieClip>();
         var _loc1_:int = 0;
         while(_loc1_ < 10)
         {
            this.rankItems.push(this.mainUI["rank" + _loc1_]);
            _loc1_++;
         }
         this.updateView();
      }
      
      private function addEvent() : void
      {
         SocketConnection.addCmdListener(CommandID.VAR_RANK,this.onGetRankHandler);
         ActivityExchangeTimesManager.addEventListener(3198,this.onPointReturn);
         ActivityExchangeTimesManager.addEventListener(3197,this.onPointReturn);
      }
      
      private function removeEvent() : void
      {
         SocketConnection.removeCmdListener(CommandID.VAR_RANK,this.onGetRankHandler);
         ActivityExchangeTimesManager.removeEventListener(3198,this.onPointReturn);
         ActivityExchangeTimesManager.removeEventListener(3197,this.onPointReturn);
      }
      
      public function requestData(param1:Boolean) : void
      {
         this.isMorning = param1;
         SocketConnection.send(CommandID.VAR_RANK,RankType.TYPE_HERO_BOSS);
         if(param1)
         {
            ActivityExchangeTimesManager.getActiviteTimeInfo(3197);
         }
         else
         {
            ActivityExchangeTimesManager.getActiviteTimeInfo(3198);
         }
      }
      
      private function onGetRankHandler(param1:SocketEvent) : void
      {
         var _loc7_:BaseRankInfo = null;
         var _loc2_:Vector.<BaseRankInfo> = new Vector.<BaseRankInfo>();
         var _loc3_:ByteArray = param1.data as ByteArray;
         var _loc4_:uint = _loc3_.readUnsignedInt();
         var _loc5_:uint = _loc3_.readUnsignedInt();
         var _loc6_:uint = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = new BaseRankInfo();
            _loc7_.read(_loc3_);
            _loc7_.index = _loc6_ + 1;
            if(_loc7_.userID == MainManager.actorInfo.userID && _loc7_.creatTime == MainManager.actorInfo.createTime)
            {
            }
            _loc2_.push(_loc7_);
            _loc6_++;
         }
         this.dataSource = _loc2_;
         this.updateView();
      }
      
      private function onPointReturn(param1:DataEvent) : void
      {
         this.updateOwnPoint();
      }
      
      private function updateOwnPoint() : void
      {
         if(this.isMorning)
         {
            this._ownPoint = ActivityExchangeTimesManager.getTimes(3197);
         }
         else
         {
            this._ownPoint = ActivityExchangeTimesManager.getTimes(3198);
         }
         this.ownTxt.text = this._ownPoint.toString();
      }
      
      private function updateView() : void
      {
         var _loc4_:MovieClip = null;
         var _loc1_:int = int(this.rankItems.length);
         var _loc2_:int = int(this.dataSource.length);
         var _loc3_:int = 0;
         while(_loc3_ < 10)
         {
            _loc4_ = this.rankItems[_loc3_];
            if(_loc3_ < _loc2_)
            {
               this.setItemSource(_loc4_,this.dataSource[_loc3_]);
            }
            else
            {
               this.setItemSource(_loc4_,null);
            }
            _loc3_++;
         }
      }
      
      private function setItemSource(param1:MovieClip, param2:BaseRankInfo) : void
      {
         if(param2)
         {
            param1["rankTxt"].text = param2.index;
            param1["nameTxt"].text = param2.nick;
            param1["hitTxt"].text = "伤害" + TextUtil.completeString(param2.element.toString(),4) + " (" + (Math.floor(param2.element / WorldBossFeather.totalBlood * 10000) / 100).toString() + "%)";
         }
         else
         {
            param1["rankTxt"].text = "";
            param1["nameTxt"].text = "";
            param1["hitTxt"].text = "";
         }
      }
      
      public function get ownPoint() : uint
      {
         return this._ownPoint;
      }
      
      public function destory() : void
      {
         this.removeEvent();
      }
   }
}

