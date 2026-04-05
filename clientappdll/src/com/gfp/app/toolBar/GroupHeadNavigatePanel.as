package com.gfp.app.toolBar
{
   import com.gfp.app.im.talk.TalkManager;
   import com.gfp.app.manager.FightGroupManager;
   import com.gfp.app.user.UserInfoController;
   import com.gfp.core.info.GroupUserInfo;
   import com.gfp.core.language.ModuleLanguageDefine;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.utils.TextFormatUtil;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.taomee.manager.TaomeeManager;
   
   public class GroupHeadNavigatePanel
   {
      
      private static var _instance:GroupHeadNavigatePanel;
      
      private var _mainUI:UI_GroupNavigatePanel;
      
      private var _groupUserInfo:GroupUserInfo;
      
      public function GroupHeadNavigatePanel()
      {
         super();
      }
      
      public static function get instance() : GroupHeadNavigatePanel
      {
         if(!_instance)
         {
            _instance = new GroupHeadNavigatePanel();
         }
         return _instance;
      }
      
      public function showNavigate(param1:GroupUserInfo, param2:Point) : void
      {
         this._groupUserInfo = param1;
         if(!this._mainUI)
         {
            this._mainUI = new UI_GroupNavigatePanel();
         }
         this.addEvent();
         this._mainUI.x = param2.x;
         this._mainUI.y = param2.y;
         LayerManager.toolsLevel.addChild(this._mainUI);
         if(FightGroupManager.instance.myIsTheLeader)
         {
            this._mainUI.gotoAndStop(1);
         }
         else
         {
            this._mainUI.gotoAndStop(2);
         }
      }
      
      private function addEvent() : void
      {
         this._mainUI.item0.addEventListener(MouseEvent.CLICK,this.clickMainUIHandler);
         this._mainUI.item1.addEventListener(MouseEvent.CLICK,this.clickMainUIHandler);
         if(this._mainUI.item3)
         {
            this._mainUI.item3.addEventListener(MouseEvent.CLICK,this.clickMainUIHandler);
         }
         TaomeeManager.stage.addEventListener(MouseEvent.CLICK,this.mouseDownHandler);
      }
      
      private function removeEvent() : void
      {
         this._mainUI.item0.removeEventListener(MouseEvent.CLICK,this.clickMainUIHandler);
         this._mainUI.item1.removeEventListener(MouseEvent.CLICK,this.clickMainUIHandler);
         if(this._mainUI.item3)
         {
            this._mainUI.item3.removeEventListener(MouseEvent.CLICK,this.clickMainUIHandler);
         }
         TaomeeManager.stage.removeEventListener(MouseEvent.CLICK,this.mouseDownHandler);
      }
      
      private function mouseDownHandler(param1:MouseEvent) : void
      {
         if(param1.target == this._mainUI.item0 || param1.target == this._mainUI.item1 || param1.target == this._mainUI.item3)
         {
            return;
         }
         this.destory();
      }
      
      public function clickMainUIHandler(param1:MouseEvent) : void
      {
         switch(param1.currentTarget)
         {
            case this._mainUI.item0:
               UserInfoController.showForInfo(this._groupUserInfo.userInfo);
               break;
            case this._mainUI.item1:
               TalkManager.showTalkPanel(this._groupUserInfo.userInfo.userID,this._groupUserInfo.userInfo.createTime);
               break;
            case this._mainUI.item3:
               AlertManager.showSimpleAnswer(TextFormatUtil.substitute(ModuleLanguageDefine.FIGHT_GROUP_MSG[8],this._groupUserInfo.userInfo.nick),this.leaveGroup);
         }
         this.destory();
      }
      
      private function leaveGroup() : void
      {
         FightGroupManager.instance.leaveGroup(this._groupUserInfo.userInfo.userID,this._groupUserInfo.userInfo.createTime);
      }
      
      private function destory() : void
      {
         this.removeEvent();
         LayerManager.toolsLevel.removeChild(this._mainUI);
      }
   }
}

