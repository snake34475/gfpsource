package com.gfp.app.mapConfigFun
{
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.TollgateXMLInfo;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.map.IMapConfigFun;
   import com.gfp.core.model.sensemodels.SightModel;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.TextFormatUtil;
   import com.gfp.core.utils.WallowUtil;
   
   public class MapXML_EnterTollgate implements IMapConfigFun
   {
      
      private static var ONE_HOUR_SECOND:int = 3600;
      
      private var _tollgateId:int;
      
      public function MapXML_EnterTollgate()
      {
         super();
      }
      
      public function exec(param1:SightModel, param2:XML, param3:XMLList) : void
      {
         var _loc4_:int = 0;
         this._tollgateId = int(param2.toString());
         if(Boolean(TollgateXMLInfo.isTurnBackTollgate(this._tollgateId)) && !MainManager.actorInfo.isTurnBack)
         {
            TextAlert.show(TextFormatUtil.getRedText("必须转生后才能进入该关卡哦。"));
         }
         else if(TollgateXMLInfo.isUserLvEnough(this._tollgateId))
         {
            _loc4_ = MainManager.olToday / ONE_HOUR_SECOND;
            if(WallowUtil.isWallow())
            {
               WallowUtil.showWallowMsg(AppLanguageDefine.WALLOW_MSG_ARR[8]);
            }
            else
            {
               this.goToTollgate();
            }
         }
         else
         {
            TextAlert.show(TextFormatUtil.getRedText(AppLanguageDefine.NPC_DIALOG_COLLECTION[29]));
         }
      }
      
      private function goToTollgate() : void
      {
         var _loc1_:int = int(TollgateXMLInfo.getMaxDifficultStep(this._tollgateId));
         var _loc2_:int = int(TollgateXMLInfo.getMinDifficultStep(this._tollgateId));
         var _loc3_:Boolean = Boolean(TollgateXMLInfo.isSingleOnly(this._tollgateId));
         if(_loc1_ == _loc2_ && _loc3_)
         {
            PveEntry.enterTollgate(this._tollgateId,_loc2_ + 1);
         }
         else
         {
            ModuleManager.turnModule(ClientConfig.getAppModule("TeamFightPanel"),AppLanguageDefine.LOAD_MATTER_COLLECTION[2],this._tollgateId);
         }
      }
   }
}

