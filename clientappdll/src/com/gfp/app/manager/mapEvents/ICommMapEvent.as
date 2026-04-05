package com.gfp.app.manager.mapEvents
{
   public interface ICommMapEvent
   {
      
      function init(... rest) : void;
      
      function exec() : void;
      
      function destroy() : void;
   }
}

