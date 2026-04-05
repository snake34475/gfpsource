package com.gfp.app.mail
{
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.utils.WebURLUtil;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   
   public class MailTemplateProcess_1012 extends BaseMailTemplateProcess
   {
      
      private var inviteUid:int;
      
      private var inviteName:String;
      
      private var inviteCode:int;
      
      public function MailTemplateProcess_1012()
      {
         super();
         _initType = MailInitType.TYPE_BASE;
      }
      
      override public function setup(param1:Sprite, param2:ByteArray) : void
      {
         super.setup(param1,param2);
         _mailContent.position = 0;
         _mailContent.readUnsignedInt();
         var _loc3_:String = _mailContent.readUTFBytes(101);
         var _loc4_:Array = _loc3_.split("|");
         this.inviteUid = _loc4_[0];
         this.inviteName = _loc4_[1];
         this.inviteCode = _loc4_[2];
         var _loc5_:TextField = _mailSP["nameTxt"];
         _loc5_.text = "hi," + MainManager.actorInfo.nick + "  我是 " + this.inviteName;
         var _loc6_:SimpleButton = _mailSP["schoolBusInviteBtn"];
         _loc6_.addEventListener(MouseEvent.CLICK,this.onInviteBtnClick);
      }
      
      private function onInviteBtnClick(param1:MouseEvent) : void
      {
         WebURLUtil.intance.navigateBusInvite(MainManager.actorID,this.inviteUid,this.inviteCode);
      }
      
      override public function destroy() : void
      {
      }
   }
}

