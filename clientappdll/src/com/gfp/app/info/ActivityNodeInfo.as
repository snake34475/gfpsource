package com.gfp.app.info
{
   import com.gfp.core.info.RectInfo;
   import com.gfp.core.utils.TimeUtil;
   
   public class ActivityNodeInfo
   {
      
      public static const TYPE_TRANSFER:int = 0;
      
      public static const TYPE_OPEN_MODULE:int = 1;
      
      public static const TYPE_URL:int = 2;
      
      public var type:int;
      
      public var priority:int;
      
      public var uiClass:String;
      
      public var params:String;
      
      public var pos:int;
      
      public var custom:String;
      
      public var customClass:String;
      
      public var hasSystemEffect:Boolean;
      
      private var _startDate:Date;
      
      private var _endDate:Date;
      
      public var minLevel1:int;
      
      public var maxLevel1:int;
      
      public var minLevel2:int;
      
      public var unlockTaskID:int;
      
      public var maxLevel2:int;
      
      private var _id:uint;
      
      private var _isAlign:Boolean;
      
      public var width:int;
      
      public var height:int;
      
      private var _appenddata:Object;
      
      public var oneShot:int;
      
      public var rectInfo:RectInfo;
      
      public var parentNode:ActivityNodeInfo;
      
      private var _oneShotKey:String;
      
      public function ActivityNodeInfo(param1:XML)
      {
         super();
         this.configXml(param1);
      }
      
      public function get limitedTime() : Boolean
      {
         return Boolean(this._startDate) && Boolean(this._endDate);
      }
      
      public function get withinTime() : Boolean
      {
         return this.limitedTime && Boolean(TimeUtil.timeLimit(this._startDate,this._endDate));
      }
      
      public function get oneShotKey() : String
      {
         var _loc1_:Date = null;
         if(this._oneShotKey == null)
         {
            if(this.oneShot == 1)
            {
               this._oneShotKey = "ever";
            }
            else if(this.oneShot == 2)
            {
               _loc1_ = TimeUtil.getSeverDateObject();
               this._oneShotKey = _loc1_.fullYear + "/" + _loc1_.month + "/" + _loc1_.date;
            }
         }
         return this._oneShotKey;
      }
      
      protected function configXml(param1:XML) : void
      {
         this.width = param1.@width;
         this.height = param1.@height;
         this._id = parseInt(param1.@id);
         this.priority = int(param1.@priority);
         this.type = parseInt(param1.@type);
         this.pos = parseInt(param1.@pos);
         this.appenddata = parseInt(param1.@appenddata);
         this.minLevel1 = parseInt(param1.@minLevel1);
         this.maxLevel1 = parseInt(param1.@maxLevel1);
         this.minLevel2 = parseInt(param1.@minLevel2);
         this.maxLevel2 = parseInt(param1.@maxLevel2);
         this.oneShot = int(param1.@oneshot);
         this.hasSystemEffect = int(param1.@hasSystemEffect) > 0;
         this.unlockTaskID = int(param1.@unlockTaskID);
         this._isAlign = parseInt(param1.@isAlign) == 1;
         if(!this._isAlign)
         {
            this.rectInfo = RectInfo.parseInfo(param1);
         }
         this.params = param1.@params;
         this.custom = param1.@custom;
         this.uiClass = param1.@uiClass;
         this.customClass = param1.@customClass;
         var _loc2_:Array = String(param1.@startTime).split("-");
         if(Boolean(_loc2_) && _loc2_.length >= 5)
         {
            this._startDate = new Date(_loc2_[0],_loc2_[1] - 1,_loc2_[2],_loc2_[3],_loc2_[4]);
         }
         _loc2_ = String(param1.@endTime).split("-");
         if(Boolean(_loc2_) && _loc2_.length >= 5)
         {
            this._endDate = new Date(_loc2_[0],_loc2_[1] - 1,_loc2_[2],_loc2_[3],_loc2_[4]);
         }
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      public function get isAlign() : Boolean
      {
         return this._isAlign;
      }
      
      public function get x() : int
      {
         if(this.rectInfo)
         {
            return this.rectInfo.x;
         }
         return 0;
      }
      
      public function get y() : int
      {
         if(this.rectInfo)
         {
            return this.rectInfo.y;
         }
         return 0;
      }
      
      public function get appenddata() : Object
      {
         return this._appenddata;
      }
      
      public function set appenddata(param1:Object) : void
      {
         this._appenddata = param1;
      }
   }
}

