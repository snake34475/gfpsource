package com.gfp.app.mapProcess
{
   import com.gfp.core.config.xml.SummonXMLInfo;
   import com.gfp.core.info.SummonInfo;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.ui.alert.TextAlert;
   import flash.display.MovieClip;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1099401 extends BaseMapProcess
   {
      
      private const VALIDATE_SUMMON:Array = [116,120,111,110,114];
      
      public function MapProcess_1099401()
      {
         super();
      }
      
      override protected function init() : void
      {
         var _loc1_:MovieClip = _mapModel.upLevel["cloudMC"];
         var _loc2_:SummonInfo = SummonManager.getActorSummonInfo().currentSummonInfo;
         if(this.checkSummon(_loc2_))
         {
            DisplayUtil.removeForParent(_loc1_);
            TextAlert.show("你携带的" + SummonXMLInfo.getName(_loc2_.roleID) + "驱散了场景中的迷雾。");
         }
      }
      
      private function checkSummon(param1:SummonInfo) : Boolean
      {
         if(param1)
         {
            if(this.VALIDATE_SUMMON.indexOf(uint(param1.roleID / 10)) != -1)
            {
               return true;
            }
         }
         return false;
      }
   }
}

