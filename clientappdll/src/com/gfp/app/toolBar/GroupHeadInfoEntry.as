package com.gfp.app.toolBar
{
   import com.gfp.app.manager.FightGroupManager;
   import com.gfp.core.events.CommEvent;
   import com.gfp.core.info.GroupUserInfo;
   import com.gfp.core.language.ModuleLanguageDefine;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class GroupHeadInfoEntry
   {
      
      private static var _instance:GroupHeadInfoEntry;
      
      private var headList:Vector.<GroupHeadInfoItem>;
      
      private var headListContainer:Sprite;
      
      private var waitMc:Head_GroupWaitPanel;
      
      public function GroupHeadInfoEntry()
      {
         super();
         this.headList = new Vector.<GroupHeadInfoItem>();
      }
      
      public static function get instance() : GroupHeadInfoEntry
      {
         if(!_instance)
         {
            _instance = new GroupHeadInfoEntry();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         FightGroupManager.instance.ed.addEventListener(FightGroupManager.FIGHT_GROUP_CREATE,this.fightGroupCreateHandler);
         FightGroupManager.instance.ed.addEventListener(FightGroupManager.FIGHT_GROUP_ENTER,this.fightGroupEnterHandler);
         FightGroupManager.instance.ed.addEventListener(FightGroupManager.FIGHT_GROUP_CHANGE,this.fightGroupChangeHandler);
         FightGroupManager.instance.ed.addEventListener(FightGroupManager.FIGHT_GROUP_QUIT,this.fightGroupQuitHandler);
         FightGroupManager.instance.ed.addEventListener(FightGroupManager.FIGHT_GROUP_USER_INFO_CHANGE,this.fightGroupUserInfoChangeHandler);
      }
      
      private function fightGroupCreateHandler(param1:CommEvent) : void
      {
         this.show();
         HeadSelfPanel.instance.initFightGroup();
      }
      
      private function fightGroupEnterHandler(param1:CommEvent) : void
      {
         this.show();
         this.refreshUserList();
         HeadSelfPanel.instance.initFightGroup();
      }
      
      private function fightGroupChangeHandler(param1:CommEvent) : void
      {
         this.refreshUserList();
      }
      
      private function fightGroupQuitHandler(param1:CommEvent) : void
      {
         this.destory();
         HeadSelfPanel.instance.initFightGroup();
      }
      
      public function show() : void
      {
         this.headListContainer = new Sprite();
         this.headListContainer.x = 10;
         this.headListContainer.y = 100;
         LayerManager.toolsLevel.addChild(this.headListContainer);
      }
      
      public function refreshUserList() : void
      {
         var _loc2_:GroupUserInfo = null;
         var _loc3_:GroupHeadInfoItem = null;
         this.clearList();
         var _loc1_:int = 0;
         for each(_loc2_ in FightGroupManager.instance.groupUserList)
         {
            if(!(_loc2_.userInfo.userID == MainManager.actorID && _loc2_.userInfo.createTime == MainManager.actorInfo.createTime))
            {
               _loc3_ = new GroupHeadInfoItem(_loc2_);
               _loc3_.y = _loc1_ * (_loc3_.height + 10);
               this.headListContainer.addChild(_loc3_);
               this.headList.push(_loc3_);
               _loc1_++;
            }
         }
      }
      
      private function fightGroupUserInfoChangeHandler(param1:CommEvent) : void
      {
         var _loc2_:GroupHeadInfoItem = null;
         for each(_loc2_ in this.headList)
         {
            _loc2_.refreshUserInfo();
         }
      }
      
      private function clearList() : void
      {
         var _loc1_:GroupHeadInfoItem = null;
         for each(_loc1_ in this.headList)
         {
            _loc1_.destory();
            this.headListContainer.removeChild(_loc1_);
         }
         this.headList.length = 0;
      }
      
      public function setHeadListVisable(param1:Boolean) : void
      {
         if(this.headListContainer)
         {
            this.headListContainer.visible = param1;
         }
      }
      
      public function destory() : void
      {
         this.clearList();
         LayerManager.toolsLevel.removeChild(this.headListContainer);
         this.headListContainer = null;
      }
      
      private function leaveGroup(param1:MouseEvent) : void
      {
         var evt:MouseEvent = param1;
         var backFunc:Function = function():void
         {
            FightGroupManager.instance.leaveGroup(MainManager.actorID,MainManager.actorInfo.createTime);
         };
         AlertManager.showSimpleAnswer(ModuleLanguageDefine.FIGHT_GROUP_MSG[7],backFunc);
      }
      
      public function set visible(param1:Boolean) : void
      {
         if(this.headListContainer)
         {
            this.headListContainer.visible = param1;
         }
      }
   }
}

