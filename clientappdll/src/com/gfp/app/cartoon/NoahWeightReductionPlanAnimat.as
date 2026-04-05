package com.gfp.app.cartoon
{
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.utils.TickManager;
   import flash.events.Event;
   import flash.net.SharedObject;
   import org.taomee.utils.DisplayUtil;
   
   public class NoahWeightReductionPlanAnimat extends AnimatBase
   {
      
      public static const TASK_IDs:Array = [5024,5025,5026];
      
      public static const START_FRAME:Array = [1,101,190];
      
      public static const END_FRAME:Array = [100,189,380];
      
      public var curTask:int;
      
      public function NoahWeightReductionPlanAnimat()
      {
         super();
      }
      
      public function play() : void
      {
         loadMC(ClientConfig.getCartoon("NoahsWeightReductionPlanMovie"));
      }
      
      override protected function playAnimat() : void
      {
         super.playAnimat();
         animatMC.addEventListener(Event.ENTER_FRAME,this.onAnimatEnter);
         animatMC.gotoAndPlay(START_FRAME[this.curTask - 1]);
         LayerManager.topLevel.addChild(animatMC);
      }
      
      private function onAnimatEnter(param1:Event) : void
      {
         var _loc2_:Date = null;
         var _loc3_:Number = NaN;
         var _loc4_:SharedObject = null;
         if(animatMC.currentFrame == END_FRAME[this.curTask - 1])
         {
            animatMC.removeEventListener(Event.ENTER_FRAME,this.onAnimatEnter);
            DisplayUtil.removeForParent(animatMC);
            TasksManager.taskComplete(TASK_IDs[this.curTask - 1]);
            _loc2_ = new Date();
            _loc3_ = _loc2_.time / 1000;
            _loc4_ = SharedObject.getLocal("NoahsWeightReductionPlan_Task");
            _loc4_.data["CompleteTime"] = _loc3_;
            _loc4_.flush();
            TickManager.instance.addTimeout(2000,this.openModule);
            destroy();
         }
      }
      
      private function openModule() : void
      {
         ModuleManager.turnAppModule("NoahsWeightReductionPlanMainPanel");
         TickManager.instance.removeTimeout(this.openModule);
      }
   }
}

