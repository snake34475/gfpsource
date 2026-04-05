package com.gfp.app.cmdl
{
   import com.gfp.app.control.WuLinFightControl;
   import com.gfp.app.fight.FightWaitPanel;
   import com.gfp.app.fight.PvpEntry;
   import com.gfp.app.manager.GhostAdventureManager;
   import com.gfp.app.toolBar.WuLinFightEntry;
   import com.gfp.core.CommandID;
   import com.gfp.core.cache.SoundCache;
   import com.gfp.core.cache.SoundInfo;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.RoleXMLInfo;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.events.ScoreEvent;
   import com.gfp.core.info.ActivityExchangeAwardInfo;
   import com.gfp.core.info.BitmapEffectInfo;
   import com.gfp.core.info.CustomMessageInfo;
   import com.gfp.core.info.WuLinMemberInfo;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.ExchangeGoldManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.MessageManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.player.BitmapEffectPlayer;
   import com.gfp.core.sound.SoundManager;
   import com.gfp.core.ui.alert.TextAlert;
   import flash.utils.ByteArray;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   
   public class ActivityCmdListener extends BaseBean
   {
      
      public function ActivityCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.CHRISTMAS_FIRE,this.onChristmasFire);
         SocketConnection.addCmdListener(CommandID.WuLin_APPLY,this.onApplyWuLinFight);
         SocketConnection.addCmdListener(CommandID.WuLin_APPLYED_LOGIN,this.onApplyWuLinForLogin);
         SocketConnection.send(CommandID.WuLin_APPLYED_LOGIN);
         SocketConnection.addCmdListener(CommandID.WuLin_ROUND_START,this.onFightRoundAlert);
         SocketConnection.addCmdListener(CommandID.WuLin_START,this.onWuLinFightStart);
         SocketConnection.addCmdListener(CommandID.WuLin_ROUND_END,this.onWuLinFightRoundEnd);
         SocketConnection.addCmdListener(CommandID.WuLin_END,this.onWuLinFightAllEnd);
         SocketConnection.addCmdListener(CommandID.WuLin_QUIT,this.onWuLinFightQuit);
         SocketConnection.addCmdListener(CommandID.SCORE_CHANGED,this.onScoreChanged);
         finish();
      }
      
      private function onScoreChanged(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         TextAlert.show("恭喜您获得" + _loc4_ + "积分");
         ExchangeGoldManager.instance.ed.dispatchEvent(new ScoreEvent(ScoreEvent.ACTVITY_SCORE,_loc4_,_loc3_));
      }
      
      private function onChristmasFire(param1:SocketEvent) : void
      {
         var _loc6_:Array = null;
         var _loc7_:UserModel = null;
         var _loc8_:BitmapEffectInfo = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         if(_loc5_ >= 1 && _loc5_ < 5)
         {
            _loc6_ = [90001,90002,90003];
            _loc7_ = UserManager.getModel(_loc3_);
            if(_loc7_)
            {
               _loc8_ = new BitmapEffectInfo();
               _loc8_.id = _loc6_[_loc5_ - 2];
               _loc8_.offY = -20;
               _loc8_.repeat = 3;
               BitmapEffectPlayer.play(_loc8_,_loc7_);
            }
         }
         if(_loc5_ == 7)
         {
            GhostAdventureManager.notifiComplete();
         }
      }
      
      private function execEffect(param1:uint, param2:uint, param3:uint = 1) : void
      {
         var _loc5_:BitmapEffectInfo = null;
         var _loc4_:UserModel = UserManager.getModel(param1);
         if(_loc4_)
         {
            _loc5_ = new BitmapEffectInfo();
            _loc5_.id = param2;
            _loc5_.offY = -(RoleXMLInfo.getHeight(MainManager.actorInfo.roleType) - 10);
            _loc5_.repeat = param3;
            BitmapEffectPlayer.play(_loc5_,_loc4_);
         }
      }
      
      private function playSound(param1:String) : void
      {
         if(SoundManager.isMusicEnable)
         {
            SoundCache.load(ClientConfig.getSoundOther(param1),this.onSoundComplete,null);
         }
      }
      
      private function onSoundComplete(param1:SoundInfo) : void
      {
         SoundManager.playSound(param1.url,0,false,0.6);
      }
      
      private function onApplyWuLinFight(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         MainManager.actorInfo.wulinID = _loc2_.readUnsignedInt();
         WuLinFightEntry.instance.show();
         AlertManager.showSimpleAlarm("恭喜小侠士报名成功，快去展现你的武艺吧！");
      }
      
      private function onApplyWuLinForLogin(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         MainManager.actorInfo.wulinID = _loc2_.readUnsignedInt();
      }
      
      private function onFightRoundAlert(param1:SocketEvent) : void
      {
         var _loc7_:WuLinMemberInfo = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:WuLinMemberInfo = new WuLinMemberInfo(_loc2_);
         var _loc6_:WuLinMemberInfo = new WuLinMemberInfo(_loc2_);
         if(_loc5_.userID == MainManager.actorID)
         {
            _loc7_ = _loc6_;
         }
         else
         {
            _loc7_ = _loc5_;
         }
         var _loc8_:CustomMessageInfo = new CustomMessageInfo();
         _loc8_.alertDesc = "小侠士,十六强争霸第" + (_loc3_ + 1) + "轮将在" + _loc4_ + "秒后开始，你的对阵选手为" + _loc7_.nick + " ,战斗吧，友谊第一，比赛第二！";
         MessageManager.addCustomMessageInfo(_loc8_);
      }
      
      private function onWuLinFightStart(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         var _loc6_:uint = _loc2_.readUnsignedInt();
         var _loc7_:uint = _loc2_.readUnsignedInt();
         var _loc8_:WuLinFightControl = WuLinFightControl.instance;
         _loc8_.round = _loc3_;
         _loc8_.applyBadge = _loc4_;
         _loc8_.winBadge = _loc5_;
         _loc8_.failBadge = _loc6_;
         _loc8_.luckyBadge = _loc7_;
         PvpEntry.instance.fightWithEnter(9);
      }
      
      private function onWuLinFightRoundEnd(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         var _loc6_:uint = _loc2_.readUnsignedInt();
         var _loc7_:uint = _loc2_.readUnsignedInt();
         var _loc8_:String = _loc2_.readUTFBytes(16);
         var _loc9_:uint = _loc2_.readUnsignedInt();
         MainManager.actorInfo.coins = _loc9_;
         var _loc10_:CustomMessageInfo = new CustomMessageInfo();
         var _loc11_:String = "";
         if(_loc4_ == 0)
         {
            _loc11_ = "很遗憾小侠士，你负于了 <font color=\'#FF9900\'>" + _loc8_ + "</font>";
         }
         else
         {
            _loc11_ = "恭喜你小侠士，你战胜了 <font color=\'#FF9900\'>" + _loc8_ + "</font>";
         }
         _loc10_.alertDesc = "武林盛典第" + (_loc3_ + 1) + "轮已经结束！" + _loc11_;
         MessageManager.addCustomMessageInfo(_loc10_);
         FightWaitPanel.hideWaitPanel();
      }
      
      private function onWuLinFightAllEnd(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:String = _loc2_.readUTFBytes(16);
         AlertManager.showSimpleAlarm("武林盛典已经全部结束，恭喜 <font color=\'#FF9900\'>" + _loc5_ + " </font>获得本次盛典冠军！您可以选择退出比赛参加另外一场十六强争霸赛");
      }
      
      private function onWuLinFightQuit(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         MainManager.actorInfo.wulinID = 0;
         AlertManager.showSimpleAlarm("小侠士，你已经离开了对阵。再次参加对阵需要重新报名。");
         WuLinFightEntry.destroy();
      }
      
      private function onExchangeCompelte(param1:ExchangeEvent) : void
      {
         var _loc2_:ActivityExchangeAwardInfo = param1.info;
         if(_loc2_.id == 1969)
         {
            MainManager.actorInfo.monsterID = 10208;
            MainManager.actorModel.changeRoleView(10208);
            TextAlert.show("你已经变身成南瓜罐，快去找其他侠士索要南瓜糖吧！");
         }
      }
   }
}

