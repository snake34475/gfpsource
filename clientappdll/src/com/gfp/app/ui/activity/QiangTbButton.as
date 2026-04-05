package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.app.info.SystemNoticeInfo;
   import com.gfp.app.toolBar.DynamicActivityEntry;
   import com.gfp.core.CommandID;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.TimeUtil;
   import flash.display.MovieClip;
   import flash.utils.ByteArray;
   import flash.utils.setInterval;
   import org.taomee.net.SocketEvent;
   
   public class QiangTbButton extends BaseActivitySprite
   {
      
      private var _alertMC:MovieClip;
      
      private var leftTime:int;
      
      public function QiangTbButton(param1:ActivityNodeInfo)
      {
         super(param1);
         setInterval(this.running,30000);
      }
      
      private function running() : void
      {
         this.executeShow();
         DynamicActivityEntry.instance.updateAlign();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._alertMC = _sprite["effectbmp_start"];
         this._alertMC.visible = false;
      }
      
      override public function addEvent() : void
      {
         super.addEvent();
         SocketConnection.addCmdListener(CommandID.NOTICE_SYSTEM,this.onSystemNotice);
      }
      
      override public function removeEvent() : void
      {
         super.removeEvent();
         SocketConnection.removeCmdListener(CommandID.NOTICE_SYSTEM,this.onSystemNotice);
      }
      
      private function onSystemNotice(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:SystemNoticeInfo = new SystemNoticeInfo(_loc2_);
         if(_loc3_.content.indexOf("mangoGold") != -1)
         {
            this._alertMC.visible = true;
         }
         this.executeShow();
         DynamicActivityEntry.instance.updateAlign();
      }
      
      override public function executeShow() : Boolean
      {
         this._alertMC.visible = false;
         var _loc1_:Boolean = super.executeShow();
         var _loc2_:Date = TimeUtil.getSeverDateObject();
         if(_loc2_.month == 9 && (_loc2_.date >= 1 && _loc2_.date <= 3) && (_loc2_.hours >= 13 && _loc2_.hours < 14))
         {
            this._alertMC.visible = true;
         }
         if(_loc1_ && (_loc2_.month == 9 && (_loc2_.date >= 1 && _loc2_.date <= 3)))
         {
            return true;
         }
         return false;
      }
   }
}

