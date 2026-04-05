package com.gfp.app.control
{
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SOManager;
   import flash.net.SharedObject;
   
   public class DragonStepsControl
   {
      
      private static var _isWindStepWin:Boolean = false;
      
      private static var _isThunderStepWin:Boolean = false;
      
      private static var _isFateStepWin:Boolean = false;
      
      public function DragonStepsControl()
      {
         super();
      }
      
      public static function isAnimatPlayed() : Boolean
      {
         var _loc1_:SharedObject = SOManager.getUserSO(SOManager.DRAGON_STEP_WIND);
         var _loc2_:* = _loc1_.data[SOManager.DRAGON_STEP_WIND];
         return int(_loc2_) == MainManager.actorInfo.userID;
      }
      
      public static function flushAnimatPlayed() : void
      {
         var _loc1_:SharedObject = SOManager.getUserSO(SOManager.DRAGON_STEP_WIND);
         _loc1_.data[SOManager.DRAGON_STEP_WIND] = MainManager.actorInfo.userID;
         SOManager.flush(_loc1_);
      }
      
      public static function get isWindStepWin() : Boolean
      {
         return _isWindStepWin;
      }
      
      public static function set isWindStepWin(param1:Boolean) : void
      {
         _isWindStepWin = param1;
      }
      
      public static function get isThunderStepWin() : Boolean
      {
         return _isThunderStepWin;
      }
      
      public static function set isThunderStepWin(param1:Boolean) : void
      {
         _isThunderStepWin = param1;
      }
      
      public static function get isFateStepWin() : Boolean
      {
         return _isFateStepWin;
      }
      
      public static function set isFateStepWin(param1:Boolean) : void
      {
         _isFateStepWin = param1;
      }
   }
}

