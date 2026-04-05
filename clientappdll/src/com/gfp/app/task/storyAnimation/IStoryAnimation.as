package com.gfp.app.task.storyAnimation
{
   public interface IStoryAnimation
   {
      
      function setParams(param1:String) : void;
      
      function start() : void;
      
      function onStart() : void;
      
      function onFinish() : void;
   }
}

