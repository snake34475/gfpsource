package com.gfp.app.control
{
   import com.gfp.app.toolBar.CityToolBar;
   import com.gfp.app.toolBar.EverydaySignEntry;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.ui.alert.TextAlert;
   
   public class OperateControl
   {
      
      public function OperateControl()
      {
         super();
      }
      
      public static function subCoin(param1:uint) : void
      {
         MainManager.actorInfo.coins -= param1;
      }
      
      public static function addCoin(param1:uint) : void
      {
         MainManager.actorInfo.coins += param1;
      }
      
      public static function subExp(param1:uint) : void
      {
         MainManager.actorInfo.exp -= param1;
      }
      
      public static function addExp(param1:uint) : void
      {
         MainManager.actorInfo.exp += param1;
         TextAlert.show("恭喜你获得了" + param1 + "点经验");
      }
      
      public static function hideCityToolBar() : void
      {
         CityToolBar.instance.hide();
         EverydaySignEntry.instance.hide();
      }
      
      public static function showCityToolBar() : void
      {
         CityToolBar.instance.show();
         EverydaySignEntry.instance.show();
      }
   }
}

