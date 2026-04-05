package com.gfp.app.cmdl
{
   import com.gfp.app.glory.HonorAchievePopPanel;
   import com.gfp.app.glory.SoundGloryPlayer;
   import com.gfp.app.toolBar.CityToolBar;
   import com.gfp.app.toolBar.chat.MultiChatPanel;
   import com.gfp.core.CommandID;
   import com.gfp.core.buff.BuffInfo;
   import com.gfp.core.buff.movie.MovieBuff;
   import com.gfp.core.events.GloryEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.HonorInfo;
   import com.gfp.core.info.TitleInfo;
   import com.gfp.core.manager.GloryManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.PopUpUIManager;
   import com.gfp.core.utils.TextUtil;
   import flash.utils.ByteArray;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.AlignType;
   
   public class GloryCmdListener extends BaseBean
   {
      
      public function GloryCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.HONOR_LIST,this.onCompletedHonorList);
         SocketConnection.addCmdListener(CommandID.HONOR_ADD,this.onHonorAchieve);
         SocketConnection.addCmdListener(CommandID.HONOR_SHOW,this.onHonorShow);
         SocketConnection.addCmdListener(CommandID.TITLE_LIST,this.onGetTitleList);
         SocketConnection.addCmdListener(CommandID.TITLE_ADD,this.onTitleAchieve);
         SocketConnection.addCmdListener(CommandID.TITLE_SET,this.onTitleSet);
         SocketConnection.send(CommandID.TITLE_LIST);
         finish();
      }
      
      private function onCompletedHonorList(param1:SocketEvent) : void
      {
         var _loc6_:uint = 0;
         GloryManager.resetInfo();
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         GloryManager._userId = _loc3_;
         GloryManager._creatTime = _loc4_;
         if(_loc3_ == MainManager.actorID && _loc4_ == MainManager.actorInfo.createTime)
         {
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               GloryManager.addHonor(new HonorInfo(_loc2_));
               _loc6_++;
            }
         }
         else
         {
            GloryManager.clearPlayerHonorMap();
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               GloryManager.addPlayerHonor(new HonorInfo(_loc2_));
               _loc6_++;
            }
            GloryManager.setOtherZong(_loc2_.readUnsignedInt());
         }
         GloryManager.dispatchEvent(new GloryEvent(GloryEvent.HONOR_LIST_COMPLETE));
      }
      
      private function onHonorAchieve(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:HonorInfo = new HonorInfo(_loc2_);
         if(GloryManager.getHonorInfo(_loc3_.id))
         {
            return;
         }
         GloryManager.addHonor(_loc3_);
         var _loc4_:HonorAchievePopPanel = new HonorAchievePopPanel(_loc3_);
         PopUpUIManager.showFor(_loc4_,null,AlignType.BOTTOM_CENTER,0,-85);
         this.execMovieBuff();
         GloryManager.dispatchEvent(new GloryEvent(GloryEvent.HONOR_GET,_loc3_.id));
         CityToolBar.instance.showGloryInfo(true);
      }
      
      private function onHonorShow(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:String = _loc2_.readUTFBytes(16);
         var _loc6_:uint = _loc2_.readUnsignedInt();
         var _loc7_:uint = _loc2_.readUnsignedInt();
         var _loc8_:String = TextUtil.getGloryLink(_loc3_,_loc4_,_loc5_,_loc6_,_loc7_);
         MultiChatPanel.instance.showSystemNotice(_loc8_,false);
      }
      
      private function onGetTitleList(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            GloryManager.addTitle(new TitleInfo(_loc2_));
            _loc4_++;
         }
      }
      
      private function onTitleAchieve(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:TitleInfo = new TitleInfo(_loc2_);
         GloryManager.addTitle(_loc3_);
      }
      
      private function onTitleSet(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         var _loc6_:UserModel = UserManager.getModel(_loc3_);
         if(_loc6_)
         {
            _loc6_.info.titleID = _loc5_;
            if(_loc5_ == 0)
            {
               _loc6_.info.updateTitleByLv(_loc6_.info.lv);
               _loc6_.updateTitle();
            }
            else
            {
               _loc6_.updateTitleByTitleID(_loc5_);
            }
            UserManager.dispatchEvent(new UserEvent(UserEvent.TITLE_CHANGE,_loc6_));
         }
      }
      
      private function execMovieBuff() : void
      {
         var _loc1_:BuffInfo = new BuffInfo();
         _loc1_.id = 9017;
         _loc1_.duration = 1000;
         _loc1_.layer = 999;
         MainManager.actorModel.execBuff(new MovieBuff(_loc1_,false));
         SoundGloryPlayer.play(2);
      }
   }
}

