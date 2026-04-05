package com.gfp.app.mapConfigFun
{
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.map.IMapConfigFun;
   import com.gfp.core.model.sensemodels.SightModel;
   import com.gfp.core.utils.WallowUtil;
   
   public class MapXML_EnterPrison implements IMapConfigFun
   {
      
      public function MapXML_EnterPrison()
      {
         super();
      }
      
      public function exec(param1:SightModel, param2:XML, param3:XMLList) : void
      {
         if(WallowUtil.isWallow())
         {
            WallowUtil.showWallowMsg(AppLanguageDefine.WALLOW_MSG_ARR[17]);
         }
         else
         {
            ModuleManager.turnModule(ClientConfig.getAppModule("PrisonEntryPanel"),AppLanguageDefine.LOAD_MATTER_COLLECTION[3]);
         }
      }
   }
}

