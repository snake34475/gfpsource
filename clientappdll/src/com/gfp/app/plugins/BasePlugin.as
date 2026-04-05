package com.gfp.app.plugins
{
   public class BasePlugin implements IPlugin
   {
      
      protected var _isInstalled:Boolean;
      
      public function BasePlugin()
      {
         super();
      }
      
      public function install() : void
      {
         this._isInstalled = true;
      }
      
      public function uninstall() : void
      {
         this._isInstalled = false;
      }
      
      public function get isInstalled() : Boolean
      {
         return this._isInstalled;
      }
   }
}

