package com.gfp.app.mapProcess
{
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.MapManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1050501 extends BaseMapProcess
   {
      
      private var sp:MovieClip;
      
      private var pos:Point;
      
      public function MapProcess_1050501()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.sp = new MaskTest_1();
         MapManager.currentMap.contentLevel.parent.addChild(this.sp);
         MapManager.currentMap.contentLevel.addEventListener(Event.ENTER_FRAME,this.onEnterFrameHandler);
      }
      
      protected function onEnterFrameHandler(param1:Event) : void
      {
         if(!param1.currentTarget["stage"])
         {
            param1.currentTarget.removeEventListener(Event.ENTER_FRAME,this.onEnterFrameHandler);
            return;
         }
         this.pos = MainManager.actorModel.pos;
         this.sp.x = this.pos.x;
         this.sp.y = this.pos.y;
      }
      
      override public function destroy() : void
      {
         DisplayUtil.removeForParent(this.sp);
      }
   }
}

