package com.gfp.app.info.rank
{
   import com.gfp.core.info.RankInfo;
   import flash.utils.IDataInput;
   
   public class SanGuoRankInfo extends RankInfo
   {
      
      public var countryId:int;
      
      public function SanGuoRankInfo(param1:IDataInput = null)
      {
         super(param1);
      }
      
      public function copy() : SanGuoRankInfo
      {
         var _loc1_:SanGuoRankInfo = new SanGuoRankInfo();
         _loc1_.userID = this.userID;
         _loc1_.creatTime = this.creatTime;
         _loc1_.roleType = this.roleType;
         _loc1_.level = this.level;
         _loc1_.nick = this.nick;
         _loc1_.teamID = this.teamID;
         _loc1_.teamLv = this.teamLv;
         _loc1_.teamName = this.teamName;
         _loc1_.socre = this.socre;
         _loc1_.rankIndex = this.rankIndex;
         _loc1_.countryId = this.countryId;
         return _loc1_;
      }
   }
}

