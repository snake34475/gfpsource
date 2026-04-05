package com.gfp.app.control
{
   import com.gfp.app.toolBar.HeadSelfPanel;
   import com.gfp.core.config.xml.SkillXMLInfo;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   import com.gfp.core.utils.TimeUtil;
   
   public class BaseBuffControl
   {
      
      public static const ROW_SIZE:uint = 7;
      
      public static const DISTANCE_X:Number = 32;
      
      public static const DISTANCE_Y:Number = 32;
      
      public function BaseBuffControl()
      {
         super();
      }
      
      public static function addBuff(param1:uint) : void
      {
         HeadSelfPanel.instance.addBaseBuff(param1);
      }
      
      public static function removeBuff(param1:uint) : void
      {
         HeadSelfPanel.instance.removeBaseBuff(param1);
      }
      
      public static function checkBaseBuff(param1:uint) : Boolean
      {
         if(MapManager.currentMap == null)
         {
            return false;
         }
         var _loc2_:uint = uint(MapManager.currentMap.info.mapType);
         if(_loc2_ == MapType.PVE || _loc2_ == MapType.PVP)
         {
            if(!SkillXMLInfo.isBaseBuffFightShow(param1))
            {
               return false;
            }
         }
         var _loc3_:Array = checkEnergyTime();
         switch(param1)
         {
            case 1:
               if(MainManager.actorModel.info.fightTeamId == 0)
               {
                  return false;
               }
               return true;
               break;
            case 2:
               return _loc3_.indexOf(2) != -1;
            case 3:
               return _loc3_.indexOf(3) != -1;
            case 4:
               return _loc3_.indexOf(5) != -1;
            case 13:
               return _loc3_.indexOf(13) != -1;
            case 9:
               return _loc3_.indexOf(9) != -1;
            case 12:
               return _loc3_.indexOf(12) != -1;
            default:
               return true;
         }
      }
      
      private static function checkEnergyTime() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:Date = TimeUtil.getSeverDateObject();
         var _loc3_:int = _loc2_.month;
         var _loc4_:int = _loc2_.date;
         var _loc5_:uint = _loc2_.day;
         var _loc6_:uint = _loc2_.hours;
         var _loc7_:int = _loc2_.minutes;
         if(_loc5_ == 5 || _loc5_ == 6 || _loc5_ == 0)
         {
            _loc1_.push(2);
         }
         if(_loc5_ == 6 || _loc5_ == 0)
         {
            if(_loc6_ >= 14 && _loc6_ < 16 || _loc6_ >= 19 && _loc6_ < 21)
            {
               _loc1_.push(3);
            }
         }
         if(SystemTimeController.instance.checkSysTimeAchieve(117))
         {
            _loc1_.push(12);
         }
         return _loc1_;
      }
   }
}

