package com.gfp.app.im.ui.tab
{
   import com.gfp.app.im.ui.IMListItem;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.RelationManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import org.taomee.data.DataChangeEvent;
   import org.taomee.data.DataChangeType;
   
   public class TabFriend implements IIMTab
   {
      
      private var _index:int;
      
      private var _fun:Function;
      
      private var _ui:MovieClip;
      
      private var _con:Sprite;
      
      public function TabFriend(param1:int, param2:MovieClip, param3:Sprite, param4:Function)
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
         this._ui.mouseEnabled = false;
         this._ui.gotoAndStop(2);
         RelationManager.addFriendListener(DataChangeEvent.DATA_CHANGE,this.onRelation);
         RelationManager.setOnLineFriend();
      }
      
      public function hide() : void
      {
         RelationManager.removeFriendListener(DataChangeEvent.DATA_CHANGE,this.onRelation);
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
      
      private function onRelation(param1:DataChangeEvent) : void
      {
         var _loc2_:UserInfo = null;
         var _loc3_:IMListItem = null;
         switch(param1.changeType)
         {
            case DataChangeType.UPDATE:
               if(param1.items.length == 0)
               {
                  this._fun(RelationManager.getFriendInfos(),RelationManager.F_MAX);
                  break;
               }
               _loc2_ = param1.items[0];
               if(_loc2_)
               {
                  _loc3_ = this._con.getChildByName(_loc2_.userID.toString()) as IMListItem;
                  if(_loc3_)
                  {
                     _loc3_.info = _loc2_;
                  }
               }
               break;
            default:
               this._fun(RelationManager.getFriendInfos(),RelationManager.F_MAX);
         }
      }
   }
}

