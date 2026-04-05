package com.gfp.app.cityWar
{
   public class TowerNameUtil
   {
      
      public function TowerNameUtil()
      {
         super();
      }
      
      public static function getTeamName(param1:uint) : String
      {
         if(param1 == 1)
         {
            return "红方";
         }
         return "蓝方";
      }
      
      public static function getLoadName(param1:uint) : String
      {
         var _loc2_:uint = uint((param1 - 1) / 4);
         switch(_loc2_)
         {
            case 0:
               return "上路";
            case 1:
               return "中路";
            case 2:
               return "下路";
            default:
               return "";
         }
      }
      
      public static function getTowerName(param1:uint) : String
      {
         if(param1 > 12)
         {
            return "将军";
         }
         var _loc2_:uint = (param1 - 1) % 4;
         switch(_loc2_)
         {
            case 0:
            case 3:
               return "二塔";
            case 1:
            case 2:
               return "一塔";
            default:
               return "";
         }
      }
   }
}

