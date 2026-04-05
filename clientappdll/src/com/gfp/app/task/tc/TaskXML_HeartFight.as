package com.gfp.app.task.tc
{
   import com.gfp.core.Constant;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.MainManager;
   
   public class TaskXML_HeartFight extends TaskXML_TollgatePassed
   {
      
      public function TaskXML_HeartFight()
      {
         super();
      }
      
      public static function getTollgateID() : int
      {
         var _loc1_:UserInfo = MainManager.actorInfo;
         if(_loc1_.roleType == Constant.ROLE_TYPE_MONKEY)
         {
            return 526;
         }
         if(_loc1_.roleType == Constant.ROLE_TYPE_DARGON)
         {
            return 527;
         }
         if(_loc1_.roleType == Constant.ROLE_TYPE_RABBIT)
         {
            return 528;
         }
         if(_loc1_.roleType == Constant.ROLE_TYPE_PANDA)
         {
            return 529;
         }
         if(_loc1_.roleType == Constant.ROLE_TYPE_TIGER)
         {
            return 530;
         }
         if(_loc1_.roleType == Constant.ROLE_TYPE_CAT)
         {
            return 531;
         }
         if(_loc1_.roleType == Constant.ROLE_TYPE_HORSE)
         {
            return 444;
         }
         if(_loc1_.roleType == Constant.ROLE_TYPE_WOLF)
         {
            return 1220;
         }
         return 0;
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         _tollgateID = getTollgateID();
      }
   }
}

