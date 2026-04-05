package com.gfp.app.cityWar
{
   import com.gfp.core.manager.MainManager;
   import flash.display.Sprite;
   import org.taomee.manager.ToolTipManager;
   
   public class MiniMapTowerIcon extends Sprite
   {
      
      private var _mainUI:Sprite;
      
      private var _tipStr:String;
      
      public function MiniMapTowerIcon(param1:TowerInfo)
      {
         super();
         this._mainUI = new Sprite();
         addChild(this._mainUI);
         if(param1.team == MainManager.actorInfo.overHeadState)
         {
            this._tipStr = "剩余血量：" + param1.hp + "<br/>防守人数：" + param1.defNum;
            ToolTipManager.add(this._mainUI,this._tipStr);
         }
      }
      
      public function updateInfo(param1:TowerInfo) : void
      {
         this._tipStr = "剩余血量：" + param1.hp + "<br/>防守人数：" + param1.defNum;
      }
      
      public function destroy() : void
      {
         ToolTipManager.remove(this._mainUI);
         this._mainUI = null;
      }
   }
}

