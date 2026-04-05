package com.gfp.app.storyProcess
{
   import com.gfp.core.manager.SOManager;
   import flash.net.SharedObject;
   import org.taomee.ds.HashMap;
   
   public class StoryProcess_1 extends BaseStoryProcess
   {
      
      private static var _instance:StoryProcess_1;
      
      public static const STEP_DEFAULT:uint = 0;
      
      public static const CHECK_STEP_1:uint = 1;
      
      public static const CHECK_STEP_2:uint = 2;
      
      public static const CHECK_STEP_3:uint = 3;
      
      private var _dailyMap:HashMap = new HashMap();
      
      public function StoryProcess_1()
      {
         super();
         this.setup();
      }
      
      public static function get instance() : StoryProcess_1
      {
         if(_instance == null)
         {
            _instance = new StoryProcess_1();
         }
         return _instance;
      }
      
      private function setup() : void
      {
         validate = false;
      }
      
      public function flushAnimatSO(param1:*) : void
      {
         var _loc2_:SharedObject = SOManager.getUserSO(SOManager.STORY_ANIMAT);
         _loc2_.data[SOManager.STORY_ANIMAT] = param1;
         SOManager.flush(_loc2_);
      }
      
      public function getAnimatSO() : *
      {
         var _loc1_:SharedObject = SOManager.getUserSO(SOManager.STORY_ANIMAT);
         return _loc1_.data[SOManager.STORY_ANIMAT];
      }
      
      public function add(param1:uint, param2:uint) : void
      {
         this._dailyMap.add(param1,param2);
      }
      
      public function getDailyCount(param1:uint) : uint
      {
         var _loc2_:* = this._dailyMap.getValue(param1);
         if(Boolean(_loc2_) && _loc2_ != 0)
         {
            return _loc2_;
         }
         return 0;
      }
   }
}

