package com.gfp.app.fight
{
   import com.gfp.app.toolBar.ActivitySuggestionEntry;
   import com.gfp.app.toolBar.AmbassadorEntry;
   import com.gfp.app.toolBar.Battery;
   import com.gfp.app.toolBar.CityQuickBar;
   import com.gfp.app.toolBar.CommunityTipsEntry;
   import com.gfp.app.toolBar.DynamicActivityEntry;
   import com.gfp.app.toolBar.EverydaySignEntry;
   import com.gfp.app.toolBar.HeadRideBar;
   import com.gfp.app.toolBar.HonorPanelEntry;
   import com.gfp.app.toolBar.LvlUpAlertEntry;
   import com.gfp.app.toolBar.MailSysEntry;
   import com.gfp.app.toolBar.MallEntry;
   import com.gfp.app.toolBar.MapInfoShow;
   import com.gfp.app.toolBar.RedBlueMasterEntry;
   import com.gfp.app.toolBar.RoleHeadEntry;
   import com.gfp.app.toolBar.RoleItemMenu;
   import com.gfp.app.toolBar.RookieTaskPrizePanel;
   import com.gfp.app.toolBar.TaskTrackPanel;
   import com.gfp.app.toolBar.TurnBackTaskIco;
   import com.gfp.app.toolBar.VipNewEntry;
   import com.gfp.app.toolBar.WuLinFightEntry;
   import com.gfp.core.config.ClientConfig;
   
   public class FightAdded
   {
      
      public function FightAdded()
      {
         super();
      }
      
      public static function hideToolbar() : void
      {
         ActivitySuggestionEntry.instance.activityShowOrHide(false);
         MallEntry.instance.hide();
         AmbassadorEntry.instance.hide();
         Battery.instance.hide();
         HonorPanelEntry.instance.hide();
         MapInfoShow.instance.activityShowOrHide(!ClientConfig.isRelease());
         EverydaySignEntry.instance.hide();
         VipNewEntry.instance.hide();
         MailSysEntry.instance.hide();
         CityQuickBar.instance.hide();
         TurnBackTaskIco.instance.hide();
         WuLinFightEntry.instance.hide();
         RedBlueMasterEntry.instance.hide();
         RoleHeadEntry.hide();
         RoleItemMenu.destory();
         DynamicActivityEntry.instance.hide();
         RookieTaskPrizePanel.hide();
         TaskTrackPanel.instance.hide();
         LvlUpAlertEntry.instance.hide();
         CommunityTipsEntry.instance.visible = false;
         HeadRideBar.hideRide();
      }
      
      public static function showToolbar() : void
      {
         EverydaySignEntry.instance.show();
         VipNewEntry.instance.show();
         ActivitySuggestionEntry.instance.activityShowOrHide(true);
         MallEntry.instance.show();
         AmbassadorEntry.instance.show();
         Battery.instance.show();
         HonorPanelEntry.instance.show();
         MapInfoShow.instance.activityShowOrHide(true);
         MailSysEntry.instance.show();
         CityQuickBar.instance.show();
         WuLinFightEntry.instance.show();
         RedBlueMasterEntry.instance.show();
         RookieTaskPrizePanel.show();
         TaskTrackPanel.instance.show();
         DynamicActivityEntry.instance.show();
         LvlUpAlertEntry.instance.show();
         CommunityTipsEntry.instance.visible = true;
         TurnBackTaskIco.instance.setup();
         HeadRideBar.showRide();
      }
   }
}

