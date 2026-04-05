package com.gfp.app.plugins
{
   public interface IPlugin
   {
      
      function install() : void;
      
      function uninstall() : void;
      
      function get isInstalled() : Boolean;
   }
}

