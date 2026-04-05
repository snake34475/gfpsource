package com.gfp.app.feature
{
   import com.gfp.core.events.HiddenEvent;
   import com.gfp.core.manager.HiddenManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.HiddenModel;
   import com.gfp.core.model.MapModel;
   import com.gfp.core.ui.alert.TextAlert;
   import flash.display.MovieClip;
   import org.taomee.utils.DisplayUtil;
   
   public class Stage105Feather
   {
      
      public function Stage105Feather()
      {
         super();
      }
      
      public function setup() : void
      {
         this.initUI();
         this.addEvent();
      }
      
      public function destory() : void
      {
         this.removeEvent();
      }
      
      private function initUI() : void
      {
         this.change(1);
         TextAlert.show("靠近风车开启风车，可召唤稻草人助战！");
      }
      
      private function change(param1:int) : void
      {
         var _loc2_:MapModel = MapManager.currentMap;
         (_loc2_.root as MovieClip)["movie_mc"].gotoAndStop(param1);
         (_loc2_.nearLevel as MovieClip).gotoAndStop(param1);
         (_loc2_.upLevel as MovieClip).gotoAndStop(param1);
         (_loc2_.contentLevel as MovieClip).gotoAndStop(param1);
         (_loc2_.downLevel as MovieClip).gotoAndStop(param1);
         if(_loc2_.groundLevel is MovieClip)
         {
            (_loc2_.groundLevel as MovieClip).gotoAndStop(param1);
         }
         (_loc2_.farNearLevel as MovieClip).gotoAndStop(param1);
         (_loc2_.farLevel as MovieClip).gotoAndStop(param1);
         (_loc2_.pathLevel as MovieClip).gotoAndStop(param1);
      }
      
      private function onHiddenStateChange(param1:HiddenEvent) : void
      {
         var _loc2_:HiddenModel = param1.model;
         var _loc3_:uint = uint(param1.state);
         DisplayUtil.removeForParent(_loc2_,false);
         _loc2_.visible = false;
         this.change(2);
      }
      
      public function addEvent() : void
      {
         HiddenManager.addEventListener(HiddenEvent.STATE_CHANGE,this.onHiddenStateChange);
      }
      
      public function removeEvent() : void
      {
         HiddenManager.removeEventListener(HiddenEvent.STATE_CHANGE,this.onHiddenStateChange);
      }
   }
}

