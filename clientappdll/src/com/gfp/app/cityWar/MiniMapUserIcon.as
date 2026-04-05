package com.gfp.app.cityWar
{
   import com.gfp.app.manager.FightGroupManager;
   import com.gfp.core.info.GroupUserInfo;
   import flash.display.Sprite;
   import org.taomee.manager.ToolTipManager;
   
   public class MiniMapUserIcon extends Sprite
   {
      
      private var _mainUI:Sprite;
      
      public function MiniMapUserIcon(param1:uint)
      {
         var name:String;
         var userID:uint = param1;
         super();
         this._mainUI = new Sprite();
         addChild(this._mainUI);
         name = "";
         FightGroupManager.instance.groupUserList.some(function(param1:GroupUserInfo, param2:int, param3:Array):Boolean
         {
            if(param1.userInfo.userID == userID)
            {
               name = param1.userInfo.nick;
               return true;
            }
            return false;
         });
         ToolTipManager.add(this._mainUI,name);
      }
      
      public function destroy() : void
      {
         ToolTipManager.remove(this._mainUI);
         this._mainUI = null;
      }
   }
}

