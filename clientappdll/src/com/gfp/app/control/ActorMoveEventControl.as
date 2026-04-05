package com.gfp.app.control
{
   import com.gfp.core.controller.KeyController;
   import com.gfp.core.events.MoveEvent;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.map.MapManager;
   import flash.events.Event;
   import org.taomee.utils.DisplayUtil;
   
   public class ActorMoveEventControl
   {
      
      private static var _instance:ActorMoveEventControl;
      
      private var _pickItemUI:Fight_C_PickTip;
      
      public function ActorMoveEventControl()
      {
         super();
      }
      
      public static function get instance() : ActorMoveEventControl
      {
         if(_instance == null)
         {
            _instance = new ActorMoveEventControl();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         MainManager.actorModel.addEventListener(MoveEvent.MOVE_ENTER,this.onActorMove);
         MainManager.actorModel.addEventListener(Event.REMOVED_FROM_STAGE,this.onActorRemove);
      }
      
      private function onActorMove(param1:MoveEvent) : void
      {
         this.moveForPickTip();
      }
      
      private function moveForPickTip() : void
      {
         if(Boolean(MapManager.isFightMap) && MainManager.actorInfo.lv <= 10)
         {
            if(ItemManager.getNearDrop(MainManager.actorModel) != null)
            {
               if(this._pickItemUI == null)
               {
                  this._pickItemUI = new Fight_C_PickTip();
                  this._pickItemUI.y = -MainManager.actorModel.height - (this._pickItemUI.height / 2 + 16);
                  this._pickItemUI.x = MainManager.actorModel.width / 2 - this._pickItemUI.width / 2 - 20;
               }
               if(!DisplayUtil.hasParent(this._pickItemUI))
               {
                  MainManager.actorModel.addChild(this._pickItemUI);
                  if(KeyController.currentControlType == 1)
                  {
                     this._pickItemUI.gotoAndStop(1);
                  }
                  else
                  {
                     this._pickItemUI.gotoAndStop(2);
                  }
               }
            }
            else
            {
               DisplayUtil.removeForParent(this._pickItemUI);
            }
         }
      }
      
      private function destroyPickUI() : void
      {
         DisplayUtil.removeForParent(this._pickItemUI);
         this._pickItemUI = null;
      }
      
      private function onActorRemove(param1:Event) : void
      {
         this.clear();
         this.destroyPickUI();
      }
      
      public function clear() : void
      {
         MainManager.actorModel.removeEventListener(MoveEvent.MOVE_ENTER,this.onActorMove);
         MainManager.actorModel.removeEventListener(Event.REMOVED_FROM_STAGE,this.onActorRemove);
      }
   }
}

