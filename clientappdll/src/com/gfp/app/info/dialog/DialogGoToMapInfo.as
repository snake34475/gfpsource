package com.gfp.app.info.dialog
{
   import flash.geom.Point;
   
   public class DialogGoToMapInfo
   {
      
      public var id:uint;
      
      public var desc:String;
      
      public var mapID:String;
      
      public var pos:Point;
      
      public function DialogGoToMapInfo(param1:XML)
      {
         super();
         this.id = param1.@id;
         this.desc = param1.toString();
         this.mapID = param1.@mapID;
         var _loc2_:Array = String(param1.@pos).split(",");
         this.pos = new Point(_loc2_[0],_loc2_[1]);
      }
   }
}

