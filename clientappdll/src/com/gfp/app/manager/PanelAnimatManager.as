package com.gfp.app.manager
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.SOManager;
   import com.gfp.core.ui.events.UIEvent;
   import flash.net.SharedObject;
   
   public class PanelAnimatManager
   {
      
      private static var _instance:PanelAnimatManager;
      
      private var _storage:Object;
      
      public function PanelAnimatManager()
      {
         super();
         this._storage = new Object();
         ModuleManager.event.addEventListener(UIEvent.OPEN_MODULE,this.onModuleOpen);
      }
      
      public static function get instance() : PanelAnimatManager
      {
         return _instance || (_instance = new PanelAnimatManager());
      }
      
      protected function onModuleOpen(param1:UIEvent) : void
      {
         var _loc3_:String = null;
         var _loc2_:String = param1.data as String;
         for(_loc3_ in this._storage)
         {
            if(_loc2_.indexOf(_loc3_) != -1)
            {
               this.playAnimat(_loc3_);
               break;
            }
         }
      }
      
      private function playAnimat(param1:String) : void
      {
         var _loc2_:SharedObject = SOManager.getActorSO("PanelAnimatManager");
         if(_loc2_.data[param1] == true)
         {
            return;
         }
         _loc2_.data[param1] = true;
         _loc2_.flush();
         AnimatPlay.startAnimat(this._storage[param1].id,-1,false,this._storage[param1].offx,this._storage[param1].offy,false,true,true,2,true,true,true);
      }
      
      public function add(param1:String, param2:Object) : void
      {
         this._storage[param1] = param2;
      }
      
      public function remove(param1:String) : void
      {
         delete this._storage[param1];
      }
   }
}

