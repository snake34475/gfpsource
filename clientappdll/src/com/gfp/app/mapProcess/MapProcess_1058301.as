package com.gfp.app.mapProcess
{
   import com.gfp.core.info.GodInstanceInfo;
   import com.gfp.core.manager.GodManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.GodStatType;
   
   public class MapProcess_1058301 extends BaseMapProcess
   {
      
      public function MapProcess_1058301()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         var _loc1_:GodInstanceInfo = GodManager.instance.getGodInfoByGodId(9009);
         if(Boolean(_loc1_) && _loc1_.sate == GodStatType.GOD_FIGHT)
         {
            TextAlert.show("小侠士有嫦娥守护神助阵，实力大大提升，猪八戒不堪一击！");
         }
         else
         {
            TextAlert.show("猪八戒实力不同凡响，快带上嫦娥守护神，助小侠士一臂之力！");
         }
      }
   }
}

