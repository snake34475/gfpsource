package com.gfp.app.info.fight
{
   public class ImproveFightUiInfo
   {
      
      public var type:int;
      
      public var text:String;
      
      public var max:int = 5000;
      
      private var _infos:Vector.<ImproveFightTranInfo>;
      
      public function ImproveFightUiInfo()
      {
         super();
         this._infos = new Vector.<ImproveFightTranInfo>();
      }
      
      public function addInfo(param1:ImproveFightTranInfo) : void
      {
         this._infos.push(param1);
      }
      
      public function get infos() : Vector.<ImproveFightTranInfo>
      {
         return this._infos;
      }
   }
}

