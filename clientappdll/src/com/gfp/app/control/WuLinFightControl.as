package com.gfp.app.control
{
   public class WuLinFightControl
   {
      
      private static var _instance:WuLinFightControl;
      
      private var _round:uint;
      
      private var _applyBadge:uint;
      
      private var _winBadge:uint;
      
      private var _failBadge:uint;
      
      private var _luckyBadge:uint;
      
      public function WuLinFightControl()
      {
         super();
      }
      
      public static function get instance() : WuLinFightControl
      {
         if(_instance == null)
         {
            _instance = new WuLinFightControl();
         }
         return _instance;
      }
      
      public function get round() : uint
      {
         return this._round;
      }
      
      public function set round(param1:uint) : void
      {
         this._round = param1;
      }
      
      public function get applyBadge() : uint
      {
         return this._applyBadge;
      }
      
      public function set applyBadge(param1:uint) : void
      {
         this._applyBadge = param1;
      }
      
      public function get winBadge() : uint
      {
         return this._winBadge;
      }
      
      public function set winBadge(param1:uint) : void
      {
         this._winBadge = param1;
      }
      
      public function get failBadge() : uint
      {
         return this._failBadge;
      }
      
      public function set failBadge(param1:uint) : void
      {
         this._failBadge = param1;
      }
      
      public function get luckyBadge() : uint
      {
         return this._luckyBadge;
      }
      
      public function set luckyBadge(param1:uint) : void
      {
         this._luckyBadge = param1;
      }
   }
}

