package com.gfp.app.storyProcess
{
   import com.gfp.core.manager.SOManager;
   import flash.net.SharedObject;
   
   public class BaseStoryProcess
   {
      
      private var _validate:Boolean;
      
      private var _step:uint;
      
      public function BaseStoryProcess()
      {
         super();
      }
      
      public function get validate() : Boolean
      {
         return this._validate;
      }
      
      public function set validate(param1:Boolean) : void
      {
         this._validate = param1;
      }
      
      public function get step() : uint
      {
         return this._step;
      }
      
      public function set step(param1:uint) : void
      {
         this._step = param1;
      }
      
      public function resetStep() : void
      {
         this._step = 0;
      }
      
      public function flushSO(param1:*) : void
      {
         var _loc2_:SharedObject = SOManager.getUserSO(SOManager.STORY);
         _loc2_.data[SOManager.STORY] = param1;
         SOManager.flush(_loc2_);
      }
      
      public function getLocalSO() : *
      {
         var _loc1_:SharedObject = SOManager.getUserSO(SOManager.STORY);
         return _loc1_.data[SOManager.STORY];
      }
   }
}

