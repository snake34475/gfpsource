package com.gfp.app.mail
{
   import com.adobe.crypto.MD5;
   import com.gfp.core.CommandID;
   import com.gfp.core.js.JSControl;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.net.SocketConnection;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class MailTemplateProcess_1007 extends BaseMailTemplateProcess
   {
      
      private var _btnTicket:SimpleButton;
      
      private var _btnBus:SimpleButton;
      
      public function MailTemplateProcess_1007()
      {
         super();
      }
      
      override public function setup(param1:Sprite, param2:ByteArray) : void
      {
         super.setup(param1,param2);
         this._btnTicket = _mailSP["btnTicket"] as SimpleButton;
         this._btnBus = _mailSP["btnBus"] as SimpleButton;
         this._btnTicket.addEventListener(MouseEvent.CLICK,this.onTicket);
         this._btnBus.addEventListener(MouseEvent.CLICK,this.onBus);
      }
      
      private function onTicket(param1:MouseEvent) : void
      {
         SocketConnection.addCmdListener(CommandID.DAILY_USE_TIME,this.onTicketAward);
         SocketConnection.send(CommandID.DAILY_USE_TIME,2071);
      }
      
      private function onTicketAward(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.DAILY_USE_TIME,this.onTicketAward);
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         if(_loc3_ == 2071)
         {
            if(_loc4_ == 0)
            {
               JSControl.getInstance().callJS("callCollect",MainManager.actorID,MD5.hash(MainManager.actorID.toString() + "taomee2011$tt%yeg*&(fdg){ol}[]{234#$+=q@~"),"gf");
            }
            else
            {
               AlertManager.showSimpleAlarm(AppLanguageDefine.ACTIVITIES_CHARACTER_COLLECTION[0]);
            }
         }
      }
      
      private function onBus(param1:MouseEvent) : void
      {
         navigateToURL(new URLRequest("http://bus.61.com"),"_blank");
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this._btnTicket.removeEventListener(MouseEvent.CLICK,this.onTicket);
         this._btnBus.removeEventListener(MouseEvent.CLICK,this.onBus);
      }
   }
}

