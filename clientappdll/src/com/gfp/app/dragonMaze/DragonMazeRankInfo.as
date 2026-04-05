package com.gfp.app.dragonMaze
{
   import flash.utils.IDataInput;
   
   public class DragonMazeRankInfo
   {
      
      private var _floor:uint;
      
      private var _userID:uint;
      
      private var _creatTime:uint;
      
      private var _lv:uint;
      
      private var _nickName:String;
      
      public function DragonMazeRankInfo(param1:IDataInput)
      {
         super();
         this._userID = param1.readUnsignedInt();
         this._creatTime = param1.readUnsignedInt();
         this._lv = param1.readUnsignedInt();
         this._nickName = param1.readUTFBytes(16);
         this._floor = param1.readUnsignedInt() + 1;
      }
      
      public function get floor() : uint
      {
         return this._floor;
      }
      
      public function get userID() : uint
      {
         return this._userID;
      }
      
      public function get creatTime() : uint
      {
         return this._creatTime;
      }
      
      public function get nickName() : String
      {
         return this._nickName;
      }
   }
}

