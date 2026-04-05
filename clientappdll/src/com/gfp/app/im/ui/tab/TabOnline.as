package com.gfp.app.im.ui.tab
{
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.model.SpriteModel;
   import com.gfp.core.model.UserModel;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class TabOnline implements IIMTab
   {
      
      private var _index:int;
      
      private var _fun:Function;
      
      private var _ui:MovieClip;
      
      private var _con:Sprite;
      
      public function TabOnline(param1:int, param2:MovieClip, param3:Sprite, param4:Function)
      {
         super();
         this._index = param1;
         this._ui = param2;
         this._ui.buttonMode = true;
         this._ui.gotoAndStop(1);
         this._con = param3;
         this._fun = param4;
      }
      
      public function show() : void
      {
         var list:Array;
         var arr:Array;
         this._ui.mouseEnabled = false;
         this._ui.gotoAndStop(2);
         list = UserManager.getModels();
         arr = list.map(function(param1:UserModel, param2:int, param3:Array):UserInfo
         {
            return param1.info;
         });
         arr = arr.filter(function(param1:UserInfo, param2:int, param3:Array):Boolean
         {
            if(param1.roleType < SpriteModel.PEOPLE_MAX)
            {
               return true;
            }
            return false;
         });
         arr.sortOn("vip",Array.DESCENDING | Array.NUMERIC);
         this._fun(arr,300);
      }
      
      public function hide() : void
      {
         this._ui.mouseEnabled = true;
         this._ui.gotoAndStop(1);
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function set index(param1:int) : void
      {
         this._index = param1;
      }
   }
}

