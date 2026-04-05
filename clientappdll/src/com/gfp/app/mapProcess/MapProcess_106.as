package com.gfp.app.mapProcess
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.cartoon.event.AnimatEvent;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.CityMap;
   
   public class MapProcess_106 extends BaseMapProcess
   {
      
      public function MapProcess_106()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         TasksManager.addListener(TaskEvent.ACCEPT,this.onTaskAccept);
      }
      
      private function removeEvent() : void
      {
         TasksManager.removeListener(TaskEvent.ACCEPT,this.onTaskAccept);
         AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimatEnd);
      }
      
      private function onTaskAccept(param1:TaskEvent) : void
      {
         if(param1.taskID == 2143)
         {
            AnimatPlay.addAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimatEnd);
            AnimatPlay.startAnimat("task2143_",0,false,467,285);
         }
      }
      
      private function onAnimatEnd(param1:AnimatEvent) : void
      {
         var _loc2_:String = param1.data as String;
         switch(_loc2_)
         {
            case "task2143_0":
               AnimatPlay.startAnimat("task2143_",1,false,473,287,false,false,false);
               break;
            case "task2143_1":
               AnimatPlay.startAnimat("task2143_",2,true,80,25);
               break;
            case "task2143_2":
               AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimatEnd);
               CityMap.instance.tranToNpc(10548);
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.removeEvent();
      }
   }
}

