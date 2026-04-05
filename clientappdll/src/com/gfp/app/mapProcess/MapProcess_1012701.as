package com.gfp.app.mapProcess
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.cartoon.event.AnimatEvent;
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.CommandID;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.HiddenEvent;
   import com.gfp.core.manager.HiddenManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.HiddenModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.TextFormatUtil;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class MapProcess_1012701 extends BaseMapProcess
   {
      
      public function MapProcess_1012701()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.addMapEvent();
      }
      
      private function addMapEvent() : void
      {
         SocketConnection.addCmdListener(CommandID.STAGE_MONSTER_PRO_CHANGE,this.onStagePropChange);
         HiddenManager.addEventListener(HiddenEvent.STATE_CHANGE,this.onHiddenStateChange);
      }
      
      private function removeMapEvent() : void
      {
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onWinner);
         SocketConnection.removeCmdListener(CommandID.STAGE_MONSTER_PRO_CHANGE,this.onStagePropChange);
         HiddenManager.removeEventListener(HiddenEvent.STATE_CHANGE,this.onHiddenStateChange);
      }
      
      private function onWinner(param1:FightEvent) : void
      {
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onWinner);
         AnimatPlay.addAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimatEnd);
      }
      
      private function onAnimatEnd(param1:AnimatEvent) : void
      {
         AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimatEnd);
         PveEntry.onWinner();
      }
      
      private function onStagePropChange(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         TextAlert.show("第 " + TextFormatUtil.getRedText(_loc5_ + 1) + " 波怪物已经出现");
      }
      
      private function onHiddenStateChange(param1:HiddenEvent) : void
      {
         var _loc2_:HiddenModel = param1.model;
         var _loc3_:uint = uint(param1.state);
         if(_loc3_ != 0)
         {
            if(_loc2_.info.roleType == 30026)
            {
               TextAlert.show("血量恢复10%，10秒后可再次使用.");
            }
            if(_loc2_.info.roleType == 30027)
            {
               TextAlert.show("气力提升10%，10秒后可再次使用.");
            }
            if(_loc2_.info.roleType == 30028)
            {
               TextAlert.show("友方异常状态消除，10秒后可再次使用.");
            }
         }
      }
      
      override public function destroy() : void
      {
         this.removeMapEvent();
         super.destroy();
      }
   }
}

