package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.CommandID;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.HiddenEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.HiddenManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1095301 extends BaseMapProcess
   {
      
      private const POSITION:Array = [[232,270],[360,270],[480,270],[595,270],[720,270],[200,343],[345,343],[480,343],[611,343],[752,343],[160,422],[320,422],[480,422],[633,422],[793,422],[125,505],[297,505],[480,505],[653,505],[828,505]];
      
      private const MAX_ROUND:uint = 15;
      
      private var _uiList:Array = [];
      
      private var _timerID:uint;
      
      private var _scoreMainUI:MovieClip;
      
      private var _blockTree:MovieClip;
      
      private var _showID:uint;
      
      private var _showPoint:Point;
      
      private var _isOpened:Boolean;
      
      public function MapProcess_1095301()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.addMapListener();
      }
      
      private function addMapListener() : void
      {
         SocketConnection.addCmdListener(CommandID.STAGE_MONSTER_PRO_CHANGE,this.onStageProChange);
         UserManager.addEventListener(UserEvent.BORN,this.onUserBorn);
         SocketConnection.addCmdListener(CommandID.FIGHT_MONSTER_RECYCLE,this.onRecyle);
         HiddenManager.addEventListener(HiddenEvent.OPEN,this.onOpen);
         FightManager.isAutoReasonEnd = false;
         FightManager.instance.addEventListener(FightEvent.REASON,this.onReason);
      }
      
      private function onReason(param1:FightEvent) : void
      {
         var e:FightEvent = param1;
         FightManager.instance.removeEventListener(FightEvent.REASON,this.onReason);
         MainManager.actorModel.execStandAction(false);
         AlertManager.showSimpleAlarm(AppLanguageDefine.TOLLGATE_CHARACTER_COLLECTION[9],function():void
         {
            FightManager.quit();
         });
      }
      
      private function onStageProChange(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         var _loc6_:uint = _loc2_.readUnsignedInt();
         if(_loc3_ == 953)
         {
            this._uiList.length = 0;
            HiddenManager.removeCmdListener();
            this.execLightSign(_loc6_);
            TextAlert.show("新的一轮已经开始");
         }
      }
      
      private function execLightSign(param1:uint) : void
      {
         var _loc4_:MovieClip = null;
         var _loc2_:String = this.convertString(param1.toString(2));
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(_loc2_.charAt(_loc3_) == "1")
            {
               _loc4_ = MapManager.currentMap.libManager.getMovieClip("spark");
               this._uiList.push(_loc4_);
               _mapModel.contentLevel.addChild(_loc4_);
               _loc4_.x = this.POSITION[_loc3_][0];
               _loc4_.y = this.POSITION[_loc3_][1];
            }
            _loc3_++;
         }
         this._timerID = setTimeout(this.delayOperate,2000);
      }
      
      private function convertString(param1:String) : String
      {
         var _loc2_:String = "";
         var _loc3_:uint = uint(param1.length);
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = _loc2_.concat(param1.charAt(_loc3_ - 1 - _loc4_));
            _loc4_++;
         }
         return _loc2_;
      }
      
      private function delayOperate() : void
      {
         var _loc1_:MovieClip = null;
         HiddenManager.creatCmdListener();
         for each(_loc1_ in this._uiList)
         {
            DisplayUtil.removeForParent(_loc1_);
            _loc1_ = null;
         }
         this._uiList.length = 0;
         this.clearTimer();
      }
      
      private function clearTimer() : void
      {
         if(this._timerID != 0)
         {
            clearTimeout(this._timerID);
            this._timerID = 0;
         }
      }
      
      private function onUserBorn(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data;
         if(_loc2_.info.roleType == 35001)
         {
            _loc2_.setNickText("",false);
            _loc2_.hideShadow();
         }
         else if(_loc2_.info.roleType == 34998)
         {
            this._showID = _loc2_.info.userID;
            this._showPoint = new Point(_loc2_.x,_loc2_.y);
            this._isOpened = false;
            _loc2_.setNickText("",false);
            _loc2_.hideShadow();
         }
      }
      
      private function onOpen(param1:HiddenEvent) : void
      {
         this._isOpened = true;
         var _loc2_:MovieClip = MapManager.currentMap.libManager.getMovieClip("stoneopen");
         _mapModel.contentLevel.addChild(_loc2_);
         _loc2_.x = param1.model.x;
         _loc2_.y = param1.model.y;
      }
      
      private function onRecyle(param1:SocketEvent) : void
      {
         var _loc4_:MovieClip = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         _loc2_.position = 0;
         if(_loc3_ == this._showID && !this._isOpened)
         {
            _loc4_ = MapManager.currentMap.libManager.getMovieClip("stone");
            _mapModel.contentLevel.addChild(_loc4_);
            _loc4_.x = this._showPoint.x;
            _loc4_.y = this._showPoint.y;
         }
      }
      
      private function removeMapListener() : void
      {
         HiddenManager.removeEventListener(HiddenEvent.OPEN,this.onOpen);
         SocketConnection.removeCmdListener(CommandID.STAGE_MONSTER_PRO_CHANGE,this.onStageProChange);
         UserManager.removeEventListener(UserEvent.BORN,this.onUserBorn);
         SocketConnection.removeCmdListener(CommandID.FIGHT_MONSTER_RECYCLE,this.onRecyle);
         FightManager.instance.removeEventListener(FightEvent.REASON,this.onReason);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.removeMapListener();
         this.clearTimer();
      }
   }
}

