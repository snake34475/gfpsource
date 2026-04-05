package com.gfp.app
{
   import com.gfp.app.manager.escortPlugin.EscortPluginManager;
   import com.gfp.app.manager.fightPlugin.AutoFightManager;
   import com.gfp.app.manager.fightPlugin.AutoRecoverManager;
   import com.gfp.app.manager.fightPlugin.AutoTollgateTransManager;
   import com.gfp.app.toolBar.MiniCityMap;
   import com.gfp.core.action.BaseAction;
   import com.gfp.core.config.xml.ActionXMLInfo;
   import com.gfp.core.controller.KeyController;
   import com.gfp.core.manager.DeffEquiptManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.WeatherManager;
   import com.gfp.core.ui.Stats;
   import com.taomee.analytics.Analytics;
   
   public class InputCommand
   {
      
      public function InputCommand()
      {
         super();
      }
      
      public static function parse(param1:String) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         if(param1 == "#Analytics.show")
         {
            Analytics.show();
            return true;
         }
         if(param1 == "#Analytics.hide")
         {
            Analytics.hide();
            return true;
         }
         if(param1 == "#changeKey")
         {
            _loc3_ = KeyController.currentControlType == 1 ? 2 : 1;
            KeyController.changeControl(_loc3_);
            return true;
         }
         if(param1 == "#deffEquipt")
         {
            DeffEquiptManager.changeEquiptDisplay(!DeffEquiptManager.isDisplayDeffEquipt);
            return true;
         }
         if(param1 == "#hideAllPlayer")
         {
            DeffEquiptManager.hideAllPlayer(!DeffEquiptManager.isHideAllPlayer);
            return true;
         }
         if(param1 == "#happy")
         {
            MainManager.actorModel.execAction(new BaseAction(ActionXMLInfo.getInfo(10008),false));
            return true;
         }
         if(param1 == "#fly")
         {
            MainManager.actorModel.execAction(new BaseAction(ActionXMLInfo.getInfo(40006),false));
            return true;
         }
         if(param1 == "#sleep")
         {
            MainManager.actorModel.execAction(new BaseAction(ActionXMLInfo.getInfo(40018),false));
            return true;
         }
         if(param1 == "#hit")
         {
            MainManager.actorModel.execAction(new BaseAction(ActionXMLInfo.getInfo(40001),false));
            return true;
         }
         if(param1 == "minimap")
         {
            MiniCityMap.instance.show();
            return true;
         }
         if(param1 == "#weather off")
         {
            WeatherManager.HideAllWeather();
            return true;
         }
         var _loc2_:RegExp = /#weather/;
         if(param1.search(_loc2_) != -1)
         {
            _loc4_ = param1.split(" ");
            WeatherManager.open(String(_loc4_[1]),int(_loc4_[2]));
            return true;
         }
         if(param1 == "#frameTest on")
         {
            Stats.show();
            return true;
         }
         if(param1 == "#frameTest off")
         {
            Stats.hide();
            return true;
         }
         if(param1 == "#Auto Fight")
         {
            AutoFightManager.instance.setup();
            AutoTollgateTransManager.instance.setup();
            AutoRecoverManager.instance.setup();
            return true;
         }
         if(param1 == "#CancelAF")
         {
            AutoFightManager.instance.destroy();
            AutoTollgateTransManager.instance.destroy();
            AutoRecoverManager.instance.destroy();
            return true;
         }
         if(param1 == "#Auto Escort")
         {
            EscortPluginManager.instance.setup();
            return true;
         }
         if(param1.indexOf("#open_pn:") != -1)
         {
            _loc5_ = param1.split(":")[1];
            if(_loc5_)
            {
               ModuleManager.turnAppModule(_loc5_);
            }
            return true;
         }
         return false;
      }
   }
}

