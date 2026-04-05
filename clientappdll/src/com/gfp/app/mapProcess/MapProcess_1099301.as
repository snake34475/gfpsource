package com.gfp.app.mapProcess
{
   import com.gfp.core.CommandID;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.net.SocketConnection;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1099301 extends BaseMapProcess
   {
      
      private var _hotBar:MovieClip;
      
      private var _hotBarWidth:uint;
      
      private var _hotRect:Rectangle;
      
      public function MapProcess_1099301()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._hotBar = new Fight_BloodBar_Red();
         this._hotBarWidth = this._hotBar.width;
         this._hotRect = new Rectangle(0,0,0,this._hotBar.height);
         this._hotBar.scrollRect = this._hotRect;
         this.addMapEvent();
      }
      
      private function addMapEvent() : void
      {
         SocketConnection.addCmdListener(CommandID.STAGE_MONSTER_PRO_CHANGE,this.onFireEnergyChange);
         MainManager.actorModel.addEventListener(Event.ADDED_TO_STAGE,this.onAddToStage);
      }
      
      private function removeMapEvent() : void
      {
         SocketConnection.removeCmdListener(CommandID.STAGE_MONSTER_PRO_CHANGE,this.onFireEnergyChange);
         MainManager.actorModel.removeEventListener(Event.ADDED_TO_STAGE,this.onAddToStage);
      }
      
      private function onAddToStage(param1:Event) : void
      {
         MainManager.actorModel.sprite.addChild(this._hotBar);
         this._hotBar.x = -MainManager.actorModel.width - 10;
         this._hotBar.y = -MainManager.actorModel.height - 20;
      }
      
      private function onFireEnergyChange(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         this._hotRect.width = _loc5_ / 100 * this._hotBarWidth;
         this._hotBar.scrollRect = this._hotRect;
      }
      
      override public function destroy() : void
      {
         this.removeMapEvent();
         DisplayUtil.removeForParent(this._hotBar);
         this._hotBar = null;
         super.destroy();
      }
   }
}

