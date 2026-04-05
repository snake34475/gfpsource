package com.gfp.app.plugins
{
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   
   public class PluginManager
   {
      
      private static var _instance:PluginManager;
      
      private var _map:Dictionary;
      
      public function PluginManager(param1:Helper)
      {
         super();
         if(param1 == null)
         {
            throw new Error("using PluginManager.instance!");
         }
         this._map = new Dictionary();
      }
      
      public static function get instance() : PluginManager
      {
         return _instance = _instance || new PluginManager(new Helper());
      }
      
      public function getPlugin(param1:String) : IPlugin
      {
         return this._map[param1] as IPlugin;
      }
      
      public function hasPlugin(param1:String) : Boolean
      {
         return this.getPlugin(param1) != null;
      }
      
      public function installPlugin(param1:String) : Boolean
      {
         var _loc2_:Class = null;
         var _loc3_:IPlugin = null;
         if(this.hasPlugin(param1))
         {
            return false;
         }
         _loc2_ = getDefinitionByName("com.gfp.app.plugins::" + param1) as Class;
         if(_loc2_ == null)
         {
            throw new Error(param1 + " plugin未定义！");
         }
         _loc3_ = new _loc2_() as IPlugin;
         if(_loc3_ == null)
         {
            return false;
         }
         _loc3_.install();
         this._map[param1] = _loc3_;
         return true;
      }
      
      public function uninstallPlugin(param1:String) : Boolean
      {
         var _loc2_:IPlugin = null;
         if(this.hasPlugin(param1) == false)
         {
            return false;
         }
         _loc2_ = this._map[param1] as IPlugin;
         if(_loc2_ == null)
         {
            return false;
         }
         _loc2_.uninstall();
         this._map[param1] = null;
         delete this._map[param1];
         return true;
      }
   }
}

class Helper
{
   
   public function Helper()
   {
      super();
   }
}
