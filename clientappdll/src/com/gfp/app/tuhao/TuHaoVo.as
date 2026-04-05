package com.gfp.app.tuhao
{
   public class TuHaoVo
   {
      
      private var _info:String;
      
      private var _childInfo:Vector.<String>;
      
      private var _childWinValue:Vector.<int>;
      
      private var _childLoseValue:Vector.<int>;
      
      public function TuHaoVo()
      {
         super();
      }
      
      public function get info() : String
      {
         return this._info;
      }
      
      public function set info(param1:String) : void
      {
         this._info = param1;
      }
      
      public function get childInfo() : Vector.<String>
      {
         if(!this._childInfo)
         {
            this._childInfo = new Vector.<String>();
         }
         return this._childInfo;
      }
      
      public function get childWinValue() : Vector.<int>
      {
         if(!this._childWinValue)
         {
            this._childWinValue = new Vector.<int>();
         }
         return this._childWinValue;
      }
      
      public function get childLoseValue() : Vector.<int>
      {
         if(!this._childLoseValue)
         {
            this._childLoseValue = new Vector.<int>();
         }
         return this._childLoseValue;
      }
   }
}

