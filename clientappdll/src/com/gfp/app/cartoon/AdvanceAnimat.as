package com.gfp.app.cartoon
{
   import com.gfp.core.action.normal.PosMoveAction;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.ActionXMLInfo;
   import com.gfp.core.events.MoveEvent;
   import com.gfp.core.manager.AdvancedManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.map.MapManager;
   import flash.events.Event;
   import flash.geom.Point;
   import org.taomee.utils.DisplayUtil;
   
   public class AdvanceAnimat extends AnimatBase
   {
      
      public function AdvanceAnimat()
      {
         super();
      }
      
      public function play() : void
      {
         loadMC(ClientConfig.getCartoon("advancedAnimation"));
      }
      
      override protected function playAnimat() : void
      {
         super.playAnimat();
         animatMC.stop();
         MainManager.closeOperate(true);
         MainManager.actorModel.execAction(new PosMoveAction(ActionXMLInfo.getInfo(9002),new Point(391,627),true));
         MainManager.actorModel.addEventListener(MoveEvent.MOVE_END,this.onMoveEnd);
      }
      
      private function onMoveEnd(param1:MoveEvent) : void
      {
         MainManager.actorModel.removeEventListener(MoveEvent.MOVE_END,this.onMoveEnd);
         animatMC.addEventListener(Event.ENTER_FRAME,this.onAnimatEnter);
         animatMC.x = 391;
         animatMC.y = 627;
         MapManager.currentMap.downLevel.addChild(animatMC);
         animatMC.play();
      }
      
      private function onAnimatEnter(param1:Event) : void
      {
         MainManager.actorModel.removeEventListener(MoveEvent.MOVE_END,this.onMoveEnd);
         if(animatMC.currentFrame == animatMC.totalFrames)
         {
            animatMC.stop();
            animatMC.removeEventListener(Event.ENTER_FRAME,this.onAnimatEnter);
            DisplayUtil.removeForParent(animatMC);
            AdvancedManager.instance.advanced();
            MainManager.openOperate();
            animatMC = null;
            destroy();
         }
      }
   }
}

