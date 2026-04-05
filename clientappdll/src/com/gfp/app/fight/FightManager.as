package com.gfp.app.fight
{
   import com.gfp.app.fight.pvai.PvaiEntry;
   import com.gfp.app.manager.WatchFightManager;
   import com.gfp.app.manager.fightPlugin.AutoRecoverManager;
   import com.gfp.app.tuhao.TuHaoVo;
   import com.gfp.core.CommandID;
   import com.gfp.core.buff.ActorOperateBuffManager;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.info.fight.FightInviteInfo;
   import com.gfp.core.info.fight.FightReadyInfo;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SkillStateManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.manager.alert.AlertInfo;
   import com.gfp.core.manager.alert.AlertType;
   import com.gfp.core.map.MapType;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.FightMode;
   import flash.display.MovieClip;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import org.taomee.bean.BeanManager;
   import org.taomee.utils.DisplayUtil;
   
   public class FightManager extends EventDispatcher
   {
      
      public static var fightMode:int;
      
      public static var pvpLevel:uint;
      
      public static var targetId:uint;
      
      public static var targetCreateTime:uint;
      
      public static var curTuHao:TuHaoVo;
      
      public static var summonCallEnabled:Boolean;
      
      public static var pvpLeftSide:Boolean;
      
      private static var _instance:FightManager;
      
      public static var isWinTheFight:Boolean;
      
      public static var outToMapID:uint;
      
      public static var outToMapPos:Point;
      
      public static var actorDiedCount:int;
      
      public static var actorLifeTime:int;
      
      public static var enemyName:String = AppLanguageDefine.VOID;
      
      public static var isAutoWinnerEnd:Boolean = true;
      
      public static var isAutoReasonEnd:Boolean = true;
      
      public static var outToMapType:int = MapType.STAND;
      
      public static var isLoadingRes:Boolean = false;
      
      private static var _isTeamFight:Boolean = false;
      
      private var _requestList:Array = [];
      
      private var _fightIcon:MovieClip;
      
      public function FightManager()
      {
         super();
      }
      
      public static function get instance() : FightManager
      {
         if(_instance == null)
         {
            _instance = new FightManager();
         }
         return _instance;
      }
      
      public static function setup(param1:FightReadyInfo) : void
      {
         if(fightMode == FightMode.PVP)
         {
            instance.dispatchEvent(new FightEvent(FightEvent.FIGHT_MATCHED,param1));
            PvpEntry.instance.setup(param1);
         }
         else if(fightMode == FightMode.PVE)
         {
            PveEntry.instance.setup(param1);
         }
         else if(fightMode == FightMode.WATCH)
         {
            WatchEntry.instance.setup(param1);
         }
         else if(fightMode == FightMode.PVAI)
         {
            PvaiEntry.instance.setup(param1);
         }
      }
      
      public static function destroy() : void
      {
         PvpEntry.destroy();
         PveEntry.destroy();
         WatchEntry.destroy();
         PvaiEntry.destroy();
         summonCallEnabled = false;
         SkillStateManager.getInstance().clear();
         MainManager.actorModel.effectManager.removeAll();
      }
      
      public static function quit() : void
      {
         SocketConnection.send(CommandID.STAGE_QUIT);
         instance.dispatchEvent(new FightEvent(FightEvent.QUITE));
         FightManager.pvpLevel = 0;
         FightGo.destroy();
         ActorOperateBuffManager.instance.clear();
         showTuHao();
         if(MainManager.actorInfo.isVip)
         {
            AutoRecoverManager.instance.vipDestroy();
         }
      }
      
      public static function showTuHao() : void
      {
         if(curTuHao)
         {
            if(isWinTheFight)
            {
            }
            curTuHao = null;
         }
      }
      
      public static function quitWithWatch() : void
      {
         instance.dispatchEvent(new FightEvent(FightEvent.QUITE));
         WatchFightManager.instance.leaveWatchFight();
      }
      
      public static function get isTeamFight() : Boolean
      {
         return _isTeamFight;
      }
      
      public static function set isTeamFight(param1:Boolean) : void
      {
         _isTeamFight = param1;
      }
      
      public function fightWithPlayer(param1:UserInfo) : void
      {
         FightWaitPanel.showWaitFight(param1);
      }
      
      public function add(param1:FightInviteInfo) : void
      {
         this._requestList.push(param1);
         this.checkLength();
      }
      
      private function next() : FightInviteInfo
      {
         var _loc1_:FightInviteInfo = this._requestList.shift() as FightInviteInfo;
         this.checkLength();
         return _loc1_;
      }
      
      private function checkLength() : void
      {
         if(!this._fightIcon)
         {
            this._fightIcon = UIManager.getMovieClip("FightInvite_Icon");
            this._fightIcon.buttonMode = true;
            this._fightIcon.x = 250;
            this._fightIcon.y = 20;
            this._fightIcon.addEventListener(MouseEvent.CLICK,this.onShowInviteAnswer);
         }
         if(this._requestList.length > 0)
         {
            LayerManager.gameLevel.addChild(this._fightIcon);
         }
         else
         {
            DisplayUtil.removeForParent(this._fightIcon);
         }
      }
      
      private function onShowInviteAnswer(param1:MouseEvent) : void
      {
         var aInfo:AlertInfo;
         var data:FightInviteInfo = null;
         var mode:uint = 0;
         var str:String = null;
         var sendData:ByteArray = null;
         var e:MouseEvent = param1;
         data = this.next();
         mode = uint(data.mode);
         if(mode == FightMode.PVP)
         {
            str = AppLanguageDefine.FIGHT_CHARACTER_COLLECTION[2];
         }
         sendData = new ByteArray();
         sendData.writeUnsignedInt(data.userID);
         aInfo = new AlertInfo();
         aInfo.type = AlertType.ANSWER;
         aInfo.str = "<a href=\'event:\'><font color=\'#ff0000\'>" + data.nickName + "(" + data.userID + ")</font></a> " + AppLanguageDefine.INVITE_FIGHT + "\r\r<font color=\'#ff0000\'>" + AppLanguageDefine.FIGHT_CHARACTER_COLLECTION[3] + str + "</font>";
         aInfo.cancelFun = function():void
         {
            sendData.writeByte(0);
            SocketConnection.send(CommandID.FIGHT_INVITE_ANSWER,sendData);
         };
         aInfo.applyFun = function():void
         {
            fightMode = mode;
            enemyName = data.nickName;
            sendData.writeByte(1);
            SocketConnection.send(CommandID.FIGHT_INVITE_ANSWER,sendData);
         };
         aInfo.linkFun = function():void
         {
            var _loc1_:* = BeanManager.getBeanInstance("UserInfoController");
            if(_loc1_)
            {
               _loc1_.show(data.userID);
               LayerManager.topLevel.addChild(_loc1_.panel);
            }
         };
         AlertManager.showForInfo(aInfo);
      }
   }
}

